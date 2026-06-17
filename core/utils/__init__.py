"""Core layer shared utility functions"""
from __future__ import annotations

from core.utils.bracket_matcher import find_matching_bracket, find_matching_paren_sql

# Alias for the SQL-aware parenthesis matcher
find_matching_paren = find_matching_paren_sql


def is_temp_table(table_name: str) -> bool:
    """Check if a table name matches temporary table patterns."""
    name = table_name.strip().upper()
    temp_suffixes = ("_TMP", "_TEMP", "_BK", "_TM", "_OP")
    temp_prefixes = ("TMP_", "TEMP_")
    if any(name.endswith(s) for s in temp_suffixes):
        return True
    if any(name.startswith(p) for p in temp_prefixes):
        return True
    return False
