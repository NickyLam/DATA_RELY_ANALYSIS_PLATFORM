"""
数仓 DDL 解析器
从 .sql 文件中解析 CREATE TABLE 语句，提取表结构、字段定义、分区和注释。
支持 ${xxx_schema} 变量替换和行内注释（-- 注释）格式。
"""

from __future__ import annotations

import logging
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

from core.models import TableInfo, ColumnInfo
from core.warehouse.schema_resolver import SchemaResolver

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# 正则：DDL 解析
# ---------------------------------------------------------------------------

# CREATE TABLE ${xxx_schema}.table_name (
_CREATE_TABLE_PATTERN = re.compile(
    r"CREATE\s+TABLE\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"     # 表名（含变量或普通格式）
    r"\s*\(",
    re.IGNORECASE,
)

# COMMENT ON TABLE ${xxx_schema}.table_name IS '注释'
_COMMENT_TABLE_PATTERN = re.compile(
    r"COMMENT\s+ON\s+TABLE\s+"
    r"(?:\$\{[\w_]+\}|[\w]+)\.(\w+)"   # 表名（去掉 schema 部分）
    r"\s+IS\s+'([^']*)'",
    re.IGNORECASE,
)

# COMMENT ON COLUMN ${xxx_schema}.table_name.column IS '注释'
_COMMENT_COLUMN_PATTERN = re.compile(
    r"COMMENT\s+ON\s+COLUMN\s+"
    r"(?:\$\{[\w_]+\}|[\w]+)\.(\w+)\.(\w+)"  # 表名.列名
    r"\s+IS\s+'([^']*)'",
    re.IGNORECASE,
)

# 列定义行：列名 数据类型 [(精度)] [NOT NULL] -- 行内注释
# 支持的格式:
#   col_name varchar2(60) -- 注释
#   col_name number(22) -- 注释
#   col_name date -- 注释
#   etl_dt date -- ETL处理日期
_COLUMN_DEF_PATTERN = re.compile(
    r"^\s*,?\s*"                         # 可选的逗号前缀
    r"(\w+)\s+"                          # 列名
    r"(varchar2|number|date|char|clob|blob|integer|float|timestamp|long|numeric|decimal|varchar)"
    r"(\([^)]*\))?"                      # 可选的精度说明
    r"\s*(NOT\s+NULL)?"                  # 可选的 NOT NULL
    r"(?:\s*--\s*(.*))?$",              # 可选的行内注释
    re.IGNORECASE,
)


