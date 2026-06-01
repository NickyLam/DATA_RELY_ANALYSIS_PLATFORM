"""
SQL 字段清洗器
从 EnhancedProcedureParser 中提取，负责字段名清洗、函数剥离、SELECT 列表解析等。
"""

from __future__ import annotations

import logging
import re

logger = logging.getLogger(__name__)

_FUNC_NAME_PATTERN = re.compile(
    r"^(TRIM|NVL|TO_CHAR|TO_NUMBER|TO_DATE|UPPER|LOWER|SUBSTR|INSTR"
    r"|LTRIM|RTRIM|REPLACE|COALESCE|DECODE|MAX|MIN|SUM|AVG|COUNT"
    r"|NVL2|NULLIF|LENGTH|ROUND|TRUNC|ABS|SIGN|GREATEST|LEAST"
    r"|CAST|EXTRACT|LISTAGG|REGEXP_REPLACE|REGEXP_SUBSTR)\s*\(",
    re.IGNORECASE,
)


class FieldCleaner:
    """SQL 字段名清洗与解析。

    职责：
      - clean_column_name: 清洗原始字段表达式，返回裸列名
      - strip_function_wrapper: 迭代剥离 SQL 函数包裹
      - parse_select_columns: 解析 SELECT 子句字段列表
      - tokenize_select_list: 拆分 SELECT 字段表达式
      - extract_column_info: 提取单个字段的结构化信息
      - parse_update_set_pairs: 解析 UPDATE SET 子句
      - split_target_columns: 拆分 INSERT 目标字段列表
      - resolve_source_from_expr: 从表达式中推断来源表和列
    """

    @staticmethod
    def clean_column_name(raw: str, strip_fn: object | None = None) -> str:
        """清洗原始字段表达式，返回最内层的裸列名。

        处理规则（按优先级从高到低）：
          1. 去除行内注释  -- xxx
          2. 去除首尾空白
          3. 剥离函数包裹：TRIM(t.col) → t.col, NVL(t.col,'x') → t.col
          4. 处理 CASE WHEN ... END → 保留原表达式作为 transform
          5. 处理 DECODE(...) → 保留原表达式作为 transform
          6. 处理子查询 (SELECT col FROM t) AS alias → 取 alias
          7. 提取 schema.table.column 或 table.column 中的列名
        """
        if not raw:
            return ""

        text = raw.strip()

        text = re.sub(r"--.*$", "", text, flags=re.MULTILINE).strip()

        if not text:
            return ""

        if re.search(r"\bCASE\b", text, re.IGNORECASE):
            return ""

        if re.match(r"^DECODE\s*\(", text, re.IGNORECASE):
            return ""

        text = FieldCleaner.strip_function_wrapper(text)

        subq_alias = re.search(r"\)\s+AS\s+(\w+)\s*$", text, re.IGNORECASE)
        if subq_alias:
            return subq_alias.group(1).upper()

        dot_match = re.search(r"(?:^|\s)([\w.]+\.\w+)\s*$", text)
        if dot_match:
            col_ref = dot_match.group(1).strip()
            parts = col_ref.split(".")
            if len(parts) >= 2:
                return parts[-1].upper()

        identifier = re.match(r"^(\w+)\s*$", text)
        if identifier:
            return identifier.group(1).upper()

        return ""

    @staticmethod
    def strip_function_wrapper(expr: str) -> str:
        """迭代剥离常见 SQL 函数包裹，返回内层表达式。"""
        if not expr:
            return ""

        current = expr.strip()
        max_iterations = 10

        for _ in range(max_iterations):
            m = _FUNC_NAME_PATTERN.match(current)
            if not m:
                break

            paren_start = m.end() - 1
            inner_start = m.end()

            depth = 0
            found_end = -1
            for idx in range(paren_start, len(current)):
                ch = current[idx]
                if ch == "(":
                    depth += 1
                elif ch == ")":
                    depth -= 1
                    if depth == 0:
                        found_end = idx
                        break

            if found_end == -1:
                break

            inner_content = current[inner_start:found_end].strip()

            comma_pos = FieldCleaner.find_top_level_comma(inner_content)
            if comma_pos > 0:
                candidate = inner_content[:comma_pos].strip()
            else:
                candidate = inner_content

            if _FUNC_NAME_PATTERN.match(candidate.strip()):
                current = candidate.strip()
            else:
                current = candidate.strip()
                break

        return current

    @staticmethod
    def find_top_level_comma(text: str) -> int:
        """在文本中找到顶层逗号位置（不考虑括号内的逗号）。"""
        depth = 0
        for i, ch in enumerate(text):
            if ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
            elif ch == "," and depth == 0:
                return i
        return -1

    @staticmethod
    def parse_select_columns(select_str: str) -> list[dict]:
        """解析 SELECT 子句中的字段列表，返回结构化信息。"""
        columns: list[dict] = []
        tokens = FieldCleaner.tokenize_select_list(select_str)

        for token in tokens:
            info = FieldCleaner.extract_column_info(token)
            columns.append(info)

        return columns

    @staticmethod
    def tokenize_select_list(select_str: str) -> list[str]:
        """将 SELECT 字符串按顶层逗号拆分为多个字段表达式。"""
        tokens: list[str] = []
        depth = 0
        current: list[str] = []
        in_string = False
        string_char = ""
        i = 0
        n = len(select_str)

        while i < n:
            ch = select_str[i]

            if ch == "/" and i + 1 < n and select_str[i + 1] == "*":
                end_idx = select_str.find("*/", i + 2)
                if end_idx != -1:
                    i = end_idx + 2
                    continue
                else:
                    i = n
                    break

            if ch == "-" and i + 1 < n and select_str[i + 1] == "-":
                end_idx = select_str.find("\n", i + 2)
                if end_idx != -1:
                    i = end_idx + 1
                    continue
                else:
                    i = n
                    break

            if in_string:
                current.append(ch)
                if ch == string_char:
                    in_string = False
                i += 1
                continue

            if ch in ("'", '"'):
                in_string = True
                string_char = ch
                current.append(ch)
            elif ch == "(":
                depth += 1
                current.append(ch)
            elif ch == ")":
                depth -= 1
                current.append(ch)
            elif ch == "," and depth == 0:
                token = "".join(current).strip()
                if token:
                    tokens.append(token)
                current = []
            else:
                current.append(ch)

            i += 1

        remainder = "".join(current).strip()
        if remainder:
            tokens.append(remainder)

        return tokens

    @staticmethod
    def extract_column_info(col_str: str) -> dict:
        """从单个字段表达式中提取结构化信息。"""
        text = col_str.strip()
        if not text:
            return {
                "table": "",
                "column": "",
                "alias": "",
                "transform": "",
                "confidence": 0.0,
            }

        text = re.sub(r"--.*$", "", text).strip()

        alias = ""
        alias_match = re.search(r"\bAS\s+(\w+)\s*$", text, re.IGNORECASE)
        if alias_match:
            alias = alias_match.group(1).upper()
            text = text[: alias_match.start()].strip()

        table_name = ""
        column_name = ""
        transform = ""
        confidence = 1.0

        triple_match = re.search(r"\b(\w+)\.(\w+)\.(\w+)\b", text)
        if triple_match:
            table_name = triple_match.group(1).upper() + "." + triple_match.group(2).upper()
            column_name = triple_match.group(3).upper()
            confidence = 0.95
        else:
            dot_match = re.search(r"\b(\w+)\.(\w+)\b", text)
            if dot_match:
                table_name = dot_match.group(1).upper()
                column_name = dot_match.group(2).upper()
                confidence = 0.95
            else:
                stripped = FieldCleaner.strip_function_wrapper(text)
                identifier = re.match(r"^(\w+)\s*$", stripped)
                if identifier:
                    column_name = identifier.group(1).upper()
                    confidence = 0.85
                elif re.match(r"^'.*'$", stripped):
                    column_name = ""
                    transform = text
                    confidence = 0.6
                elif re.match(r"^\d+(\.\d+)?$", stripped):
                    column_name = ""
                    transform = text
                    confidence = 0.6
                else:
                    column_name = stripped.upper() if stripped and re.match(r"^\w+$", stripped) else ""
                    transform = text
                    confidence = 0.5

        if not column_name and alias:
            column_name = alias
            confidence = min(confidence, 0.75)

        return {
            "table": table_name,
            "column": column_name,
            "alias": alias,
            "transform": transform,
            "confidence": confidence,
        }

    @staticmethod
    def parse_update_set_pairs(set_clause: str) -> list[tuple[str, str]]:
        """将 UPDATE SET col1=expr1, col2=expr2 解析为 [(col, expr), ...]。"""
        pairs: list[tuple[str, str]] = []
        depth = 0
        current_col: list[str] = []
        current_val: list[str] = []
        in_value = False

        for ch in set_clause:
            if ch == "(":
                depth += 1
                (current_val if in_value else current_col).append(ch)
            elif ch == ")":
                depth -= 1
                (current_val if in_value else current_col).append(ch)
            elif ch == "=" and depth == 0 and not in_value:
                in_value = True
            elif ch == "," and depth == 0 and in_value:
                col = "".join(current_col).strip()
                val = "".join(current_val).strip()
                if col:
                    pairs.append((col, val))
                current_col = []
                current_val = []
                in_value = False
            else:
                (current_val if in_value else current_col).append(ch)

        if in_value:
            col = "".join(current_col).strip()
            val = "".join(current_val).strip()
            if col:
                pairs.append((col, val))

        return pairs

    @staticmethod
    def split_target_columns(cols_str: str) -> list[str]:
        """拆分 INSERT 目标字段列表，正确处理行内注释。"""
        cleaned = re.sub(r"--.*$", "", cols_str, flags=re.MULTILINE)
        parts = cleaned.split(",")
        return [p.strip() for p in parts if p.strip()]

    @staticmethod
    def resolve_source_from_expr(expr: str, default_table: str) -> tuple[str, str]:
        """从表达式中推断来源表和来源列。"""
        if not expr:
            return ("", "")

        dot_match = re.match(r"^([\w.]+)\.(\w+)$", expr.strip())
        if dot_match:
            return (dot_match.group(1).upper(), dot_match.group(2).upper())

        identifier = re.match(r"^(\w+)$", expr.strip())
        if identifier:
            return (default_table.upper(), identifier.group(1).upper())

        return (default_table.upper(), expr.strip().upper())
