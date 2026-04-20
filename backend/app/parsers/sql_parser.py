"""
SQL 解析器主类
使用 sqlparse 库解析 SQL 语句，提取表和字段信息
"""
import re
from dataclasses import dataclass, field
from enum import Enum
from typing import Optional, List, Dict, Any, Set, Tuple

import sqlparse
from sqlparse.sql import (
    Statement,
    Token,
    Identifier,
    IdentifierList,
    Where,
    Parenthesis,
    Comparison,
    Function,
    Operation,
)
from sqlparse.tokens import Keyword, DML, DDL, Name, String, Number, Punctuation, Comment


class SQLStatementType(Enum):
    SELECT = "SELECT"
    INSERT = "INSERT"
    UPDATE = "UPDATE"
    DELETE = "DELETE"
    CREATE = "CREATE"
    ALTER = "ALTER"
    DROP = "DROP"
    MERGE = "MERGE"
    WITH = "WITH"
    UNKNOWN = "UNKNOWN"


@dataclass
class TableReference:
    name: str
    alias: Optional[str] = None
    schema: Optional[str] = None
    database: Optional[str] = None
    is_target: bool = False

    @property
    def full_name(self) -> str:
        parts = []
        if self.database:
            parts.append(self.database)
        if self.schema:
            parts.append(self.schema)
        parts.append(self.name)
        return ".".join(parts)

    @property
    def unique_key(self) -> str:
        return self.alias if self.alias else self.name


@dataclass
class ColumnReference:
    name: str
    table_alias: Optional[str] = None
    expression: Optional[str] = None
    is_source: bool = True
    is_target: bool = False

    @property
    def full_name(self) -> str:
        if self.table_alias:
            return f"{self.table_alias}.{self.name}"
        return self.name


@dataclass
class JoinClause:
    join_type: str
    right_table: TableReference
    condition: Optional[str] = None
    left_table: Optional[TableReference] = None


@dataclass
class ParsedSQL:
    statement_type: SQLStatementType
    raw_sql: str
    source_tables: List[TableReference] = field(default_factory=list)
    target_tables: List[TableReference] = field(default_factory=list)
    source_columns: List[ColumnReference] = field(default_factory=list)
    target_columns: List[ColumnReference] = field(default_factory=list)
    joins: List[JoinClause] = field(default_factory=list)
    where_clause: Optional[str] = None
    subqueries: List["ParsedSQL"] = field(default_factory=list)
    ctes: Dict[str, "ParsedSQL"] = field(default_factory=dict)
    merge_source: Optional[TableReference] = None
    merge_target: Optional[TableReference] = None
    merge_condition: Optional[str] = None
    errors: List[str] = field(default_factory=list)


