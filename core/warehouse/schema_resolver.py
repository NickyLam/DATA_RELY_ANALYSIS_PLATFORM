"""
数仓脚本变量替换与表名解析
处理 ${xxx_schema}、${batch_date} 等 shell 风格变量替换，
以及层级前缀与 schema 的映射关系。
"""

from __future__ import annotations

import logging
import re
from dataclasses import dataclass, field
from typing import Optional

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# 常量：schema 变量 → 层级前缀 映射
# ---------------------------------------------------------------------------

SCHEMA_LAYER_MAP: dict[str, str] = {
    "idl_schema": "IDL",
    "iml_schema": "IML",
    "icl_schema": "ICL",
    "iol_schema": "IOL",
    "itl_schema": "ITL",
    "iel_schema": "IEL",
    "msl_schema": "MSL",
    "dqc_schema": "DQC",
    "src_schema": "SRC",
}

# 反向映射：层级前缀 → schema 变量名
LAYER_SCHEMA_MAP: dict[str, str] = {
    "idl": "idl_schema",
    "iml": "iml_schema",
    "icl": "icl_schema",
    "iol": "iol_schema",
    "itl": "itl_schema",
    "iel": "iel_schema",
    "msl": "msl_schema",
    "dqc": "dqc_schema",
    "src": "src_schema",
}

# 层级数据流向：msl → itl → iol → icl → idl → iel
LAYER_FLOW_ORDER: list[str] = ["SRC", "MSL", "ITL", "IOL", "ICL", "IML", "IDL", "IEL", "DQC"]

# 匹配 ${xxx_schema} 变量
_SCHEMA_VAR_PATTERN = re.compile(r"\$\{(\w+_schema)\}", re.IGNORECASE)

# 匹配 ${xxx} 通用变量
_GENERIC_VAR_PATTERN = re.compile(r"\$\{(\w+)\}")

# 匹配 schema.table 格式（schema 可以是 ${xxx_schema} 变量或普通标识符）
_SCHEMA_TABLE_PATTERN = re.compile(
    r"^(\$\{[\w_]+\}|\w+)\.(\w+)$",
    re.IGNORECASE,
)


@dataclass
class ResolvedTable:
    """变量替换后的表名解析结果"""
    schema: str = ""          # 解析后的 schema 名（如 "ICL"）
    table_name: str = ""      # 解析后的表名（如 "cmm_abmt_remit_dtl"）
    full_name: str = ""       # 完整名（如 "ICL.cmm_abmt_remit_dtl"）
    raw_schema_var: str = ""  # 原始 schema 变量名（如 "icl_schema"）
    layer: str = ""           # 层级标识（如 "ICL"）


