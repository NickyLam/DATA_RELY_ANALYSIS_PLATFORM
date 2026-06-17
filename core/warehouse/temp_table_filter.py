"""
临时表过滤器
识别和过滤数仓脚本中的临时表、备份表、交换表等，
避免它们作为血缘关系的端点污染结果。
"""

from __future__ import annotations

import logging
import re
from dataclasses import dataclass

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# 临时表识别规则
# ---------------------------------------------------------------------------

# 后缀模式：以这些后缀结尾的表为临时表
TEMP_SUFFIXES: tuple[str, ...] = (
    "_bk",  # 备份表 (backup)
    "_tm",  # 临时表 (temp)
    "_tmp",  # 临时表 (temp)
    "_op",  # 操作表 (operation)
    "_cl",  # 清理表 (clean)
    "_old",  # 旧表 (旧版本保留)
    "_new",  # 新表 (新版本临时)
)

# 前缀模式：以这些前缀开头的表为临时表
TEMP_PREFIXES: tuple[str, ...] = (
    "tmp_",  # 临时表前缀
    "temp_",  # 临时表前缀
)

# 正则模式：匹配临时表的附加模式
TEMP_PATTERNS: tuple[re.Pattern, ...] = (
    re.compile(r"_\d{8}$", re.IGNORECASE),  # 日期后缀如 _20240101（非分区表）
    re.compile(r"^etl_", re.IGNORECASE),  # ETL 临时表
    re.compile(r"^stg_", re.IGNORECASE),  # staging 临时表
)

_EXCHANGE_PATTERN = re.compile(r"_ex\d*$", re.IGNORECASE)

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

        short_name = table_name.split(".")[-1] if "." in table_name else table_name
        short_lower = short_name.lower()

        for pattern in self.whitelist:
            if pattern.search(short_name):
                return False

        for suffix in self.suffixes:
            if short_lower.endswith(suffix):
                return True

        for prefix in self.prefixes:
            if short_lower.startswith(prefix):
                return True

        for pattern in self.patterns:
            if pattern.search(short_name):
                return True

        return False

    def is_exchange_table(self, table_name: str) -> bool:
        """判断表名是否为分区交换中间表（_ex / _ex01 / _ex02 后缀）

        分区交换中间表是 Oracle 数仓的常见模式：
        INSERT INTO xxx_ex SELECT ... → ALTER TABLE xxx EXCHANGE PARTITION WITH xxx_ex
        _ex 表是正式表数据的载体，不应被当作临时表过滤。

        Args:
            table_name: 表名（可能含 schema 前缀）

        Returns:
            True 表示是分区交换中间表
        """
        if not table_name:
            return False
        short_name = table_name.split(".")[-1] if "." in table_name else table_name
        return bool(_EXCHANGE_PATTERN.search(short_name))

    def resolve_exchange_table(self, table_name: str) -> str:
        """将分区交换中间表名解析为正式表名

        例如: ICL.CMM_INDV_CUST_BASIC_INFO_EX → ICL.CMM_INDV_CUST_BASIC_INFO
             IDL.SOME_TABLE_EX01 → IDL.SOME_TABLE

        Args:
            table_name: 交换表名

        Returns:
            正式表名（去掉 _ex / _ex01 后缀）
        """
        if not self.is_exchange_table(table_name):
            return table_name

        short_name = table_name.split(".")[-1] if "." in table_name else table_name
        schema = table_name.rsplit(".", 1)[0] if "." in table_name else ""

        match = _EXCHANGE_PATTERN.search(short_name)
        if match:
            formal_name = short_name[: match.start()]
            return f"{schema}.{formal_name}" if schema else formal_name

        return table_name

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
        filtered = [t for t in tables if not self.is_temp_table(t.get("full_name", ""))]

        removed = len(tables) - len(filtered)
        if removed > 0:
            logger.debug("过滤了 %d 张临时表", removed)

        return filtered
