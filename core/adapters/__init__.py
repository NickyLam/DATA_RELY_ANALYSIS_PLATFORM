"""
解析器适配器包
将现有解析器适配为 FileParser Protocol，无需修改原始代码。
"""

from core.adapters.oracle_tab_adapter import OracleTabAdapter
from core.adapters.oracle_prc_adapter import OraclePrcAdapter
from core.adapters.indicator_adapter import IndicatorAdapter

__all__ = ["OracleTabAdapter", "OraclePrcAdapter", "IndicatorAdapter"]