class DDLParser:
    """数仓 DDL 解析器

    从 .sql DDL 文件中提取：
      - 表名（含 schema 解析与变量替换）
      - 字段定义（名称、类型、注释）
      - 表注释
      - 分区信息

    用法:
        resolver = SchemaResolver()
        parser = DDLParser(resolver)
        table_info = parser.parse_file(Path("idl_abss_base_asset_info.sql"))
    """

    def __init__(self, schema_resolver: SchemaResolver):
        self._resolver = schema_resolver

    def parse_file(self, file_path: Path) -> Optional[TableInfo]:
        """解析单个 DDL 文件

        Args:
            file_path: .sql DDL 文件路径

        Returns:
            TableInfo 对象，解析失败返回 None
        """
        try:
            with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
        except OSError as e:
            logger.error("读取文件失败: %s - %s", file_path, e)
            return None

        if not content.strip():
            return None

        return self._parse_content(content, str(file_path))

    def parse_directory(self, dir_path: Path) -> dict[str, TableInfo]:
        """递归解析目录下所有 .sql DDL 文件

        Args:
            dir_path: DDL 目录路径

        Returns:
            {full_name: TableInfo} 字典
        """
        tables: dict[str, TableInfo] = {}

        if not dir_path.exists() or not dir_path.is_dir():
            return tables

        for file_path in sorted(dir_path.rglob("*.sql")):
            # 跳过非 SQL 文件
            if file_path.suffix.lower() != ".sql":
                continue

            table_info = self.parse_file(file_path)
            if table_info is not None:
                tables[table_info.full_name] = table_info

        logger.info("DDLParser: 解析目录 %s, 共 %d 张表", dir_path, len(tables))
        return tables

    def _parse_content(self, content: str, file_path: str) -> Optional[TableInfo]:
        """解析 DDL 内容

        Args:
            content: DDL 文件内容
            file_path: 文件路径（用于日志和 TableInfo.file_path）

        Returns:
            TableInfo 或 None
        """
        # 1. 提取 CREATE TABLE 语句中的表名
        raw_table_name = self._extract_table_name(content)
        if not raw_table_name:
            logger.debug("未找到 CREATE TABLE 语句: %s", file_path)
            return None

        # 2. 解析表名（变量替换）
        resolved = self._resolver.resolve_table_name(raw_table_name)
        if resolved is None:
            logger.warning("无法解析表名: %s (原始: %s)", file_path, raw_table_name)
            return None

        # 3. 从路径推断层级（如果变量替换未得到层级）
        inferred_layer = self._resolver.infer_schema_from_path(file_path)

        schema = resolved.schema or inferred_layer or "UNKNOWN"
        table_name = resolved.table_name
        full_name = f"{schema}.{table_name}" if schema else table_name

        # 4. 提取列定义
        columns = self._extract_columns(content, raw_table_name)

        # 5. 提取列注释（COMMENT ON COLUMN）
        column_comments = self._extract_column_comments(content, raw_table_name)
        for col in columns:
            if col.name.upper() in column_comments:
                col.comment = column_comments[col.name.upper()]

        # 6. 提取表注释
        table_comment = self._extract_table_comment(content, raw_table_name)

        # 7. 提取分区信息
        partitions = self._extract_partitions(content)

        # 8. 构建 TableInfo
        table_info = TableInfo(
            schema=schema,
            table_name=table_name,
            full_name=full_name,
            comment=table_comment,
            columns=columns,
            partitions=partitions,
            file_path=file_path,
        )

        return table_info

    def _extract_table_name(self, content: str) -> Optional[str]:
        """从 CREATE TABLE 语句中提取原始表名"""
        match = _CREATE_TABLE_PATTERN.search(content)
        if match:
            return match.group(1).strip()
        return None

    def _extract_columns(self, content: str, raw_table_name: str) -> list[ColumnInfo]:
        """从 CREATE TABLE 语句中提取列定义

        支持两种注释格式：
          - 行内注释: col_name varchar2(60) -- 注释
          - COMMENT ON COLUMN: comment on column schema.table.col is '注释'
        """
        columns: list[ColumnInfo] = []

        # 找到 CREATE TABLE ... ( ... ) 的内容
        # 使用括号计数法提取表体
        create_match = _CREATE_TABLE_PATTERN.search(content)
        if not create_match:
            return columns

        start = create_match.end()  # 指向 '(' 之后
        depth = 1
        end = start
        for i in range(start, len(content)):
            if content[i] == '(':
                depth += 1
            elif content[i] == ')':
                depth -= 1
                if depth == 0:
                    end = i
                    break

        table_body = content[start:end]
        lines = table_body.split('\n')

        for line in lines:
            line = line.strip()
            if not line:
                continue

            # 跳过约束行
            if re.match(
                r'^\s*(CONSTRAINT|PARTITION|PRIMARY|FOREIGN|UNIQUE|CHECK|USING|TABLESPACE)',
                line,
                re.IGNORECASE,
            ):
                continue

            col_match = _COLUMN_DEF_PATTERN.match(line)
            if col_match:
                col_name = col_match.group(1).upper()
                col_type = col_match.group(2).upper()
                precision = col_match.group(3)
                if precision:
                    col_type += precision
                nullable = col_match.group(4) is None
                inline_comment = col_match.group(5)
                comment = inline_comment.strip() if inline_comment else ""

                columns.append(ColumnInfo(
                    name=col_name,
                    data_type=col_type,
                    nullable=nullable,
                    comment=comment,
                ))

        return columns

    def _extract_column_comments(self, content: str, raw_table_name: str) -> dict[str, str]:
        """提取 COMMENT ON COLUMN 的列注释"""
        comments: dict[str, str] = {}
        for match in _COMMENT_COLUMN_PATTERN.finditer(content):
            col_name = match.group(2).upper()
            comment = match.group(3)
            comments[col_name] = comment
        return comments

    def _extract_table_comment(self, content: str, raw_table_name: str) -> str:
        """提取 COMMENT ON TABLE 的表注释"""
        # 先尝试替换变量后的匹配
        replaced_content = self._resolver.replace_schema_vars(content)
        match = _COMMENT_TABLE_PATTERN.search(replaced_content)
        if match:
            return match.group(2)

        # 回退到原始内容匹配
        match = _COMMENT_TABLE_PATTERN.search(content)
        if match:
            return match.group(2)

        return ""

    def _extract_partitions(self, content: str) -> list[str]:
        """提取分区名列表"""
        partitions: list[str] = []
        for match in re.finditer(
            r"PARTITION\s+(\w+)\s+VALUES\s*\(", content, re.IGNORECASE
        ):
            partitions.append(match.group(1))
        return partitions
