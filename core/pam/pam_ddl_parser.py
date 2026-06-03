"""
PAM DDL 解析器
从 Oracle PL/SQL*Plus 导出格式的单文件中解析多个 CREATE TABLE 语句，
提取表结构、字段定义和注释信息。

文件特征：
  - 单文件包含数千个 CREATE TABLE 语句
  - 使用裸表名（无 schema 前缀）
  - 包含 COMMENT ON TABLE/COLUMN 注释
  - 表之间由 prompt 行分隔
"""

from __future__ import annotations

import logging
import re
from pathlib import Path

from core.models import ColumnInfo, TableInfo

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# 正则模式
# ---------------------------------------------------------------------------

# CREATE TABLE table_name (
_CREATE_TABLE_RE = re.compile(
    r"create\s+table\s+([\w.]+)\s*\(",
    re.IGNORECASE,
)

# 列定义：col_name DATA_TYPE[(precision)] [NOT NULL] [DEFAULT ...]
_COLUMN_DEF_RE = re.compile(
    r"^\s*,?\s*"
    r"(\w+)\s+"
    r"(varchar2|number|date|char|clob|blob|integer|float|timestamp|long|numeric|decimal|varchar|nvarchar2|raw|nchar|nclob|interval|xmltype)"
    r"(\([^)]*\))?"
    r"(?:\s+default\s+[^,\n]*)?"
    r"(?:\s+not\s+null)?"
    r"\s*,?"
    r"(?:\s*--\s*(.*))?$",
    re.IGNORECASE,
)

# COMMENT ON TABLE table_name IS '...'
_COMMENT_TABLE_RE = re.compile(
    r"comment\s+on\s+table\s+([\w.]+)\s+is\s+'([^']*)'",
    re.IGNORECASE,
)

# COMMENT ON COLUMN table_name.column_name IS '...'
_COMMENT_COLUMN_RE = re.compile(
    r"comment\s+on\s+column\s+([\w.]+)\.([\w]+)\s+is\s+'([^']*)'",
    re.IGNORECASE,
)


class PamDDLParser:
    """PAM DDL 解析器 — 从单文件中拆分并解析多个 CREATE TABLE"""

    def __init__(self, default_schema: str = "pam"):
        self._default_schema = default_schema.upper()

    def parse_file(self, file_path: Path) -> list[TableInfo]:
        """解析 DDL 文件，返回所有表结构列表"""
        try:
            with open(file_path, encoding="utf-8", errors="ignore") as f:
                content = f.read()
        except OSError as e:
            logger.error("读取 DDL 文件失败: %s - %s", file_path, e)
            return []

        if not content.strip():
            return []

        blocks = self._split_tables(content)
        logger.info("PamDDLParser: 文件 %s 拆分出 %d 个表块", file_path.name, len(blocks))

        tables: list[TableInfo] = []
        for block in blocks:
            table_info = self._parse_single_table(block)
            if table_info is not None:
                tables.append(table_info)

        logger.info("PamDDLParser: 成功解析 %d 张表", len(tables))
        return tables

    def _split_tables(self, content: str) -> list[str]:
        """按 CREATE TABLE 边界拆分为独立块"""
        positions = [m.start() for m in _CREATE_TABLE_RE.finditer(content)]
        if not positions:
            return []

        blocks: list[str] = []
        for i, start in enumerate(positions):
            end = positions[i + 1] if i + 1 < len(positions) else len(content)
            blocks.append(content[start:end])
        return blocks

    def _parse_single_table(self, block: str) -> TableInfo | None:
        """解析单个表块，提取表名、列定义和注释"""
        match = _CREATE_TABLE_RE.search(block)
        if not match:
            return None

        raw_name = match.group(1).strip().upper()
        # 处理可能的 schema.table 格式
        if "." in raw_name:
            table_name = raw_name.split(".", 1)[1]
        else:
            table_name = raw_name

        columns = self._extract_columns(block, match.end())
        table_comment, col_comments = self._extract_comments(block, table_name)

        # 将 COMMENT ON COLUMN 的注释合并到列定义
        for col in columns:
            if col.name in col_comments:
                col.comment = col_comments[col.name]

        full_name = f"{self._default_schema}.{table_name}"

        return TableInfo(
            schema=self._default_schema,
            table_name=table_name,
            full_name=full_name,
            comment=table_comment,
            columns=columns,
            file_path="",
        )

    def _extract_columns(self, block: str, body_start: int) -> list[ColumnInfo]:
        """从 CREATE TABLE 体中提取列定义"""
        # 用括号计数法找到表体结束位置
        depth = 1
        end = body_start
        for i in range(body_start, len(block)):
            if block[i] == "(":
                depth += 1
            elif block[i] == ")":
                depth -= 1
                if depth == 0:
                    end = i
                    break

        table_body = block[body_start:end]
        columns: list[ColumnInfo] = []

        for line in table_body.split("\n"):
            line = line.strip()
            if not line:
                continue
            # 跳过约束行
            if re.match(
                r"^\s*(constraint|partition|primary|foreign|unique|check|using|tablespace|supplemental)",
                line,
                re.IGNORECASE,
            ):
                continue

            col_match = _COLUMN_DEF_RE.match(line)
            if col_match:
                col_name = col_match.group(1).upper()
                col_type = col_match.group(2).upper()
                precision = col_match.group(3)
                if precision:
                    col_type += precision.upper()
                inline_comment = col_match.group(4)
                comment = inline_comment.strip() if inline_comment else ""

                columns.append(
                    ColumnInfo(
                        name=col_name,
                        data_type=col_type,
                        comment=comment,
                    )
                )

        return columns

    def _extract_comments(self, block: str, table_name: str) -> tuple[str, dict[str, str]]:
        """提取表注释和列注释"""
        table_comment = ""
        col_comments: dict[str, str] = {}

        for m in _COMMENT_TABLE_RE.finditer(block):
            comment_table = m.group(1).upper()
            if "." in comment_table:
                comment_table = comment_table.split(".", 1)[1]
            if comment_table == table_name:
                table_comment = m.group(2)
                break

        for m in _COMMENT_COLUMN_RE.finditer(block):
            comment_table = m.group(1).upper()
            if "." in comment_table:
                comment_table = comment_table.split(".", 1)[1]
            if comment_table == table_name:
                col_name = m.group(2).upper()
                col_comments[col_name] = m.group(3)

        return table_comment, col_comments
