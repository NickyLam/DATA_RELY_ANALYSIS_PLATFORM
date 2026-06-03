"""
PAM DML 解析器
从 Oracle PL/SQL*Plus 导出格式的单文件中解析多个 CREATE EDITIONABLE procedure，
提取存储过程信息、表级血缘和字段级映射。

文件特征：
  - 单文件包含数百个 CREATE EDITIONABLE procedure 语句
  - 存储过程之间由 `/` 行分隔
  - 使用动态 SQL (execute immediate v_sql) 拼接表名
  - 文件尾部有 ALTER PROCEDURE 编译块（需跳过）
"""

from __future__ import annotations

import logging
import re
from pathlib import Path

from core.parser_protocol import ParseOutput

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# 正则模式
# ---------------------------------------------------------------------------

# CREATE [EDITIONABLE] procedure PROC_NAME
_CREATE_PROC_RE = re.compile(
    r"CREATE\s+(?:EDITIONABLE\s+)?(?:OR\s+REPLACE\s+)?procedure\s+([\w.]+)",
    re.IGNORECASE,
)

# ALTER PROCEDURE 块（跳过）
_ALTER_PROC_RE = re.compile(
    r"^\s*ALTER\s+PROCEDURE\s+",
    re.IGNORECASE | re.MULTILINE,
)

# 变量赋值：v_xxx := 'VALUE' 或 v_xxx varchar2(...) := 'VALUE'
_VAR_ASSIGN_RE = re.compile(
    r"(\w+)\s+(?:varchar2|number|char)\s*\([^)]*\)\s*:=\s*'([^']+)'",
    re.IGNORECASE,
)

# 变量赋值（简单形式）：v_xxx := 'VALUE'
_VAR_SIMPLE_ASSIGN_RE = re.compile(
    r"(\w+)\s*:=\s*'([^']+)'\s*;",
    re.IGNORECASE,
)

# SQL 字符串赋值：v_sql := '...' (跨行，到 '; 结束)
_SQL_ASSIGN_RE = re.compile(
    r"v_sql\s*:=\s*'(.*?)'\s*;",
    re.IGNORECASE | re.DOTALL,
)

# execute immediate('...') 或 execute immediate '...'
_EXEC_IMMEDIATE_RE = re.compile(
    r"execute\s+immediate\s*\(?'(.*?)'\)?\s*;",
    re.IGNORECASE | re.DOTALL,
)

# 变量拼接片段：'||v_xxx||' 或 '||v_xxx
_VAR_CONCAT_RE = re.compile(
    r"'\s*\|\|\s*(\w+)\s*\|\|\s*'",
)

# INSERT INTO target [(cols)] 或 INSERT /*+ hint */ INTO target
_INSERT_INTO_RE = re.compile(
    r"insert\s+(?:/\*[^*]*\*/\s*)?into\s+(?:/\*[^*]*\*/\s*)?([\w.]+)",
    re.IGNORECASE,
)

# INSERT ... (columns) 提取列列表
_INSERT_COLS_RE = re.compile(
    r"insert\s+(?:/\*[^*]*\*/\s*)?into\s+(?:/\*[^*]*\*/\s*)?[\w.]+\s*(?:nologging\s*)?\(\s*([^)]+)\s*\)",
    re.IGNORECASE,
)

# DELETE FROM target
_DELETE_FROM_RE = re.compile(
    r"delete\s+from\s+([\w.]+)",
    re.IGNORECASE,
)

# MERGE INTO target USING source
_MERGE_INTO_RE = re.compile(
    r"merge\s+into\s+([\w.]+)\s+(?:\w+\s+)?using\s+([\w.]+)",
    re.IGNORECASE,
)

# FROM/JOIN 子句中的表名
_FROM_TABLE_RE = re.compile(
    r"(?:from|join)\s+([\w.]+)",
    re.IGNORECASE,
)

# SELECT 列列表（从 SELECT 到 FROM）
_SELECT_COLS_RE = re.compile(
    r"select\s+(?:/\*[^*]*\*/\s*)?(.+?)\s+from\s+",
    re.IGNORECASE | re.DOTALL,
)

# 需要忽略的伪表名
_IGNORE_TABLES = frozenset({
    "DUAL", "SYS", "SYSTEM", "ALL_TAB_COLUMNS", "USER_TAB_COLUMNS",
    "ALL_TABLES", "USER_TABLES", "DBA_TABLES",
})


