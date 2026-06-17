"""
指标口径条件提取器
从 SQL 操作块中提取 WHERE / JOIN / GROUP BY / HAVING 条件，
以及操作类型、SELECT列映射、DISTINCT、ORDER BY、窗口函数、集合运算、子查询等，
构建增强版 CaliberInfo 对象。设计为无状态工具类，被各数据源解析器复用。
"""

from __future__ import annotations

import logging
import re

from core.layer_detector import detect_layer
from core.models import (
    CaliberInfo,
    ExpressionDetail,
    FieldMapping,
    SelectColumnMapping,
    SourceLocation,
    SQLCondition,
    SQLOperationType,
    SubqueryInfo,
)
from core.utils import find_matching_paren

logger = logging.getLogger(__name__)

_WHERE_PATTERN = re.compile(
    r"\bWHERE\s+(.*?)(?:\bGROUP\s+BY\b|\bHAVING\b|\bORDER\s+BY\b|\bUNION\b|;|$)",
    re.IGNORECASE | re.DOTALL,
)

_JOIN_PATTERN = re.compile(
    r"\b(?:INNER\s+|LEFT\s+(?:OUTER\s+)?|RIGHT\s+(?:OUTER\s+)?|FULL\s+(?:OUTER\s+)?|CROSS\s+)?"
    r"JOIN\s+([\w.]+)\s+(?:AS\s+)?(\w+)?\s*ON\s+(.*?)(?="
    r"\b(?:INNER|LEFT|RIGHT|FULL|CROSS|WHERE|GROUP|HAVING|ORDER|UNION|SET|;)\b|$)",
    re.IGNORECASE | re.DOTALL,
)

_GROUP_BY_PATTERN = re.compile(
    r"\bGROUP\s+BY\s+(.*?)(?:\bHAVING\b|\bORDER\s+BY\b|\bUNION\b|;|$)",
    re.IGNORECASE | re.DOTALL,
)

_HAVING_PATTERN = re.compile(
    r"\bHAVING\s+(.*?)(?:\bORDER\s+BY\b|\bUNION\b|;|$)",
    re.IGNORECASE | re.DOTALL,
)

_TABLE_REF_PATTERN = re.compile(
    r"\b(?:FROM|JOIN)\s+([\w.]+)(?:\s+(?:AS\s+)?(\w+))?",
    re.IGNORECASE,
)

_FIELD_REF_PATTERN = re.compile(
    r"(?:^|[\s,(])((?:[\w.]+\.)?[\w]+)\s*(?:=|!=|<>|>|<|>=|<=|LIKE|IN|BETWEEN|IS)",
    re.IGNORECASE,
)

_INSERT_SELECT_PATTERN = re.compile(
    r"\bINSERT\s+(?:INTO\s+)?([\w.]+)\s*(?:\(([^)]*)\))?\s*SELECT\b",
    re.IGNORECASE | re.DOTALL,
)

_MERGE_PATTERN = re.compile(
    r"\bMERGE\s+INTO\s+([\w.]+)",
    re.IGNORECASE,
)

_UPDATE_PATTERN = re.compile(
    r"\bUPDATE\s+([\w.]+)\s+SET\b",
    re.IGNORECASE,
)

_CTAS_PATTERN = re.compile(
    r"\bCREATE\s+(?:OR\s+REPLACE\s+)?(?:GLOBAL\s+)?(?:TEMPORARY\s+)?TABLE\s+([\w.]+)\s+AS\s+SELECT\b",
    re.IGNORECASE | re.DOTALL,
)

_DISTINCT_PATTERN = re.compile(
    r"\bSELECT\s+DISTINCT\b",
    re.IGNORECASE,
)

_ORDER_BY_PATTERN = re.compile(
    r"\bORDER\s+BY\s+([^\n;]+?)(?:\s*$|\s*;|\s+UNION)",
    re.IGNORECASE,
)

