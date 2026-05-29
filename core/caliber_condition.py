"""
SQL condition extraction (WHERE, JOIN, GROUP BY, HAVING, etc.)
Extracted from CaliberExtractor for SRP.
"""

from __future__ import annotations

import logging
import re

from core.caliber_common import (
    _CTAS_PATTERN,
    _DISTINCT_PATTERN,
    _GROUP_BY_PATTERN,
    _HAVING_PATTERN,
    _INSERT_SELECT_PATTERN,
    _JOIN_PATTERN,
    _MERGE_PATTERN,
    _ORDER_BY_PATTERN,
    _SET_OPERATION_PATTERN,
    _UPDATE_PATTERN,
    _WHERE_PATTERN,
    _extract_field_refs,
    _extract_table_refs,
)
from core.models import SQLCondition, SQLOperationType

logger = logging.getLogger(__name__)


class ConditionExtractor:
    """Extracts WHERE/JOIN/GROUP BY/HAVING/ORDER BY conditions from SQL blocks."""

    @staticmethod
    def extract_conditions(
        sql_block: str,
        dialect: str = "oracle",
    ) -> tuple[list[SQLCondition], list[SQLCondition], str, str]:
        where_conditions = ConditionExtractor._extract_where(sql_block)
        join_conditions = ConditionExtractor._extract_joins(sql_block)
        group_by_clause = ConditionExtractor._extract_group_by(sql_block)
        having_clause = ConditionExtractor._extract_having(sql_block)
        return where_conditions, join_conditions, group_by_clause, having_clause

    @staticmethod
    def _detect_operation_type(sql_block: str) -> str:
        upper = sql_block.upper().strip()
        if _CTAS_PATTERN.search(upper):
            return SQLOperationType.CREATE_TABLE_AS_SELECT
        if _MERGE_PATTERN.search(upper):
            return SQLOperationType.MERGE
        if _INSERT_SELECT_PATTERN.search(upper):
            return SQLOperationType.INSERT_SELECT
        if re.match(r"\s*INSERT\b", upper):
            return SQLOperationType.INSERT_VALUES
        if _UPDATE_PATTERN.search(upper):
            return SQLOperationType.UPDATE
        if re.match(r"\s*DELETE\b", upper):
            return SQLOperationType.DELETE
        return ""

    @staticmethod
    def _detect_distinct(sql_block: str) -> bool:
        return bool(_DISTINCT_PATTERN.search(sql_block))

    @staticmethod
    def _detect_set_operation(sql_block: str) -> str:
        match = _SET_OPERATION_PATTERN.search(sql_block)
        if match:
            return match.group(1).upper()
        return ""

    @staticmethod
    def _extract_order_by(sql_block: str) -> str:
        match = _ORDER_BY_PATTERN.search(sql_block)
        if match:
            return match.group(1).strip()
        return ""

    @staticmethod
    def _extract_where(sql_block: str) -> list[SQLCondition]:
        match = _WHERE_PATTERN.search(sql_block)
        if not match:
            return []

        raw_text = match.group(1).strip()
        if not raw_text:
            return []

        fields_involved = _extract_field_refs(raw_text)
        tables_involved = _extract_table_refs(raw_text)

        return [
            SQLCondition(
                condition_type="WHERE",
                raw_text=raw_text,
                tables_involved=tables_involved,
                fields_involved=fields_involved,
            )
        ]

    @staticmethod
    def _extract_joins(sql_block: str) -> list[SQLCondition]:
        results: list[SQLCondition] = []
        for match in _JOIN_PATTERN.finditer(sql_block):
            join_table = match.group(1).strip()
            join_cond = match.group(3).strip() if match.group(3) else ""
            if not join_cond:
                continue

            results.append(
                SQLCondition(
                    condition_type="JOIN",
                    raw_text=f"JOIN {join_table} ON {join_cond}",
                    tables_involved=[join_table.upper()] + _extract_table_refs(join_cond),
                    fields_involved=_extract_field_refs(join_cond),
                )
            )
        return results

    @staticmethod
    def _extract_group_by(sql_block: str) -> str:
        match = _GROUP_BY_PATTERN.search(sql_block)
        if match:
            return match.group(1).strip()
        return ""

    # ------------------------------------------------------------------
    # 步骤级隔离条件提取（Batch B）
    # ------------------------------------------------------------------

    @staticmethod
    def _extract_step_isolated_where(
        sql_block: str,
        accumulated_where: list[SQLCondition] | None = None,
    ) -> list[SQLCondition]:
        """提取步骤级隔离 WHERE 条件（非累积）。

        核心逻辑：
          1. 从当前 SQL 块提取 WHERE 条件
          2. 与已知的累积条件做差集，得到当前步骤独有的条件
          3. 如果没有累积条件，则当前块的全部 WHERE 条件即为隔离条件

        Args:
            sql_block: 当前步骤的 SQL 文本
            accumulated_where: 截至当前步骤的累积 WHERE 条件（可为空）

        Returns:
            当前步骤独有的 WHERE 条件列表
        """
        current_where = ConditionExtractor._extract_where(sql_block)
        if not current_where:
            return []

        if not accumulated_where:
            # 无累积条件，当前全部 WHERE 即为隔离条件
            return current_where

        # 通过 raw_text 去重：累积条件中已存在的条件不再重复
        accumulated_texts = {c.raw_text.strip().upper() for c in accumulated_where}
        isolated: list[SQLCondition] = []
        for cond in current_where:
            if cond.raw_text.strip().upper() not in accumulated_texts:
                isolated.append(cond)
        return isolated

    @staticmethod
    def _extract_step_isolated_join(
        sql_block: str,
        accumulated_join: list[SQLCondition] | None = None,
    ) -> list[SQLCondition]:
        """提取步骤级隔离 JOIN 条件（非累积）。

        核心逻辑与 _extract_step_isolated_where 类似：
          1. 从当前 SQL 块提取 JOIN 条件
          2. 与已知的累积条件做差集
          3. 如果没有累积条件，则当前块的全部 JOIN 即为隔离条件

        Args:
            sql_block: 当前步骤的 SQL 文本
            accumulated_join: 截至当前步骤的累积 JOIN 条件（可为空）

        Returns:
            当前步骤独有的 JOIN 条件列表
        """
        current_join = ConditionExtractor._extract_joins(sql_block)
        if not current_join:
            return []

        if not accumulated_join:
            return current_join

        accumulated_texts = {c.raw_text.strip().upper() for c in accumulated_join}
        isolated: list[SQLCondition] = []
        for cond in current_join:
            if cond.raw_text.strip().upper() not in accumulated_texts:
                isolated.append(cond)
        return isolated

    @staticmethod
    def _extract_having(sql_block: str) -> str:
        match = _HAVING_PATTERN.search(sql_block)
        if match:
            return match.group(1).strip()
        return ""

    # ------------------------------------------------------------------
    # CTE / 自定义函数 / 完整表达式提取（Batch C）
    # ------------------------------------------------------------------
