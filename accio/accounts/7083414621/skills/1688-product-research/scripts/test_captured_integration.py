#!/usr/bin/env python3
"""
集成测试：验证页面捕获商品数据优化功能

需要 Chrome 已启动：
    python scripts/chrome_launcher.py --port 9222

测试内容：
1. 导航到 1688 搜索页
2. 验证 XHR 拦截器捕获了响应数据
3. 验证 captured_products 包含商品
4. 验证 search_products 正确使用捕获数据

使用方法：
    python scripts/test_captured_integration.py --keyword "手机壳" --limit 20
"""

from __future__ import annotations

import argparse
import json
import logging
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from ali.cdp import Browser
from ali.session import SessionManager
from ali.search import search_products

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)


def test_capture_integration(keyword: str, limit: int, port: int = 9222):
    """集成测试：验证页面捕获功能。"""
    logger.info("="*60)
    logger.info("集成测试：页面捕获商品数据优化")
    logger.info("="*60)
    logger.info(f"测试参数: keyword={keyword}, limit={limit}")
    
    # 1. 连接 Chrome
    logger.info("\n[步骤1] 连接 Chrome...")
    browser = Browser(port=port)
    try:
        browser.connect()
        logger.info("✅ Chrome 连接成功")
    except Exception as e:
        logger.error(f"❌ Chrome 连接失败: {e}")
        logger.info("请确保 Chrome 已启动: python scripts/chrome_launcher.py --port 9222")
        return False
    
    try:
        # 2. 获取页面
        logger.info("\n[步骤2] 获取页面...")
        page = browser.get_or_create_page()
        logger.info(f"✅ 页面获取成功")
        
        # 3. 创建 SessionManager 并提取会话
        logger.info("\n[步骤3] 提取会话（导航到搜索页并捕获数据）...")
        session = SessionManager(page)
        
        import time
        start_time = time.time()
        
        session.extract_session(
            keyword=keyword,
            sort_type="sale",
        )
        
        extract_time = time.time() - start_time
        logger.info(f"✅ 会话提取完成，耗时: {extract_time:.2f}s")
        
        # 4. 验证捕获的商品数据
        logger.info("\n[步骤4] 验证捕获的商品数据...")
        captured = session.captured_products
        
        if not captured:
            logger.warning("⚠️ 未捕获到任何商品数据")
            logger.info("可能原因：")
            logger.info("  - 页面加载时 MTOP 请求未完成")
            logger.info("  - XHR 拦截器未正确注入")
            logger.info("  - 1688 页面结构变化")
        else:
            logger.info(f"✅ 成功捕获 {len(captured)} 条商品数据")
            
            # 显示前3条商品
            logger.info("\n捕获的商品样例（前3条）:")
            for i, p in enumerate(captured[:3], 1):
                logger.info(f"  {i}. {p.title[:30]}... (ID: {p.offer_id}, 价格: {p.price})")
        
        # 5. 测试 search_products 使用捕获数据
        logger.info("\n[步骤5] 测试 search_products 优化逻辑...")
        
        # 记录 API 调用次数
        api_call_count = [0]
        original_send = None
        
        def mock_send(template, data, callback=None):
            api_call_count[0] += 1
            logger.info(f"  📡 API 请求被调用 (第{api_call_count[0]}次)")
            # 调用原始函数
            from ali.search import _send_mtop_request as original
            return original(template, data, callback)
        
        # 临时替换（仅用于计数）
        import ali.search as search_module
        original_send = search_module._send_mtop_request
        
        # 场景A：limit 小于等于捕获数量
        if len(captured) >= limit:
            logger.info(f"\n场景A: limit={limit} <= captured={len(captured)}")
            logger.info("预期：直接使用捕获数据，不调用 API")
            
            search_module._send_mtop_request = mock_send
            try:
                result = search_products(session, keyword=keyword, sort_type="sale", limit=limit)
                
                if api_call_count[0] == 0:
                    logger.info(f"✅ 优化生效！未调用 API，直接返回 {len(result)} 条商品")
                else:
                    logger.warning(f"⚠️ 优化未生效，调用了 {api_call_count[0]} 次 API")
                    
            finally:
                search_module._send_mtop_request = original_send
                api_call_count[0] = 0
        
        # 场景B：limit 大于捕获数量
        larger_limit = len(captured) + 20 if captured else limit
        logger.info(f"\n场景B: limit={larger_limit} > captured={len(captured)}")
        logger.info("预期：使用捕获数据 + 从第2页开始 API 请求")
        
        search_module._send_mtop_request = mock_send
        try:
            result = search_products(session, keyword=keyword, sort_type="sale", limit=larger_limit)
            
            logger.info(f"✅ 共返回 {len(result)} 条商品")
            logger.info(f"   API 调用次数: {api_call_count[0]} 次")
            
            if captured:
                logger.info(f"   前{len(captured)}条来自页面捕获，后续来自 API")
                
        finally:
            search_module._send_mtop_request = original_send
        
        # 6. 保存结果
        logger.info("\n[步骤6] 保存测试结果...")
        output = {
            "test_info": {
                "keyword": keyword,
                "limit": limit,
                "captured_count": len(captured),
                "extract_time": extract_time,
            },
            "captured_products": [p.to_dict() for p in captured[:10]],  # 只保存前10条
        }
        
        output_path = Path("test_capture_result.json")
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(output, f, ensure_ascii=False, indent=2)
        logger.info(f"✅ 结果已保存到: {output_path.absolute()}")
        
        logger.info("\n" + "="*60)
        logger.info("集成测试完成")
        logger.info("="*60)
        
        return True
        
    except Exception as e:
        logger.error(f"❌ 测试失败: {e}")
        import traceback
        traceback.print_exc()
        return False
        
    finally:
        browser.close()
        logger.info("Chrome 连接已关闭")


def main():
    parser = argparse.ArgumentParser(description="页面捕获优化集成测试")
    parser.add_argument("--keyword", "-k", default="手机壳", help="搜索关键词")
    parser.add_argument("--limit", "-l", type=int, default=20, help="需求数量")
    parser.add_argument("--port", "-p", type=int, default=9222, help="Chrome CDP 端口")
    
    args = parser.parse_args()
    
    success = test_capture_integration(
        keyword=args.keyword,
        limit=args.limit,
        port=args.port,
    )
    
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
