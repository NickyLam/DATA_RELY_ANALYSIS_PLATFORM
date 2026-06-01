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

from core.models import FieldMapping, ProcedureInfo, TableLineage
from core.warehouse.schema_resolver import SchemaResolver
from core.warehouse.temp_table_filter import TempTableFilter

logger = logging.getLogger(__name__)

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

# FROM 子句中的表引用（简化版）
_FROM_TABLE_PATTERN = re.compile(
    r"(?:FROM|JOIN)\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"  # 表名
    r"(?:\s+\w+)?",  # 可选别名
    re.IGNORECASE,
)

# 逗号分隔的表引用
_COMMA_TABLE_PATTERN = re.compile(
    r",\s*"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"  # 表名
    r"(?:\s+\w+)?",  # 可选别名
    re.IGNORECASE,
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
_CTAS_PATTERN = re.compile(
    r"CREATE\s+TABLE\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"  # 目标表
    r"\s+(?:NOLOGGING\s+)?"
    r"(?:COMPRESS\s+\$\{[\w_]+\}\s+FOR\s+QUERY\s+HIGH\s+)?"
    r"AS\s+SELECT\s+(.*?)"
    r"\bFROM\b\s+(.*?)",
    re.IGNORECASE | re.DOTALL,
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

# FROM 子句中的表引用（简化版）
_FROM_TABLE_PATTERN = re.compile(
    r"(?:FROM|JOIN)\s+"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"  # 表名
    r"(?:\s+\w+)?",  # 可选别名
    re.IGNORECASE,
)

# 逗号分隔的表引用
_COMMA_TABLE_PATTERN = re.compile(
    r",\s*"
    r"(\$\{[\w_]+\}\.\w+|[\w.]+)"  # 表名
    r"(?:\s+\w+)?",  # 可选别名
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
        from core.parser_protocol import ParseOutput

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
        from core.parser_protocol import ParseOutput

        output = ParseOutput()

        if not dir_path.exists() or not dir_path.is_dir():
            output.errors.append(f"目录不存在: {dir_path}")
            return output

        # ★ 优化：收集所有文件后并行解析
        sql_files = sorted(f for f in dir_path.rglob("*.sql") if f.suffix.lower() == ".sql")
        if not sql_files:
            return output

        from concurrent.futures import ThreadPoolExecutor

        with ThreadPoolExecutor(max_workers=4) as executor:
            futures = {executor.submit(self.parse_file, fp): fp for fp in sql_files}
            for future in futures:
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

        # 2. 提取 MERGE INTO ... USING 语句
        for match in _MERGE_INTO_PATTERN.finditer(content):
            stmt = self._parse_merge_statement(match, file_path)
            if stmt:
                statements.append(stmt)

        # 3. 提取 UPDATE ... SET 语句
        for match in _UPDATE_PATTERN.finditer(content):
            stmt = self._parse_update_statement(match, file_path)
            if stmt:
                statements.append(stmt)

        # 4. 提取 CTAS (CREATE TABLE AS SELECT)
        for match in _CTAS_PATTERN.finditer(content):
            stmt = self._parse_ctas_statement(match, file_path)
            if stmt:
                statements.append(stmt)

        # 5. 提取 EXCHANGE PARTITION（作为血缘关系）
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

        target_table = target_resolved.full_name

        if self._temp_filter.is_temp_table(target_table):
            return None

        if self._temp_filter.is_exchange_table(target_table):
            target_table = self._temp_filter.resolve_exchange_table(target_table)
            logger.debug(
                "INSERT 目标为交换表，映射为正式表: %s → %s",
                target_resolved.full_name,
                target_table,
            )

        # 解析目标字段
        target_columns = self._parse_column_list(columns_raw)

        # 提取源表：从 INSERT 语句的 SELECT ... FROM 部分提取
        # 使用从 match 结束位置到分号之间的文本作为 FROM 子句
        from_clause = self._extract_from_clause(content, match.end())

        source_tables = self._extract_source_tables(from_clause)

        # 计算行号
        start_line = content[: match.start()].count("\n") + 1

        return DMLStatement(
            op_type="insert",
            target_table=target_table,
            target_columns=target_columns,
            source_tables=source_tables,
            select_clause="",  # 不再单独提取 SELECT 子句
            from_clause=from_clause,
            raw_sql=match.group(0),
            file_path=file_path,
            start_line=start_line,
        )

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

    def _parse_ctas_statement(self, match: re.Match, file_path: str) -> DMLStatement | None:
        """解析 CREATE TABLE AS SELECT 语句"""
        target_raw = match.group(1).strip()
        target_resolved = self._resolver.resolve_table_name(target_raw)

        if target_resolved is None:
            return None

        if self._temp_filter.is_temp_table(target_resolved.full_name):
            return None

        from_clause = match.group(3).strip() if match.group(3) else ""
        source_tables = self._extract_source_tables(from_clause)

        return DMLStatement(
            op_type="ctas",
            target_table=target_resolved.full_name,
            source_tables=source_tables,
            raw_sql=match.group(0),
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

        return DMLStatement(
            op_type="exchange_partition",
            target_table=target_resolved.full_name,
            source_tables=[source_table],
            raw_sql=match.group(0),
            file_path=file_path,
        )

    def _extract_from_clause(self, content: str, start_pos: int) -> str:
        """提取 FROM 子句的完整内容（到分号或下一个 DDL/DML 关键字为止）"""
        # 简化处理：从 start_pos 开始，到下一个分号或 UNION/EXCEPT/INTERSECT 为止
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
            idx = search_text.upper().find(kw.upper())
            if idx != -1 and idx < end_pos:
                end_pos = idx

        return search_text[:end_pos].strip()

    def _extract_source_tables(self, from_clause: str) -> list[str]:
        """从 FROM 子句中提取源表列表"""
        tables: list[str] = []
        seen: set[str] = set()

        # 提取 FROM/JOIN 后的表名
        for match in _FROM_TABLE_PATTERN.finditer(from_clause):
            table_raw = match.group(1).strip()
            if self._is_valid_table_name(table_raw):
                resolved = self._resolver.resolve_table_name(table_raw)
                if resolved and resolved.full_name and resolved.full_name not in seen:
                    if not self._temp_filter.is_temp_table(resolved.full_name):
                        seen.add(resolved.full_name)
                        tables.append(resolved.full_name)

        # 提取逗号分隔的表名
        for match in _COMMA_TABLE_PATTERN.finditer(from_clause):
            table_raw = match.group(1).strip()
            if self._is_valid_table_name(table_raw):
                resolved = self._resolver.resolve_table_name(table_raw)
                if resolved and resolved.full_name and resolved.full_name not in seen:
                    if not self._temp_filter.is_temp_table(resolved.full_name):
                        seen.add(resolved.full_name)
                        tables.append(resolved.full_name)

        return tables

    @staticmethod
    def _is_valid_table_name(name: str) -> bool:
        """判断名称是否为有效的表名（排除函数、关键字、常量等）

        过滤规则：
          - 长度 >= 3（排除 '0', '1' 等常量）
          - 不以数字开头（排除 '0', '123' 等）
          - 不在已知函数/关键字列表中（NVL, TO_DATE, TO_TIMESTAMP, DUAL 等）
        """
        if not name or len(name) < 3:
            return False

        # 去掉 schema 前缀后检查短名
        short = name.split(".")[-1] if "." in name else name

        # 长度检查
        if len(short) < 3:
            return False

        # 数字开头的不是表名
        if short[0].isdigit():
            return False

        # 常见 SQL 函数/关键字黑名单
        _BLACKLIST = {
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
        }

        return short.upper() not in _BLACKLIST

    def _parse_column_list(self, columns_raw: str) -> list[str]:
        """解析目标字段列表

        处理格式: "col1 -- 注释, col2 -- 注释, col3"
        """
        columns = []
        for col in columns_raw.split(","):
            # 去掉行内注释
            col = col.split("--")[0].strip()
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

            # 构建字段级映射（如果目标字段列表可用）
            if stmt.target_columns and stmt.source_tables:
                for col in stmt.target_columns:
                    for src in stmt.source_tables:
                        # 简化：假设字段名在源表中也存在（同名映射）
                        field_mappings.append(
                            FieldMapping(
                                source_table=src,
                                source_column=col,
                                target_table=stmt.target_table,
                                target_column=col,
                                procedure=proc_name,
                                confidence=0.5,  # 中等置信度（同名假设）
                            )
                        )

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

    def _proc_info_to_output(self, proc_info: ProcedureInfo) -> ParseOutput:
        """将 ProcedureInfo 转换为 ParseOutput"""
        from core.parser_protocol import ParseOutput

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
