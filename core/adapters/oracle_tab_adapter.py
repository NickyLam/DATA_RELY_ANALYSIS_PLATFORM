"""
Oracle .tab 文件解析器适配器
将 OracleTableParser 适配为 FileParser Protocol，无需修改原始代码。
"""

from __future__ import annotations

import logging
from pathlib import Path

from core.parser_protocol import ParseOutput
from core.table_parser import OracleTableParser

logger = logging.getLogger(__name__)


class OracleTabAdapter:
    """适配 OracleTableParser → FileParser Protocol

    将 OracleTableParser 的返回值（TableInfo 对象）
    转换为 ParseOutput 的 dict 列表格式，与 ParserService.ParseResult 对齐。
    """

    def __init__(self, table_parser: OracleTableParser):
        self._parser = table_parser

    def supported_extensions(self) -> list[str]:
        return [".tab"]

    def parse_file(self, file_path: Path) -> ParseOutput:
        """解析单个 .tab 文件"""
        table_info = self._parser.parse_tab_file(str(file_path))
        if table_info is None:
            return ParseOutput()

        # 转换为 dict 格式（对齐 ParserService._parse_tab_directory 的序列化逻辑）
        table_dict = {
            "full_name": table_info.full_name,
            "schema": table_info.schema,
            "table_name": table_info.table_name,
            "comment": table_info.comment,
            "columns": [
                {"name": c.name, "data_type": c.data_type, "comment": c.comment}
                for c in table_info.columns
            ],
            "primary_keys": table_info.primary_keys,
        }
        return ParseOutput(tables=[table_dict])

    def parse_directory(self, dir_path: Path) -> ParseOutput:
        """递归解析目录下所有 .tab 文件"""
        output = ParseOutput()

        if not dir_path.exists() or not dir_path.is_dir():
            output.errors.append(f"目录不存在或不是目录: {dir_path}")
            return output

        for file_path in dir_path.rglob("*.tab"):
            try:
                file_output = self.parse_file(file_path)
                output.merge(file_output)
            except Exception as e:
                logger.warning("解析 .tab 文件失败: %s - %s", file_path, e)
                output.errors.append(f"文件 {file_path.name}: {str(e)}")

        logger.info(
            "OracleTabAdapter: 解析目录 %s, 共 %d 张表",
            dir_path, len(output.tables),
        )
        return output
