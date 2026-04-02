"""CLI 入口 — 1688 商品搜索自动化。

子命令：
  search       商品搜索（默认不登录，MTOP API 回放）
  transform    将搜索结果转为 AITable records 格式
  check-login  检查登录状态
  login        扫码登录（可选）
  schema       输出表结构获取指引
"""

from __future__ import annotations

import argparse
import json
import logging
import os
import subprocess
import sys
import tempfile


def _ensure_dependencies() -> None:
    """检查并自动安装缺失的依赖（按需安装，用户无感知）。"""
    required_packages = [
        ("requests", "requests>=2.28.0"),
        ("websockets", "websockets>=12.0"),
        ("httpx", "httpx>=0.27.0"),
    ]
    
    missing = []
    for module, package in required_packages:
        try:
            __import__(module)
        except ImportError:
            missing.append(package)
    
    if missing:
        print(f"[INFO] 正在安装缺失的依赖: {', '.join(missing)}", file=sys.stderr)
        try:
            subprocess.check_call(
                [sys.executable, "-m", "pip", "install"] + missing,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.PIPE,
            )
            print("[INFO] 依赖安装完成", file=sys.stderr)
        except subprocess.CalledProcessError as e:
            print(f"[ERROR] 依赖安装失败: {e}", file=sys.stderr)
            sys.exit(1)


# 在导入其他模块前，先确保依赖已安装
_ensure_dependencies()

# 将 scripts 目录加入 sys.path，以支持 ali 包的导入
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from ali.schema import extract_field_id_map, transform_all
from ali.cdp import Browser, Page
from ali.login import (
    check_login_status,
    fetch_qrcode,
    make_qrcode_url,
    save_qrcode_to_file,
    wait_for_login,
)
from ali.search import search_products
from ali.session import SessionManager

logger = logging.getLogger(__name__)


def _setup_logging(verbose: bool = False) -> None:
    """配置日志。"""
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%H:%M:%S",
    )


def _connect(
    host: str = "127.0.0.1",
    port: int = 9222,
    reuse_existing: bool = False,
    target_url_hint: str | None = None,
) -> tuple[Browser, Page]:
    """连接到 Chrome 并获取页面。
    
    Args:
        host: CDP 主机地址
        port: CDP 端口
        reuse_existing: 是否优先复用已有页面（如 use_browser 打开的页面）
        target_url_hint: 优先匹配包含该字符串的页面 URL（如 "1688.com"）
    """
    browser = Browser(host=host, port=port)
    browser.connect()
    
    if reuse_existing:
        # 优先复用已有页面（如 use_browser 预打开的 1688 页面）
        page = browser.get_existing_page(target_url_hint=target_url_hint)
        if page:
            logger.info("复用已有页面: %s", page.target_id)
            return browser, page
        logger.info("未找到已有页面，创建新页面")
    
    page = browser.get_or_create_page()
    return browser, page


def _output(data: dict) -> None:
    """JSON 格式输出结果。"""
    print(json.dumps(data, ensure_ascii=False, indent=2))


# ========== search 子命令 ==========


def cmd_search(args: argparse.Namespace) -> None:
    """商品搜索（默认不登录）。"""
    _setup_logging(args.verbose)

    # 优先复用 use_browser 预打开的 1688 页面
    browser, page = _connect(
        args.host, args.port, reuse_existing=True, target_url_hint="1688.com"
    )
    page_closed = False
    try:
        session = SessionManager(page)
        # 用搜索关键词和排序/价格参数初始化会话（导航到搜索页提取 Cookie）
        session.ensure_session(
            keyword=args.keyword,
            sort_type=args.sort,
            price_start=args.price_start,
            price_end=args.price_end,
        )

        products = search_products(
            session=session,
            keyword=args.keyword,
            sort_type=args.sort,
            price_start=args.price_start,
            price_end=args.price_end,
            limit=args.limit,
            begin_page=args.page,
        )

        result: dict = {
            "keyword": args.keyword,
            "sort": args.sort,
            "count": len(products),
            "products": [p.to_dict() for p in products],
        }
        if args.price_start is not None:
            result["price_start"] = args.price_start
        if args.price_end is not None:
            result["price_end"] = args.price_end

        # 如果指定了输出文件，保存原始结果
        if args.output:
            import os
            os.makedirs(os.path.dirname(args.output) or ".", exist_ok=True)
            with open(args.output, "w", encoding="utf-8") as f:
                json.dump(result, f, ensure_ascii=False, indent=2)
            logger.info("原始结果已保存到: %s", args.output)

        _output(result)
        
        # 数据处理完成后关闭页面，避免 tab 堆积占用内存
        browser.close_page(page)
        page_closed = True
        logger.debug("搜索完成，已关闭页面")
    finally:
        # 最终清理：如果页面还未关闭，则关闭它
        if not page_closed:
            browser.close_page(page)
        browser.close()


