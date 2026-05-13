"""
Oracle 表结构解析器
解析 .tab 文件中的 CREATE TABLE 语句，提取表名、字段、主键、分区等信息
"""

import os
import re
import logging
from typing import Optional

from core.models import TableInfo, ColumnInfo

logger = logging.getLogger(__name__)


class OracleTableParser:
    """表结构解析器"""

    def __init__(self):
        self.tables: dict[str, TableInfo] = {}

    def parse_tab_file(self, file_path: str) -> Optional[TableInfo]:
        """解析.tab文件"""
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
        except Exception as e:
            logger.error(f"读取文件失败: {file_path}, 错误: {e}")
            return None

        table_info = self._parse_create_table(content)
        if not table_info:
            return None

        table_info.file_path = file_path
        table_info.columns = self._parse_columns(content)
        table_info.comment = self._parse_table_comment(content, table_info.full_name)
        table_info.primary_keys = self._parse_primary_keys(content)
        table_info.partitions = self._parse_partitions(content)

        return table_info

    def _parse_create_table(self, content: str) -> Optional[TableInfo]:
        """解析CREATE TABLE语句"""
        match = re.search(
            r'CREATE\s+TABLE\s+([\w.]+)\s*\((.*?)\)\s*(?:PARTITION\s+BY|TABLESPACE|/|$)',
            content,
            re.IGNORECASE | re.DOTALL
        )
        if not match:
            return None

        full_name = match.group(1).strip()
        parts = full_name.split('.')
        if len(parts) == 2:
            schema, table_name = parts
        else:
            schema = "UNKNOWN"
            table_name = parts[0]

        return TableInfo(
            schema=schema,
            table_name=table_name.upper(),
            full_name=full_name.upper(),
        )

    def _parse_columns(self, content: str) -> list[ColumnInfo]:
        """解析字段定义（使用括号计数法避免正则懒惰匹配截断）"""
        columns = []

        # 1. 找到 CREATE TABLE ... ( 的位置
        match = re.search(r'CREATE\s+TABLE\s+[\w.]+\s*\(', content, re.IGNORECASE)
        if not match:
            return columns

        start = match.end()  # 指向 '(' 之后的位置
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
            line = line.strip().rstrip(',')
            if not line:
                continue
            if re.match(r'^\s*(CONSTRAINT|PARTITION|PRIMARY|FOREIGN|UNIQUE|CHECK)', line, re.IGNORECASE):
                continue

            col_match = re.match(r'^(\w+)\s+(VARCHAR2|NUMBER|CHAR|DATE|CLOB|BLOB|INTEGER|FLOAT|TIMESTAMP|LONG)(\([^)]*\))?\s*(NOT\s+NULL)?', line, re.IGNORECASE)
            if col_match:
                col_name = col_match.group(1).upper()
                col_type = col_match.group(2).upper()
                if col_match.group(3):
                    col_type += col_match.group(3)
                nullable = 'NOT NULL' not in line.upper()

                columns.append(ColumnInfo(
                    name=col_name,
                    data_type=col_type,
                    nullable=nullable,
                ))

        return columns

    def _parse_table_comment(self, content: str, table_name: str) -> str:
        """解析表注释"""
        pattern = rf"COMMENT\s+ON\s+TABLE\s+{re.escape(table_name)}\s+IS\s+'([^']+)'"
        match = re.search(pattern, content, re.IGNORECASE)
        return match.group(1) if match else ""

    def _parse_column_comments(self, content: str, table_name: str) -> dict[str, str]:
        """解析字段注释"""
        comments = {}
        pattern = rf"COMMENT\s+ON\s+COLUMN\s+{re.escape(table_name)}\.(\w+)\s+IS\s+'([^']+)'"
        for match in re.finditer(pattern, content, re.IGNORECASE):
            comments[match.group(1).upper()] = match.group(2)
        return comments

    def _parse_primary_keys(self, content: str) -> list[str]:
        """解析主键"""
        pks = []
        pk_match = re.search(r'PRIMARY\s+KEY\s*\(([^)]+)\)', content, re.IGNORECASE)
        if pk_match:
            pks = [pk.strip().upper() for pk in pk_match.group(1).split(',')]
        return pks

    def _parse_partitions(self, content: str) -> list[str]:
        """解析分区信息"""
        partitions = []
        for match in re.finditer(r'PARTITION\s+(\w+)\s+VALUES\s*\(', content, re.IGNORECASE):
            partitions.append(match.group(1))
        return partitions

    def parse_directory(self, directory: str) -> dict[str, TableInfo]:
        """解析目录下的所有.tab文件"""
        for root, _, files in os.walk(directory):
            for file in files:
                if file.endswith('.tab'):
                    file_path = os.path.join(root, file)
                    table_info = self.parse_tab_file(file_path)
                    if table_info:
                        self.tables[table_info.full_name] = table_info
                        logger.info(f"解析表: {table_info.full_name}")

        return self.tables
