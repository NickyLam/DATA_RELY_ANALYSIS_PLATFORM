"""SQL 注释剥离工具。

提供统一的 SQL 注释剥离能力，供 warehouse / pam 等解析器复用，
避免各解析器重复实现（CodeReview D-07：SQL 解析基础设施重复）。

支持：
  - 行注释 ``-- ...``（到行尾）
  - 块注释 ``/* ... */``（可跨行）

保留字符串字面量内容与换行边界，仅将注释字符替换为等长空格。
"""

from __future__ import annotations


def strip_sql_comments(sql: str) -> str:
    """移除 SQL 注释，保留字符串内容和换行边界。

    使用状态机逐字符扫描，正确处理：
      - 单引号 / 双引号字符串内的 ``--`` 和 ``/*``
      - 行注释 ``--`` 到行尾
      - 块注释 ``/* */`` 跨行

    Args:
        sql: 原始 SQL 文本。

    Returns:
        与输入等长的字符串，注释字符替换为空格，换行符保留。
    """
    result: list[str] = []
    in_single_quote = False
    in_double_quote = False
    in_line_comment = False
    in_block_comment = False
    i = 0
    n = len(sql)

    while i < n:
        ch = sql[i]
        next_ch = sql[i + 1] if i + 1 < n else ""

        # 行注释：替换到行尾
        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
                result.append(ch)
            else:
                result.append(" ")
            i += 1
            continue

        # 块注释：替换到 */
        if in_block_comment:
            if ch == "*" and next_ch == "/":
                in_block_comment = False
                result.extend("  ")
                i += 2
            else:
                result.append("\n" if ch == "\n" else " ")
                i += 1
            continue

        # 字符串外：检测注释起始
        if not in_single_quote and not in_double_quote:
            if ch == "-" and next_ch == "-":
                in_line_comment = True
                result.extend("  ")
                i += 2
                continue
            if ch == "/" and next_ch == "*":
                in_block_comment = True
                result.extend("  ")
                i += 2
                continue

        # 字符串边界检测
        if ch == "'" and not in_double_quote:
            # Oracle 转义引号：字符串内的 '' 表示一个字面量单引号
            if in_single_quote and next_ch == "'":
                result.append(ch)
                result.append(next_ch)
                i += 2
                continue
            in_single_quote = not in_single_quote
        elif ch == '"' and not in_single_quote:
            in_double_quote = not in_double_quote

        result.append(ch)
        i += 1

    return "".join(result)
