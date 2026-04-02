"""AITable 表结构描述与数据转换。

提供：
- transform 系列函数：将 search 原始数据转为 AITable records 格式
- extract_field_id_map：从 dws 表信息中提取字段 ID 映射
- FIELD_MAPPINGS：字段映射配置，支持灵活匹配

注意：表结构定义通过 dws aitable 命令获取，不在代码中硬编码
"""

from __future__ import annotations

import datetime
import re


# ---------------------------------------------------------------------------
# 字段映射配置：支持多个可能的字段名映射到同一个数据
# ---------------------------------------------------------------------------

FIELD_MAPPINGS: dict[str, list[str]] = {
    "采集日期": ["采集日期", "日期", "创建时间"],
    "商品ID": ["商品ID", "商品 ID", "产品ID", "产品 ID", "ID"],
    "商品标题": ["商品标题", "标题", "产品名称", "名称"],
    "商品链接": ["商品链接", "产品链接", "链接"],
    "主图URL": ["主图URL", "主图 URL", "主图", "商品图片", "图片"],
    "价格": ["价格", "单价", "售价", "零售价"],
    "近期成交件数": ["近期成交件数", "近期成交", "成交件数", "销量", "销售量"],
    "店铺名称": ["店铺名称", "商家名称", "供应商", "卖家"],
    "店铺链接": ["店铺链接", "商家链接", "店铺主页"],
    "复购率": ["复购率", "复购比例", "重复购买率"],
    "回头率": ["回头率", "回头比例", "再次购买率"],
    "综合评分": ["综合评分", "评分", "总体评分"],
    "商品评分": ["商品评分", "产品评分", "宝贝评分"],
    "物流评分": ["物流评分", "发货评分", "快递评分"],
    "服务标签": ["服务标签", "标签", "服务", "店铺标签"],
}


# ---------------------------------------------------------------------------
# 1. 辅助转换函数（纯函数，无副作用）
# ---------------------------------------------------------------------------

def parse_percent(value: str) -> float:
    """百分比字符串转小数。

    >>> parse_percent("15%")
    0.15
    >>> parse_percent("46%")
    0.46
    >>> parse_percent("")
    0
    >>> parse_percent("0.15")
    0.15
    """
    if not value:
        return 0
    s = str(value).strip()
    if not s:
        return 0
    if "%" in s:
        s = s.replace("%", "").strip()
        try:
            return round(float(s) / 100, 4)
        except (ValueError, TypeError):
            return 0
    # 无 % 符号：如果 > 1 视为百分比整数（如 "15"），否则视为已转换的小数
    try:
        f = float(s)
        return round(f / 100, 4) if f > 1 else f
    except (ValueError, TypeError):
        return 0


def parse_float(value: str) -> float:
    """字符串转 float，空值或异常返回 0。

    >>> parse_float("4.5")
    4.5
    >>> parse_float("")
    0
    >>> parse_float("0.83")
    0.83
    """
    if not value:
        return 0
    s = str(value).strip()
    if not s:
        return 0
    try:
        return float(s)
    except (ValueError, TypeError):
        return 0


def parse_int(value: str) -> int:
    """字符串转 int，支持逗号分隔，空值或异常返回 0。

    >>> parse_int("39893")
    39893
    >>> parse_int("1,234")
    1234
    >>> parse_int("")
    0
    """
    if not value:
        return 0
    s = str(value).strip()
    if not s:
        return 0
    s = s.replace(",", "")
    # 提取开头的数字部分（兼容 "565件" 等格式）
    m = re.match(r"(\d+)", s)
    if m:
        return int(m.group(1))
    return 0


def format_link(url: str, text: str) -> dict | None:
    """URL 转 AITable 链接格式，空 URL 返回 None。

    >>> format_link("https://example.com", "查看")
    {'link': 'https://example.com', 'text': '查看'}
    >>> format_link("", "查看") is None
    True
    """
    if not url or not str(url).strip():
        return None
    return {"link": str(url).strip(), "text": text}


# ---------------------------------------------------------------------------
# 2. 核心转换函数
# ---------------------------------------------------------------------------

