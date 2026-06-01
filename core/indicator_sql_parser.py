"""Parse SQL templates from indicator config to extract table dependencies, field mappings, and conditions."""

from __future__ import annotations

import re


def _is_skip_table(table_name: str) -> bool:
    upper = table_name.upper()
    skip_prefixes = (
        "FDL_IDX_TMP_",
        "FDL_INDEX_CALC_GL_TMP",
        "FDL_IDX_PARA_",
        "V_FDL_",
    )
    return any(upper.startswith(prefix) for prefix in skip_prefixes)


class IndicatorSQLParser:
    _FROM_JOIN_PATTERN = re.compile(
        r"""(?:FROM|JOIN)\s+([A-Za-z_][\w$#]*(?:\.[A-Za-z_][\w$#]*)?)""",
        re.IGNORECASE,
    )
    _SELECT_COLUMNS_PATTERN = re.compile(r"SELECT\s+(.*?)\s+FROM", re.IGNORECASE | re.DOTALL)
    _INSERT_COLUMNS_PATTERN = re.compile(
        r"INSERT\s+INTO\s+[A-Za-z_][\w$#]*(?:\.[A-Za-z_][\w$#]*)?\s*\((.*?)\)",
        re.IGNORECASE | re.DOTALL,
    )
    _WHERE_PATTERN = re.compile(
        r"\bWHERE\s+(.*?)(?:\bGROUP\s+BY\b|\bORDER\s+BY\b|\bHAVING\b|\bLIMIT\b|$)",
        re.IGNORECASE | re.DOTALL,
    )
    _DATE_VAR_PATTERN = re.compile(
        r"""(?:
            V_ETL_DT
            |V_MONTH_START
            |V_MONTH_END
            |V_DATE_START
            |V_DATE_END
            |V_ACCT_DT
            |V_BUSI_DT
            |V_DATA_DT
        )""",
        re.IGNORECASE | re.VERBOSE,
    )
    _AND_OR_PATTERN = re.compile(r"^\s*(?:AND|OR)\s+", re.IGNORECASE)

    def extract_source_tables(self, sqlcc: str) -> list[str]:
        matches = self._FROM_JOIN_PATTERN.findall(sqlcc)
        tables: list[str] = []
        for raw in matches:
            name = raw.split(".")[-1] if "." in raw else raw
            if _is_skip_table(name):
                continue
            upper_name = name.upper()
            if upper_name not in tables:
                tables.append(upper_name)
        return tables

    def extract_field_mappings(self, sqlcc: str) -> list[tuple[str, str]]:
        insert_match = self._INSERT_COLUMNS_PATTERN.search(sqlcc)
        select_match = self._SELECT_COLUMNS_PATTERN.search(sqlcc)

        target_columns: list[str] = []
        source_expressions: list[str] = []

        if insert_match:
            raw_cols = insert_match.group(1)
            target_columns = [c.strip().strip("`").strip('"').strip("[]") for c in raw_cols.split(",")]
            target_columns = [c for c in target_columns if c]

        if select_match:
            raw_exprs = select_match.group(1)
            source_expressions = [e.strip() for e in raw_exprs.split(",")]
            source_expressions = [e for e in source_expressions if e]

        mappings: list[tuple[str, str]] = []

        if target_columns and len(target_columns) == len(source_expressions):
            for src, tgt in zip(source_expressions, target_columns, strict=False):
                mappings.append((src, tgt))
        else:
            for expr in source_expressions:
                alias_match = re.search(
                    r"\bAS\s+([A-Za-z_][\w$#]*)\s*$",
                    expr,
                    re.IGNORECASE,
                )
                if alias_match:
                    alias = alias_match.group(1)
                    source = expr[: alias_match.start()].strip()
                    mappings.append((source, alias))
                else:
                    parts = expr.rsplit(".", maxsplit=1)
                    if len(parts) == 2 and re.match(r"^[A-Za-z_][\w$#]*$", parts[1]):
                        mappings.append((expr, parts[1]))
                    else:
                        mappings.append((expr, ""))

        return mappings

    def extract_where_conditions(self, sqlcc: str) -> list[str]:
        where_match = self._WHERE_PATTERN.search(sqlcc)
        if not where_match:
            return []

        where_clause = where_match.group(1)
        where_clause = self._DATE_VAR_PATTERN.sub("''", where_clause)

        raw_conditions = re.split(r"\b(?:AND|OR)\b", where_clause, flags=re.IGNORECASE)
        conditions: list[str] = []
        for cond in raw_conditions:
            cleaned = cond.strip()
            cleaned = self._AND_OR_PATTERN.sub("", cleaned)
            cleaned = re.sub(r"'\s*'", "", cleaned)
            cleaned = re.sub(r"=\s*''", "= ''", cleaned)
            cleaned = cleaned.strip()
            cleaned = re.sub(r"\s{2,}", " ", cleaned)
            if cleaned and cleaned not in ("", "''", "= ''"):
                conditions.append(cleaned)

        return conditions

    def clean_sql_for_display(self, sqlcc: str, max_length: int = 500) -> str:
        cleaned = re.sub(r"\s+", " ", sqlcc).strip()
        if len(cleaned) > max_length:
            cleaned = cleaned[:max_length] + "..."
        return cleaned
