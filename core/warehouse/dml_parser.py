"""
数仓 DML 解析器
从 .sql 文件中解析 INSERT INTO ... SELECT FROM / MERGE INTO / UPDATE 等 DML 语句，
提取表级血缘和字段级映射关系。

支持7种DML类型：
  Type1: IDL全量快照 - 单表FROM + 拉链条件
  Type2: IML全量拉链 - 备份表/临时表/FULL JOIN/分区交换
  Type3: IOL全量拉链 - exchange partition
  Type4: IEL卸数 - shell格式 query="..."
  Type5: ICL共性加工 - 多临时表(tmp_01~17), CTAS + INSERT
  Type6: ITL技术缓冲 - 单表FROM msl
  Type7: 管架IDL - DELETE+INSERT / MERGE INTO / WITH CTE / UPDATE
"""

from __future__ import annotations

import logging
import re
from dataclasses import dataclass, field
from pathlib import Path

from core.field_cleaner import FieldCleaner
from core.models import FieldMapping, ProcedureInfo, TableInfo, TableLineage
from core.parser_protocol import ParseOutput
from core.utils.sql_comment_stripper import strip_sql_comments
from core.warehouse.schema_resolver import SchemaResolver
from core.warehouse.temp_table_filter import TempTableFilter

logger = logging.getLogger(__name__)
_SQL_KEYWORDS = {
    "NVL",
    "TO_DATE",
    "TO_TIMESTAMP",
    "TO_CHAR",
    "TO_NUMBER",
    "DUAL",
    "SYSDATE",
    "ROWNUM",
    "NULL",
    "CASE",
    "WHEN",
    "SELECT",
    "FROM",
    "WHERE",
    "AND",
    "OR",
    "NOT",
    "IN",
    "EXISTS",
    "BETWEEN",
    "LIKE",
    "IS",
    "AS",
    "ON",
    "SET",
    "INTO",
    "VALUES",
    "GROUP",
    "ORDER",
    "HAVING",
    "LIMIT",
    "UNION",
    "ALL",
    "DISTINCT",
    "TRIM",
    "UPPER",
    "LOWER",
    "SUBSTR",
    "INSTR",
    "LENGTH",
    "REPLACE",
    "CONCAT",
    "SUM",
    "COUNT",
    "AVG",
    "MAX",
    "MIN",
    "DECODE",
    "GREATEST",
    "LEAST",
    "COALESCE",
    "CAST",
    "EXTRACT",
    "ROUND",
    "TRUNC",
    "FLOOR",
    "CEIL",
    "ABS",
    "MOD",
    "SIGN",
    "POWER",
    "SQRT",
    "ADD_MONTHS",
    "LAST_DAY",
    "NEXT_DAY",
    "MONTHS_BETWEEN",
    "ROW_NUMBER",
    "RANK",
    "DENSE_RANK",
    "LEAD",
    "LAG",
    "FIRST_VALUE",
    "LAST_VALUE",
    "OVER",
    "PARTITION",
    "WITH",
    "JOIN",
    "LEFT",
    "RIGHT",
    "INNER",
    "OUTER",
    "FULL",
    "CROSS",
    "USING",
}

# ---------------------------------------------------------------------------
# 正则：DML 解析
# ---------------------------------------------------------------------------

# INSERT INTO target [PARTITION ...] (columns) SELECT ... FROM source
# 简化版：仅匹配目标表名和目标字段列表，不贪婪匹配 SELECT/FROM
_INSERT_TARGET_PATTERN = re.compile(
    r"INSERT\s+(?:/\*.*?\*/\s*)?"  # 可选 hint
    r"INTO\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"  # 目标表名（含变量或普通格式）
    r"(?:\s+PARTITION\s+FOR\s*\(.*?\))?"  # 可选 PARTITION FOR(expr) — 简化后
    r"(?:\s+PARTITION\s+\w+)?"  # 可选 PARTITION p_xxx
    r"(?:\s+NOLOGGING)?\s*"
    r"\((.*?)\)\s*"  # 目标字段列表
    r"SELECT\b",  # SELECT 关键字确认
    re.IGNORECASE | re.DOTALL,
)

# SQL 标识符按数据库对象名处理，避免 Python \w 把中文注释误识别为表名。
_SQL_IDENTIFIER = r"[A-Za-z_][A-Za-z0-9_$#]*"
_SCHEMA_TABLE_REF = rf"(?:\$\{{[\w_]+\}}|{_SQL_IDENTIFIER})\.{_SQL_IDENTIFIER}"
_BARE_TABLE_REF = _SQL_IDENTIFIER
_TABLE_REF = rf"(?:{_SCHEMA_TABLE_REF}|{_BARE_TABLE_REF})"

# FROM 子句中的表引用（简化版）
_FROM_TABLE_PATTERN = re.compile(
    r"(?:FROM|JOIN)\s+"
    rf"({_TABLE_REF})"  # 表名
    rf"(?:\s+(?:AS\s+)?({_SQL_IDENTIFIER}))?",  # 可选别名
    re.IGNORECASE,
)

