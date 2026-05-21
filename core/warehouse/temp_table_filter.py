"""
临时表过滤器
识别和过滤数仓脚本中的临时表、备份表、交换表等，
避免它们作为血缘关系的端点污染结果。
"""

from __future__ import annotations

import logging
import re
from dataclasses import dataclass, field

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# 临时表识别规则
# ---------------------------------------------------------------------------

# 后缀模式：以这些后缀结尾的表为临时表
TEMP_SUFFIXES: tuple[str, ...] = (
    "_bk",    # 备份表 (backup)
    "_tm",    # 临时表 (temp)
    "_op",    # 操作表 (operation)
    "_cl",    # 清理表 (clean)
    "_ex",    # 交换表 (exchange partition 用的临时表)
    "_old",   # 旧表 (旧版本保留)
    "_new",   # 新表 (新版本临时)
)

# 前缀模式：以这些前缀开头的表为临时表
TEMP_PREFIXES: tuple[str, ...] = (
    "tmp_",   # 临时表前缀
    "temp_",  # 临时表前缀
)

# 正则模式：匹配临时表的附加模式
TEMP_PATTERNS: tuple[re.Pattern, ...] = (
    re.compile(r"_\d{8}$", re.IGNORECASE),      # 日期后缀如 _20240101（非分区表）
    re.compile(r"^etl_", re.IGNORECASE),          # ETL 临时表
    re.compile(r"^stg_", re.IGNORECASE),          # staging 临时表
    re.compile(r"_ex\d*$", re.IGNORECASE),        # 交换表后缀如 _ex, _ex01, _ex02（分区交换临时表）
)

# 白名单：即使匹配临时表规则也不应过滤的表名模式
WHITELIST_PATTERNS: tuple[re.Pattern, ...] = (
    # 数仓正式表含 tmp 的特殊情况（如有已知特例可添加）
)


@dataclass
class TempTableFilter:
    """临时表识别与过滤

    用法:
        filter = TempTableFilter()
        if filter.is_temp_table("cmm_abmt_remit_dtl_ex"):
            print("是临时表，应过滤")
    """

    # 可通过构造函数自定义规则
    suffixes: tuple[str, ...] = TEMP_SUFFIXES
    prefixes: tuple[str, ...] = TEMP_PREFIXES
    patterns: tuple[re.Pattern, ...] = TEMP_PATTERNS
    whitelist: tuple[re.Pattern, ...] = WHITELIST_PATTERNS

    def is_temp_table(self, table_name: str) -> bool:
        """判断表名是否为临时表

        Args:
            table_name: 表名（可能含 schema 前缀，如 "ICL.cmm_abmt_remit_dtl_ex"）

        Returns:
            True 表示是临时表
        """
        if not table_name:
            return False

        # 去掉 schema 前缀
        short_name = table_name.split(".")[-1] if "." in table_name else table_name
        short_lower = short_name.lower()

        # 白名单优先
        for pattern in self.whitelist:
            if pattern.search(short_name):
                return False

        # 后缀匹配
        for suffix in self.suffixes:
            if short_lower.endswith(suffix):
                return True

        # 前缀匹配
        for prefix in self.prefixes:
            if short_lower.startswith(prefix):
                return True

        # 正则模式匹配
        for pattern in self.patterns:
            if pattern.search(short_name):
                return True

        return False

    def filter_field_mappings(self, mappings: list[dict]) -> list[dict]:
        """过滤掉源表或目标表为临时表的字段映射

        Args:
            mappings: 字段映射列表

        Returns:
            过滤后的字段映射列表
        """
        filtered = []
        for fm in mappings:
            source = fm.get("source_table", "")
            target = fm.get("target_table", "")

            # 源表和目标表都不是临时表才保留
            if not self.is_temp_table(source) and not self.is_temp_table(target):
                filtered.append(fm)

        removed = len(mappings) - len(filtered)
        if removed > 0:
            logger.debug("过滤了 %d 条临时表字段映射", removed)

        return filtered

    def filter_table_lineages(self, lineages: list[dict]) -> list[dict]:
        """过滤掉源表或目标表为临时表的表级血缘

        Args:
            lineages: 表级血缘列表

        Returns:
            过滤后的表级血缘列表
        """
        filtered = []
        for tl in lineages:
            source = tl.get("source_table", "")
            target = tl.get("target_table", "")

            if not self.is_temp_table(source) and not self.is_temp_table(target):
                filtered.append(tl)

        removed = len(lineages) - len(filtered)
        if removed > 0:
            logger.debug("过滤了 %d 条临时表血缘关系", removed)

        return filtered

    def filter_tables(self, tables: list[dict]) -> list[dict]:
        """过滤掉临时表的表结构信息

        Args:
            tables: 表信息列表

        Returns:
            过滤后的表信息列表
        """
        filtered = [
            t for t in tables
            if not self.is_temp_table(t.get("full_name", ""))
        ]

        removed = len(tables) - len(filtered)
        if removed > 0:
            logger.debug("过滤了 %d 张临时表", removed)

        return filtered
