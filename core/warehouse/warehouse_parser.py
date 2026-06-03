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

from core.parser_protocol import ParseOutput
from core.warehouse.ctl_parser import CTLParser
from core.warehouse.ddl_parser import DDLParser
from core.warehouse.dml_parser import DMLParser
from core.warehouse.schema_resolver import SchemaResolver
from core.warehouse.temp_table_filter import TempTableFilter

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
        schema_resolver: SchemaResolver | None = None,
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

        # ★ 优化：先尝试 DDL 解析，如果解析出表结构则直接返回，
        # 不再单纯依赖路径中的 ddl/dml 关键字路由。
        # 这解决了 FDM 等数据源的 .sql 文件放在 dml/ 目录下但内容为 DDL 的问题。
        path_str = str(file_path).lower()
        in_ddl_dir = "/ddl/" in path_str or "\\ddl\\" in path_str
        in_dml_dir = "/dml/" in path_str or "\\dml\\" in path_str
        in_ext_dir = "/ext/" in path_str or "\\ext\\" in path_str

        if in_ddl_dir or in_ext_dir:
            # 明确的 DDL/ext 目录 → 先尝试 DDL，无结果回退 DML
            output = self._ddl_parser.parse_file(file_path)
            if output and output.columns:
                return self._table_info_to_output(output)
            return self._dml_parser.parse_file(file_path)

        if in_dml_dir:
            # dml 目录 → 先尝试 DML（大多数情况），但如果 DML 无产出则回退 DDL
            dml_output = self._dml_parser.parse_file(file_path)
            if dml_output and (dml_output.table_lineages or dml_output.field_mappings):
                return dml_output
            # ★ 回退尝试 DDL：处理 dml/ 目录下实际为 DDL 的文件
            ddl_output = self._ddl_parser.parse_file(file_path)
            if ddl_output and ddl_output.columns:
                return self._table_info_to_output(ddl_output)
            return dml_output

        # 未知路径 → 先 DDL，再 DML
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
            total_output.tables.append(
                {
                    "full_name": table_info.full_name,
                    "schema": table_info.schema,
                    "table_name": table_info.table_name,
                    "comment": table_info.comment,
                    "columns": [
                        {"name": c.name, "data_type": c.data_type, "comment": c.comment} for c in table_info.columns
                    ],
                    "primary_keys": table_info.primary_keys,
                }
            )

        logger.info(
            "Phase 1 完成: DDL 解析出 %d 张表",
            len(ddl_tables),
        )

        # 将 DDL 表结构注入 DML 解析器（辅助字段映射）
        # ★ 使用局部变量避免并发场景下 self._dml_parser 被覆盖导致竞态条件
        local_dml_parser = DMLParser(self._schema_resolver, self._temp_filter, ddl_tables)

        # Phase 2: 解析 DML
        # ★ 优化：DML 目录下的文件如果 DML 解析无产出，回退尝试 DDL
        # 解决 FDM 等数据源 dml/ 目录下实际为 DDL 文件的问题
        logger.info("Phase 2: 解析 DML 文件...")
        dml_count = 0
        ddl_fallback_count = 0
        for dml_dir in dir_path.rglob("dml"):
            if dml_dir.is_dir():
                dml_output = local_dml_parser.parse_directory(dml_dir)
                total_output.merge(dml_output)
                dml_count += 1

                # ★ 回退：对 DML 目录下仍无产出的 .sql 文件，并行尝试 DDL 解析
                if not dml_output.table_lineages and not dml_output.field_mappings:
                    sql_files = [f for f in dml_dir.rglob("*.sql") if f.is_file()]
                    if sql_files:
                        logger.info(
                            "DML 无产出，回退 DDL 解析 %d 个 .sql 文件...",
                            len(sql_files),
                        )
                        from concurrent.futures import ThreadPoolExecutor, as_completed

                        with ThreadPoolExecutor(max_workers=4) as pool:
                            futures = {pool.submit(self._ddl_parser.parse_file, f): f for f in sql_files}
                            for future in as_completed(futures):
                                try:
                                    ddl_result = future.result()
                                    if ddl_result and ddl_result.columns:
                                        ddl_tables[ddl_result.table_name] = ddl_result
                                        total_output.tables.append(
                                            {
                                                "full_name": ddl_result.full_name,
                                                "schema": ddl_result.schema,
                                                "table_name": ddl_result.table_name,
                                                "comment": ddl_result.comment,
                                                "columns": [
                                                    {
                                                        "name": c.name,
                                                        "data_type": c.data_type,
                                                        "comment": c.comment,
                                                    }
                                                    for c in ddl_result.columns
                                                ],
                                                "primary_keys": ddl_result.primary_keys,
                                            }
                                        )
                                        ddl_fallback_count += 1
                                except Exception as e:
                                    logger.warning("DDL 回退解析失败: %s", e)

        logger.info(
            "Phase 2 完成: DML 解析出 %d 条血缘, %d 条字段映射, DDL 回退解析 %d 张表",
            len(total_output.table_lineages),
            len(total_output.field_mappings),
            ddl_fallback_count,
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
            output.tables.append(
                {
                    "full_name": table_info.full_name,
                    "schema": table_info.schema,
                    "table_name": table_info.table_name,
                    "comment": table_info.comment,
                    "columns": [
                        {"name": c.name, "data_type": c.data_type, "comment": c.comment} for c in table_info.columns
                    ],
                    "primary_keys": table_info.primary_keys,
                }
            )
        return output
