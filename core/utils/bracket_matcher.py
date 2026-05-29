"""
Shared bracket/parenthesis matching utilities.

Consolidates the bracket-depth-tracking pattern used across multiple parsers
(caliber_extractor, table_parser, field_cleaner, etc.) into reusable functions.
"""

from __future__ import annotations


def find_matching_bracket(
    text: str,
    start: int,
    open_char: str = "(",
    close_char: str = ")",
) -> int:
    """Find the matching close bracket starting from an open bracket position.

    Simple depth counter without quote-awareness. Use
    ``find_matching_paren_sql`` when the text may contain SQL string literals.

    Args:
        text: Source text.
        start: Index of the opening bracket character.
        open_char: Opening bracket character.
        close_char: Closing bracket character.

    Returns:
        Index of the matching closing bracket, or -1 if unbalanced.
    """
    if start >= len(text) or text[start] != open_char:
        return -1

    depth = 0
    i = start
    while i < len(text):
        if text[i] == open_char:
            depth += 1
        elif text[i] == close_char:
            depth -= 1
            if depth == 0:
                return i
        i += 1
    return -1


def find_matching_paren_sql(text: str, start: int) -> int:
    """Find matching ')' from a '(' position, respecting SQL single-quote strings.

    Handles escaped single quotes (\'\'). This is the quote-aware variant
    suitable for use inside SQL/PLSQL text blocks.

    Args:
        text: Source text (SQL/PLSQL).
        start: Index of the opening '(' character.

    Returns:
        Index of the matching ')', or ``start`` if unbalanced (legacy compat).
    """
    if start >= len(text) or text[start] != "(":
        return start

    depth = 0
    in_single_quote = False
    i = start

    while i < len(text):
        ch = text[i]
        if ch == "'" and not in_single_quote:
            in_single_quote = True
        elif ch == "'" and in_single_quote:
            if i + 1 < len(text) and text[i + 1] == "'":
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

    return start


def extract_parenthesized_block(text: str, start: int) -> str:
    """Extract the content between matching parentheses (exclusive of parens).

    Args:
        text: Source text.
        start: Index of the opening '(' character.

    Returns:
        The substring between the opening and closing parens, or empty string
        if no match is found.
    """
    end = find_matching_bracket(text, start)
    if end == -1:
        return ""
    return text[start + 1 : end]
