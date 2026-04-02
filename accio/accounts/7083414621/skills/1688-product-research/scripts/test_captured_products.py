#!/usr/bin/env python3
"""
测试页面捕获商品数据优化功能

测试场景：
1. 页面加载时已捕获足够商品（无需额外 API 请求）
2. 页面加载时捕获部分商品（需要从第2页补充）
3. 页面未捕获商品（正常 API 请求流程）

使用方法：
    # 1. 先启动 Chrome
    python scripts/chrome_launcher.py --port 9222
    
    # 2. 运行测试
    python scripts/test_captured_products.py
"""

from __future__ import annotations

import json
import logging
import sys
from pathlib import Path
from typing import Any
from unittest.mock import Mock, MagicMock

# 添加路径
sys.path.insert(0, str(Path(__file__).parent))

from ali.types import Product, RequestTemplate

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)


def create_mock_product(offer_id: str, title: str = "测试商品") -> Product:
    """创建模拟商品数据。"""
    return Product(
        offer_id=offer_id,
        title=title,
        product_url=f"https://detail.1688.com/offer/{offer_id}.html",
        image_url="https://example.com/image.jpg",
        price="99.00",
        booked_count="100",
        shop_name="测试店铺",
    )


def create_mock_session(captured_products: list[Product] | None = None) -> Mock:
    """创建模拟 SessionManager。"""
    session = Mock()
    session.page_id = "test_page_id_12345"
    session.captured_products = captured_products or []
    session.template = RequestTemplate(
        cookies={"_m_h5_tk": "test_token_12345"},
        m_h5_tk="test_token_12345",
        headers={"User-Agent": "Test"},
    )
    return session


def test_sufficient_captured_products():
    """测试场景1：页面已捕获足够商品，无需额外 API 请求。"""
    logger.info("\n" + "="*60)
    logger.info("测试场景1：页面已捕获足够商品（limit=20, captured=60）")
    logger.info("="*60)
    
    # 模拟页面已捕获 60 条商品
    captured = [create_mock_product(f"offer_{i}", f"商品{i}") for i in range(60)]
    session = create_mock_session(captured)
    
    # 导入被测函数
    from ali.search import search_products
    
    # 模拟 _send_mtop_request 不应该被调用
    original_send = None
    api_called = [False]  # 使用 list 来在嵌套函数中修改
    
    def mock_send(*args, **kwargs):
        api_called[0] = True
        raise AssertionError("不应该调用 API，因为已捕获足够商品")
    
    # 替换函数
    import ali.search as search_module
    original_send = search_module._send_mtop_request
    search_module._send_mtop_request = mock_send
    
    try:
        result = search_products(
            session=session,
            keyword="测试关键词",
            sort_type="sale",
            limit=20,
        )
        
        assert len(result) == 20, f"期望返回 20 条，实际返回 {len(result)}"
        assert not api_called[0], "错误：不应该调用 API"
        assert result[0].offer_id == "offer_0", "应该返回已捕获的商品"
        
        logger.info("✅ 测试通过：直接返回已捕获的 20 条商品，无 API 请求")
        return True
        
    finally:
        search_module._send_mtop_request = original_send


def test_partial_captured_products():
    """测试场景2：页面捕获部分商品，需要从第2页补充。"""
    logger.info("\n" + "="*60)
    logger.info("测试场景2：页面捕获部分商品（limit=50, captured=30）")
    logger.info("="*60)
    
    # 模拟页面已捕获 30 条商品
    captured = [create_mock_product(f"captured_{i}") for i in range(30)]
    session = create_mock_session(captured)
    
    from ali.search import search_products, _send_mtop_request
    
    call_log: list[dict] = []
    
    def mock_send(template, data, callback=None):
        call_log.append({"data": data})
        # 返回模拟数据（20条）
        return {
            "data": {
                "data": {
                    "OFFER": {
                        "items": [
                            {"data": {"offerId": f"api_{i}", "title": f"API商品{i}"}}
                            for i in range(20)
                        ]
                    }
                }
            }
        }
    
    import ali.search as search_module
    original_send = search_module._send_mtop_request
    search_module._send_mtop_request = mock_send
    
    try:
        result = search_products(
            session=session,
            keyword="测试关键词",
            sort_type="sale",
            limit=50,
        )
        
        assert len(result) == 50, f"期望返回 50 条，实际返回 {len(result)}"
        assert len(call_log) == 1, f"期望调用 1 次 API（从第2页），实际调用 {len(call_log)} 次"
        
        # 验证前30条是已捕获的，后20条是 API 获取的
        assert result[0].offer_id == "captured_0", "前30条应该是已捕获商品"
        assert result[29].offer_id == "captured_29", "第30条应该是已捕获商品"
        assert result[30].offer_id == "api_0", "第31条应该是 API 获取的商品"
        
        logger.info("✅ 测试通过：使用已捕获 30 条 + API 获取 20 条 = 50 条")
        return True
        
    finally:
        search_module._send_mtop_request = original_send


