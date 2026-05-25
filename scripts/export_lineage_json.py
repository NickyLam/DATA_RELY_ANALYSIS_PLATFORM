#!/usr/bin/env python3
"""
JSON 导出脚本: 将 SQLite 缓存数据导出为 JSON 文件

用法:
    python scripts/export_lineage_json.py
    python scripts/export_lineage_json.py --output output/lineage_data.json
    python scripts/export_lineage_json.py --db output/lineage.db --output output/lineage_export.json

行为:
    1. 从 SQLite 数据库读取解析结果。
    2. 导出为 JSON 文件。
    3. 需要 enable_json_export 配置为 true（默认）。
"""

from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path

# 添加项目根目录到 sys.path
project_root = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(project_root))

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)


def main():
    parser = argparse.ArgumentParser(description="导出 SQLite 缓存数据为 JSON")
    parser.add_argument(
        "--db", type=Path, default=Path("output/lineage.db"),
        help="SQLite 数据库路径 (默认: output/lineage.db)",
    )
    parser.add_argument(
        "--output", type=Path, default=Path("output/lineage_data.json"),
        help="输出 JSON 文件路径 (默认: output/lineage_data.json)",
    )
    args = parser.parse_args()

    db_path = args.db
    if not db_path.is_absolute():
        db_path = project_root / db_path

    output_path = args.output
    if not output_path.is_absolute():
        output_path = project_root / output_path

    if not db_path.exists():
        logger.error("SQLite 数据库不存在: %s", db_path)
        sys.exit(1)

    # 检查配置是否允许导出
    try:
        from app.config import config
        if not config.enable_json_export:
            logger.error("JSON 导出已禁用 (ENABLE_JSON_EXPORT=false)")
            sys.exit(1)
    except Exception:
        logger.warning("无法读取配置，跳过导出权限检查")

    from app.services.storage.sqlite_store import SQLiteResultStore

    store = SQLiteResultStore(db_path)
    logger.info("从 SQLite 导出: %s -> %s", db_path, output_path)
    store.export_json(output_path)

    if output_path.exists():
        size_mb = output_path.stat().st_size / (1024 * 1024)
        logger.info("导出完成: %.1f MB", size_mb)
    else:
        logger.error("导出失败")
        sys.exit(1)


if __name__ == "__main__":
    main()