_TABLE_REF_AT_PATTERN = re.compile(_TABLE_REF, re.IGNORECASE)
_SQL_IDENTIFIER_AT_PATTERN = re.compile(_SQL_IDENTIFIER, re.IGNORECASE)
_FROM_KEYWORD_PATTERN = re.compile(r"\bFROM\b", re.IGNORECASE)
_INSERT_ALL_PATTERN = re.compile(
    r"INSERT\s+(?:/\*.*?\*/\s*)?ALL\b",
    re.IGNORECASE,
)
_INSERT_ALL_INTO_PATTERN = re.compile(
    r"\bINTO\s+"
    rf"({_TABLE_REF})"
    r"(?:\s+PARTITION\s+FOR\s*\(.*?\))?"
    r"(?:\s+PARTITION\s+\w+)?"
    r"(?:\s+NOLOGGING)?\s*"
    r"\((.*?)\)",
    re.IGNORECASE | re.DOTALL,
)

# MERGE INTO target USING source ON (...)
_MERGE_INTO_PATTERN = re.compile(
    r"MERGE\s+INTO\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"  # 目标表
    r"\s+USING\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+(?:\s+\w+)?)",  # 源表
    re.IGNORECASE,
)

# UPDATE target SET ...
_UPDATE_PATTERN = re.compile(
    r"UPDATE\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"  # 目标表
    r"\s+SET\s+",
    re.IGNORECASE,
)

# CREATE TABLE ... AS SELECT (CTAS)
# Only matches up to the AS keyword; FROM clause is extracted via token-aware scanning.
_CTAS_PATTERN = re.compile(
    r"CREATE\s+TABLE\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"  # 目标表
    r"\s+(?:NOLOGGING\s+)?"
    r"(?:COMPRESS\s+\$\{[\w_]+\}\s+FOR\s+QUERY\s+HIGH\s+)?"
    r"AS\s+",
    re.IGNORECASE,
)

# ALTER TABLE ... EXCHANGE PARTITION ... WITH TABLE ...
_EXCHANGE_PARTITION_PATTERN = re.compile(
    r"ALTER\s+TABLE\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"  # 目标表
    r"\s+EXCHANGE\s+PARTITION\s+\S+\s+"
    r"WITH\s+TABLE\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)",  # 交换表
    re.IGNORECASE,
)

# 识别 IEL 卸数格式的 query="..." 内嵌 SQL
_IEL_QUERY_PATTERN = re.compile(
    r'query\s*=\s*"([^"]+)"',
    re.IGNORECASE,
)


@dataclass
class DMLStatement:
    """解析出的单条 DML 语句"""

    op_type: str = ""  # insert / merge / update / ctas
    target_table: str = ""  # 目标表（变量替换后）
    target_columns: list[str] = field(default_factory=list)  # 目标字段
    source_tables: list[str] = field(default_factory=list)  # 源表列表
    select_clause: str = ""  # SELECT 子句
    from_clause: str = ""  # FROM 子句
    raw_sql: str = ""  # 原始 SQL
    file_path: str = ""  # 来源文件
    start_line: int = 0  # 起始行号


