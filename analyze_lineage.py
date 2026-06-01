#!/usr/bin/env python3
"""
数据库血缘分析工具 (CLI 入口)

功能已迁移到：
  - OracleTableParser       -> core/table_parser.py
  - EnhancedProcedureParser -> core/procedure_parser.py
  - LineageTracer           -> core/lineage_tracer.py
  - CaliberExtractor        -> core/caliber_extractor.py
  - FastAPI 服务            -> app/main.py
"""

import json
import logging
import os

from core.caliber_extractor import CaliberExtractor
from core.models import FieldMapping, TableLineage
from core.procedure_parser import EnhancedProcedureParser
from core.table_parser import OracleTableParser

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


def main() -> None:
    base_dir = os.path.dirname(os.path.abspath(__file__))
    rrp_dir = os.path.join(base_dir, "RRP_ORACLE")

    if not os.path.exists(rrp_dir):
        logger.error("目录不存在: %s", rrp_dir)
        return

    output_dir = os.path.join(base_dir, "output")
    os.makedirs(output_dir, exist_ok=True)

    logger.info("=" * 60)
    logger.info("开始解析数据库血缘关系 (Enhanced Parser)")
    logger.info("=" * 60)

    logger.info("第一步: 解析表结构...")
    table_parser = OracleTableParser()
    for schema_dir in ["rrp_east", "rrp_mdl"]:
        full_dir = os.path.join(rrp_dir, schema_dir)
        if os.path.exists(full_dir):
            table_parser.parse_directory(full_dir)

    logger.info("共解析 %d 张表", len(table_parser.tables))

    logger.info("第二步: 解析存储过程...")
    enhanced_parser = EnhancedProcedureParser(table_parser.tables)
    procedures_dict: dict = {}
    for schema_dir in ["rrp_mdl", "rrp_east"]:
        full_dir = os.path.join(rrp_dir, schema_dir)
        if os.path.exists(full_dir):
            procedures_dict.update(enhanced_parser.parse_directory(full_dir))

    logger.info("共解析 %d 个存储过程", len(procedures_dict))

    logger.info("第三步: 构建血缘关系...")
    all_field_mappings: list[FieldMapping] = []
    all_table_lineages: list[TableLineage] = []

    for proc_info in procedures_dict.values():
        all_field_mappings.extend(proc_info.field_mappings)
        all_table_lineages.extend(proc_info.table_lineages)

    logger.info("表级血缘关系: %d 条", len(all_table_lineages))
    logger.info("字段级映射关系: %d 条", len(all_field_mappings))

    logger.info("第三步(续): 提取指标口径...")
    all_caliber_infos = []
    for proc_info in procedures_dict.values():
        caliber_infos = enhanced_parser.extract_caliber_from_proc(proc_info, data_source="oracle")
        all_caliber_infos.extend(caliber_infos)
    logger.info("口径信息: %d 条", len(all_caliber_infos))

    logger.info("第四步: 导出结构化数据...")
    json_path = os.path.join(output_dir, "lineage_data.json")

    tables_list = [
        {
            "full_name": t.full_name,
            "schema": t.schema,
            "table_name": t.table_name,
            "comment": t.comment,
            "columns": [{"name": c.name, "data_type": c.data_type, "comment": c.comment} for c in t.columns],
            "primary_keys": t.primary_keys,
        }
        for t in table_parser.tables.values()
    ]

    procs_list = [
        {
            "full_name": p.full_name,
            "schema": p.schema,
            "proc_name": p.proc_name,
            "description": p.description,
            "source_tables": p.source_tables,
            "target_tables": p.target_tables,
            "config_tables": getattr(p, "config_tables", []),
        }
        for p in procedures_dict.values()
    ]

    lineages_list = [
        {
            "source_table": tl.source_table,
            "target_table": tl.target_table,
            "procedure": tl.procedure,
        }
        for tl in all_table_lineages
    ]

    mappings_list = [
        {
            "source_table": fm.source_table,
            "source_column": fm.source_column,
            "target_table": fm.target_table,
            "target_column": fm.target_column,
            "transform_logic": fm.transform_logic,
            "procedure": fm.procedure,
            "confidence": fm.confidence,
        }
        for fm in all_field_mappings
    ]

    data = {
        "metadata": {
            "total_tables": len(tables_list),
            "total_procedures": len(procs_list),
            "total_table_lineages": len(lineages_list),
            "total_field_mappings": len(mappings_list),
            "total_caliber_infos": len(all_caliber_infos),
            "parser_version": "enhanced-v2",
        },
        "tables": tables_list,
        "procedures": procs_list,
        "table_lineages": lineages_list,
        "field_mappings": mappings_list,
        "caliber_infos": [CaliberExtractor.to_dict(ci) for ci in all_caliber_infos],
    }

    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    logger.info("JSON数据已导出到: %s", json_path)
    logger.info("=" * 60)
    logger.info("分析完成!")
    logger.info("=" * 60)


if __name__ == "__main__":
    main()
