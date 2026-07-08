#!/usr/bin/env python3
"""
缓存迁移脚本: 从 pickle/json 迁移到 SQLite

用法:
    python scripts/migrate_cache_to_sqlite.py --input output/lineage_data.pkl --output output/lineage.db
    python scripts/migrate_cache_to_sqlite.py --input output/lineage_data.json --output output/lineage.db

行为:
    1. 优先读取 pickle；pickle 不存在或版本不匹配时读取 JSON。
    2. 校验 metadata 和必要字段。
    3. 调用 SQLiteResultStore.save() 写入。
    4. 输出迁移统计。
    5. 不删除旧缓存文件。
"""

from __future__ import annotations

import argparse
import json
import logging
import pickle
import sys
import time
from pathlib import Path

# 添加项目根目录到 sys.path
project_root = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(project_root))

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)


def load_from_pickle(pickle_path: Path) -> dict | None:
    """从 pickle 文件加载数据。"""
    if not pickle_path.exists():
        return None
    try:
        with open(pickle_path, "rb") as f:
            data = pickle.load(f)
        logger.info("从 pickle 加载: %s", pickle_path)
        return data
    except Exception as e:
        logger.error("加载 pickle 失败: %s", e)
        return None


def load_from_json(json_path: Path) -> dict | None:
    """从 JSON 文件加载数据。"""
    if not json_path.exists():
        return None
    try:
        with open(json_path, encoding="utf-8") as f:
            data = json.load(f)
        logger.info("从 JSON 加载: %s", json_path)
        return data
    except Exception as e:
        logger.error("加载 JSON 失败: %s", e)
        return None


def validate_data(data: dict) -> bool:
    """校验数据格式。"""
    metadata = data.get("metadata", {})
    if not metadata:
        logger.error("数据缺少 metadata")
        return False
    if not metadata.get("total_tables"):
        logger.error("metadata 中 total_tables 为空")
        return False
    return True


def main():
    parser = argparse.ArgumentParser(description="迁移缓存到 SQLite")
    parser.add_argument(
        "--input",
        type=Path,
        default=None,
        help="输入缓存文件路径 (pickle 或 json)，默认自动检测",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("output/lineage.db"),
        help="输出 SQLite 文件路径 (默认: output/lineage.db)",
    )
    args = parser.parse_args()

    output_path = args.output
    if not output_path.is_absolute():
        output_path = project_root / output_path

    # 自动检测或使用指定输入
    data = None
    if args.input:
        input_path = args.input
        if not input_path.is_absolute():
            input_path = project_root / input_path
        if input_path.suffix == ".pkl":
            data = load_from_pickle(input_path)
        elif input_path.suffix == ".json":
            data = load_from_json(input_path)
        else:
            logger.error("不支持的输入文件格式: %s", input_path.suffix)
            sys.exit(1)
    else:
        # 自动检测
        pickle_path = project_root / "output" / "lineage_data.pkl"
        json_path = project_root / "output" / "lineage_data.json"
        data = load_from_pickle(pickle_path)
        if data is None:
            data = load_from_json(json_path)

    if data is None:
        logger.error("未找到可迁移的缓存数据")
        sys.exit(1)

    if not validate_data(data):
        logger.error("数据校验失败")
        sys.exit(1)

    # 输出旧数据统计
    metadata = data.get("metadata", {})
    logger.info("源数据统计:")
    logger.info("  表: %s", metadata.get("total_tables", 0))
    logger.info("  过程: %s", metadata.get("total_procedures", 0))
    logger.info(
        "  血缘: %s",
        metadata.get("total_table_lineages", len(data.get("table_lineages", []))),
    )
    logger.info(
        "  映射: %s",
        metadata.get("total_field_mappings", len(data.get("field_mappings", []))),
    )
    logger.info(
        "  口径: %s",
        metadata.get("total_caliber_infos", len(data.get("caliber_infos", []))),
    )

    # 写入 SQLite
    from app.services.storage.sqlite_store import SQLiteResultStore

    logger.info("开始写入 SQLite: %s", output_path)
    t0 = time.time()

    store = SQLiteResultStore(output_path)
    store.save(data)

    elapsed = time.time() - t0
    db_size_mb = output_path.stat().st_size / (1024 * 1024)

    logger.info("迁移完成!")
    logger.info("  耗时: %.2fs", elapsed)
    logger.info("  数据库大小: %.1f MB", db_size_mb)

    # 验证
    loaded = store.load()
    if loaded:
        logger.info("验证结果:")
        logger.info("  表: %d", len(loaded.get("tables", [])))
        logger.info("  过程: %d", len(loaded.get("procedures", [])))
        logger.info("  血缘: %d", len(loaded.get("table_lineages", [])))
        logger.info("  映射: %d", len(loaded.get("field_mappings", [])))
        logger.info("  口径: %d", len(loaded.get("caliber_infos", [])))
    else:
        logger.error("验证失败: 无法从 SQLite 读取数据")
        sys.exit(1)

    logger.info("旧缓存文件未删除，可手动清理")


if __name__ == "__main__":
    main()
