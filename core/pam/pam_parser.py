"""
PAM 解析器主入口
实现 FileParser Protocol，组合 DDL/DML 子解析器，
采用两阶段解析策略（DDL 先于 DML）。

对外暴露统一的 parse_file / parse_directory 接口，
由 ParserRegistry 按文件扩展名路由。
"""

from __future__ import annotations

import logging
from pathlib import Path

from core.parser_protocol import ParseOutput
from core.pam.pam_ddl_parser import PamDDLParser
from core.pam.pam_dml_parser import PamDMLParser

logger = logging.getLogger(__name__)


class PamParser:
    """PAM 解析器 — 实现 FileParser Protocol

    两阶段解析策略：
      Phase 1: 解析 ddl/ 目录，构建表结构
      Phase 2: 解析 dml/ 目录，提取过程血缘

    用法:
        parser = PamParser(default_schema="pam")
        output = parser.parse_directory(Path("SOURCE_DATA/PAM"))
    """

    def __init__(self, default_schema: str = "pam"):
        self._default_schema = default_schema
        self._ddl_parser = PamDDLParser(default_schema)
        self._dml_parser = PamDMLParser(default_schema)

    def supported_extensions(self) -> list[str]:
        return [".sql"]

    def parse_file(self, file_path: Path) -> ParseOutput:
        """解析单个文件，根据路径判断 DDL 或 DML"""
        if not file_path.exists():
            return ParseOutput(errors=[f"文件不存在: {file_path}"])

        path_str = str(file_path).lower()
        in_ddl_dir = "/ddl/" in path_str or "\\ddl\\" in path_str
        in_dml_dir = "/dml/" in path_str or "\\dml\\" in path_str

        if in_ddl_dir:
            return self._parse_ddl_file(file_path)
        elif in_dml_dir:
            return self._dml_parser.parse_file(file_path)
        else:
            # 未知路径：先尝试 DDL，无结果回退 DML
            output = self._parse_ddl_file(file_path)
            if output.tables:
                return output
            return self._dml_parser.parse_file(file_path)

    def parse_directory(self, dir_path: Path) -> ParseOutput:
        """两阶段解析目录

        Phase 1 (DDL) 并行解析，Phase 2 (DML) 保持顺序解析，
        以维持两阶段语义不变。
        """
        if not dir_path.exists():
            return ParseOutput(errors=[f"目录不存在: {dir_path}"])

        if not dir_path.is_dir():
            return ParseOutput(errors=[f"路径不是目录: {dir_path}"])

        total_output = ParseOutput()

        logger.info("=== PAM 两阶段解析开始: %s (schema=%s) ===", dir_path, self._default_schema)

        # Phase 1: 并行解析 DDL
        logger.info("Phase 1: 并行解析 DDL 文件...")
        ddl_files: list[Path] = []
        for ddl_dir in dir_path.rglob("ddl"):
            if ddl_dir.is_dir():
                ddl_files.extend(f for f in sorted(ddl_dir.rglob("*.sql")) if f.is_file())

        if ddl_files:
            from concurrent.futures import ThreadPoolExecutor, as_completed

            with ThreadPoolExecutor(max_workers=4) as executor:
                futures = {executor.submit(self._parse_ddl_file, fp): fp for fp in ddl_files}
                for future in as_completed(futures):
                    fp = futures[future]
                    try:
                        ddl_output = future.result()
                    except Exception as e:
                        logger.warning("解析 PAM DDL 文件失败: %s - %s", fp, e)
                        total_output.errors.append(f"DDL 文件 {fp.name}: {str(e)}")
                        continue
                    total_output.merge(ddl_output)

        logger.info("Phase 1 完成: DDL 解析出 %d 张表", len(total_output.tables))

        # Phase 2: 顺序解析 DML（保持两阶段语义，不并行）
        logger.info("Phase 2: 解析 DML 文件...")
        for dml_dir in dir_path.rglob("dml"):
            if dml_dir.is_dir():
                for sql_file in sorted(dml_dir.rglob("*.sql")):
                    if sql_file.is_file():
                        dml_output = self._dml_parser.parse_file(sql_file)
                        total_output.merge(dml_output)

        summary = total_output.summary()
        logger.info(
            "=== PAM 解析完成: %d 表, %d 过程, %d 血缘, %d 字段映射 ===",
            summary["tables"],
            summary["procedures"],
            summary["table_lineages"],
            summary["field_mappings"],
        )

        return total_output

    def _parse_ddl_file(self, file_path: Path) -> ParseOutput:
        """解析 DDL 文件，转换为 ParseOutput"""
        tables = self._ddl_parser.parse_file(file_path)
        output = ParseOutput()
        for table_info in tables:
            output.tables.append({
                "full_name": table_info.full_name,
                "schema": table_info.schema,
                "table_name": table_info.table_name,
                "comment": table_info.comment,
                "columns": [
                    {"name": c.name, "data_type": c.data_type, "comment": c.comment}
                    for c in table_info.columns
                ],
                "primary_keys": getattr(table_info, "primary_keys", []),
            })
        return output