def test_no_captured_products():
    """测试场景3：页面未捕获商品，正常 API 请求流程。"""
    logger.info("\n" + "="*60)
    logger.info("测试场景3：页面未捕获商品（limit=20, captured=0）")
    logger.info("="*60)
    
    session = create_mock_session([])  # 空列表
    
    from ali.search import search_products
    
    call_count = [0]
    
    def mock_send(template, data, callback=None):
        call_count[0] += 1
        return {
            "data": {
                "data": {
                    "OFFER": {
                        "items": [
                            {"data": {"offerId": f"api_{i}", "title": f"API商品{i}"}}
                            for i in range(20)
                        ]
                    }
                }
            }
        }
    
    import ali.search as search_module
    original_send = search_module._send_mtop_request
    search_module._send_mtop_request = mock_send
    
    try:
        result = search_products(
            session=session,
            keyword="测试关键词",
            sort_type="sale",
            limit=20,
        )
        
        assert len(result) == 20, f"期望返回 20 条，实际返回 {len(result)}"
        assert call_count[0] == 1, f"期望调用 1 次 API，实际调用 {call_count[0]} 次"
        assert result[0].offer_id == "api_0", "应该返回 API 获取的商品"
        
        logger.info("✅ 测试通过：正常 API 流程获取 20 条商品")
        return True
        
    finally:
        search_module._send_mtop_request = original_send


def test_session_captured_products_property():
    """测试 SessionManager.captured_products 属性。"""
    logger.info("\n" + "="*60)
    logger.info("测试 SessionManager.captured_products 属性")
    logger.info("="*60)
    
    from ali.session import SessionManager
    
    # 创建 mock page
    mock_page = Mock()
    
    session = SessionManager(mock_page)
    
    # 初始状态应该是空列表
    assert session.captured_products == [], "初始 captured_products 应该是空列表"
    
    # 模拟设置捕获的商品
    products = [create_mock_product("1"), create_mock_product("2")]
    session._captured_products = products
    
    assert session.captured_products == products, "captured_products 应该返回设置的值"
    assert len(session.captured_products) == 2, "应该有 2 条捕获商品"
    
    logger.info("✅ 测试通过：captured_products 属性工作正常")
    return True


def test_parse_mtop_response():
    """测试 SessionManager._parse_mtop_response 方法。"""
    logger.info("\n" + "="*60)
    logger.info("测试 _parse_mtop_response 方法")
    logger.info("="*60)
    
    from ali.session import SessionManager
    
    mock_page = Mock()
    session = SessionManager(mock_page)
    
    # 测试 JSONP 格式
    jsonp_response = 'mtopjsonp123({"ret":["SUCCESS"],"data":{"key":"value"}});'
    result = session._parse_mtop_response(jsonp_response)
    assert result == {"ret": ["SUCCESS"], "data": {"key": "value"}}, "应该正确解析 JSONP"
    
    # 测试纯 JSON 格式
    json_response = '{"ret":["SUCCESS"],"data":{"key":"value"}}'
    result = session._parse_mtop_response(json_response)
    assert result == {"ret": ["SUCCESS"], "data": {"key": "value"}}, "应该正确解析 JSON"
    
    # 测试空响应
    result = session._parse_mtop_response("")
    assert result is None, "空响应应该返回 None"
    
    # 测试无效响应
    result = session._parse_mtop_response("invalid json")
    assert result is None, "无效响应应该返回 None"
    
    logger.info("✅ 测试通过：_parse_mtop_response 解析正确")
    return True


def run_all_tests():
    """运行所有测试。"""
    logger.info("\n" + "="*60)
    logger.info("开始运行优化功能测试")
    logger.info("="*60)
    
    tests = [
        ("SessionManager.captured_products 属性", test_session_captured_products_property),
        ("_parse_mtop_response 方法", test_parse_mtop_response),
        ("场景1：已捕获足够商品", test_sufficient_captured_products),
        ("场景2：捕获部分商品", test_partial_captured_products),
        ("场景3：未捕获商品", test_no_captured_products),
    ]
    
    passed = 0
    failed = 0
    
    for name, test_func in tests:
        try:
            if test_func():
                passed += 1
        except Exception as e:
            failed += 1
            logger.error(f"❌ 测试失败 [{name}]: {e}")
            import traceback
            traceback.print_exc()
    
    logger.info("\n" + "="*60)
    logger.info(f"测试结果：通过 {passed}/{len(tests)}, 失败 {failed}/{len(tests)}")
    logger.info("="*60)
    
    return failed == 0


if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)
