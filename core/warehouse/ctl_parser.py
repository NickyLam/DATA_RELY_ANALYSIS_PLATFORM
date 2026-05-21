"""
数仓 CTL 文件解析器
从 .ctl (SQL*Loader 控制文件) 中提取目标表名和字段定义。
CTL 文件描述数据文件到数据库表的加载映射，是 MSL 层数据进入数仓的入口。
"""

from __future__ import annotations

import logging
import re
from pathlib import Path
from typing import Optional

from core.models import TableInfo, ColumnInfo
from core.parser_protocol import ParseOutput
from core.warehouse.schema_resolver import SchemaResolver

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# 正则：CTL 解析
# ---------------------------------------------------------------------------

# INTO TABLE ${xxx_schema}.table_name
_INTO_TABLE_PATTERN = re.compile(
    r"(?:INTO|TRUNCATE\s+INTO)\s+TABLE\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)",       # 目标表名
    re.IGNORECASE,
)

# INFILE 'path/filename.dat'
_INFILE_PATTERN = re.compile(
    r"INFILE\s+'([^']+)'",
    re.IGNORECASE,
)

# 字段定义行：FIELD_NAME type_spec nullif ...
_CTL_FIELD_PATTERN = re.compile(
    r"^\s*,?\s*"
    r"(\w+)\s+"                             # 字段名
    r"(?:CHAR|DATE|TIMESTAMP|INTEGER|FLOAT|DECIMAL)"  # 类型
    r"(?:\(\d+\))?"                         # 可选精度
    r'(?:\s+"[^"]*")?'                      # 可选日期格式
    r"(?:\s+NULLIF\s+\w+=\w+)?",            # 可选 nullif
    re.IGNORECASE,
)


class CTLParser:
    """数仓 CTL 文件解析器

    从 .ctl 文件中提取：
      - 目标表名（含 schema 解析）
      - 数据文件路径
      - 字段定义（名称、类型）
      - 字段分隔符

    CTL 文件不产生血缘关系（数据来源是外部文件而非其他表），
    但需要产出 TableInfo 以确保目标表在血缘图谱中存在。

    用法:
        resolver = SchemaResolver()
        parser = CTLParser(resolver)
        output = parser.parse_file(Path("msl_msl_xxx.ctl"))
    """

    def __init__(self, schema_resolver: SchemaResolver):
        self._resolver = schema_resolver

    def parse_file(self, file_path: Path) -> ParseOutput:
        """解析单个 CTL 文件"""
        try:
            with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
        except OSError as e:
            logger.error("读取文件失败: %s - %s", file_path, e)
            return ParseOutput(errors=[f"文件 {file_path.name}: {str(e)}"])

        if not content.strip():
            return ParseOutput()

        return self._parse_content(content, str(file_path))

    def parse_directory(self, dir_path: Path) -> ParseOutput:
        """递归解析目录下所有 .ctl 文件"""
        output = ParseOutput()

        if not dir_path.exists() or not dir_path.is_dir():
            output.errors.append(f"目录不存在: {dir_path}")
            return output

        for file_path in sorted(dir_path.rglob("*.ctl")):
            file_output = self.parse_file(file_path)
            output.merge(file_output)

        logger.info(
            "CTLParser: 解析目录 %s, 共 %d 张表",
            dir_path, len(output.tables),
        )
        return output

    def _parse_content(self, content: str, file_path: str) -> ParseOutput:
        """解析 CTL 文件内容"""
        output = ParseOutput()

        # 1. 提取目标表名
        match = _INTO_TABLE_PATTERN.search(content)
        if not match:
            logger.debug("CTL 文件无目标表: %s", file_path)
            return output

        raw_table_name = match.group(1).strip()
        resolved = self._resolver.resolve_table_name(raw_table_name)
        if resolved is None:
            return output

        schema = resolved.schema or self._resolver.infer_schema_from_path(file_path) or "UNKNOWN"
        table_name = resolved.table_name
        full_name = f"{schema}.{table_name}" if schema else table_name

        # 2. 提取数据文件路径
        data_file = ""
        infile_match = _INFILE_PATTERN.search(content)
        if infile_match:
            data_file = infile_match.group(1)

        # 3. 提取字段定义
        columns = self._extract_columns(content)

        # 4. 构建 TableInfo（MSL 层的入口表）
        table_info = TableInfo(
            schema=schema,
            table_name=table_name,
            full_name=full_name,
            comment=f"CTL 数据加载: {data_file}" if data_file else "CTL 数据加载",
            columns=columns,
            file_path=file_path,
        )

        # 转换为 dict
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

    def _extract_columns(self, content: str) -> list[ColumnInfo]:
        """从 CTL 字段定义区域提取列信息"""
        columns: list[ColumnInfo] = []

        # 找到字段定义区域（括号内）
        # 简化：逐行匹配
        for line in content.split('\n'):
            line = line.strip().rstrip(',')
            if not line:
                continue

            match = _CTL_FIELD_PATTERN.match(line)
            if match:
                col_name = match.group(1).upper()
                # 跳过 SQL*Loader 关键字
                if col_name in ("FIELDS", "TRAILING", "NULLCOLS", "OPTIONALLY",
                                "ENCLOSED", "TERMINATED", "LOAD", "DATA",
                                "INFILE", "INTO", "TABLE", "TRUNCATE"):
                    continue

                # 提取类型信息
                col_type = "VARCHAR2"  # CTL 中 CHAR(n) 默认映射为 VARCHAR2
                if "DATE" in line.upper():
                    col_type = "DATE"
                elif "TIMESTAMP" in line.upper():
                    col_type = "TIMESTAMP"
                elif "INTEGER" in line.upper():
                    col_type = "NUMBER"
                elif "FLOAT" in line.upper():
                    col_type = "FLOAT"
                elif "DECIMAL" in line.upper():
                    col_type = "NUMBER"

                columns.append(ColumnInfo(
                    name=col_name,
                    data_type=col_type,
                    comment="",
                ))

        return columns
