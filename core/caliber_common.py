"""
Shared regex patterns and helper functions for the caliber extraction subsystem.
"""

from __future__ import annotations

import re

from core.models import SelectColumnMapping

# ---------------------------------------------------------------------------
# Regex patterns
# ---------------------------------------------------------------------------

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


# ---------------------------------------------------------------------------
# Shared helper functions
# ---------------------------------------------------------------------------


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