# ========== check-login 子命令 ==========


def cmd_check_login(args: argparse.Namespace) -> None:
    """检查登录状态。"""
    _setup_logging(args.verbose)

    browser, page = _connect(args.host, args.port)
    try:
        logged_in = check_login_status(page)
        _output({
            "logged_in": logged_in,
            "message": "已登录" if logged_in else "未登录",
        })
    finally:
        browser.close_page(page)
        browser.close()


# ========== login 子命令 ==========


def cmd_login(args: argparse.Namespace) -> None:
    """扫码登录。"""
    _setup_logging(args.verbose)

    browser, page = _connect(args.host, args.port)
    try:
        png_bytes, _b64_str, already_logged_in = fetch_qrcode(page)

        if already_logged_in:
            _output({"logged_in": True, "message": "已登录，无需重复登录"})
            return

        # 保存二维码文件
        qr_file = save_qrcode_to_file(png_bytes)

        # 尝试生成 URL
        image_url, login_url = make_qrcode_url(png_bytes)

        _output({
            "logged_in": False,
            "message": "请扫描二维码登录",
            "qrcode_file": qr_file,
            "qrcode_url": image_url,
            "login_url": login_url,
        })

        # 等待扫码
        success = wait_for_login(page, timeout=120.0)
        if success:
            _output({"logged_in": True, "message": "登录成功"})
        else:
            _output({"logged_in": False, "message": "登录超时"})
    finally:
        browser.close_page(page)
        browser.close()


# ========== CLI 入口 ==========


def main() -> None:
    """CLI 主入口。"""
    parser = argparse.ArgumentParser(
        prog="cli.py",
        description="1688 商品搜索自动化（CDP + MTOP API 回放）",
    )
    parser.add_argument("--host", default="127.0.0.1", help="Chrome CDP 主机地址")
    parser.add_argument("--port", type=int, default=9222, help="Chrome 调试端口")
    parser.add_argument("-v", "--verbose", action="store_true", help="详细日志")

    subparsers = parser.add_subparsers(dest="command", help="子命令")

    # search
    sp_search = subparsers.add_parser("search", help="商品搜索")
    sp_search.add_argument("--keyword", "-k", required=True, help="搜索关键词")
    sp_search.add_argument(
        "--sort", "-s",
        choices=["default", "sale", "price_asc", "price_desc"],
        default="default",
        help="排序方式",
    )
    sp_search.add_argument("--price-start", type=float, default=None, help="最低价格")
    sp_search.add_argument("--price-end", type=float, default=None, help="最高价格")
    sp_search.add_argument("--limit", "-l", type=int, default=40, help="最大返回数量")
    sp_search.add_argument("--page", "-p", type=int, default=1, help="起始页码")
    sp_search.add_argument("--output", "-o", default=None, help="保存原始结果到 JSON 文件")
    sp_search.set_defaults(func=cmd_search)

    # schema
    sp_schema = subparsers.add_parser("schema", help="输出 AITable 表结构描述")
    sp_schema.set_defaults(func=cmd_schema)

    # transform
    sp_transform = subparsers.add_parser("transform", help="将搜索结果转为 AITable records")
    sp_transform.add_argument("--input", "-i", required=True, help="搜索结果 JSON 文件路径")
    sp_transform.add_argument("--table-info", "-t", required=True, help="dws aitable table get 输出的 JSON 文件路径")
    sp_transform.add_argument("--output", "-o", required=True, help="输出 records JSON 文件路径")
    sp_transform.add_argument("--date", default=None, help="采集日期（YYYY-MM-DD），默认今天")
    sp_transform.set_defaults(func=cmd_transform)

    # check-login
    sp_check = subparsers.add_parser("check-login", help="检查登录状态")
    sp_check.set_defaults(func=cmd_check_login)

    # login
    sp_login = subparsers.add_parser("login", help="扫码登录")
    sp_login.set_defaults(func=cmd_login)

    args = parser.parse_args()
    if not args.command:
        parser.print_help()
        sys.exit(1)

    try:
        args.func(args)
    except KeyboardInterrupt:
        sys.exit(130)
    except Exception as e:
        _output({"error": str(e)})
        if args.verbose:
            import traceback
            traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
ogin", help="扫码登录")
    sp_login.set_defaults(func=cmd_login)

    args = parser.parse_args()
    if not args.command:
        parser.print_help()
        sys.exit(1)

    try:
        args.func(args)
    except KeyboardInterrupt:
        sys.exit(130)
    except Exception as e:
        _output({"error": str(e)})
        if args.verbose:
            import traceback
            traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