class SQLParser:
    """
    SQL 解析器主类
    负责解析 SQL 语句并提取表、字段、JOIN 等信息
    """

    KEYWORDS = {
        "SELECT", "FROM", "WHERE", "JOIN", "INNER", "LEFT", "RIGHT", "OUTER",
        "ON", "AND", "OR", "AS", "INSERT", "INTO", "VALUES", "UPDATE", "SET",
        "DELETE", "CREATE", "TABLE", "DROP", "ALTER", "MERGE", "USING",
        "WHEN", "MATCHED", "THEN", "WITH", "GROUP", "BY", "HAVING", "ORDER",
        "UNION", "EXCEPT", "INTERSECT", "DISTINCT", "ALL", "NULL", "NOT",
        "IN", "EXISTS", "BETWEEN", "LIKE", "CASE", "WHEN", "ELSE", "END",
    }

    def __init__(self, dialect: Optional[str] = None):
        self.dialect = dialect or "standard"
        self._table_aliases: Dict[str, TableReference] = {}
        self._cte_names: Set[str] = set()

    def parse(self, sql: str) -> ParsedSQL:
        statements = sqlparse.parse(sql)
        if not statements:
            return ParsedSQL(
                statement_type=SQLStatementType.UNKNOWN,
                raw_sql=sql,
                errors=["无法解析 SQL 语句"],
            )

        statement = statements[0]
        return self._parse_statement(statement, sql)

    def _parse_statement(self, statement: Statement, raw_sql: str) -> ParsedSQL:
        self._table_aliases = {}
        self._cte_names = set()

        stmt_type = self._detect_statement_type(statement)

        parsed = ParsedSQL(
            statement_type=stmt_type,
            raw_sql=raw_sql,
        )

        if stmt_type == SQLStatementType.WITH:
            self._parse_with_statement(statement, parsed)
        elif stmt_type == SQLStatementType.SELECT:
            self._parse_select_statement(statement, parsed)
        elif stmt_type == SQLStatementType.INSERT:
            self._parse_insert_statement(statement, parsed)
        elif stmt_type == SQLStatementType.UPDATE:
            self._parse_update_statement(statement, parsed)
        elif stmt_type == SQLStatementType.DELETE:
            self._parse_delete_statement(statement, parsed)
        elif stmt_type == SQLStatementType.CREATE:
            self._parse_create_statement(statement, parsed)
        elif stmt_type == SQLStatementType.MERGE:
            self._parse_merge_statement(statement, parsed)
        else:
            parsed.errors.append(f"不支持的语句类型: {stmt_type.value}")

        return parsed

    def _detect_statement_type(self, statement: Statement) -> SQLStatementType:
        first_token = statement.token_first(skip_ws=True, skip_cm=True)
        if first_token is None:
            return SQLStatementType.UNKNOWN

        token_value = first_token.ttype

        if token_value == DML:
            keyword = first_token.value.upper()
            if keyword == "SELECT":
                if self._has_with_clause(statement):
                    return SQLStatementType.WITH
                return SQLStatementType.SELECT
            elif keyword == "INSERT":
                return SQLStatementType.INSERT
            elif keyword == "UPDATE":
                return SQLStatementType.UPDATE
            elif keyword == "DELETE":
                return SQLStatementType.DELETE
            elif keyword == "MERGE":
                return SQLStatementType.MERGE
        elif token_value == DDL:
            keyword = first_token.value.upper()
            if keyword == "CREATE":
                return SQLStatementType.CREATE
            elif keyword == "ALTER":
                return SQLStatementType.ALTER
            elif keyword == "DROP":
                return SQLStatementType.DROP

        return SQLStatementType.UNKNOWN

    def _has_with_clause(self, statement: Statement) -> bool:
        for token in statement.tokens:
            if token.ttype == Keyword and token.value.upper() == "WITH":
                return True
        return False

    def _parse_with_statement(self, statement: Statement, parsed: ParsedSQL) -> None:
        cte_names: List[str] = []
        cte_statements: List[Statement] = []
        main_statement: Optional[Statement] = None

        idx = 0
        tokens = list(statement.flatten())
        while idx < len(tokens):
            token = tokens[idx]
            if token.ttype == Keyword and token.value.upper() == "WITH":
                idx += 1
                while idx < len(tokens):
                    cte_name_token = tokens[idx]
                    if cte_name_token.ttype in (Name, None) and cte_name_token.value.upper() not in self.KEYWORDS:
                        cte_names.append(cte_name_token.value.strip())
                        idx += 1
                        while idx < len(tokens) and tokens[idx].value != "(":
                            idx += 1
                        if idx < len(tokens):
                            paren_count = 1
                            idx += 1
                            cte_sql_tokens = []
                            while idx < len(tokens) and paren_count > 0:
                                if tokens[idx].value == "(":
                                    paren_count += 1
                                elif tokens[idx].value == ")":
                                    paren_count -= 1
                                if paren_count > 0:
                                    cte_sql_tokens.append(tokens[idx])
                                idx += 1
                            cte_sql = "".join(t.value for t in cte_sql_tokens)
                            cte_statements.append(sqlparse.parse(cte_sql)[0] if cte_sql else None)
                    else:
                        idx += 1
                        if idx < len(tokens) and tokens[idx - 1].value.upper() in (",", "WITH"):
                            continue
                        if cte_names:
                            break
                break
            idx += 1

        self._cte_names = set(cte_names)

        for i, cte_name in enumerate(cte_names):
            if i < len(cte_statements) and cte_statements[i]:
                cte_parsed = self._parse_statement(cte_statements[i], "")
                parsed.ctes[cte_name] = cte_parsed

        main_parsed = self._parse_select_statement(statement, parsed)
        for cte_name in cte_names:
            if cte_name in self._table_aliases:
                del self._table_aliases[cte_name]

    def _parse_select_statement(self, statement: Statement, parsed: ParsedSQL) -> ParsedSQL:
        self._extract_columns_from_select(statement, parsed)
        self._extract_tables_from_from(statement, parsed)
        self._extract_joins(statement, parsed)
        self._extract_where(statement, parsed)
        self._extract_subqueries(statement, parsed)

        return parsed

    def _extract_columns_from_select(self, statement: Statement, parsed: ParsedSQL) -> None:
        select_idx = None
        from_idx = None

        for i, token in enumerate(statement.tokens):
            if token.ttype == DML and token.value.upper() == "SELECT":
                select_idx = i
            elif token.ttype == Keyword and token.value.upper() == "FROM":
                from_idx = i
                break

        if select_idx is None or from_idx is None:
            return

        select_tokens = statement.tokens[select_idx + 1:from_idx]

        for token in select_tokens:
            if isinstance(token, IdentifierList):
                for identifier in token.get_identifiers():
                    col = self._parse_column_identifier(identifier)
                    if col:
                        parsed.source_columns.append(col)
            elif isinstance(token, Identifier):
                col = self._parse_column_identifier(token)
                if col:
                    parsed.source_columns.append(col)
            elif token.ttype not in (Punctuation, Comment, None) or (token.ttype is None and token.value.strip() and token.value != ","):
                if token.ttype is None and token.value.strip() and token.value not in (",", "*"):
                    parsed.source_columns.append(ColumnReference(name=token.value.strip()))

    def _parse_column_identifier(self, identifier: Identifier) -> Optional[ColumnReference]:
        name = identifier.get_real_name()
        alias = identifier.get_alias()
        expression = identifier.value

        table_alias = None
        col_name = name

        if "." in name:
            parts = name.split(".", 1)
            table_alias = parts[0]
            col_name = parts[1] if len(parts) > 1 else name

        return ColumnReference(
            name=alias or col_name,
            table_alias=table_alias,
            expression=expression,
            is_source=True,
        )

    def _extract_tables_from_from(self, statement: Statement, parsed: ParsedSQL) -> None:
        from_idx = None
        where_idx = None
        group_idx = None
        order_idx = None
        limit_idx = None

        for i, token in enumerate(statement.tokens):
            token_upper = token.value.upper() if hasattr(token, "value") else ""
            if token.ttype == Keyword and token_upper == "FROM":
                from_idx = i
            elif token.ttype == Keyword and token_upper == "WHERE":
                where_idx = i
            elif token.ttype == Keyword and token_upper == "GROUP":
                group_idx = i
            elif token.ttype == Keyword and token_upper == "ORDER":
                order_idx = i
            elif token.ttype == Keyword and token_upper == "LIMIT":
                limit_idx = i

        if from_idx is None:
            return

        end_idx = where_idx or group_idx or order_idx or limit_idx or len(statement.tokens)
        from_tokens = statement.tokens[from_idx + 1:end_idx]

        self._parse_table_list(from_tokens, parsed, is_source=True)

    def _parse_table_list(self, tokens: List[Token], parsed: ParsedSQL, is_source: bool = True) -> None:
        current_tables: List[TableReference] = []
        current_token_list = []

        for token in tokens:
            if token.ttype == Keyword and token.value.upper() in ("JOIN", "INNER", "LEFT", "RIGHT", "OUTER", "CROSS", "NATURAL"):
                if current_token_list:
                    self._extract_tables_from_tokens(current_token_list, parsed, is_source)
                    current_token_list = []
                break
            current_token_list.append(token)

        if current_token_list:
            self._extract_tables_from_tokens(current_token_list, parsed, is_source)

    def _extract_tables_from_tokens(self, tokens: List[Token], parsed: ParsedSQL, is_source: bool) -> None:
        for token in tokens:
            if isinstance(token, IdentifierList):
                for identifier in token.get_identifiers():
                    table = self._parse_table_identifier(identifier, is_source)
                    if table:
                        if is_source:
                            parsed.source_tables.append(table)
                        else:
                            parsed.target_tables.append(table)
                        if table.alias:
                            self._table_aliases[table.alias] = table
            elif isinstance(token, Identifier):
                table = self._parse_table_identifier(token, is_source)
                if table:
                    if is_source:
                        parsed.source_tables.append(table)
                    else:
                        parsed.target_tables.append(table)
                    if table.alias:
                        self._table_aliases[table.alias] = table
            elif token.ttype == Name or (token.ttype is None and token.value.strip() and token.value.upper() not in self.KEYWORDS):
                value = token.value.strip()
                if value and value not in (",", "(", ")"):
                    table = TableReference(name=value, is_target=not is_source)
                    if is_source:
                        parsed.source_tables.append(table)
                    else:
                        parsed.target_tables.append(table)
            elif isinstance(token, Parenthesis):
                sub_sql = token.value.strip()[1:-1]
                if sub_sql:
                    sub_parsed = self.parse(sub_sql)
                    parsed.subqueries.append(sub_parsed)

    def _parse_table_identifier(self, identifier: Identifier, is_source: bool = True) -> Optional[TableReference]:
        name = identifier.get_real_name()
        alias = identifier.get_alias()

        schema = None
        database = None
        table_name = name

        if "." in name:
            parts = name.split(".")
            if len(parts) == 2:
                schema, table_name = parts
            elif len(parts) >= 3:
                database, schema, table_name = parts[0], parts[1], parts[2]

        return TableReference(
            name=table_name,
            alias=alias,
            schema=schema,
            database=database,
            is_target=not is_source,
        )

    def _extract_joins(self, statement: Statement, parsed: ParsedSQL) -> None:
        join_keywords = {"JOIN", "INNER", "LEFT", "RIGHT", "OUTER", "CROSS", "NATURAL"}

        i = 0
        tokens = list(statement.tokens)

        while i < len(tokens):
            token = tokens[i]
            token_upper = token.value.upper() if hasattr(token, "value") else ""

            if token.ttype == Keyword and token_upper in join_keywords:
                join_type = token_upper

                if token_upper in ("LEFT", "RIGHT", "CROSS", "NATURAL"):
                    if i + 1 < len(tokens):
                        next_token = tokens[i + 1]
                        if next_token.ttype == Keyword and next_token.value.upper() in ("OUTER", "JOIN"):
                            if next_token.value.upper() == "OUTER":
                                join_type = f"{token_upper} OUTER"
                                i += 1
                            elif next_token.value.upper() == "JOIN":
                                join_type = f"{token_upper} JOIN"
                                i += 1
                        elif next_token.value.upper() == "JOIN":
                            join_type = f"{token_upper} JOIN"
                            i += 1

                i += 1
                while i < len(tokens) and tokens[i].ttype in (None, Punctuation) and tokens[i].value.strip() in ("", ","):
                    i += 1

                if i < len(tokens):
                    table_token = tokens[i]
                    if isinstance(table_token, Identifier):
                        table = self._parse_table_identifier(table_token, is_source=True)
                        if table:
                            parsed.source_tables.append(table)
                            if table.alias:
                                self._table_aliases[table.alias] = table

                            join = JoinClause(
                                join_type=join_type,
                                right_table=table,
                            )

                            on_idx = i + 1
                            while on_idx < len(tokens):
                                if tokens[on_idx].ttype == Keyword and tokens[on_idx].value.upper() == "ON":
                                    on_idx += 1
                                    condition_tokens = []
                                    while on_idx < len(tokens):
                                        t = tokens[on_idx]
                                        if t.ttype == Keyword and t.value.upper() in ("WHERE", "GROUP", "ORDER", "JOIN", "LEFT", "RIGHT", "INNER", "CROSS", "NATURAL"):
                                            break
                                        condition_tokens.append(t.value)
                                        on_idx += 1
                                    join.condition = "".join(condition_tokens).strip()
                                    break
                                on_idx += 1

                            parsed.joins.append(join)
            i += 1

    def _extract_where(self, statement: Statement, parsed: ParsedSQL) -> None:
        for token in statement.tokens:
            if isinstance(token, Where):
                parsed.where_clause = token.value
                break

    def _extract_subqueries(self, statement: Statement, parsed: ParsedSQL) -> None:
        for token in statement.flatten():
            if isinstance(token, Parenthesis):
                inner = token.value.strip()
                if inner.startswith("(") and inner.endswith(")"):
                    inner_sql = inner[1:-1].strip()
                    if inner_sql and any(kw in inner_sql.upper() for kw in ["SELECT", "INSERT", "UPDATE", "DELETE"]):
                        try:
                            sub_parsed = self.parse(inner_sql)
                            if sub_parsed.statement_type != SQLStatementType.UNKNOWN:
                                parsed.subqueries.append(sub_parsed)
                        except Exception:
                            pass

    def _parse_insert_statement(self, statement: Statement, parsed: ParsedSQL) -> None:
        tokens = list(statement.tokens)
        into_idx = None
        values_idx = None
        select_idx = None

        for i, token in enumerate(tokens):
            token_upper = token.value.upper() if hasattr(token, "value") else ""
            if token.ttype == Keyword and token_upper == "INTO":
                into_idx = i
            elif token.ttype == Keyword and token_upper == "VALUES":
                values_idx = i
            elif token.ttype == DML and token_upper == "SELECT":
                select_idx = i

        if into_idx is not None:
            for i in range(into_idx + 1, len(tokens)):
                token = tokens[i]
                if isinstance(token, Identifier):
                    table = self._parse_table_identifier(token, is_source=False)
                    if table:
                        parsed.target_tables.append(table)
                    break
                elif token.ttype == Name or (token.ttype is None and token.value.strip()):
                    table = TableReference(name=token.value.strip(), is_target=True)
                    parsed.target_tables.append(table)
                    break

        if select_idx is not None:
            select_sql = "".join(t.value for t in tokens[select_idx:])
            select_parsed = self.parse(select_sql)
            parsed.source_tables.extend(select_parsed.source_tables)
            parsed.source_columns.extend(select_parsed.source_columns)
            parsed.joins.extend(select_parsed.joins)
            parsed.subqueries.extend(select_parsed.subqueries)

        if values_idx is not None:
            for i in range(values_idx + 1, len(tokens)):
                token = tokens[i]
                if isinstance(token, Parenthesis):
                    inner = token.value.strip()[1:-1]
                    columns = [c.strip() for c in inner.split(",") if c.strip()]
                    for col in columns:
                        parsed.target_columns.append(ColumnReference(name=col, is_target=True))
                    break

    def _parse_update_statement(self, statement: Statement, parsed: ParsedSQL) -> None:
        tokens = list(statement.tokens)
        update_idx = None
        set_idx = None
        where_idx = None

        for i, token in enumerate(tokens):
            token_upper = token.value.upper() if hasattr(token, "value") else ""
            if token.ttype == DML and token_upper == "UPDATE":
                update_idx = i
            elif token.ttype == Keyword and token_upper == "SET":
                set_idx = i
            elif token.ttype == Keyword and token_upper == "WHERE":
                where_idx = i

        if update_idx is not None:
            for i in range(update_idx + 1, len(tokens)):
                token = tokens[i]
                if isinstance(token, Identifier):
                    table = self._parse_table_identifier(token, is_source=False)
                    if table:
                        parsed.target_tables.append(table)
                        parsed.source_tables.append(TableReference(
                            name=table.name,
                            alias=table.alias,
                            schema=table.schema,
                            database=table.database,
                            is_target=False,
                        ))
                    break
                elif token.ttype == Name or (token.ttype is None and token.value.strip()):
                    table_name = token.value.strip()
                    table = TableReference(name=table_name, is_target=True)
                    parsed.target_tables.append(table)
                    parsed.source_tables.append(TableReference(name=table_name, is_target=False))
                    break

        if set_idx is not None:
            end_idx = where_idx or len(tokens)
            set_tokens = tokens[set_idx + 1:end_idx]

            for token in set_tokens:
                if isinstance(token, Comparison):
                    left = token.left.value if hasattr(token, "left") else ""
                    if left:
                        parsed.target_columns.append(ColumnReference(name=left, is_target=True))
                elif isinstance(token, Identifier):
                    parsed.target_columns.append(ColumnReference(name=token.value, is_target=True))

        if where_idx is not None:
            where_tokens = tokens[where_idx:]
            for token in where_tokens:
                if isinstance(token, Where):
                    parsed.where_clause = token.value
                    break

    def _parse_delete_statement(self, statement: Statement, parsed: ParsedSQL) -> None:
        tokens = list(statement.tokens)
        from_idx = None
        where_idx = None

        for i, token in enumerate(tokens):
            token_upper = token.value.upper() if hasattr(token, "value") else ""
            if token.ttype == Keyword and token_upper == "FROM":
                from_idx = i
            elif token.ttype == Keyword and token_upper == "WHERE":
                where_idx = i

        if from_idx is not None:
            for i in range(from_idx + 1, len(tokens)):
                token = tokens[i]
                if isinstance(token, Identifier):
                    table = self._parse_table_identifier(token, is_source=False)
                    if table:
                        parsed.target_tables.append(table)
                    break
                elif token.ttype == Name or (token.ttype is None and token.value.strip()):
                    table = TableReference(name=token.value.strip(), is_target=True)
                    parsed.target_tables.append(table)
                    break

        if where_idx is not None:
            for token in tokens[where_idx:]:
                if isinstance(token, Where):
                    parsed.where_clause = token.value
                    break

    def _parse_create_statement(self, statement: Statement, parsed: ParsedSQL) -> None:
        tokens = list(statement.tokens)
        as_idx = None
        select_idx = None

        for i, token in enumerate(tokens):
            token_upper = token.value.upper() if hasattr(token, "value") else ""
            if token.ttype == Keyword and token_upper == "AS":
                as_idx = i
            elif token.ttype == DML and token_upper == "SELECT":
                select_idx = i

        table_idx = None
        for i, token in enumerate(tokens):
            if token.ttype == Keyword and token.value.upper() == "TABLE":
                table_idx = i + 1
                break

        if table_idx is not None:
            for i in range(table_idx, len(tokens)):
                token = tokens[i]
                if isinstance(token, Identifier):
                    table = self._parse_table_identifier(token, is_source=False)
                    if table:
                        parsed.target_tables.append(table)
                    break
                elif token.ttype == Name or (token.ttype is None and token.value.strip()):
                    table = TableReference(name=token.value.strip(), is_target=True)
                    parsed.target_tables.append(table)
                    break

        if select_idx is not None:
            select_sql = "".join(t.value for t in tokens[select_idx:])
            select_parsed = self.parse(select_sql)
            parsed.source_tables.extend(select_parsed.source_tables)
            parsed.source_columns.extend(select_parsed.source_columns)
            parsed.joins.extend(select_parsed.joins)
            parsed.subqueries.extend(select_parsed.subqueries)

    def _parse_merge_statement(self, statement: Statement, parsed: ParsedSQL) -> None:
        tokens = list(statement.tokens)
        into_idx = None
        using_idx = None
        on_idx = None
        when_idx = None

        for i, token in enumerate(tokens):
            token_upper = token.value.upper() if hasattr(token, "value") else ""
            if token.ttype == Keyword and token_upper == "INTO":
                into_idx = i
            elif token.ttype == Keyword and token_upper == "USING":
                using_idx = i
            elif token.ttype == Keyword and token_upper == "ON":
                on_idx = i
            elif token.ttype == Keyword and token_upper == "WHEN":
                when_idx = i

        if into_idx is not None:
            for i in range(into_idx + 1, min(using_idx or len(tokens), len(tokens))):
                token = tokens[i]
                if isinstance(token, Identifier):
                    table = self._parse_table_identifier(token, is_source=False)
                    if table:
                        parsed.target_tables.append(table)
                        parsed.merge_target = table
                    break
                elif token.ttype == Name or (token.ttype is None and token.value.strip()):
                    table = TableReference(name=token.value.strip(), is_target=True)
                    parsed.target_tables.append(table)
                    parsed.merge_target = table
                    break

        if using_idx is not None:
            for i in range(using_idx + 1, min(on_idx or len(tokens), len(tokens))):
                token = tokens[i]
                if isinstance(token, Identifier):
                    table = self._parse_table_identifier(token, is_source=True)
                    if table:
                        parsed.source_tables.append(table)
                        parsed.merge_source = table
                    break
                elif token.ttype == Name or (token.ttype is None and token.value.strip()):
                    table = TableReference(name=token.value.strip(), is_target=False)
                    parsed.source_tables.append(table)
                    parsed.merge_source = table
                    break

        if on_idx is not None:
            end_idx = when_idx or len(tokens)
            condition_tokens = []
            for i in range(on_idx + 1, end_idx):
                token = tokens[i]
                if token.ttype == Keyword and token.value.upper() == "WHEN":
                    break
                condition_tokens.append(token.value)
            parsed.merge_condition = "".join(condition_tokens).strip()

    def get_table_alias_map(self) -> Dict[str, TableReference]:
        return self._table_aliases.copy()

    def resolve_column_table(self, column: ColumnReference) -> Optional[TableReference]:
        if column.table_alias:
            return self._table_aliases.get(column.table_alias)
        return None