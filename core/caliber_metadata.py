"""
SQL metadata extraction (CTE, window functions, subqueries, custom functions).
Extracted from CaliberExtractor for SRP.
"""

from __future__ import annotations

import logging
import re

from core.caliber_common import (
    _SUBQUERY_PATTERN,
    _WHERE_PATTERN,
    _WINDOW_FUNCTION_PATTERN,
    _extract_field_refs,
    _extract_table_refs,
)
from core.caliber_condition import ConditionExtractor
from core.models import SelectColumnMapping, SQLCondition, SubqueryInfo
from core.utils.bracket_matcher import find_matching_paren_sql

logger = logging.getLogger(__name__)


def _get_select_columns(sql_block: str) -> list[SelectColumnMapping]:
    """Lazy wrapper to avoid circular import with ExpressionBuilder."""
    from core.caliber_expression import ExpressionBuilder

    return ExpressionBuilder._extract_select_columns(sql_block)


class MetadataExtractor:
    """Extracts CTE definitions, custom functions, window functions, and subqueries."""

    @staticmethod
    def extract_enhanced_metadata(sql_block: str) -> dict:
        """从SQL块提取增强版元数据

        Returns:
            dict 包含以下键:
              - operation_type: SQL操作类型
              - distinct_flag: 是否DISTINCT
              - order_by_clause: ORDER BY子句
              - set_operation: 集合运算类型
              - select_columns: SELECT列映射列表
              - window_functions: 窗口函数列表
              - subqueries: 子查询信息列表
        """
        return {
            "operation_type": ConditionExtractor._detect_operation_type(sql_block),
            "distinct_flag": ConditionExtractor._detect_distinct(sql_block),
            "order_by_clause": ConditionExtractor._extract_order_by(sql_block),
            "set_operation": ConditionExtractor._detect_set_operation(sql_block),
            "select_columns": _get_select_columns(sql_block),
            "window_functions": MetadataExtractor._extract_window_functions(sql_block),
            "subqueries": MetadataExtractor._extract_subqueries(sql_block),
        }

    @staticmethod
    def _extract_window_functions(sql_block: str) -> list[str]:
        return [m.group(1).strip() for m in _WINDOW_FUNCTION_PATTERN.finditer(sql_block)]

    @staticmethod
    def _extract_subqueries(sql_block: str) -> list[SubqueryInfo]:
        results: list[SubqueryInfo] = []
        for match in _SUBQUERY_PATTERN.finditer(sql_block):
            raw = match.group(0).strip()
            alias = match.group(2).strip() if match.group(2) else ""
            inner_sql = match.group(1).strip()
            source_tables = _extract_table_refs(inner_sql)
            where_conds: list[SQLCondition] = []
            inner_where = _WHERE_PATTERN.search(inner_sql)
            if inner_where:
                where_conds.append(
                    SQLCondition(
                        condition_type="WHERE",
                        raw_text=inner_where.group(1).strip(),
                        tables_involved=_extract_table_refs(inner_where.group(1)),
                        fields_involved=_extract_field_refs(inner_where.group(1)),
                    )
                )
            results.append(
                SubqueryInfo(
                    alias=alias,
                    raw_text=raw[:200],
                    source_tables=source_tables,
                    where_conditions=where_conds,
                )
            )
        return results

    @staticmethod
    def _extract_cte_definitions(sql_block: str) -> list[str]:
        """提取 WITH ... AS (...) CTE 定义。

        支持多个 CTE 定义：
          - WITH a AS (...), b AS (...) — 逗号分隔
          - WITH a AS (...) — 单 CTE

        Args:
            sql_block: SQL 文本

        Returns:
            CTE 定义字符串列表，格式为 "cte_name: body_preview"
        """
        cte_defs: list[str] = []

        # 策略1：匹配 WITH name AS ( 模式（第一个CTE）
        # 策略2：匹配逗号后的 name AS ( 模式（后续CTE）
        cte_name_pattern = re.compile(
            r"(?:\bWITH\s+|,\s*)(\w+)\s+AS\s*\(",
            re.IGNORECASE,
        )

        for match in cte_name_pattern.finditer(sql_block):
            cte_name = match.group(1)
            paren_start = match.end() - 1  # '(' 的位置
            paren_end = find_matching_paren_sql(sql_block, paren_start)
            if paren_end > paren_start:
                body = sql_block[paren_start + 1 : paren_end].strip()
                preview = body[:200] + "..." if len(body) > 200 else body
                cte_defs.append(f"{cte_name}: {preview}")
            else:
                cte_defs.append(f"{cte_name}: <unparsed>")
        return cte_defs

    @staticmethod
    def _extract_custom_functions(sql_block: str) -> list[str]:
        """检测 Oracle 自定义函数调用。

        匹配规则：
          - PKG_ 开头的标识符 + 左括号（包内函数调用）
          - FN_ 开头的标识符 + 左括号（独立函数调用）
          - FUNC_ 开头的标识符 + 左括号（独立函数调用）

        Args:
            sql_block: SQL 文本

        Returns:
            去重后的自定义函数名列表
        """
        custom_funcs: list[str] = []
        pattern = re.compile(
            r"((?:PKG_\w+|FN_\w+|FUNC_\w+)\s*\.)?\s*(PKG_\w+|FN_\w+|FUNC_\w+)\s*\(",
            re.IGNORECASE,
        )
        seen: set[str] = set()
        for match in pattern.finditer(sql_block):
            # 取最具体的函数引用
            pkg_part = match.group(1)
            func_part = match.group(2)
            if pkg_part:  # noqa: SIM108
                full_name = f"{pkg_part.strip()}.{func_part}"
            else:
                full_name = func_part
            upper_name = full_name.upper()
            if upper_name not in seen:
                seen.add(upper_name)
                custom_funcs.append(full_name)
        return custom_funcs
