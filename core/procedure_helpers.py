"""存储过程解析器的无状态 helper 函数。

从 core/procedure_parser.py 提取，便于复用和单元测试。
所有函数均为纯函数，不依赖 self 状态。
"""

from __future__ import annotations

import logging
import re

from core.utils import is_temp_table as _is_temp_table_shared

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# 常量：无效表名前缀（用于过滤误匹配）
# ---------------------------------------------------------------------------
INVALID_TABLE_PREFIXES: tuple[str, ...] = (
    "DUAL",
    "ETL_",
    "FUN_",
    "SQL",
    "ALTER",
    "EXECUTE",
    "COMMIT",
    "ROLLBACK",
)

# 常量：临时表识别模式后缀
TEMP_TABLE_SUFFIXES: tuple[str, ...] = ("TMP", "_TMP", "TEMP", "_TEMP")

# 不能作为别名的 SQL 关键字（用于 _parse_from_aliases 过滤）
_SQL_KEYWORDS_FOR_ALIAS: frozenset[str] = frozenset({
    "ON", "AND", "WHERE", "SET", "SELECT", "INSERT",
    "UPDATE", "DELETE", "FROM", "JOIN", "LEFT", "RIGHT",
    "INNER", "OUTER", "FULL", "CROSS", "USING", "GROUP",
    "ORDER", "HAVING", "LIMIT", "OFFSET", "UNION", "EXCEPT",
    "INTERSECT", "CASE", "WHEN", "THEN", "ELSE", "END", "AS",
    "IS", "NOT", "NULL", "TRUE", "FALSE", "LIKE", "IN",
    "EXISTS", "BETWEEN", "OR", "XOR",
})

# 子查询别名过滤用的关键字子集
_SUBQUERY_ALIAS_KEYWORDS: frozenset[str] = frozenset({
    "ON", "AND", "WHERE", "SET", "SELECT", "INSERT",
    "UPDATE", "DELETE", "FROM", "JOIN", "LEFT", "RIGHT",
    "INNER", "OUTER", "FULL", "CROSS", "USING", "GROUP",
    "ORDER", "HAVING", "UNION", "EXCEPT", "INTERSECT",
})


def is_valid_table(table_name: str) -> bool:
    """判断表名是否为有效表名（非 SQL 别名、非伪表）。

    纯函数版本，从 EnhancedProcedureParser._is_valid_table 提取。
    """
    if not table_name:
        return False
    if table_name.startswith(INVALID_TABLE_PREFIXES):
        return False
    if len(table_name) < 2:
        return False
    # 拒绝无 schema 前缀的短名称（SQL 别名，如 T1, A, BU_NO）
    if "." not in table_name and len(table_name) <= 5:
        upper = table_name.upper()
        if not (upper.endswith(TEMP_TABLE_SUFFIXES) or upper.startswith("TMP_")):
            return False
    # 拒绝 alias.column 格式（如 T1.ORG_LEVEL）
    if "." in table_name:
        prefix = table_name.split(".")[0]
        if len(prefix) <= 3:
            return False
    return True


def looks_like_unresolved_alias(table_name: str) -> bool:
    """判断 table_name 是否看起来像未解析的 SQL 别名而非真实表名。

    真实表名通常带 schema 前缀（如 ICL.XXX, IML.XXX, RRP_EAST.XXX），
    而 SQL 别名通常是短名称（如 T1, T3, A, TB）。
    带 TMP/TEMP 后缀的视为合法临时表，不做过滤。

    纯函数版本，从 EnhancedProcedureParser._looks_like_unresolved_alias 提取。
    """
    if not table_name or "." in table_name:
        return False
    upper = table_name.upper()
    # 带临时表后缀的视为合法临时表名
    if upper.endswith(TEMP_TABLE_SUFFIXES) or upper.startswith("TMP_"):
        return False
    # 无 schema 前缀且名称较短（≤5字符），极大概率是 SQL 别名
    if len(upper) <= 5:
        return True
    return False


def is_temp_table(table_name: str) -> bool:
    """判断表名是否为临时表（基于命名约定）。

    纯函数版本，从 EnhancedProcedureParser._is_temp_table 提取，
    委托到 core.utils.is_temp_table 共享单例。
    """
    return _is_temp_table_shared(table_name)


def parse_from_aliases(sql_block: str) -> dict[str, str]:
    """解析 FROM 子句中的表别名映射。

    返回 {alias: real_table} 字典，例如 {'A': 'RRP_EAST.M_CUST_IND_INFO_EAST'}
    支持标准表别名和子查询别名（如 FROM (SELECT ...) T1）。

    纯函数版本，从 EnhancedProcedureParser._parse_from_aliases 提取。
    """
    aliases: dict[str, str] = {}

    # 匹配 FROM table_name alias 或 FROM table_name AS alias
    # 支持 schema.table 格式
    patterns = [
        r"\bFROM\s+([\w.]+)\s+AS\s+(\w+)\b",
        r"\bFROM\s+([\w.]+)\s+(\w+)\b",
        r"\bJOIN\s+([\w.]+)\s+AS\s+(\w+)\b",
        r"\bJOIN\s+([\w.]+)\s+(\w+)\b",
        r"\bLEFT\s+JOIN\s+([\w.]+)\s+AS\s+(\w+)\b",
        r"\bLEFT\s+JOIN\s+([\w.]+)\s+(\w+)\b",
        r"\bRIGHT\s+JOIN\s+([\w.]+)\s+AS\s+(\w+)\b",
        r"\bRIGHT\s+JOIN\s+([\w.]+)\s+(\w+)\b",
        r"\bINNER\s+JOIN\s+([\w.]+)\s+AS\s+(\w+)\b",
        r"\bINNER\s+JOIN\s+([\w.]+)\s+(\w+)\b",
    ]

    for pattern in patterns:
        for match in re.finditer(pattern, sql_block, re.IGNORECASE):
            table_name = match.group(1).upper()
            alias_name = match.group(2).upper()
            # 排除关键字（如 ON, AND, WHERE, SET 等）
            if alias_name not in _SQL_KEYWORDS_FOR_ALIAS:
                aliases[alias_name] = table_name

    # --- 子查询别名提取：FROM (SELECT ...) T1 / JOIN (SELECT ...) AS T1 ---
    # 通过括号深度追踪定位子查询的右括号，再提取后续标识符作为别名
    i = 0
    sql_upper = sql_block.upper()
    while i < len(sql_block):
        ch = sql_block[i]
        if ch == "(":
            # 检查是否为子查询开头
            rest = sql_upper[i + 1:].lstrip()
            if rest.startswith("SELECT"):
                sub_start = i
                j = i + 1
                d = 1
                while j < len(sql_block) and d > 0:
                    if sql_block[j] == "(":
                        d += 1
                    elif sql_block[j] == ")":
                        d -= 1
                    j += 1
                # j 现在指向子查询右括号之后
                after = sql_block[j: j + 30].strip()
                alias_m = re.match(r"(?:AS\s+)?(\w+)\b", after, re.IGNORECASE)
                if alias_m:
                    alias_name = alias_m.group(1).upper()
                    if alias_name not in _SUBQUERY_ALIAS_KEYWORDS:
                        # 子查询别名不加入 alias_map，避免被解析为伪表名。
                        # _extract_insert_mappings 的别名守卫会将其过滤掉。
                        logger.debug(
                            "    检测到子查询别名: %s (position=%d)，不解析为真实表",
                            alias_name, sub_start,
                        )
                i = j
                continue
        i += 1

    return aliases
