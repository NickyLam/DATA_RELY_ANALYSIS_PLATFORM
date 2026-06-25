"""Tests for core/utils/bracket_matcher.py.

Covers T08: find_matching_paren_sql must return -1 on failure (non-paren
start, unbalanced parens) instead of the legacy ``start`` sentinel.
"""

from __future__ import annotations

from core.utils.bracket_matcher import (
    extract_parenthesized_block,
    find_matching_bracket,
    find_matching_paren_sql,
)


class TestFindMatchingParenSql:
    """find_matching_paren_sql — SQL quote-aware parenthesis matching."""

    def test_simple_match(self):
        assert find_matching_paren_sql("(a, b, c)", 0) == 8

    def test_nested_match(self):
        # (a, (b, c), d)
        # 0123456789...
        assert find_matching_paren_sql("(a, (b, c), d)", 0) == 13
        # inner pair starting at index 4 closes at index 9
        assert find_matching_paren_sql("(a, (b, c), d)", 4) == 9

    def test_non_paren_start_returns_minus_one(self):
        """When start does not point to '(', return -1 (not start)."""
        assert find_matching_paren_sql("abc", 0) == -1
        assert find_matching_paren_sql("a(b)", 0) == -1

    def test_out_of_range_start_returns_minus_one(self):
        assert find_matching_paren_sql("()", 5) == -1
        assert find_matching_paren_sql("()", -1) == -1

    def test_unbalanced_open_returns_minus_one(self):
        """Unbalanced '(' with no closing ')' must return -1."""
        assert find_matching_paren_sql("(a, b", 0) == -1
        assert find_matching_paren_sql("(a(b)", 0) == -1

    def test_paren_inside_single_quote_ignored(self):
        """Parentheses inside SQL string literals must not affect depth."""
        # The ')' inside the string should not close the outer paren
        sql = "('text with ) paren', b)"
        assert find_matching_paren_sql(sql, 0) == len(sql) - 1

    def test_escaped_single_quote_in_string(self):
        """Escaped quotes ('') inside strings must not toggle quote state."""
        sql = "('it''s a ) test', x)"
        assert find_matching_paren_sql(sql, 0) == len(sql) - 1

    def test_empty_parens(self):
        assert find_matching_paren_sql("()", 0) == 1


class TestFindMatchingBracket:
    """find_matching_bracket — simple depth counter (non-quote-aware)."""

    def test_simple_match(self):
        assert find_matching_bracket("[a, b]", 0, "[", "]") == 5

    def test_non_bracket_start_returns_minus_one(self):
        assert find_matching_bracket("abc", 0, "(", ")") == -1

    def test_unbalanced_returns_minus_one(self):
        assert find_matching_bracket("(a, b", 0, "(", ")") == -1


class TestExtractParenthesizedBlock:
    """extract_parenthesized_block — content extraction helper."""

    def test_extracts_inner_content(self):
        assert extract_parenthesized_block("(a, b, c)", 0) == "a, b, c"

    def test_no_match_returns_empty(self):
        assert extract_parenthesized_block("(a, b", 0) == ""

    def test_non_paren_start_returns_empty(self):
        assert extract_parenthesized_block("abc", 0) == ""
