"""Core layer shared utility functions"""
from __future__ import annotations

from core.utils.bracket_matcher import find_matching_bracket, find_matching_paren_sql
from core.warehouse.temp_table_filter import TempTableFilter

# Alias for the SQL-aware parenthesis matcher
find_matching_paren = find_matching_paren_sql

# 共享单例：所有 core.utils.is_temp_table 调用方使用同一套规则
_shared_temp_filter = TempTableFilter()


def is_temp_table(table_name: str) -> bool:
    """Check if a table name matches temporary table patterns.

    委托到共享 TempTableFilter 单例，确保与 core.warehouse.temp_table_filter
    使用同一套规则（后缀/前缀/正则模式），避免规则不一致。
    """
    return _shared_temp_filter.is_temp_table(table_name)
