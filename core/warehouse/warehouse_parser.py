"""
数仓脚本解析器主入口（多系统配置注入版本）

组合 DDL/DML/CTL 子解析器，实现两阶段解析（DDL 优先，DML 其次），
对外暴露 FileParser Protocol 接口。

支持多系统：通过 system 参数注入不同的 SchemaResolver 配置，
使同一套解析器可复用于 EDW/MCS/PAM/CCR/ICR/BRT 等多个数仓类系统。
"""

from __future__ import annotations

import logging
from pathlib import Path
from typing import Optional

from core.parser_protocol import ParseOutput
from core.warehouse.schema_resolver import SchemaResolver
from core.warehouse.temp_table_filter import TempTableFilter
from core.warehouse.ddl_parser import DDLParser
from core.warehouse.dml_parser import DMLParser
from core.warehouse.ctl_parser import CTLParser

logger = logging.getLogger(__name__)


class WarehouseSQLParser:
    """数仓脚本解析器 — 实现 FileParser Protocol（多系统配置注入版本）

    两阶段解析策略：
      Phase 1: 解析所有 DDL 文件，构建表结构字典
      Phase 2: 解析所有 DML 文件，用表结构字典辅助字段映射

    多系统支持：
      通过 system 参数指定当前解析的系统，影响 schema 变量映射。
      不同系统可使用不同的 SchemaResolver 配置。

    用法:
        # RRP/默认模式
        parser = WarehouseSQLParser()
        output = parser.parse_directory(Path("数仓脚本/"))

        # 指定系统模式
        parser = WarehouseSQLParser(system="edw")
        output = parser.parse_directory(Path("SOURCE_DATA/EDW/"))
    """

    def __init__(
        self,
        schema_resolver: Optional[SchemaResolver] = None,
        system: str = "rrp",
    ):
        self._schema_resolver = schema_resolver or SchemaResolver()
        self._system = system
        self._temp_filter = TempTableFilter()
        self._ddl_parser = DDLParser(self._schema_resolver)
        self._dml_parser = DMLParser(self._schema_resolver, self._temp_filter)
        self._ctl_parser = CTLParser(self._schema_resolver)

    @property
    def system(self) -> str:
        return self._system

    def supported_extensions(self) -> list[str]:
        return [".sql", ".ctl"]

    def parse_file(self, file_path: Path) -> ParseOutput:
        if not file_path.exists():
            return ParseOutput(errors=[f"文件不存在: {file_path}"])

        ext = file_path.suffix.lower()

        if ext == ".ctl":
            return self._ctl_parser.parse_file(file_path)

        path_str = str(file_path).lower()

        if "/ddl/" in path_str or "\\ddl\\" in path_str:
            output = self._ddl_parser.parse_file(file_path)
            if not output.tables:
                dml_output = self._dml_parser.parse_file(file_path)
                if dml_output.table_lineages or dml_output.field_mappings:
                    return dml_output
            return self._table_info_to_output(output)

        elif "/dml/" in path_str or "\\dml\\" in path_str:
            return self._dml_parser.parse_file(file_path)

        elif "/ext/" in path_str or "\\ext\\" in path_str:
            output = self._ddl_parser.parse_file(file_path)
            return self._table_info_to_output(output)

        else:
            ddl_output = self._ddl_parser.parse_file(file_path)
            if ddl_output and ddl_output.columns:
                return self._table_info_to_output(ddl_output)
            return self._dml_parser.parse_file(file_path)

    def parse_directory(self, dir_path: Path) -> ParseOutput:
        if not dir_path.exists():
            return ParseOutput(errors=[f"目录不存在: {dir_path}"])

        if not dir_path.is_dir():
            return ParseOutput(errors=[f"路径不是目录: {dir_path}"])

        total_output = ParseOutput()

        logger.info("=== 数仓脚本两阶段解析开始: %s (system=%s) ===", dir_path, self._system)

        # Phase 1: 解析 DDL
        logger.info("Phase 1: 解析 DDL 文件...")
        ddl_tables: dict = {}

        for ddl_dir in dir_path.rglob("ddl"):
            if ddl_dir.is_dir():
                tables = self._ddl_parser.parse_directory(ddl_dir)
                ddl_tables.update(tables)

        for table_info in ddl_tables.values():
            total_output.tables.append({
                "full_name": table_info.full_name,
                "schema": table_info.schema,
                "table_name": table_info.table_name,
                "comment": table_info.comment,
                "columns": [
                    {"name": c.name, "data_type": c.data_type, "comment": c.comment}
                    for c in table_info.columns
                ],
                "primary_keys": table_info.primary_keys,
            })

        logger.info(
            "Phase 1 完成: DDL 解析出 %d 张表",
            len(ddl_tables),
        )

        # 将 DDL 表结构注入 DML 解析器（辅助字段映射）
        self._dml_parser = DMLParser(
            self._schema_resolver, self._temp_filter, ddl_tables
        )

        # Phase 2: 解析 DML
        logger.info("Phase 2: 解析 DML 文件...")
        dml_count = 0
        for dml_dir in dir_path.rglob("dml"):
            if dml_dir.is_dir():
                dml_output = self._dml_parser.parse_directory(dml_dir)
                total_output.merge(dml_output)
                dml_count += 1

        logger.info(
            "Phase 2 完成: DML 解析出 %d 条血缘, %d 条字段映射",
            len(total_output.table_lineages),
            len(total_output.field_mappings),
        )

        # Phase 3: 解析 CTL
        logger.info("Phase 3: 解析 CTL 文件...")
        ctl_count = 0
        for ctl_file in dir_path.rglob("*.ctl"):
            ctl_output = self._ctl_parser.parse_file(ctl_file)
            total_output.merge(ctl_output)
            ctl_count += 1

        logger.info(
            "Phase 3 完成: CTL 解析 %d 个文件",
            ctl_count,
        )

        # 过滤临时表
        total_output.tables = self._temp_filter.filter_tables(total_output.tables)

        summary = total_output.summary()
        logger.info(
            "=== 数仓脚本解析完成: %d 表, %d 过程, %d 血缘, %d 字段映射 (system=%s) ===",
            summary["tables"],
            summary["procedures"],
            summary["table_lineages"],
            summary["field_mappings"],
            self._system,
        )

        return total_output

    def _table_info_to_output(self, table_info) -> ParseOutput:
        output = ParseOutput()
        if table_info is not None:
            output.tables.append({
                "full_name": table_info.full_name,
                "schema": table_info.schema,
                "table_name": table_info.table_name,
                "comment": table_info.comment,
                "columns": [
                    {"name": c.name, "data_type": c.data_type, "comment": c.comment}
                    for c in table_info.columns
                ],
                "primary_keys": table_info.primary_keys,
            })
        return output
