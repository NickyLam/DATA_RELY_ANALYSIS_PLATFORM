"""
Expression building and CaliberInfo construction.
Extracted from CaliberExtractor for SRP.
"""

from __future__ import annotations

import logging
import re

from core.caliber_common import (
    _SELECT_COLUMNS_PATTERN,
    _parse_single_select_column,
    _split_select_columns,
    _truncate_sql,
)
from core.caliber_condition import ConditionExtractor
from core.layer_detector import detect_layer
from core.models import (
    CaliberInfo,
    ExpressionDetail,
    FieldMapping,
    SelectColumnMapping,
    SourceLocation,
    SQLCondition,
)

logger = logging.getLogger(__name__)


def _get_metadata_extractor():
    """Lazy import to avoid circular dependency with caliber_metadata."""
    from core.caliber_metadata import MetadataExtractor

    return MetadataExtractor


class ExpressionBuilder:
    """Builds CaliberInfo objects from SQL analysis results."""

    @staticmethod
    def build_caliber_info(
        field_mapping: FieldMapping,
        sql_block: str,
        procedure: str,
        step_num: int = 0,
        step_desc: str = "",
        data_source: str = "oracle",
        sql_operation_sequence: int = 0,
        file_path: str = "",
        start_line: int = 0,
        end_line: int = 0,
        accumulated_where: list[SQLCondition] | None = None,
        accumulated_join: list[SQLCondition] | None = None,
    ) -> CaliberInfo:
        where_conds, join_conds, group_by, having = ConditionExtractor.extract_conditions(
            sql_block, dialect=data_source
        )
        enhanced = _get_metadata_extractor().extract_enhanced_metadata(sql_block)

        source_layer = detect_layer(field_mapping.source_table).value if field_mapping.source_table else ""
        target_layer = detect_layer(field_mapping.target_table).value if field_mapping.target_table else ""

        select_cols_for_field = ExpressionBuilder._filter_select_columns_for_field(
            enhanced["select_columns"], field_mapping
        )

        info = CaliberInfo(
            target_table=field_mapping.target_table,
            target_column=field_mapping.target_column,
            source_location=SourceLocation(
                source_schema="",
                source_table=field_mapping.source_table,
                source_column=field_mapping.source_column,
            ),
            expression_detail=ExpressionDetail(
                select_columns=select_cols_for_field,
                where_conditions=where_conds,
                subqueries=enhanced["subqueries"],
            ),
            transform_logic=field_mapping.transform_logic,
            join_conditions=join_conds,
            group_by_clause=group_by,
            having_clause=having,
            procedure=procedure,
            step_num=step_num,
            step_desc=step_desc,
            data_source=data_source,
            raw_sql_fragment=_truncate_sql(sql_block, max_len=2000),
            confidence=field_mapping.confidence,
            operation_type=enhanced["operation_type"],
            distinct_flag=enhanced["distinct_flag"],
            order_by_clause=enhanced["order_by_clause"],
            set_operation=enhanced["set_operation"],
            source_table_layer=source_layer,
            target_table_layer=target_layer,
            window_functions=enhanced["window_functions"],
            sql_operation_sequence=sql_operation_sequence,
            file_path=file_path,
            start_line=start_line,
            end_line=end_line,
        )

        # 步骤级隔离条件提取（Batch B）
        info.step_isolated_where = ConditionExtractor._extract_step_isolated_where(
            sql_block, accumulated_where=accumulated_where
        )
        info.step_isolated_join = ConditionExtractor._extract_step_isolated_join(
            sql_block, accumulated_join=accumulated_join
        )

        # CTE / 自定义函数 / 完整表达式提取（Batch C）
        info.cte_definitions = _get_metadata_extractor()._extract_cte_definitions(sql_block)
        info.custom_functions = _get_metadata_extractor()._extract_custom_functions(sql_block)
        info.full_expression = ExpressionBuilder._extract_full_expression(sql_block, field_mapping.target_column)
        info.is_custom_function_call = bool(info.custom_functions)

        return info

    @staticmethod
    def build_caliber_infos(
        mappings: list[FieldMapping],
        sql_block: str,
        procedure: str,
        step_num: int = 0,
        step_desc: str = "",
        data_source: str = "oracle",
        sql_operation_sequence: int = 0,
        file_path: str = "",
        start_line: int = 0,
        end_line: int = 0,
        accumulated_where: list[SQLCondition] | None = None,
        accumulated_join: list[SQLCondition] | None = None,
    ) -> list[CaliberInfo]:
        if not mappings:
            return []

        # ★ 优化：sql_block 级别的提取结果只计算一次，复用给所有 FieldMapping
        where_conds, join_conds, group_by, having = ConditionExtractor.extract_conditions(
            sql_block, dialect=data_source
        )
        enhanced = _get_metadata_extractor().extract_enhanced_metadata(sql_block)

        # ★ 优化：sql_block 级别的不变结果只计算一次
        cte_defs = _get_metadata_extractor()._extract_cte_definitions(sql_block)
        custom_funcs = _get_metadata_extractor()._extract_custom_functions(sql_block)
        step_isolated_where = ConditionExtractor._extract_step_isolated_where(
            sql_block, accumulated_where=accumulated_where
        )
        step_isolated_join = ConditionExtractor._extract_step_isolated_join(
            sql_block, accumulated_join=accumulated_join
        )

        results: list[CaliberInfo] = []
        for fm in mappings:
            source_layer = detect_layer(fm.source_table).value if fm.source_table else ""
            target_layer = detect_layer(fm.target_table).value if fm.target_table else ""

            select_cols_for_field = ExpressionBuilder._filter_select_columns_for_field(enhanced["select_columns"], fm)

            info = CaliberInfo(
                target_table=fm.target_table,
                target_column=fm.target_column,
                source_location=SourceLocation(
                    source_schema="",
                    source_table=fm.source_table,
                    source_column=fm.source_column,
                ),
                expression_detail=ExpressionDetail(
                    select_columns=select_cols_for_field,
                    where_conditions=where_conds,
                    subqueries=enhanced["subqueries"],
                ),
                transform_logic=fm.transform_logic,
                join_conditions=join_conds,
                group_by_clause=group_by,
                having_clause=having,
                procedure=procedure,
                step_num=step_num,
                step_desc=step_desc,
                data_source=data_source,
                raw_sql_fragment=_truncate_sql(sql_block, max_len=2000),
                confidence=fm.confidence,
                operation_type=enhanced["operation_type"],
                distinct_flag=enhanced["distinct_flag"],
                order_by_clause=enhanced["order_by_clause"],
                set_operation=enhanced["set_operation"],
                source_table_layer=source_layer,
                target_table_layer=target_layer,
                window_functions=enhanced["window_functions"],
                sql_operation_sequence=sql_operation_sequence,
                file_path=file_path,
                start_line=start_line,
                end_line=end_line,
            )
            # ★ 优化：复用 sql_block 级别缓存的不变结果
            info.step_isolated_where = step_isolated_where
            info.step_isolated_join = step_isolated_join
            info.cte_definitions = cte_defs
            info.custom_functions = custom_funcs
            # full_expression 每字段不同，仍需逐个算
            info.full_expression = ExpressionBuilder._extract_full_expression(sql_block, fm.target_column)
            info.is_custom_function_call = bool(custom_funcs)
            results.append(info)
        return results

    @staticmethod
    def _extract_select_columns(sql_block: str) -> list[SelectColumnMapping]:
        match = _SELECT_COLUMNS_PATTERN.search(sql_block)
        if not match:
            return []

        raw_select = match.group(1).strip()
        if not raw_select or raw_select == "*":
            return []

        columns: list[SelectColumnMapping] = []
        depth = 0
        current = ""

        for ch in raw_select:
            if ch == "(":
                depth += 1
                current += ch
            elif ch == ")":
                depth -= 1
                current += ch
            elif ch == "," and depth == 0:
                col = _parse_single_select_column(current.strip())
                if col:
                    columns.append(col)
                current = ""
            else:
                current += ch

        if current.strip():
            col = _parse_single_select_column(current.strip())
            if col:
                columns.append(col)

        return columns

    @staticmethod
    def _filter_select_columns_for_field(
        all_columns: list[SelectColumnMapping],
        field_mapping: FieldMapping,
    ) -> list[SelectColumnMapping]:
        if not all_columns:
            return []

        target_col = field_mapping.target_column.upper()
        for col in all_columns:
            alias = col.alias.upper() if col.alias else ""
            tgt = col.target_column.upper() if col.target_column else ""
            if alias == target_col or tgt == target_col:
                return [col]

        return all_columns[:5]

    @staticmethod
    def _extract_full_expression(sql_block: str, target_column: str) -> str:
        """提取 SELECT 中目标字段对应的完整表达式。

        支持以下场景：
          - 简单列引用: SELECT A -> "A"
          - AS 别名: SELECT EXPR AS A -> "EXPR"
          - 函数嵌套: SELECT FN(X) AS A -> "FN(X)"
          - CASE WHEN: SELECT CASE WHEN ... END AS A -> "CASE WHEN ... END"
          - 无别名: SELECT FN(X) -> "FN(X)"

        Args:
            sql_block: SQL 文本
            target_column: 目标字段名

        Returns:
            完整表达式文本，未找到返回空字符串
        """
        if not target_column:
            return ""

        # 提取 SELECT ... FROM 之间的列列表
        select_match = _SELECT_COLUMNS_PATTERN.search(sql_block)
        if not select_match:
            return ""

        raw_select = select_match.group(1).strip()
        if not raw_select or raw_select == "*":
            return ""

        # 按逗号拆分列（考虑括号深度）
        columns = _split_select_columns(raw_select)

        target_upper = target_column.upper().strip()

        for col_text in columns:
            col_text = col_text.strip()
            if not col_text:
                continue

            # 尝试匹配 AS alias
            as_match = re.search(r"\bAS\s+([\w]+)\s*$", col_text, re.IGNORECASE)
            if as_match:
                alias = as_match.group(1).upper()
                if alias == target_upper:
                    expr = col_text[: as_match.start()].strip()
                    return expr

            # 尝试匹配裸别名（expr alias，无 AS）
            bare_match = re.match(r"^(.+?)\s+([\w]+)\s*$", col_text)
            if bare_match:
                expr_candidate = bare_match.group(1).strip()
                alias_candidate = bare_match.group(2).upper()
                if alias_candidate == target_upper and alias_candidate not in (
                    "AS",
                    "FROM",
                    "WHERE",
                    "AND",
                    "OR",
                    "ON",
                    "CASE",
                    "WHEN",
                    "THEN",
                    "ELSE",
                    "END",
                ):
                    return expr_candidate

            # 无别名：如果列名本身匹配目标字段
            simple_match = re.match(r"^([\w.]+)$", col_text)
            if simple_match:
                col_name = simple_match.group(1)
                short = col_name.split(".")[-1] if "." in col_name else col_name
                if short.upper() == target_upper:
                    return col_text

        return ""

    @staticmethod
    def to_dict(caliber_info: CaliberInfo) -> dict:
        return caliber_info.to_dict()

    @staticmethod
    def from_dict(data: dict) -> CaliberInfo:
        return CaliberInfo.from_dict(data)
