"""
Oracle 方言适配器
处理 Oracle 特有的 SQL 语法扩展
"""
import re
from dataclasses import dataclass, field
from typing import Optional, List, Dict, Any, Set, Tuple
from enum import Enum

import sqlparse
from sqlparse.sql import Statement, Token, Identifier, IdentifierList, Parenthesis, Where
from sqlparse.tokens import Keyword, DML, DDL, Name, Punctuation

from app.parsers.sql_parser import (
    SQLParser,
    SQLStatementType,
    ParsedSQL,
    TableReference,
    ColumnReference,
    JoinClause,
)


class OracleStatementType(Enum):
    MERGE = "MERGE"
    CONNECT_BY = "CONNECT_BY"
    START_WITH = "START_WITH"
    PIVOT = "PIVOT"
    UNPIVOT = "UNPIVOT"
    MODEL = "MODEL"


@dataclass
class ConnectByClause:
    condition: str
    start_with: Optional[str] = None
    is_nocycle: bool = False
    level_column: Optional[str] = None


@dataclass
class PivotClause:
    aggregation_columns: List[str] = field(default_factory=list)
    pivot_column: Optional[str] = None
    pivot_values: List[str] = field(default_factory=list)
    alias: Optional[str] = None


@dataclass
class UnpivotClause:
    unpivot_columns: List[str] = field(default_factory=list)
    measure_column: Optional[str] = None
    pivot_column: Optional[str] = None
    alias: Optional[str] = None


@dataclass
class MergeClause:
    match_type: str
    condition: Optional[str] = None
    update_columns: List[Tuple[str, str]] = field(default_factory=list)
    insert_columns: List[str] = field(default_factory=list)
    insert_values: List[str] = field(default_factory=list)
    delete_condition: Optional[str] = None


@dataclass
class OracleParsedSQL(ParsedSQL):
    connect_by: Optional[ConnectByClause] = None
    pivot: Optional[PivotClause] = None
    unpivot: Optional[UnpivotClause] = None
    merge_clauses: List[MergeClause] = field(default_factory=list)
    model_clause: Optional[str] = None
    partition_by: List[str] = field(default_factory=list)
    hints: List[str] = field(default_factory=list)