_SET_OPERATION_PATTERN = re.compile(
    r"\b(UNION\s+ALL|UNION|INTERSECT|MINUS)\b",
    re.IGNORECASE,
)

_WINDOW_FUNCTION_PATTERN = re.compile(
    r"(\w+\s*\(\s*[^)]*\s*\)\s*OVER\s*\([^)]*\))",
    re.IGNORECASE,
)

_SELECT_COLUMNS_PATTERN = re.compile(
    r"\bSELECT\s+(?:DISTINCT\s+)?(.*?)(?:\bFROM\b)",
    re.IGNORECASE | re.DOTALL,
)

_SUBQUERY_PATTERN = re.compile(
    r"\(\s*SELECT\s+(.*?)\)\s+(?:AS\s+)?(\w+)",
    re.IGNORECASE | re.DOTALL,
)


class CaliberExtractor:
    """指标口径条件提取器（无状态工具类）"""

    @staticmethod
    def extract_conditions(
        sql_block: str,
        dialect: str = "oracle",
    ) -> tuple[list[SQLCondition], list[SQLCondition], str, str]:
        where_conditions = CaliberExtractor._extract_where(sql_block)
        join_conditions = CaliberExtractor._extract_joins(sql_block)
        group_by_clause = CaliberExtractor._extract_group_by(sql_block)
        having_clause = CaliberExtractor._extract_having(sql_block)
        return where_conditions, join_conditions, group_by_clause, having_clause

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
            "operation_type": CaliberExtractor._detect_operation_type(sql_block),
            "distinct_flag": CaliberExtractor._detect_distinct(sql_block),
            "order_by_clause": CaliberExtractor._extract_order_by(sql_block),
            "set_operation": CaliberExtractor._detect_set_operation(sql_block),
            "select_columns": CaliberExtractor._extract_select_columns(sql_block),
            "window_functions": CaliberExtractor._extract_window_functions(sql_block),
            "subqueries": CaliberExtractor._extract_subqueries(sql_block),
        }

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
        where_conds, join_conds, group_by, having = CaliberExtractor.extract_conditions(sql_block, dialect=data_source)
        enhanced = CaliberExtractor.extract_enhanced_metadata(sql_block)

        source_layer = detect_layer(field_mapping.source_table).value if field_mapping.source_table else ""
        target_layer = detect_layer(field_mapping.target_table).value if field_mapping.target_table else ""

        select_cols_for_field = CaliberExtractor._filter_select_columns_for_field(
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
        info.step_isolated_where = CaliberExtractor._extract_step_isolated_where(
            sql_block, accumulated_where=accumulated_where
        )
        info.step_isolated_join = CaliberExtractor._extract_step_isolated_join(
            sql_block, accumulated_join=accumulated_join
        )

        # CTE / 自定义函数 / 完整表达式提取（Batch C）
        info.cte_definitions = CaliberExtractor._extract_cte_definitions(sql_block)
        info.custom_functions = CaliberExtractor._extract_custom_functions(sql_block)
        info.full_expression = CaliberExtractor._extract_full_expression(sql_block, field_mapping.target_column)
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
        where_conds, join_conds, group_by, having = CaliberExtractor.extract_conditions(sql_block, dialect=data_source)
        enhanced = CaliberExtractor.extract_enhanced_metadata(sql_block)

        # ★ 优化：sql_block 级别的不变结果只计算一次
        cte_defs = CaliberExtractor._extract_cte_definitions(sql_block)
        custom_funcs = CaliberExtractor._extract_custom_functions(sql_block)
        step_isolated_where = CaliberExtractor._extract_step_isolated_where(
            sql_block, accumulated_where=accumulated_where
        )
        step_isolated_join = CaliberExtractor._extract_step_isolated_join(sql_block, accumulated_join=accumulated_join)

        results: list[CaliberInfo] = []
        for fm in mappings:
            source_layer = detect_layer(fm.source_table).value if fm.source_table else ""
            target_layer = detect_layer(fm.target_table).value if fm.target_table else ""

            select_cols_for_field = CaliberExtractor._filter_select_columns_for_field(enhanced["select_columns"], fm)

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
            info.full_expression = CaliberExtractor._extract_full_expression(sql_block, fm.target_column)
            info.is_custom_function_call = bool(custom_funcs)
            results.append(info)
        return results

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
        current_where = CaliberExtractor._extract_where(sql_block)
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
        current_join = CaliberExtractor._extract_joins(sql_block)
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
            paren_end = _find_matching_paren_in_text(sql_block, paren_start)
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
            if pkg_part:
                full_name = f"{pkg_part.strip()}.{func_part}"
            else:
                full_name = func_part
            upper_name = full_name.upper()
            if upper_name not in seen:
                seen.add(upper_name)
                custom_funcs.append(full_name)
        return custom_funcs

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


def _parse_single_select_column(raw: str) -> SelectColumnMapping | None:
    if not raw:
        return None

    alias_match = re.search(
        r"\bAS\s+([\w]+)\s*$",
        raw,
        re.IGNORECASE,
    )
    if alias_match:
        alias = alias_match.group(1)
        source_expr = raw[: alias_match.start()].strip()
        return SelectColumnMapping(
            source_expression=source_expr,
            target_column=alias,
            alias=alias,
        )

    bare_alias_match = re.search(
        r"^([\w.]+)\s+([\w]+)\s*$",
        raw.strip(),
    )
    if bare_alias_match:
        expr = bare_alias_match.group(1)
        alias = bare_alias_match.group(2)
        if alias.upper() not in ("AS", "FROM", "WHERE", "AND", "OR", "ON"):
            return SelectColumnMapping(
                source_expression=expr,
                target_column=alias,
                alias=alias,
            )

    simple_col_match = re.match(r"^([\w.]+)$", raw.strip())
    if simple_col_match:
        col = simple_col_match.group(1)
        short = col.split(".")[-1] if "." in col else col
        return SelectColumnMapping(
            source_expression=col,
            target_column=short,
            alias="",
        )

    return SelectColumnMapping(
        source_expression=raw.strip(),
        target_column="",
        alias="",
    )


def _truncate_sql(sql: str, max_len: int = 2000) -> str:
    if len(sql) <= max_len:
        return sql.strip()
    return sql[:max_len].strip() + "..."


def _extract_table_refs(text: str) -> list[str]:
    tables: list[str] = []
    for match in _TABLE_REF_PATTERN.finditer(text):
        table_name = match.group(1).strip().upper()
        if table_name and table_name not in ("DUAL", "SELECT"):
            tables.append(table_name)
    return list(dict.fromkeys(tables))


def _extract_field_refs(text: str) -> list[str]:
    fields: list[str] = []
    for match in _FIELD_REF_PATTERN.finditer(text):
        field_name = match.group(1).strip().upper()
        if field_name and not field_name.startswith(("SELECT", "FROM", "WHERE", "AND", "OR")):
            fields.append(field_name)
    return list(dict.fromkeys(fields))


def _find_matching_paren_in_text(text: str, start: int) -> int:
    """从 start 位置（必须是左括号）开始，找到匹配的右括号位置。

    处理字符串中的引号转义。

    Returns:
        匹配的右括号字符偏移，未找到返回 start
    """
    return find_matching_paren(text, start)


def _split_select_columns(raw_select: str) -> list[str]:
    """按顶层逗号拆分 SELECT 列列表。

    考虑括号深度，不拆分函数参数内的逗号。

    Args:
        raw_select: SELECT ... FROM 之间的原始文本

    Returns:
        拆分后的列表达式列表
    """
    columns: list[str] = []
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
            columns.append(current.strip())
            current = ""
        else:
            current += ch

    if current.strip():
        columns.append(current.strip())

    return columns