class DMLParser:
    """数仓 DML 解析器

    从 .sql DML 文件中提取表级血缘和字段级映射。
    核心逻辑：识别 INSERT INTO ... SELECT FROM 模式，提取目标表和源表。

    用法:
        resolver = SchemaResolver()
        temp_filter = TempTableFilter()
        parser = DMLParser(resolver, temp_filter, tables_dict)
        output = parser.parse_file(Path("idl_abss_base_asset_info.sql"))
    """

    def __init__(
        self,
        schema_resolver: SchemaResolver,
        temp_filter: TempTableFilter,
        tables: dict[str, TableInfo] | None = None,
    ):
        self._resolver = schema_resolver
        self._temp_filter = temp_filter
        self._tables = tables or {}

    def parse_file(self, file_path: Path) -> ParseOutput:
        """解析单个 DML 文件

        Args:
            file_path: .sql DML 文件路径

        Returns:
            ParseOutput 统一产出
        """
        try:
            with open(file_path, encoding="utf-8", errors="ignore") as f:
                content = f.read()
        except OSError as e:
            logger.error("读取文件失败: %s - %s", file_path, e)
            return ParseOutput(errors=[f"文件 {file_path.name}: {str(e)}"])

        if not content.strip():
            return ParseOutput()

        # 从路径推断 schema 层级
        inferred_layer = self._resolver.infer_schema_from_path(str(file_path))

        # 替换 schema 变量
        resolved_content = self._resolver.replace_schema_vars(content)

        # 简化 SQL：去掉 PARTITION FOR 子句中的复杂表达式
        # 使用括号计数法精确匹配 PARTITION FOR (....) 结构
        resolved_content = self._simplify_partition_for(resolved_content)

        # 提取所有 DML 语句
        statements = self._extract_all_statements(resolved_content, str(file_path))

        if not statements:
            return ParseOutput()

        # 构建 ProcedureInfo
        proc_name = file_path.stem.upper()
        proc_info = self._build_procedure_info(statements, proc_name, inferred_layer, str(file_path))

        # 转换为 ParseOutput
        return self._proc_info_to_output(proc_info)

    def parse_directory(self, dir_path: Path) -> ParseOutput:
        """递归解析目录下所有 .sql DML 文件"""
        output = ParseOutput()

        if not dir_path.exists() or not dir_path.is_dir():
            output.errors.append(f"目录不存在: {dir_path}")
            return output

        # ★ 优化：收集所有文件后并行解析
        sql_files = sorted(f for f in dir_path.rglob("*.sql") if f.suffix.lower() == ".sql")
        if not sql_files:
            return output

        from concurrent.futures import ThreadPoolExecutor, as_completed

        with ThreadPoolExecutor(max_workers=4) as executor:
            futures = {executor.submit(self.parse_file, fp): fp for fp in sql_files}
            for future in as_completed(futures):
                fp = futures[future]
                try:
                    file_output = future.result()
                    output.merge(file_output)
                except Exception as e:
                    logger.error("解析 DML 文件失败: %s - %s", fp, e)
                    output.errors.append(f"文件 {fp.name}: {str(e)}")

        logger.info(
            "DMLParser: 解析目录 %s, %d 个文件, %d 条血缘",
            dir_path,
            len(sql_files),
            len(output.table_lineages),
        )
        return output

    def _extract_all_statements(self, content: str, file_path: str) -> list[DMLStatement]:
        """从内容中提取所有 DML 语句"""
        statements: list[DMLStatement] = []

        # 1. 提取 INSERT INTO ... SELECT FROM 语句
        for match in _INSERT_TARGET_PATTERN.finditer(content):
            stmt = self._parse_insert_statement(match, content, file_path)
            if stmt:
                statements.append(stmt)

        # 2. 提取 Oracle INSERT ALL ... INTO ... SELECT FROM 语句
        for match in _INSERT_ALL_PATTERN.finditer(content):
            statements.extend(self._parse_insert_all_statement(match, content, file_path))

        # 3. 提取 MERGE INTO ... USING 语句
        for match in _MERGE_INTO_PATTERN.finditer(content):
            stmt = self._parse_merge_statement(match, file_path)
            if stmt:
                statements.append(stmt)

        # 4. 提取 UPDATE ... SET 语句
        for match in _UPDATE_PATTERN.finditer(content):
            stmt = self._parse_update_statement(match, file_path)
            if stmt:
                statements.append(stmt)

        # 5. 提取 CTAS (CREATE TABLE AS SELECT)
        for match in _CTAS_PATTERN.finditer(content):
            stmt = self._parse_ctas_statement(match, content, file_path)
            if stmt:
                statements.append(stmt)

        # 6. 提取 EXCHANGE PARTITION（作为血缘关系）
        for match in _EXCHANGE_PARTITION_PATTERN.finditer(content):
            stmt = self._parse_exchange_statement(match, file_path)
            if stmt:
                statements.append(stmt)

        return statements

    def _parse_insert_statement(self, match: re.Match, content: str, file_path: str) -> DMLStatement | None:
        """解析 INSERT INTO ... SELECT FROM 语句"""
        target_raw = match.group(1).strip()
        columns_raw = match.group(2).strip()

        target_resolved = self._resolver.resolve_table_name(target_raw)
        if target_resolved is None:
            return None

        target_table = self._resolve_insert_target_table(target_resolved.full_name)
        if not target_table:
            return None

        # 解析目标字段
        target_columns = self._parse_column_list(columns_raw)

        # 提取 SELECT 字段列表和 FROM 子句。
        # 使用从 match 结束位置到分号之间的文本作为 SELECT 语句主体。
        statement_body = self._extract_from_clause(content, match.end())
        select_clause, from_clause = self._split_select_body(statement_body)

        source_tables = self._extract_source_tables(from_clause)

        # 计算行号
        start_line = content[: match.start()].count("\n") + 1

        return DMLStatement(
            op_type="insert",
            target_table=target_table,
            target_columns=target_columns,
            source_tables=source_tables,
            select_clause=select_clause,
            from_clause=from_clause,
            raw_sql=match.group(0),
            file_path=file_path,
            start_line=start_line,
        )

    def _parse_insert_all_statement(self, match: re.Match, content: str, file_path: str) -> list[DMLStatement]:
        """解析 Oracle INSERT ALL ... INTO ... SELECT ... 语句。"""
        statement_text = self._extract_sql_statement(content, match.start())
        body_start = match.end() - match.start()
        body = statement_text[body_start:]
        select_pos = self._find_top_level_keyword(body, "SELECT")
        if select_pos < 0:
            return []

        into_clause = body[:select_pos]
        select_body = body[select_pos + len("SELECT") :]
        select_clause, from_clause = self._split_select_body(select_body)
        if not from_clause:
            return []

        source_tables = self._extract_source_tables(from_clause)
        start_line = content[: match.start()].count("\n") + 1
        statements: list[DMLStatement] = []
        seen_targets: set[tuple[str, tuple[str, ...]]] = set()

        for into_match in _INSERT_ALL_INTO_PATTERN.finditer(into_clause):
            target_raw = into_match.group(1).strip()
            columns_raw = into_match.group(2).strip()
            target_resolved = self._resolver.resolve_table_name(target_raw)
            if target_resolved is None:
                continue

            target_table = self._resolve_insert_target_table(target_resolved.full_name)
            if not target_table:
                continue

            target_columns = self._parse_column_list(columns_raw)
            target_key = (target_table, tuple(target_columns))
            if target_key in seen_targets:
                continue
            seen_targets.add(target_key)

            statements.append(
                DMLStatement(
                    op_type="insert_all",
                    target_table=target_table,
                    target_columns=target_columns,
                    source_tables=source_tables,
                    select_clause=select_clause,
                    from_clause=from_clause,
                    raw_sql=statement_text,
                    file_path=file_path,
                    start_line=start_line,
                )
            )

        return statements

    def _resolve_insert_target_table(self, target_table: str) -> str:
        """将 INSERT 目标规范到正式表；无法证明正式表存在的临时表仍过滤。"""
        if self._temp_filter.is_exchange_table(target_table):
            formal_table = self._temp_filter.resolve_exchange_table(target_table)
            logger.debug("INSERT 目标为交换表，映射为正式表: %s → %s", target_table, formal_table)
            return formal_table

        if not self._temp_filter.is_temp_table(target_table):
            return target_table

        formal_table = self._resolve_formal_table_for_operational_table(target_table)
        if formal_table:
            logger.debug("INSERT 目标为操作临时表，映射为正式表: %s → %s", target_table, formal_table)
            return formal_table

        return ""

    def _resolve_formal_table_for_operational_table(self, table_name: str) -> str:
        """根据已解析 DDL 表结构，将 xxx_job_tm/cl/op 等操作表折叠到正式表。"""
        if not self._tables:
            return ""

        table_upper = table_name.upper()
        schema = table_upper.rsplit(".", 1)[0] if "." in table_upper else ""
        short = table_upper.rsplit(".", 1)[-1]
        candidates: list[tuple[int, str]] = []

        for full_name, table_info in self._tables.items():
            formal_full = getattr(table_info, "full_name", "") or full_name
            formal_upper = formal_full.upper()
            formal_schema = formal_upper.rsplit(".", 1)[0] if "." in formal_upper else ""
            if schema and formal_schema and schema != formal_schema:
                continue

            formal_short = (getattr(table_info, "table_name", "") or formal_upper.rsplit(".", 1)[-1]).upper()
            if not formal_short or not short.startswith(f"{formal_short}_"):
                continue

            suffix = short[len(formal_short) + 1 :]
            if self._looks_like_operational_suffix(suffix):
                candidates.append((len(formal_short), formal_upper))

        if not candidates:
            return ""

        candidates.sort(reverse=True)
        return candidates[0][1]

    @staticmethod
    def _looks_like_operational_suffix(suffix: str) -> bool:
        if not suffix:
            return False

        parts = [part for part in suffix.upper().split("_") if part]
        if not parts:
            return False

        operational_tail = {"TM", "TMP", "TEMP", "OP", "CL", "BK", "OLD", "NEW"}
        if parts[-1] in operational_tail:
            return True

        return bool(re.fullmatch(r"EX\d*", parts[-1]))

    def _parse_merge_statement(self, match: re.Match, file_path: str) -> DMLStatement | None:
        """解析 MERGE INTO ... USING 语句"""
        target_raw = match.group(1).strip()
        source_raw = match.group(2).strip().split()[0]  # 取第一个词（去掉别名）

        target_resolved = self._resolver.resolve_table_name(target_raw)
        source_resolved = self._resolver.resolve_table_name(source_raw)

        if target_resolved is None:
            return None

        source_tables = []
        if source_resolved and not self._temp_filter.is_temp_table(source_resolved.full_name):
            source_tables.append(source_resolved.full_name)

        return DMLStatement(
            op_type="merge",
            target_table=target_resolved.full_name,
            source_tables=source_tables,
            raw_sql=match.group(0),
            file_path=file_path,
        )

    def _parse_update_statement(self, match: re.Match, file_path: str) -> DMLStatement | None:
        """解析 UPDATE ... SET 语句"""
        target_raw = match.group(1).strip()
        target_resolved = self._resolver.resolve_table_name(target_raw)

        if target_resolved is None:
            return None

        if self._temp_filter.is_temp_table(target_resolved.full_name):
            return None

        return DMLStatement(
            op_type="update",
            target_table=target_resolved.full_name,
            source_tables=[],  # UPDATE 的源表需要从 FROM 子句提取
            raw_sql=match.group(0),
            file_path=file_path,
        )

    def _parse_ctas_statement(self, match: re.Match, content: str, file_path: str) -> DMLStatement | None:
        """Parse a CREATE TABLE AS SELECT statement.

        Uses token-aware scanning to find the FROM keyword, avoiding false
        matches inside string literals, comments, or nested subqueries.
        """
        target_raw = match.group(1).strip()
        target_resolved = self._resolver.resolve_table_name(target_raw)

        if target_resolved is None:
            return None

        if self._temp_filter.is_temp_table(target_resolved.full_name):
            return None

        # Extract the rest of the statement after AS keyword using token-aware scan.
        # Find the semicolon (or end of content) to bound the statement.
        as_end = match.end()
        remaining = content[as_end:]
        semi_pos = self._find_top_level_semicolon(remaining)
        if semi_pos >= 0:
            select_body = remaining[:semi_pos]
        else:
            select_body = remaining

        # Use token-aware FROM search. Reuse _split_select_body so the FROM
        # keyword is retained in from_clause — _extract_source_tables relies on
        # the FROM/JOIN prefix to match table references.
        select_clause, from_clause = self._split_select_body(select_body)
        if not from_clause:
            return None

        source_tables = self._extract_source_tables(from_clause)

        return DMLStatement(
            op_type="ctas",
            target_table=target_resolved.full_name,
            source_tables=source_tables,
            select_clause=select_clause,
            from_clause=from_clause,
            raw_sql=match.group(0) + select_body,
            file_path=file_path,
        )

    def _parse_exchange_statement(self, match: re.Match, file_path: str) -> DMLStatement | None:
        """解析 ALTER TABLE ... EXCHANGE PARTITION ... WITH TABLE 语句

        分区交换意味着交换表的数据会进入目标表，形成血缘关系。
        交换表 → 目标表
        """
        target_raw = match.group(1).strip()
        source_raw = match.group(2).strip()

        target_resolved = self._resolver.resolve_table_name(target_raw)
        source_resolved = self._resolver.resolve_table_name(source_raw)

        if target_resolved is None or source_resolved is None:
            return None

        source_table = source_resolved.full_name
        if self._temp_filter.is_temp_table(source_table):
            return None

        if self._temp_filter.is_exchange_table(source_table):
            source_table = self._temp_filter.resolve_exchange_table(source_table)
            logger.debug(
                "EXCHANGE 源为交换表，映射为正式表: %s → %s",
                source_resolved.full_name,
                source_table,
            )

        if source_table == target_resolved.full_name:
            return None

        return DMLStatement(
            op_type="exchange_partition",
            target_table=target_resolved.full_name,
            source_tables=[source_table],
            raw_sql=match.group(0),
            file_path=file_path,
        )

    def _extract_from_clause(self, content: str, start_pos: int) -> str:
        """Extract the full FROM clause (up to semicolon or next DDL/DML keyword).

        Uses token-aware scanning to avoid matching keywords inside string
        literals, comments, or nested sub-queries.
        """
        end_keywords = [
            ";",
            "UNION",
            "EXCEPT",
            "INTERSECT",
            "CREATE TABLE",
            "ALTER TABLE",
            "DROP TABLE",
            "GRANT ",
            "COMMENT ON",
            "EXEC ",
            "COMMIT;",
        ]

        search_text = content[start_pos:]
        end_pos = len(search_text)

        for kw in end_keywords:
            if kw == ";":
                # Semicolon is not a keyword; use plain find but skip quoted ones
                idx = self._find_top_level_semicolon(search_text)
            else:
                idx = self._find_top_level_keyword(search_text, kw)
            if idx != -1 and idx < end_pos:
                end_pos = idx

        return search_text[:end_pos].strip()

    @staticmethod
    def _extract_sql_statement(content: str, start_pos: int) -> str:
        """从指定位置提取到下一个分号的 SQL 语句。"""
        search_text = content[start_pos:]
        end_pos = search_text.find(";")
        if end_pos < 0:
            return search_text.strip()
        return search_text[:end_pos].strip()

    def _split_select_body(self, statement_body: str) -> tuple[str, str]:
        """将 INSERT 的 SELECT 主体拆成 select 列表和 FROM 子句。"""
        from_pos = self._find_top_level_keyword(statement_body, "FROM")
        if from_pos < 0:
            return statement_body.strip(), ""
        return statement_body[:from_pos].strip(), statement_body[from_pos:].strip()

    @staticmethod
    def _find_top_level_semicolon(sql: str) -> int:
        """Find the position of the first top-level semicolon.

        Skips semicolons inside string literals and comments.
        """
        in_single_quote = False
        in_double_quote = False
        in_line_comment = False
        in_block_comment = False
        i = 0

        while i < len(sql):
            ch = sql[i]
            next_ch = sql[i + 1] if i + 1 < len(sql) else ""

            if in_line_comment:
                if ch == "\n":
                    in_line_comment = False
                i += 1
                continue

            if in_block_comment:
                if ch == "*" and next_ch == "/":
                    in_block_comment = False
                    i += 2
                else:
                    i += 1
                continue

            if not in_single_quote and not in_double_quote:
                if ch == "-" and next_ch == "-":
                    in_line_comment = True
                    i += 2
                    continue
                if ch == "/" and next_ch == "*":
                    in_block_comment = True
                    i += 2
                    continue

            if ch == "'" and not in_double_quote:
                if next_ch == "'":
                    i += 2
                    continue
                in_single_quote = not in_single_quote
                i += 1
                continue

            if ch == '"' and not in_single_quote:
                in_double_quote = not in_double_quote
                i += 1
                continue

            if not in_single_quote and not in_double_quote and ch == ";":
                return i

            i += 1

        return -1

    @staticmethod
    def _find_top_level_keyword(sql: str, keyword: str) -> int:
        """查找不在括号、字符串或注释中的顶层关键字位置。"""
        keyword_upper = keyword.upper()
        in_single_quote = False
        in_double_quote = False
        in_line_comment = False
        in_block_comment = False
        depth = 0
        i = 0

        while i < len(sql):
            ch = sql[i]
            next_ch = sql[i + 1] if i + 1 < len(sql) else ""

            if in_line_comment:
                if ch == "\n":
                    in_line_comment = False
                i += 1
                continue

            if in_block_comment:
                if ch == "*" and next_ch == "/":
                    in_block_comment = False
                    i += 2
                else:
                    i += 1
                continue

            if not in_single_quote and not in_double_quote:
                if ch == "-" and next_ch == "-":
                    in_line_comment = True
                    i += 2
                    continue
                if ch == "/" and next_ch == "*":
                    in_block_comment = True
                    i += 2
                    continue

            if ch == "'" and not in_double_quote:
                if next_ch == "'":
                    i += 2
                    continue
                in_single_quote = not in_single_quote
                i += 1
                continue

            if ch == '"' and not in_single_quote:
                in_double_quote = not in_double_quote
                i += 1
                continue

            if not in_single_quote and not in_double_quote:
                if ch == "(":
                    depth += 1
                elif ch == ")":
                    depth = max(depth - 1, 0)
                elif depth == 0 and sql[i : i + len(keyword)].upper() == keyword_upper:
                    before = sql[i - 1] if i > 0 else " "
                    after = sql[i + len(keyword)] if i + len(keyword) < len(sql) else " "
                    if not (before.isalnum() or before == "_") and not (after.isalnum() or after == "_"):
                        return i

            i += 1

        return -1

    def _extract_source_tables(self, from_clause: str) -> list[str]:
        """从 FROM 子句中提取源表列表"""
        tables: list[str] = []
        seen: set[str] = set()

        for table_raw, _alias_raw in self._iter_table_references(from_clause):
            if self._is_valid_table_name(table_raw):
                resolved = self._resolver.resolve_table_name(table_raw)
                if resolved and resolved.full_name and resolved.full_name not in seen:
                    if not self._temp_filter.is_temp_table(resolved.full_name):
                        seen.add(resolved.full_name)
                        tables.append(resolved.full_name)

        return tables

    def _iter_table_references(self, from_clause: str) -> list[tuple[str, str]]:
        """提取 FROM/JOIN 中真实表引用，逗号表仅限 FROM 顶层项。"""
        clean_clause = self._strip_sql_comments(from_clause)
        references: list[tuple[str, str]] = []

        for match in _FROM_TABLE_PATTERN.finditer(clean_clause):
            table_raw = match.group(1).strip()
            alias_raw = match.group(2).strip() if match.lastindex and match.group(2) else ""
            references.append((table_raw, alias_raw))

        for match in _FROM_KEYWORD_PATTERN.finditer(clean_clause):
            references.extend(self._extract_comma_table_references(clean_clause, match.end()))

        return references

    def _extract_comma_table_references(self, sql: str, from_pos: int) -> list[tuple[str, str]]:
        """解析 FROM 后逗号分隔的并列表，不扫描 SELECT 列表逗号。"""
        references: list[tuple[str, str]] = []
        _first_table, _first_alias, pos = self._read_table_factor(sql, from_pos)

        while pos < len(sql):
            pos = self._skip_whitespace(sql, pos)
            if pos >= len(sql) or sql[pos] != ",":
                break

            table_raw, alias_raw, next_pos = self._read_table_factor(sql, pos + 1)
            if next_pos <= pos:
                break

            if table_raw:
                references.append((table_raw, alias_raw))

            pos = next_pos

        return references

    def _read_table_factor(self, sql: str, pos: int) -> tuple[str, str, int]:
        """读取一个 FROM 项；子查询返回空表名但会跳过别名。"""
        pos = self._skip_whitespace(sql, pos)
        if pos >= len(sql):
            return "", "", pos

        if sql[pos] == "(":
            close_pos = self._find_matching_paren(sql, pos)
            if close_pos < 0:
                return "", "", len(sql)

            alias_raw, next_pos = self._read_optional_alias(sql, close_pos + 1)
            return "", alias_raw, next_pos

        match = _TABLE_REF_AT_PATTERN.match(sql, pos)
        if not match:
            return "", "", pos

        table_raw = match.group(0).strip()
        alias_raw, next_pos = self._read_optional_alias(sql, match.end())
        return table_raw, alias_raw, next_pos

    def _read_optional_alias(self, sql: str, pos: int) -> tuple[str, int]:
        """读取表别名；遇到 SQL 关键字时不消费，避免吞掉 WHERE/JOIN。"""
        start_pos = pos
        pos = self._skip_whitespace(sql, pos)

        word, word_end = self._read_identifier(sql, pos)
        if not word:
            return "", start_pos

        if word.upper() == "AS":
            alias_pos = self._skip_whitespace(sql, word_end)
            alias, alias_end = self._read_identifier(sql, alias_pos)
            if alias and self._is_valid_alias(alias):
                return alias, alias_end
            return "", start_pos

        if self._is_valid_alias(word):
            return word, word_end

        return "", start_pos

    @staticmethod
    def _read_identifier(sql: str, pos: int) -> tuple[str, int]:
        match = _SQL_IDENTIFIER_AT_PATTERN.match(sql, pos)
        if not match:
            return "", pos
        return match.group(0), match.end()

    @staticmethod
    def _skip_whitespace(sql: str, pos: int) -> int:
        while pos < len(sql) and sql[pos].isspace():
            pos += 1
        return pos

    @staticmethod
    def _find_matching_paren(sql: str, open_pos: int) -> int:
        depth = 0
        in_single_quote = False
        in_double_quote = False
        i = open_pos

        while i < len(sql):
            ch = sql[i]
            next_ch = sql[i + 1] if i + 1 < len(sql) else ""

            if ch == "'" and not in_double_quote:
                if next_ch == "'":
                    i += 2
                    continue
                in_single_quote = not in_single_quote
                i += 1
                continue

            if ch == '"' and not in_single_quote:
                in_double_quote = not in_double_quote
                i += 1
                continue

            if not in_single_quote and not in_double_quote:
                if ch == "(":
                    depth += 1
                elif ch == ")":
                    depth -= 1
                    if depth == 0:
                        return i

            i += 1

        return -1

    @staticmethod
    def _strip_sql_comments(sql: str) -> str:
        """移除 SQL 注释，保留字符串内容和换行边界。

        委托到 core.utils.sql_comment_stripper.strip_sql_comments，
        避免各解析器重复实现（CodeReview D-07）。
        """
        return strip_sql_comments(sql)

    def _is_valid_table_name(self, name: str) -> bool:
        """判断名称是否为有效的表名（排除函数、关键字、常量等）

        过滤规则：
          - 长度 >= 3（排除 '0', '1' 等常量）
          - 不含非 ASCII 字符（排除 SQL 注释泄漏的中文/全角字符）
          - 不以数字开头（排除 '0', '123' 等）
          - 不在已知函数/关键字列表中（NVL, TO_DATE, TO_TIMESTAMP, DUAL 等）

        防御性说明：
          合法的 Oracle / 数仓表名仅含 ASCII 字符（字母、数字、_ $ # .），
          任何含中文/CJK/全角字符的"表名"均来自 SQL 注释或文本泄漏
          （如 "--个人客户,对私担保客户" 被误捕获），一律拒绝。

        schema 前缀判断使用 ``self._resolver.known_schema_prefixes()``，
        以支持 ``SchemaResolver(custom_mapping=...)`` 自定义 schema。
        """
        if not name or len(name) < 3:
            return False

        # 防御性非 ASCII 过滤：拒绝任何含中文/CJK/全角字符的"表名"
        # 合法表名仅含 ASCII，含非 ASCII 即为注释/文本泄漏
        if not name.isascii():
            return False

        # 去掉 schema 前缀后检查短名
        short = name.split(".")[-1] if "." in name else name

        # 长度检查
        if len(short) < 3:
            return False

        # 数字开头的不是表名
        if short[0].isdigit():
            return False

        if short.upper() in _SQL_KEYWORDS:
            return False

        # --- SQL 别名过滤 ---
        # 拒绝无 schema 前缀且看起来像 SQL 别名的短名称（如 UNIT, KHNF, BU_NO）
        if "." not in name and len(name) <= 5:
            upper = name.upper()
            if not (upper.endswith(("TMP", "_TMP", "TEMP", "_TEMP")) or upper.startswith("TMP_")):
                return False

        # 拒绝 alias.column 格式（如 T1.ORG_LEVEL, T3.OPEN_ACCT_ORG_ID）
        if "." in name:
            prefix = name.split(".")[0].upper()
            known_prefixes = self._resolver.known_schema_prefixes()
            if prefix in known_prefixes or prefix.startswith("$"):
                return True
            if len(prefix) <= 3:
                return False

        return True

    @staticmethod
    def _is_valid_alias(alias: str) -> bool:
        if not alias:
            return False
        upper = alias.upper()
        return upper not in _SQL_KEYWORDS

    def _parse_column_list(self, columns_raw: str) -> list[str]:
        """解析目标字段列表

        处理格式: "col1 -- 注释, col2 -- 注释, col3"

        注意：必须先剥离整段注释再按逗号拆分，否则注释中的逗号
        （如 "--产品分类(易贷,字节)"）会被误判为列分隔符，导致
        "字节)" 被提取为列名。
        """
        # 先剥离 SQL 注释（含 -- 行注释和 /* */ 块注释），避免注释内逗号污染拆分
        cleaned = self._strip_sql_comments(columns_raw)
        columns = []
        for col in cleaned.split(","):
            col = col.strip()
            col = col.strip('"').strip("'").strip()
            if col:
                columns.append(col.upper())
        return columns

    def _build_procedure_info(
        self,
        statements: list[DMLStatement],
        proc_name: str,
        schema: str,
        file_path: str,
    ) -> ProcedureInfo:
        """从 DML 语句列表构建 ProcedureInfo"""
        source_tables: list[str] = []
        target_tables: list[str] = []
        table_lineages: list[TableLineage] = []
        field_mappings: list[FieldMapping] = []

        seen_source: set[str] = set()
        seen_target: set[str] = set()

        for stmt in statements:
            # 收集源表和目标表
            if stmt.target_table and stmt.target_table not in seen_target:
                seen_target.add(stmt.target_table)
                target_tables.append(stmt.target_table)

            for src in stmt.source_tables:
                if src not in seen_source:
                    seen_source.add(src)
                    source_tables.append(src)

                # 构建表级血缘
                tl_key = (src, stmt.target_table)
                if tl_key not in {(tl.source_table, tl.target_table) for tl in table_lineages}:
                    table_lineages.append(
                        TableLineage(
                            source_table=src,
                            target_table=stmt.target_table,
                            procedure=proc_name,
                        )
                    )

            field_mappings.extend(self._build_field_mappings_for_statement(stmt, proc_name))

        return ProcedureInfo(
            schema=schema,
            proc_name=proc_name,
            full_name=f"{schema}.{proc_name}" if schema else proc_name,
            source_tables=source_tables,
            target_tables=target_tables,
            table_lineages=table_lineages,
            field_mappings=field_mappings,
            file_path=file_path,
        )

    def _build_field_mappings_for_statement(self, stmt: DMLStatement, proc_name: str) -> list[FieldMapping]:
        """基于 INSERT 目标字段和 SELECT 表达式的位置关系构建字段映射。"""
        if not stmt.target_columns:
            return []

        if stmt.select_clause:
            return self._build_positional_insert_mappings(stmt, proc_name)

        # 无 SELECT 列表时保留原有低置信度单源同名兜底。
        if len(stmt.source_tables) != 1:
            return []

        src = stmt.source_tables[0]
        return [
            FieldMapping(
                source_table=src,
                source_column=col,
                target_table=stmt.target_table,
                target_column=col,
                procedure=proc_name,
                confidence=0.5,
            )
            for col in stmt.target_columns
        ]

    def _build_positional_insert_mappings(self, stmt: DMLStatement, proc_name: str) -> list[FieldMapping]:
        mappings: list[FieldMapping] = []
        alias_map = self._extract_alias_map(stmt.from_clause)
        select_infos = FieldCleaner.parse_select_columns(stmt.select_clause)

        for idx, target_col in enumerate(stmt.target_columns):
            if idx >= len(select_infos):
                continue

            src_info = select_infos[idx]
            source_column = src_info.get("column", "").upper()
            source_table = self._resolve_source_table_for_select_expr(
                src_info.get("table", ""),
                source_column,
                alias_map,
                stmt.source_tables,
            )

            if not source_table or not source_column:
                continue

            mappings.append(
                FieldMapping(
                    source_table=source_table,
                    source_column=source_column,
                    target_table=stmt.target_table,
                    target_column=target_col,
                    transform_logic=src_info.get("transform", ""),
                    procedure=proc_name,
                    confidence=src_info.get("confidence", 0.5),
                )
            )

        return mappings

    def _extract_alias_map(self, from_clause: str) -> dict[str, str]:
        """从 FROM/JOIN 子句中提取 alias -> table 映射。"""
        alias_map: dict[str, str] = {}

        for table_raw, alias_raw in self._iter_table_references(from_clause):
            resolved = self._resolver.resolve_table_name(table_raw)
            if not resolved or not resolved.full_name:
                continue

            if alias_raw and self._is_valid_alias(alias_raw):
                alias_map[alias_raw.upper()] = resolved.full_name

        alias_map.update(self._extract_subquery_alias_map(from_clause))
        return alias_map

    def _extract_subquery_alias_map(self, from_clause: str) -> dict[str, str]:
        """解析 FROM/JOIN 子查询别名；仅单一真实来源表时建立映射。"""
        clean_clause = self._strip_sql_comments(from_clause)
        alias_map: dict[str, str] = {}
        pattern = re.compile(r"\b(?:FROM|JOIN)\s*\(", re.IGNORECASE)
        pos = 0

        while True:
            match = pattern.search(clean_clause, pos)
            if not match:
                break

            open_pos = clean_clause.find("(", match.start())
            if open_pos < 0:
                break

            close_pos = self._find_matching_paren(clean_clause, open_pos)
            if close_pos < 0:
                break

            alias_raw, next_pos = self._read_optional_alias(clean_clause, close_pos + 1)
            if alias_raw and self._is_valid_alias(alias_raw):
                inner_sql = clean_clause[open_pos + 1 : close_pos]
                sources = self._extract_source_tables(inner_sql)
                if len(sources) == 1:
                    alias_map[alias_raw.upper()] = sources[0]

            pos = max(next_pos, close_pos + 1)

        return alias_map

    def _resolve_source_table_for_select_expr(
        self,
        source_table_ref: str,
        source_column: str,
        alias_map: dict[str, str],
        source_tables: list[str],
    ) -> str:
        """将 SELECT 表达式中的表引用解析为真实表名。"""
        if source_table_ref:
            table_ref = source_table_ref.upper()
            if table_ref in alias_map:
                return alias_map[table_ref]

            if "." not in table_ref:
                return ""

            resolved = self._resolver.resolve_table_name(table_ref)
            if resolved and resolved.full_name:
                return resolved.full_name

            return ""

        if source_column and len(source_tables) == 1:
            return source_tables[0]

        return ""

    def _proc_info_to_output(self, proc_info: ProcedureInfo) -> ParseOutput:
        """将 ProcedureInfo 转换为 ParseOutput"""
        output = ParseOutput()

        # 过滤临时表的血缘和映射
        filtered_lineages = self._temp_filter.filter_table_lineages(
            [
                {
                    "source_table": tl.source_table,
                    "target_table": tl.target_table,
                    "procedure": tl.procedure,
                }
                for tl in proc_info.table_lineages
            ]
        )
        filtered_mappings = self._temp_filter.filter_field_mappings(
            [
                {
                    "source_table": fm.source_table,
                    "source_column": fm.source_column,
                    "target_table": fm.target_table,
                    "target_column": fm.target_column,
                    "transform_logic": fm.transform_logic,
                    "procedure": fm.procedure,
                    "confidence": fm.confidence,
                }
                for fm in proc_info.field_mappings
            ]
        )

        # 仅当有有效血缘时才输出 ProcedureInfo
        if filtered_lineages or filtered_mappings:
            output.procedures.append(
                {
                    "full_name": proc_info.full_name,
                    "schema": proc_info.schema,
                    "proc_name": proc_info.proc_name,
                    "description": proc_info.description,
                    "source_tables": [t for t in proc_info.source_tables if not self._temp_filter.is_temp_table(t)],
                    "target_tables": [t for t in proc_info.target_tables if not self._temp_filter.is_temp_table(t)],
                }
            )

        output.table_lineages = filtered_lineages
        output.field_mappings = filtered_mappings

        return output

    @staticmethod
    def _simplify_partition_for(content: str) -> str:
        """简化 PARTITION FOR (复杂表达式) 为 PARTITION FOR (...)

        使用括号计数法精确匹配 PARTITION FOR 后的括号对，
        避免非贪婪正则在嵌套函数调用时截断过早。
        """
        result = []
        i = 0
        upper = content.upper()

        while i < len(content):
            # 检测 PARTITION FOR 关键字
            if upper[i : i + 13] == "PARTITION FOR":
                # 找到紧跟的 (
                j = i + 13
                while j < len(content) and content[j] != "(":
                    j += 1

                if j < len(content) and content[j] == "(":
                    # 用括号计数法找到匹配的 )
                    depth = 1
                    k = j + 1
                    while k < len(content) and depth > 0:
                        if content[k] == "(":
                            depth += 1
                        elif content[k] == ")":
                            depth -= 1
                        k += 1

                    # 替换为简化版本
                    result.append("PARTITION FOR (...)")
                    i = k
                    continue

            result.append(content[i])
            i += 1

        return "".join(result)