class OracleDialect:
    """
    Oracle 方言适配器
    处理 Oracle 特有的 SQL 语法
    """

    ORACLE_HINTS = {
        "PARALLEL", "NOPARALLEL", "APPEND", "NOAPPEND", "DRIVING_SITE",
        "LEADING", "ORDERED", "USE_NL", "USE_HASH", "USE_MERGE",
        "INDEX", "NO_INDEX", "FULL", "FIRST_ROWS", "ALL_ROWS",
        "CHOOSE", "RULE", "CARDINALITY", "CPU_COSTING", "NO_CPU_COSTING",
        "DYNAMIC_SAMPLING", "MONITOR", "NO_MONITOR", "GATHER_PLAN_STATISTICS",
        "RESULT_CACHE", "NO_RESULT_CACHE", "MATERIALIZE", "INLINE",
        "MERGE", "NO_MERGE", "PUSH_PRED", "NO_PUSH_PRED", "PUSH_SUBQ",
        "NO_PUSH_SUBQ", "PX_JOIN_FILTER", "NO_PX_JOIN_FILTER", "QB_NAME",
        "CONNECT_BY_FILTERING", "NO_CONNECT_BY_FILTERING", "CONNECT_BY_COMBINE_SW",
        "NO_CONNECT_BY_COMBINE_SW", "CONNECT_BY_COST_BASED", "NO_CONNECT_BY_COST_BASED",
    }

    def __init__(self):
        self.base_parser = SQLParser(dialect="oracle")

    def parse(self, sql: str) -> OracleParsedSQL:
        sql = self._preprocess_sql(sql)
        base_parsed = self.base_parser.parse(sql)

        oracle_parsed = OracleParsedSQL(
            statement_type=base_parsed.statement_type,
            raw_sql=base_parsed.raw_sql,
            source_tables=base_parsed.source_tables,
            target_tables=base_parsed.target_tables,
            source_columns=base_parsed.source_columns,
            target_columns=base_parsed.target_columns,
            joins=base_parsed.joins,
            where_clause=base_parsed.where_clause,
            subqueries=base_parsed.subqueries,
            ctes=base_parsed.ctes,
            merge_source=base_parsed.merge_source,
            merge_target=base_parsed.merge_target,
            merge_condition=base_parsed.merge_condition,
            errors=base_parsed.errors,
        )

        statements = sqlparse.parse(sql)
        if statements:
            self._extract_oracle_features(statements[0], oracle_parsed)

        return oracle_parsed

    def _preprocess_sql(self, sql: str) -> str:
        sql = self._remove_oracle_hints(sql)
        sql = self._normalize_identifiers(sql)
        sql = self._handle_quoted_identifiers(sql)
        return sql

    def _remove_oracle_hints(self, sql: str) -> str:
        hint_pattern = r'/\*\+[^*]*\*+(?:[^/*][^*]*\*+)*\*/'
        return re.sub(hint_pattern, '', sql, flags=re.IGNORECASE)

    def _normalize_identifiers(self, sql: str) -> str:
        return sql

    def _handle_quoted_identifiers(self, sql: str) -> str:
        return sql

    def _extract_oracle_features(self, statement: Statement, parsed: OracleParsedSQL) -> None:
        self._extract_hints(statement, parsed)
        self._extract_connect_by(statement, parsed)
        self._extract_pivot_unpivot(statement, parsed)
        self._extract_merge_clauses(statement, parsed)
        self._extract_model_clause(statement, parsed)
        self._extract_partition_by(statement, parsed)

    def _extract_hints(self, statement: Statement, parsed: OracleParsedSQL) -> None:
        sql = statement.value
        hint_pattern = r'/\*\+([^*]+)\*/'
        matches = re.findall(hint_pattern, sql, re.IGNORECASE)

        for match in matches:
            hints = [h.strip() for h in match.split() if h.strip()]
            parsed.hints.extend(hints)

    def _extract_connect_by(self, statement: Statement, parsed: OracleParsedSQL) -> None:
        sql = statement.value.upper()
        connect_by_match = re.search(
            r'CONNECT\s+BY\s+(NOCYCLE\s+)?(.+?)(?=ORDER\s+BY|GROUP\s+BY|HAVING|PIVOT|UNPIVOT|MODEL|$)',
            sql,
            re.IGNORECASE | re.DOTALL
        )

        if connect_by_match:
            is_nocycle = connect_by_match.group(1) is not None
            condition = connect_by_match.group(2).strip()

            start_with_match = re.search(
                r'START\s+WITH\s+(.+?)(?=CONNECT\s+BY|$)',
                sql,
                re.IGNORECASE | re.DOTALL
            )
            start_with = start_with_match.group(1).strip() if start_with_match else None

            level_match = re.search(r'\bLEVEL\b', condition, re.IGNORECASE)
            level_column = "LEVEL" if level_match else None

            parsed.connect_by = ConnectByClause(
                condition=condition,
                start_with=start_with,
                is_nocycle=is_nocycle,
                level_column=level_column,
            )

    def _extract_pivot_unpivot(self, statement: Statement, parsed: OracleParsedSQL) -> None:
        sql = statement.value

        pivot_match = re.search(
            r'PIVOT\s*(\w+\s+)?\s*\(\s*(.+?)\s+FOR\s+(\w+)\s+IN\s*\(([^)]+)\)\s*\)\s*(\w+)?',
            sql,
            re.IGNORECASE | re.DOTALL
        )

        if pivot_match:
            alias = pivot_match.group(1)
            agg_part = pivot_match.group(2)
            pivot_column = pivot_match.group(3)
            values_part = pivot_match.group(4)
            pivot_alias = pivot_match.group(5)

            agg_columns = [a.strip() for a in agg_part.split(',') if a.strip()]
            pivot_values = [v.strip().strip("'\"") for v in values_part.split(',') if v.strip()]

            parsed.pivot = PivotClause(
                aggregation_columns=agg_columns,
                pivot_column=pivot_column,
                pivot_values=pivot_values,
                alias=pivot_alias,
            )

        unpivot_match = re.search(
            r'UNPIVOT\s*(\w+\s+)?\s*\(\s*(\w+)\s+FOR\s+(\w+)\s+IN\s*\(([^)]+)\)\s*\)\s*(\w+)?',
            sql,
            re.IGNORECASE | re.DOTALL
        )

        if unpivot_match:
            alias = unpivot_match.group(1)
            measure_column = unpivot_match.group(2)
            pivot_column = unpivot_match.group(3)
            columns_part = unpivot_match.group(4)
            unpivot_alias = unpivot_match.group(5)

            unpivot_columns = [c.strip() for c in columns_part.split(',') if c.strip()]

            parsed.unpivot = UnpivotClause(
                unpivot_columns=unpivot_columns,
                measure_column=measure_column,
                pivot_column=pivot_column,
                alias=unpivot_alias,
            )

    def _extract_merge_clauses(self, statement: Statement, parsed: OracleParsedSQL) -> None:
        if parsed.statement_type != SQLStatementType.MERGE:
            return

        sql = statement.value

        when_matched = re.findall(
            r'WHEN\s+MATCHED\s+THEN\s+(UPDATE\s+SET\s+([^;]+?)(?:\s+WHERE\s+(.+?))?)?(?=WHEN|$)',
            sql,
            re.IGNORECASE | re.DOTALL
        )

        for match in when_matched:
            if match[0]:
                update_clause = match[1].strip()
                where_clause = match[2].strip() if match[2] else None

                update_columns = []
                set_pairs = re.findall(r'(\w+)\s*=\s*([^,]+)', update_clause)
                for col, val in set_pairs:
                    update_columns.append((col.strip(), val.strip()))

                merge_clause = MergeClause(
                    match_type="MATCHED",
                    condition=where_clause,
                    update_columns=update_columns,
                )
                parsed.merge_clauses.append(merge_clause)

        when_not_matched = re.findall(
            r'WHEN\s+NOT\s+MATCHED\s+THEN\s+INSERT\s*\(([^)]+)\)\s*VALUES\s*\(([^)]+)\)',
            sql,
            re.IGNORECASE | re.DOTALL
        )

        for match in when_not_matched:
            columns = [c.strip() for c in match[0].split(',') if c.strip()]
            values = [v.strip() for v in match[1].split(',') if v.strip()]

            merge_clause = MergeClause(
                match_type="NOT_MATCHED",
                insert_columns=columns,
                insert_values=values,
            )
            parsed.merge_clauses.append(merge_clause)

        delete_match = re.search(
            r'WHEN\s+MATCHED\s+THEN\s+DELETE\s+WHERE\s+(.+?)(?=WHEN|$)',
            sql,
            re.IGNORECASE | re.DOTALL
        )

        if delete_match:
            merge_clause = MergeClause(
                match_type="MATCHED_DELETE",
                delete_condition=delete_match.group(1).strip(),
            )
            parsed.merge_clauses.append(merge_clause)

    def _extract_model_clause(self, statement: Statement, parsed: OracleParsedSQL) -> None:
        sql = statement.value

        model_match = re.search(
            r'MODEL\s+(.+?)(?=ORDER\s+BY|FETCH|$)',
            sql,
            re.IGNORECASE | re.DOTALL
        )

        if model_match:
            parsed.model_clause = model_match.group(1).strip()

    def _extract_partition_by(self, statement: Statement, parsed: OracleParsedSQL) -> None:
        sql = statement.value

        partition_match = re.search(
            r'PARTITION\s+BY\s+\(([^)]+)\)',
            sql,
            re.IGNORECASE
        )

        if partition_match:
            columns = [c.strip() for c in partition_match.group(1).split(',') if c.strip()]
            parsed.partition_by = columns

    def parse_analytic_function(self, expr: str) -> Optional[Dict[str, Any]]:
        pattern = r'(\w+)\s*\(([^)]*)\)\s*OVER\s*\(\s*(PARTITION\s+BY\s+([^)]+?))?\s*(ORDER\s+BY\s+([^)]+?))?\s*(ROWS\s+BETWEEN\s+.+?)?\s*\)'

        match = re.search(pattern, expr, re.IGNORECASE | re.DOTALL)
        if not match:
            return None

        return {
            "function": match.group(1).upper(),
            "arguments": match.group(2).strip() if match.group(2) else "",
            "partition_by": [p.strip() for p in match.group(4).split(',')] if match.group(4) else [],
            "order_by": match.group(6).strip() if match.group(6) else None,
            "window_frame": match.group(7).strip() if match.group(7) else None,
        }

    def parse_decode_expression(self, expr: str) -> Optional[Dict[str, Any]]:
        pattern = r'DECODE\s*\((.+)\)'
        match = re.search(pattern, expr, re.IGNORECASE)

        if not match:
            return None

        args_str = match.group(1)
        args = []
        current_arg = ""
        paren_depth = 0

        for char in args_str:
            if char == '(':
                paren_depth += 1
            elif char == ')':
                paren_depth -= 1
            elif char == ',' and paren_depth == 0:
                args.append(current_arg.strip())
                current_arg = ""
                continue
            current_arg += char

        if current_arg.strip():
            args.append(current_arg.strip())

        if len(args) < 3:
            return None

        return {
            "expression": args[0],
            "search_value": args[1],
            "result_value": args[2],
            "default_value": args[3] if len(args) > 3 else None,
            "additional_pairs": [(args[i], args[i + 1]) for i in range(3, len(args) - 1, 2)] if len(args) > 4 else [],
        }

    def parse_nvl_expression(self, expr: str) -> Optional[Dict[str, Any]]:
        pattern = r'NVL\s*\(\s*([^,]+)\s*,\s*([^)]+)\s*\)'
        match = re.search(pattern, expr, re.IGNORECASE)

        if not match:
            return None

        return {
            "expression": match.group(1).strip(),
            "default_value": match.group(2).strip(),
        }

    def parse_case_expression(self, expr: str) -> Optional[Dict[str, Any]]:
        pattern = r'CASE\s+(.+?)\s+END'
        match = re.search(pattern, expr, re.IGNORECASE | re.DOTALL)

        if not match:
            return None

        case_body = match.group(1)
        result = {
            "type": None,
            "operand": None,
            "when_clauses": [],
            "else_clause": None,
        }

        simple_case = re.match(r'^(\w+)\s+WHEN', case_body, re.IGNORECASE)
        if simple_case:
            result["type"] = "simple"
            result["operand"] = simple_case.group(1)
            case_body = case_body[len(simple_case.group(1)):].strip()
        else:
            result["type"] = "searched"

        when_pattern = r'WHEN\s+(.+?)\s+THEN\s+(.+?)(?=WHEN|ELSE|END|$)'
        when_matches = re.findall(when_pattern, case_body, re.IGNORECASE | re.DOTALL)

        for condition, value in when_matches:
            result["when_clauses"].append({
                "condition": condition.strip(),
                "result": value.strip(),
            })

        else_match = re.search(r'ELSE\s+(.+?)(?=END|$)', case_body, re.IGNORECASE | re.DOTALL)
        if else_match:
            result["else_clause"] = else_match.group(1).strip()

        return result

    def is_oracle_reserved_word(self, word: str) -> bool:
        oracle_reserved = {
            "ACCESS", "ADD", "ALL", "ALTER", "AND", "ANY", "AS", "ASC", "AUDIT",
            "BETWEEN", "BY", "CHAR", "CHECK", "CLUSTER", "COLUMN", "COMMENT",
            "COMPRESS", "CONNECT", "CREATE", "CURRENT", "DATE", "DECIMAL",
            "DEFAULT", "DELETE", "DESC", "DISTINCT", "DROP", "ELSE", "EXCLUSIVE",
            "EXISTS", "FILE", "FLOAT", "FOR", "FROM", "GRANT", "GROUP", "HAVING",
            "IDENTIFIED", "IMMEDIATE", "IN", "INCREMENT", "INDEX", "INITIAL",
            "INSERT", "INTEGER", "INTERSECT", "INTO", "IS", "LEVEL", "LIKE",
            "LOCK", "LONG", "MAXEXTENTS", "MINUS", "MLSLABEL", "MODE", "MODIFY",
            "NOAUDIT", "NOCOMPRESS", "NOT", "NOWAIT", "NULL", "NUMBER", "OF",
            "OFFLINE", "ON", "ONLINE", "OPTION", "OR", "ORDER", "PCTFREE",
            "PRIOR", "PRIVILEGES", "PUBLIC", "RAW", "RENAME", "RESOURCE", "REVOKE",
            "ROW", "ROWID", "ROWNUM", "ROWS", "SELECT", "SESSION", "SET",
            "SHARE", "SIZE", "SMALLINT", "START", "SUCCESSFUL", "SYNONYM",
            "SYSDATE", "TABLE", "THEN", "TO", "TRIGGER", "UID", "UNION",
            "UNIQUE", "UPDATE", "USER", "VALIDATE", "VALUES", "VARCHAR",
            "VARCHAR2", "VIEW", "WHENEVER", "WHERE", "WITH",
        }
        return word.upper() in oracle_reserved

    def quote_identifier(self, identifier: str) -> str:
        if self.is_oracle_reserved_word(identifier):
            return f'"{identifier}"'
        if re.match(r'^[A-Z_][A-Z0-9_]*$', identifier.upper()):
            return identifier
        return f'"{identifier}"'

    def normalize_table_name(self, name: str, default_schema: Optional[str] = None) -> str:
        parts = name.replace('"', '').split('.')

        if len(parts) == 1:
            table_name = parts[0]
            schema = default_schema
        elif len(parts) == 2:
            schema, table_name = parts
        else:
            return name

        if schema:
            return f"{schema}.{table_name}"
        return table_name