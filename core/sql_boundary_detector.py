"""
SQL 边界检测器
在存储过程中精确定位每条 DML 操作的行号范围，
识别 CTE (WITH ... AS) 子句的边界，
为步骤级隔离条件提取提供精确的位置信息。
"""

from __future__ import annotations

import logging
import re
from dataclasses import dataclass

logger = logging.getLogger(__name__)


@dataclass
class DMLBoundary:
    """单条 DML 操作的边界信息"""

    operation_type: str = ""  # INSERT / MERGE / UPDATE
    start_line: int = 0  # 起始行号（1-based）
    end_line: int = 0  # 结束行号（1-based）
    start_offset: int = 0  # 起始字符偏移
    end_offset: int = 0  # 结束字符偏移
    target_table: str = ""  # 目标表名


@dataclass
class CTEBoundary:
    """CTE (WITH ... AS) 子句的边界信息"""

    cte_name: str = ""  # CTE 名称
    start_line: int = 0  # 起始行号（1-based）
    end_line: int = 0  # 结束行号（1-based）
    start_offset: int = 0  # 起始字符偏移
    end_offset: int = 0  # 结束字符偏移
    body: str = ""  # CTE 定义体


# ---------------------------------------------------------------------------
# 正则模式
# ---------------------------------------------------------------------------

_DML_START_PATTERNS = [
    (re.compile(r"\bINSERT\s+(?:/\*.*?\*/\s*)?INTO\b", re.IGNORECASE), "INSERT"),
    (re.compile(r"\bMERGE\s+INTO\b", re.IGNORECASE), "MERGE"),
    (re.compile(r"\bUPDATE\s+([\w.]+)\s+SET\b", re.IGNORECASE), "UPDATE"),
]

# WITH name AS (
_CTE_PATTERN = re.compile(
    r"\bWITH\s+(\w+)\s+AS\s*\(",
    re.IGNORECASE,
)

# 匹配目标表名
_INSERT_TABLE_PATTERN = re.compile(
    r"\bINSERT\s+(?:/\*.*?\*/\s*)?INTO\s+([\w.]+)",
    re.IGNORECASE,
)
_MERGE_TABLE_PATTERN = re.compile(
    r"\bMERGE\s+INTO\s+([\w.]+)",
    re.IGNORECASE,
)
_UPDATE_TABLE_PATTERN = re.compile(
    r"\bUPDATE\s+([\w.]+)\s+SET\b",
    re.IGNORECASE,
)


