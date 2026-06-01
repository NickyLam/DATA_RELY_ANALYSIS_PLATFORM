#!/usr/bin/env python3
"""
测试指标血缘服务
"""

import logging
from pathlib import Path

from app.services.indicator_service import IndicatorService
from app.utils.cache_manager import CacheManager

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)


def main():
    base_dir = Path(__file__).parent
    # 正确的指标数据路径
    indicator_data_dir = base_dir / "财务集市指标血缘分析" / "指标"

    logger.info("指标数据目录: %s", indicator_data_dir)
    logger.info("数据目录是否存在: %s", indicator_data_dir.exists())

    if indicator_data_dir.exists():
        logger.info("指标数据目录内容:")
        for item in indicator_data_dir.iterdir():
            logger.info("  %s", item)

    cache = CacheManager()
    # 初始化指标服务时传入正确的数据路径
    service = IndicatorService(str(indicator_data_dir), cache)

    test_indices = ["FM0100011", "FM0100005", "FM0100015"]

    for index_no in test_indices:
        logger.info("\n" + "=" * 60)
        logger.info("测试指标: %s", index_no)
        logger.info("=" * 60)

        # 测试搜索
        logger.info("1. 搜索指标...")
        search_results = service.search_indicators(index_no)
        logger.info("搜索结果: %d 条", len(search_results))
        for r in search_results:
            logger.info("  - %s", r)

        # 测试详情
        logger.info("2. 获取指标详情...")
        detail = service.get_indicator_detail(index_no)
        logger.info("指标详情: %s", detail)

        # 测试血缘
        logger.info("3. 追溯指标血缘...")
        result = service.trace_indicator(index_no, direction="upstream", depth=5)
        logger.info("血缘查询结果:")
        logger.info("  - 目标指标: %s", result["target_index_no"])
        logger.info("  - 节点数: %s", len(result["graph"]["nodes"]) if result["graph"] else 0)
        logger.info("  - 边数: %s", len(result["graph"]["edges"]) if result["graph"] else 0)
        logger.info("  - 链条数: %s", len(result["chains"]))
        if result["graph"]:
            logger.info("  - 节点: %s", [n["display_label"] for n in result["graph"]["nodes"]])


if __name__ == "__main__":
    main()