class SchemaResolver:
    """${xxx_schema} 变量解析与替换

    数仓脚本使用 shell 风格的变量替换，如 ${icl_schema}.table_name。
    SchemaResolver 负责将这些变量替换为具体的 schema 名，
    并提供表名归一化功能。

    用法:
        resolver = SchemaResolver()
        resolved = resolver.resolve_table_name("${icl_schema}.cmm_abmt_remit_dtl")
        # resolved.schema = "ICL"
        # resolved.table_name = "cmm_abmt_remit_dtl"
        # resolved.full_name = "ICL.cmm_abmt_remit_dtl"
        # resolved.layer = "ICL"
    """

    def __init__(self, custom_mapping: Optional[dict[str, str]] = None):
        """初始化

        Args:
            custom_mapping: 自定义 schema 变量 → schema 名的映射
                           （覆盖默认映射，如 {"idl_schema": "IDL_CUSTOM"}）
        """
        self._schema_mapping: dict[str, str] = dict(SCHEMA_LAYER_MAP)
        if custom_mapping:
            self._schema_mapping.update(custom_mapping)

    def resolve_table_name(self, raw: str) -> Optional[ResolvedTable]:
        """解析含变量的表名

        支持的格式:
          - "${icl_schema}.table_name" → schema=ICL, table_name
          - "ICL.table_name" → schema=ICL, table_name
          - "table_name" → schema="", table_name

        Args:
            raw: 原始表名（可能含 ${xxx_schema} 变量）

        Returns:
            ResolvedTable 或 None（无法解析时）
        """
        if not raw or not raw.strip():
            return None

        raw = raw.strip().strip('"').strip("'").upper()

        # 尝试匹配 schema.table 格式
        match = _SCHEMA_TABLE_PATTERN.match(raw)
        if match:
            schema_part = match.group(1)
            table_part = match.group(2)

            # schema 部分可能是 ${xxx_schema} 变量
            var_match = _SCHEMA_VAR_PATTERN.match(schema_part)
            if var_match:
                var_name = var_match.group(1).lower()
                schema_name = self._schema_mapping.get(var_name, schema_part)
                layer = self._schema_mapping.get(var_name, "")
                return ResolvedTable(
                    schema=schema_name,
                    table_name=table_part,
                    full_name=f"{schema_name}.{table_part}",
                    raw_schema_var=var_name,
                    layer=layer,
                )
            else:
                # 已经是具体的 schema 名
                layer = schema_part if schema_part in [v for v in SCHEMA_LAYER_MAP.values()] else ""
                return ResolvedTable(
                    schema=schema_part,
                    table_name=table_part,
                    full_name=f"{schema_part}.{table_part}",
                    raw_schema_var="",
                    layer=layer,
                )

        # 无 schema 前缀的表名
        return ResolvedTable(
            schema="",
            table_name=raw,
            full_name=raw,
            raw_schema_var="",
            layer="",
        )

    def resolve_schema_var(self, var_name: str) -> str:
        """将 schema 变量名替换为具体 schema 名

        Args:
            var_name: 变量名（如 "icl_schema" 或 "${icl_schema}"）

        Returns:
            解析后的 schema 名（如 "ICL"），未知变量返回原值
        """
        # 去掉 ${ } 包裹
        clean_name = var_name.strip("${}").lower()
        return self._schema_mapping.get(clean_name, var_name)

    def infer_schema_from_path(self, file_path: str) -> Optional[str]:
        """从文件路径推断所属的 schema

        约定：DDL/DML 目录名即层级前缀
        例如: .../ddl/idl/xxx.sql → idl_schema → IDL

        Args:
            file_path: 文件路径

        Returns:
            层级标识（如 "IDL"）或 None
        """
        import os
        parts = Path(file_path).parts

        # 从路径末尾往前找，优先匹配 DDL/DML 下的层级目录
        for i in range(len(parts) - 1, -1, -1):
            part_lower = parts[i].lower()
            if part_lower in ("ddl", "dml") and i + 1 < len(parts):
                next_part = parts[i + 1].lower()
                if next_part in LAYER_SCHEMA_MAP:
                    schema_var = LAYER_SCHEMA_MAP[next_part]
                    return self._schema_mapping.get(schema_var, next_part.upper())

        return None

    def replace_schema_vars(self, sql: str) -> str:
        """替换 SQL 中的所有 ${xxx_schema} 变量为具体 schema 名

        注意：非 schema 变量（如 ${batch_date}）保持不变

        Args:
            sql: 原始 SQL 文本

        Returns:
            替换后的 SQL 文本
        """
        def _replacer(match):
            var_name = match.group(1).lower()
            if var_name in self._schema_mapping:
                return self._schema_mapping[var_name]
            return match.group(0)  # 未知变量保持原样

        return _SCHEMA_VAR_PATTERN.sub(_replacer, sql)

    def extract_all_schema_refs(self, sql: str) -> list[str]:
        """提取 SQL 中引用的所有 schema 变量

        Args:
            sql: SQL 文本

        Returns:
            去重排序后的 schema 变量名列表（如 ["icl_schema", "iol_schema"]）
        """
        return sorted(set(m.group(1).lower() for m in _SCHEMA_VAR_PATTERN.finditer(sql)))


# 导入 Path 供 infer_schema_from_path 使用
from pathlib import Path