class SQLBoundaryDetector:
    """SQL 操作边界检测器

    功能：
      1. 精确行号定位：识别 INSERT/MERGE/UPDATE 在文件中的 start_line / end_line
      2. CTE 边界识别：识别 WITH ... AS (...) 子句的范围
      3. 嵌套语句处理：处理 BEGIN...END 嵌套内的 DML 定位
    """

    def __init__(self, file_content: str) -> None:
        self.file_content = file_content
        self.lines = file_content.split("\n")

    def detect_dml_boundaries(self) -> list[DMLBoundary]:
        """检测文件中所有 DML 操作的边界信息。

        Returns:
            按 start_line 排序的 DMLBoundary 列表
        """
        boundaries: list[DMLBoundary] = []

        for pattern, op_type in _DML_START_PATTERNS:
            for match in pattern.finditer(self.file_content):
                start_offset = match.start()
                end_offset = self._find_statement_end(start_offset)
                start_line = self.file_content[:start_offset].count("\n") + 1
                end_line = self.file_content[:end_offset].count("\n") + 1

                target_table = self._extract_target_table(self.file_content[start_offset:end_offset], op_type)

                boundaries.append(
                    DMLBoundary(
                        operation_type=op_type,
                        start_line=start_line,
                        end_line=end_line,
                        start_offset=start_offset,
                        end_offset=end_offset,
                        target_table=target_table,
                    )
                )

        # 按起始位置排序
        boundaries.sort(key=lambda b: b.start_offset)
        return boundaries

    def detect_cte_boundaries(self) -> list[CTEBoundary]:
        """检测文件中所有 CTE (WITH ... AS) 子句的边界信息。

        Returns:
            按 start_line 排序的 CTEBoundary 列表
        """
        cte_boundaries: list[CTEBoundary] = []

        for match in _CTE_PATTERN.finditer(self.file_content):
            cte_name = match.group(1)
            start_offset = match.start()

            # 从 CTE 的左括号开始，找到匹配的右括号
            paren_start = self.file_content.find("(", match.start())
            if paren_start == -1:
                logger.warning("CTE '%s' 未找到左括号，跳过", cte_name)
                continue
            paren_end = self._find_matching_paren(paren_start)

            end_offset = paren_end if paren_end > paren_start else paren_start + 1
            start_line = self.file_content[:start_offset].count("\n") + 1
            end_line = self.file_content[:end_offset].count("\n") + 1

            body = self.file_content[paren_start + 1 : paren_end].strip() if paren_end > paren_start else ""

            cte_boundaries.append(
                CTEBoundary(
                    cte_name=cte_name,
                    start_line=start_line,
                    end_line=end_line,
                    start_offset=start_offset,
                    end_offset=end_offset,
                    body=body,
                )
            )

        cte_boundaries.sort(key=lambda c: c.start_offset)
        return cte_boundaries

    def get_sql_block_by_line_range(self, start_line: int, end_line: int) -> str:
        """根据行号范围提取对应的文本内容。

        Args:
            start_line: 起始行号（1-based, inclusive）
            end_line: 结束行号（1-based, inclusive）

        Returns:
            对应行范围的文本
        """
        if start_line < 1 or end_line < start_line:
            return ""
        line_indices = range(start_line - 1, min(end_line, len(self.lines)))
        return "\n".join(self.lines[i] for i in line_indices)

    def _find_statement_end(self, start_offset: int) -> int:
        """从给定偏移开始，查找 SQL 语句的结束位置。

        策略：
          1. 找到下一个分号（不在字符串/注释内）
          2. 如果没有分号，找下一个 DML 关键字作为边界
          3. 兜底：文件末尾
        """
        content = self.file_content[start_offset:]

        # 策略1：查找分号
        semi_pos = self._find_semicolon_outside_quotes(content)
        if semi_pos >= 0:
            return start_offset + semi_pos + 1

        # 策略2：查找下一个 DML 关键字
        for pattern, _ in _DML_START_PATTERNS:
            next_match = pattern.search(content[10:])  # 跳过当前 DML 的开头
            if next_match:
                candidate = start_offset + 10 + next_match.start()
                if candidate > start_offset:
                    return candidate

        # 策略3：文件末尾
        return len(self.file_content)

    def _find_semicolon_outside_quotes(self, text: str) -> int:
        """在文本中查找第一个不在引号/注释内的分号位置。

        Returns:
            分号的字符偏移，未找到返回 -1
        """
        in_single_quote = False
        in_double_quote = False
        in_line_comment = False
        in_block_comment = False
        i = 0

        while i < len(text):
            ch = text[i]

            # 行注释
            if not in_single_quote and not in_double_quote and not in_block_comment:
                if ch == "-" and i + 1 < len(text) and text[i + 1] == "-":
                    in_line_comment = True
                    i += 2
                    continue

            # 块注释开始
            if not in_single_quote and not in_double_quote and not in_line_comment:
                if ch == "/" and i + 1 < len(text) and text[i + 1] == "*":
                    in_block_comment = True
                    i += 2
                    continue

            # 块注释结束
            if in_block_comment:
                if ch == "*" and i + 1 < len(text) and text[i + 1] == "/":
                    in_block_comment = False
                    i += 2
                    continue
                i += 1
                continue

            # 行注释：到行末结束
            if in_line_comment:
                if ch == "\n":
                    in_line_comment = False
                i += 1
                continue

            # 单引号
            if ch == "'" and not in_double_quote:
                # 连续两个单引号是转义
                if i + 1 < len(text) and text[i + 1] == "'":
                    i += 2
                    continue
                in_single_quote = not in_single_quote
                i += 1
                continue

            # 双引号
            if ch == '"' and not in_single_quote:
                in_double_quote = not in_double_quote
                i += 1
                continue

            # 分号
            if ch == ";" and not in_single_quote and not in_double_quote:
                return i

            i += 1

        return -1

    def _find_matching_paren(self, start: int) -> int:
        """从 start 位置（必须是左括号）开始，找到匹配的右括号位置。

        Returns:
            匹配的右括号字符偏移，未找到返回 start
        """
        if start >= len(self.file_content) or self.file_content[start] != "(":
            return start

        depth = 0
        in_single_quote = False
        i = start

        while i < len(self.file_content):
            ch = self.file_content[i]

            if ch == "'" and not in_single_quote:
                in_single_quote = True
            elif ch == "'" and in_single_quote:
                # 转义单引号
                if i + 1 < len(self.file_content) and self.file_content[i + 1] == "'":
                    i += 2
                    continue
                in_single_quote = False
            elif not in_single_quote:
                if ch == "(":
                    depth += 1
                elif ch == ")":
                    depth -= 1
                    if depth == 0:
                        return i

            i += 1

        return start  # 未找到匹配的右括号

    @staticmethod
    def _extract_target_table(sql_fragment: str, op_type: str) -> str:
        """从 SQL 片段中提取目标表名。"""
        if op_type == "INSERT":
            m = _INSERT_TABLE_PATTERN.search(sql_fragment)
            return m.group(1).strip().upper() if m else ""
        elif op_type == "MERGE":
            m = _MERGE_TABLE_PATTERN.search(sql_fragment)
            return m.group(1).strip().upper() if m else ""
        elif op_type == "UPDATE":
            m = _UPDATE_TABLE_PATTERN.search(sql_fragment)
            return m.group(1).strip().upper() if m else ""
        return ""