def _resolve_field_id(field_id_map: dict[str, str], standard_name: str) -> str | None:
    """根据标准字段名解析 fieldId，支持字段映射配置。
    
    先尝试标准名，再尝试配置的别名。
    """
    # 先尝试标准名
    fid = field_id_map.get(standard_name)
    if fid:
        return fid
    
    # 尝试别名
    for alias in FIELD_MAPPINGS.get(standard_name, []):
        fid = field_id_map.get(alias)
        if fid:
            return fid
    
    return None


def transform_product(
    product: dict,
    field_id_map: dict[str, str],
    date_str: str,
) -> dict:
    """将单条商品 dict 转为 AITable record 格式。

    Args:
        product: Product.to_dict() 输出的字典
        field_id_map: {fieldName: fieldId} 映射（来自 dws aitable table get）
        date_str: 采集日期，YYYY-MM-DD 格式

    Returns:
        {"cells": {fieldId: value, ...}}
    """
    cells: dict = {}

    def put(standard_name: str, value) -> None:
        """将值写入 cells，自动查找 fieldId（支持字段映射）。跳过 None 值和未知字段。"""
        if value is None:
            return
        fid = _resolve_field_id(field_id_map, standard_name)
        if fid:
            cells[fid] = value

    put("采集日期",     date_str)
    put("商品ID",       product.get("offer_id", ""))
    put("商品标题",     product.get("title", ""))
    put("商品链接",     format_link(product.get("product_url", ""), "查看商品"))
    put("主图URL",      format_link(product.get("image_url", ""), ""))
    put("价格",         parse_float(product.get("price", "")))
    put("近期成交件数",  parse_int(product.get("booked_count", "")))
    put("店铺名称",     product.get("shop_name", ""))
    put("店铺链接",     format_link(product.get("shop_url", ""), "查看店铺"))
    put("复购率",       parse_percent(product.get("repurchase_rate", "")))
    put("回头率",       parse_percent(product.get("return_rate", "")))
    put("综合评分",     parse_float(product.get("composite_score", "")))
    put("商品评分",     parse_float(product.get("goods_score", "")))
    put("物流评分",     parse_float(product.get("logistics_score", "")))
    put("服务标签",     product.get("service_tags", []))

    return {"cells": cells}


def transform_all(
    result_data: dict,
    field_id_map: dict[str, str],
    date_str: str | None = None,
) -> list[dict]:
    """批量转换所有商品为 AITable records。

    Args:
        result_data: cli.py search 输出的完整 JSON（含 products 数组）
        field_id_map: {fieldName: fieldId} 映射
        date_str: 采集日期，默认今天

    Returns:
        [{"cells": {...}}, {"cells": {...}}, ...]
    """
    if date_str is None:
        date_str = datetime.date.today().isoformat()

    products = result_data.get("products", [])
    return [transform_product(p, field_id_map, date_str) for p in products]


# ---------------------------------------------------------------------------
# 3. fieldId 映射提取
# ---------------------------------------------------------------------------

def extract_field_id_map(table_info: dict) -> dict[str, str]:
    """从 dws aitable table get 的 JSON 输出中提取 fieldName → fieldId 映射。

    期望输入格式:
    {
      "data": {
        "tables": [{
          "fields": [
            {"fieldId": "abc", "fieldName": "采集日期", "type": "date"},
            ...
          ]
        }]
      }
    }

    Returns:
        {"采集日期": "abc", "商品ID": "def", ...}

    Raises:
        ValueError: 输入格式不符合预期时
    """
    data = table_info.get("data")
    if not isinstance(data, dict):
        raise ValueError(
            f"table_info 格式错误：缺少 'data' 键或类型不正确。"
            f"收到的顶层键：{list(table_info.keys())}"
        )

    tables = data.get("tables")
    if not isinstance(tables, list) or len(tables) == 0:
        raise ValueError(
            f"table_info 格式错误：'data.tables' 为空或不是列表。"
            f"收到的 data 键：{list(data.keys())}"
        )

    fields = tables[0].get("fields", [])
    if not fields:
        raise ValueError(
            "table_info 格式错误：'data.tables[0].fields' 为空。"
            "请确认表格已正确创建字段。"
        )

    field_map: dict[str, str] = {}
    for f in fields:
        name = f.get("fieldName", "")
        fid = f.get("fieldId", "")
        if name and fid:
            field_map[name] = fid

    return field_map