class PamDMLParser:
    """PAM DML 解析器 — 从单文件中拆分并解析多个存储过程"""

    def __init__(self, default_schema: str = "pam"):
        self._default_schema = default_schema.upper()

    def parse_file(self, file_path: Path) -> ParseOutput:
        """解析 DML 文件，返回统一产出"""
        try:
            with open(file_path, encoding="utf-8", errors="ignore") as f:
                content = f.read()
        except OSError as e:
            logger.error("读取 DML 文件失败: %s - %s", file_path, e)
            return ParseOutput(errors=[f"读取文件失败: {file_path} - {e}"])

        if not content.strip():
            return ParseOutput()

        blocks = self._split_procedures(content)
        logger.info("PamDMLParser: 文件 %s 拆分出 %d 个过程块", file_path.name, len(blocks))

        output = ParseOutput()
        for block in blocks:
            result = self._parse_single_procedure(block)
            if result is None:
                continue
            proc_dict, lineages, mappings = result
            output.procedures.append(proc_dict)
            output.table_lineages.extend(lineages)
            output.field_mappings.extend(mappings)

        logger.info(
            "PamDMLParser: 解析完成 %d 个过程, %d 条血缘, %d 条字段映射",
            len(output.procedures),
            len(output.table_lineages),
            len(output.field_mappings),
        )
        return output

    def _split_procedures(self, content: str) -> list[str]:
        """按 `/` 行分隔拆分过程块，过滤 ALTER PROCEDURE 块"""
        # 按独立 `/` 行拆分
        raw_blocks = re.split(r"^\s*/\s*$", content, flags=re.MULTILINE)

        blocks: list[str] = []
        for block in raw_blocks:
            block = block.strip()
            if not block:
                continue
            # 跳过 ALTER PROCEDURE 编译块
            if _ALTER_PROC_RE.match(block):
                continue
            # 只保留包含 CREATE procedure 的块
            if _CREATE_PROC_RE.search(block):
                blocks.append(block)

        return blocks

    def _parse_single_procedure(self, block: str) -> tuple[dict, list[dict], list[dict]] | None:
        """解析单个过程块，返回 (过程字典, 血缘列表, 映射列表)"""
        proc_name = self._extract_proc_name(block)
        if not proc_name:
            return None

        full_name = f"{self._default_schema}.{proc_name}"
        var_map = self._resolve_variables(block)
        sql_stmts = self._extract_dynamic_sql(block, var_map)

        source_tables: set[str] = set()
        target_tables: set[str] = set()
        lineages: list[dict] = []
        mappings: list[dict] = []
        seen_lineage_keys: set[tuple] = set()
        seen_mapping_keys: set[tuple] = set()

        for sql in sql_stmts:
            stmt_lineages, stmt_mappings = self._parse_dml_from_sql(sql, full_name)
            for tl in stmt_lineages:
                key = (tl["source_table"], tl["target_table"], tl["procedure"])
                if key not in seen_lineage_keys:
                    seen_lineage_keys.add(key)
                    lineages.append(tl)
                    source_tables.add(tl["source_table"])
                    target_tables.add(tl["target_table"])
            for fm in stmt_mappings:
                key = (fm["source_table"], fm["source_column"], fm["target_table"], fm["target_column"])
                if key not in seen_mapping_keys:
                    seen_mapping_keys.add(key)
                    mappings.append(fm)

        proc_dict = {
            "full_name": full_name,
            "schema": self._default_schema,
            "proc_name": proc_name,
            "description": "",
            "source_tables": sorted(source_tables),
            "target_tables": sorted(target_tables),
            "config_tables": [],
        }

        return proc_dict, lineages, mappings

    def _extract_proc_name(self, block: str) -> str | None:
        """提取过程名"""
        match = _CREATE_PROC_RE.search(block)
        if not match:
            return None
        name = match.group(1).strip().upper()
        # 去除可能的 schema 前缀
        if "." in name:
            name = name.split(".", 1)[1]
        return name

    def _resolve_variables(self, block: str) -> dict[str, str]:
        """扫描变量赋值语句，构建变量名→值映射"""
        var_map: dict[str, str] = {}

        # 类型声明中的赋值：v_xxx varchar2(50) := 'VALUE'
        for m in _VAR_ASSIGN_RE.finditer(block):
            var_name = m.group(1).lower()
            var_map[var_name] = m.group(2)

        # 简单赋值：v_xxx := 'VALUE';
        for m in _VAR_SIMPLE_ASSIGN_RE.finditer(block):
            var_name = m.group(1).lower()
            value = m.group(2)
            # 只保留看起来像表名的值（全字母/数字/下划线，且非 SQL 关键字片段）
            if re.match(r"^[\w]+$", value) and not value.isdigit():
                var_map[var_name] = value

        return var_map

    def _extract_dynamic_sql(self, block: str, var_map: dict[str, str]) -> list[str]:
        """提取并还原动态 SQL 语句"""
        sql_stmts: list[str] = []

        # 提取 v_sql := '...' 赋值
        for m in _SQL_ASSIGN_RE.finditer(block):
            sql = m.group(1)
            sql = self._substitute_variables(sql, var_map)
            sql_stmts.append(sql)

        # 提取 execute immediate '...'
        for m in _EXEC_IMMEDIATE_RE.finditer(block):
            sql = m.group(1)
            sql = self._substitute_variables(sql, var_map)
            if sql not in sql_stmts:
                sql_stmts.append(sql)

        return sql_stmts

    def _substitute_variables(self, sql: str, var_map: dict[str, str]) -> str:
        """将 '||v_xxx||' 形式的变量拼接替换为实际值"""
        def _replace(m: re.Match) -> str:
            var_name = m.group(1).lower()
            if var_name in var_map:
                return var_map[var_name]
            return m.group(0)  # 无法解析的保留原样

        # 替换 '||var||' 形式
        result = _VAR_CONCAT_RE.sub(_replace, sql)
        # 替换行尾的 '||var (无闭合引号)
        result = re.sub(r"'\s*\|\|\s*(\w+)\s*$", lambda m: var_map.get(m.group(1).lower(), m.group(0)), result)
        # 替换开头的 var||' (无开始引号)
        result = re.sub(r"^(\w+)\s*\|\|\s*'", lambda m: var_map.get(m.group(1).lower(), m.group(0)), result)
        return result

    def _parse_dml_from_sql(self, sql: str, proc_name: str) -> tuple[list[dict], list[dict]]:
        """从解析后的 SQL 中提取表级血缘和字段映射"""
        lineages: list[dict] = []
        mappings: list[dict] = []

        # INSERT INTO target ... SELECT ... FROM source
        insert_match = _INSERT_INTO_RE.search(sql)
        if insert_match:
            target = self._normalize_table(insert_match.group(1))
            if target:
                sources = self._extract_source_tables(sql)
                target_cols = self._extract_insert_columns(sql)
                select_cols = self._extract_select_columns(sql)

                for src in sources:
                    lineages.append({
                        "source_table": src,
                        "target_table": target,
                        "procedure": proc_name,
                    })

                # 字段映射：按位置对齐 INSERT 列和 SELECT 列
                if target_cols and select_cols and len(target_cols) == len(select_cols):
                    for t_col, s_expr in zip(target_cols, select_cols):
                        # 简单列名（非表达式）映射到第一个源表
                        s_col = s_expr.strip()
                        if re.match(r"^\w+$", s_col) and sources:
                            mappings.append({
                                "source_table": sources[0],
                                "source_column": s_col.upper(),
                                "target_table": target,
                                "target_column": t_col.upper(),
                                "transform_logic": "",
                                "procedure": proc_name,
                                "confidence": 0.7,
                            })

            return lineages, mappings

        # MERGE INTO target USING source
        merge_match = _MERGE_INTO_RE.search(sql)
        if merge_match:
            target = self._normalize_table(merge_match.group(1))
            source = self._normalize_table(merge_match.group(2))
            if target and source:
                lineages.append({
                    "source_table": source,
                    "target_table": target,
                    "procedure": proc_name,
                })
            return lineages, mappings

        return lineages, mappings

    def _extract_source_tables(self, sql: str) -> list[str]:
        """从 FROM/JOIN 子句提取源表"""
        tables: list[str] = []
        for m in _FROM_TABLE_RE.finditer(sql):
            table = self._normalize_table(m.group(1))
            if table and table not in tables:
                tables.append(table)
        return tables

    def _extract_insert_columns(self, sql: str) -> list[str]:
        """提取 INSERT INTO ... (col1, col2, ...) 的目标列"""
        m = _INSERT_COLS_RE.search(sql)
        if not m:
            return []
        cols_str = m.group(1)
        return [c.strip() for c in cols_str.split(",") if c.strip()]

    def _extract_select_columns(self, sql: str) -> list[str]:
        """提取 SELECT col1, col2 ... FROM 的选择列"""
        m = _SELECT_COLS_RE.search(sql)
        if not m:
            return []
        select_str = m.group(1)
        # 按逗号拆分，去除别名
        cols: list[str] = []
        for part in select_str.split(","):
            part = part.strip()
            if not part:
                continue
            # 去除 AS alias 或尾部别名
            part = re.sub(r"\s+as\s+\w+\s*$", "", part, flags=re.IGNORECASE)
            # 取最后一个空格前的表达式中的列名（简单情况）
            tokens = part.split()
            if len(tokens) >= 2 and re.match(r"^\w+$", tokens[-1]):
                # 可能是 expr alias 形式
                cols.append(tokens[-1] if not re.match(r"^\w+$", tokens[0]) else tokens[0])
            else:
                cols.append(tokens[0] if tokens else part)
        return cols

    def _normalize_table(self, raw: str) -> str | None:
        """标准化表名为 SCHEMA.TABLE 格式"""
        if not raw:
            return None

        raw = raw.strip().upper()
        # 过滤无效表名
        if raw in _IGNORE_TABLES:
            return None
        if raw.startswith(("'", "(", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")):
            return None

        # 处理 schema.table
        if "." in raw:
            schema, table = raw.split(".", 1)
            # 将 PAS schema 统一为 default_schema
            if schema in ("PAS", self._default_schema):
                return f"{self._default_schema}.{table}"
            return f"{schema}.{table}"

        return f"{self._default_schema}.{raw}"
