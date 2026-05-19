"""
统一表名解析器
集中管理表名的标准化、模糊匹配、短名解析、临时表判断等逻辑。
替代原先散落在 procedure_parser / lineage_tracer / lineage_service 中的重复实现。
"""

from __future__ import annotations

import logging
from typing import Optional

logger = logging.getLogger(__name__)

KNOWN_SCHEMAS: frozenset[str] = frozenset({
    "ICL", "IML", "IOL", "RRP_EAST", "RRP_MDL",
})

TEMP_TABLE_SUFFIXES: frozenset[str] = frozenset({
    "TMP", "_TMP", "TEMP", "_TEMP",
})

INVALID_TABLE_PREFIXES: tuple[str, ...] = (
    "DUAL", "ETL_", "FUN_", "SQL", "ALTER", "EXECUTE", "COMMIT", "ROLLBACK",
)

_RRP_PREFIXES: tuple[str, ...] = ("O_ICL_", "O_IML_", "O_IOL_", "O_RDW_")


class TableNameResolver:
    """统一的表名标准化与解析器。

    职责：
      - normalize: 将任意格式的表名标准化为 SCHEMA.TABLE_NAME
      - resolve: 将短名/部分名解析为完整表名
      - is_valid_table: 判断是否为有效表名
      - is_temp_table: 判断是否为临时表
      - match: 表名模糊匹配（支持 schema 差异）
    """

    def __init__(self, known_full_names: Optional[set[str]] = None):
        self._known_full_names: set[str] = {n.upper() for n in (known_full_names or set())}
        self._bare_name_index: dict[str, list[str]] = {}
        self._build_bare_name_index()

    def _build_bare_name_index(self) -> None:
        for full_name in self._known_full_names:
            bare = self._extract_bare_name(full_name)
            self._bare_name_index.setdefault(bare, []).append(full_name)

    @staticmethod
    def _extract_bare_name(full_name: str) -> str:
        upper = full_name.upper()
        return upper.split(".")[-1] if "." in upper else upper

    def normalize(self, raw_name: str, default_schema: str = "RRP_MDL") -> str:
        """将任意格式的表名标准化为 SCHEMA.TABLE_NAME。

        策略：
          1. 如果已包含已知 schema 前缀，尝试在已知表中精确匹配
          2. 如果是裸表名，查找已知表中的匹配项
          3. 找不到则用 default_schema 补全
        """
        raw = raw_name.strip().upper()
        if not raw:
            return ""

        if "." in raw:
            schema_part, tbl_part = raw.split(".", 1)
            if schema_part in KNOWN_SCHEMAS:
                best = self._find_best_match(tbl_part, preferred_schema=schema_part)
                if best:
                    return best
                return f"{schema_part}.{tbl_part}"
            return raw

        best = self._find_best_match(raw)
        if best:
            return best
        return f"{default_schema}.{raw}"

    def resolve(self, query: str) -> list[str]:
        """将短名/部分名解析为所有可能的完整表名。"""
        query_upper = query.strip().upper()
        if not query_upper:
            return []

        if query_upper in self._known_full_names:
            return [query_upper]

        bare = self._extract_bare_name(query_upper)

        results = []
        for full_name in self._known_full_names:
            full_upper = full_name.upper()
            if full_upper == query_upper:
                results.append(full_name)
            elif full_upper.endswith("." + bare):
                results.append(full_name)
            elif full_upper.endswith(query_upper):
                results.append(full_name)

        return sorted(set(results), key=len)

    def match(self, table_a: str, table_b: str) -> bool:
        """表名模糊匹配。

        匹配优先级：
          1. 完全匹配
          2. 短名完全匹配（去掉 schema 后比较）
          3. 一方是另一方的 .短名 形式
          4. 严格包含匹配（至少 6 字符，且以 .短名 结尾）
        """
        a = table_a.upper().strip()
        b = table_b.upper().strip()
        if not a or not b:
            return False

        if a == b:
            return True

        short_a = a.split(".")[-1]
        short_b = b.split(".")[-1]

        if short_a == short_b:
            return True

        if a == short_b or b == short_a:
            return True

        if len(short_a) >= 6:
            if b.endswith("." + short_a):
                return True
            if a.endswith("." + short_b):
                return True

        return False

    @staticmethod
    def bare_table(table_name: str) -> str:
        """获取裸表名并处理 O_ICL_*/ICL.*/ICL.V_* 同义词映射。

        统一实现，供 lineage_tracer / api_server 等模块共同调用，消除重复。

        映射规则：
          - RRP_MDL.O_ICL_* → ICL_*（去掉 O_ 前缀）
          - ICL.V_* → ICL_*（去掉 V_ 视图前缀，加 ICL_ 前缀）
          - ICL.XXX → ICL_XXX（加 ICL_ 前缀）
        这样 O_ICL_CMM_XXX / ICL.V_CMM_XXX / ICL.CMM_XXX 都映射到 ICL_CMM_XXX。

        Args:
            table_name: 原始表名（可能含 schema 前缀）

        Returns:
            归一化后的裸表名。
        """
        parts = table_name.split(".")
        bare = parts[-1].upper()
        schema = parts[0].upper() if len(parts) > 1 else ""

        # O_ICL_* → ICL_*
        if bare.startswith("O_ICL_"):
            return bare[2:]  # O_ICL_ → ICL_

        # ICL.V_* → ICL_* (视图前缀去掉 V_)
        if schema == "ICL" and bare.startswith("V_"):
            return f"ICL_{bare[2:]}"

        # ICL.XXX → ICL_XXX
        if schema == "ICL" and not bare.startswith("ICL_"):
            return f"ICL_{bare}"

        return bare

    @staticmethod
    def is_valid_table(table_name: str) -> bool:
        """判断是否为有效表名（排除 DUAL/ETL_/FUN_ 等系统对象）。"""
        if not table_name:
            return False
        if table_name.startswith(INVALID_TABLE_PREFIXES):
            return False
        if len(table_name) < 2:
            return False
        return True

    @staticmethod
    def is_temp_table(table_name: str) -> bool:
        """判断是否为临时表（基于命名约定：以 TMP/_TMP/TEMP/_TEMP 结尾）。"""
        if not table_name:
            return False
        upper = table_name.upper()
        return any(upper.endswith(suffix) for suffix in TEMP_TABLE_SUFFIXES)

    @staticmethod
    def match_field(field_a: str, field_b: str) -> bool:
        """字段名严格匹配（避免过度扩展导致错误血缘链路）。

        匹配规则（从严格到宽松）：
          1. 完全匹配
          2. 前缀匹配（基准 >= 5 字符，占比 >= 75%，排除脱敏后缀）
          3. 后缀匹配（合理短前缀 + 基准 >= 4 字符，占比 >= 75%）
        """
        a = field_a.upper().strip()
        b = field_b.upper().strip()

        if not a or not b:
            return False

        if a == b:
            return True

        ignore_suffixes = (
            "_DESEN", "_ORIG", "_BAK", "_NEW", "_TMP", "_TEMP",
            "_ENCRYPT", "_MASK", "_HASH",
        )

        shorter, longer = (a, b) if len(a) <= len(b) else (b, a)
        min_len = len(shorter)

        if min_len < 4:
            return False

        if longer.startswith(shorter):
            suffix = longer[min_len:]
            if any(suffix.startswith(s) for s in ignore_suffixes):
                return False
            if min_len >= 5 and (min_len / len(longer)) >= 0.75:
                return True

        if longer.endswith(shorter):
            prefix = longer[:-min_len] if len(longer) > min_len else ""
            is_valid_prefix = (
                (len(prefix) == 1 and prefix.isalpha())
                or (prefix.endswith("_") and len(prefix) <= 3)
            )
            if is_valid_prefix:
                min_len_req = 4 if len(prefix) <= 2 else 5
                if min_len >= min_len_req and (min_len / len(longer)) >= 0.75:
                    return True

        return False

    @staticmethod
    def resolve_from_mappings(table_name: str, field_mappings: list[dict]) -> str:
        """从字段映射中解析完整表名。

        如果 table_name 是短名（如 EAST5_201_GRJCXXB），
        会在字段映射中查找对应的完整名（如 RRP_EAST.EAST5_201_GRJCXXB）。
        """
        table_upper = table_name.upper()

        if "." in table_upper:
            return table_upper

        candidates: set[str] = set()
        for fm in field_mappings:
            src = fm.get("source_table", "").upper()
            tgt = fm.get("target_table", "").upper()
            if src == table_upper or tgt == table_upper:
                return table_upper
            if src.endswith("." + table_upper):
                candidates.add(src)
            if tgt.endswith("." + table_upper):
                candidates.add(tgt)

        if candidates:
            return min(candidates, key=len)

        return table_upper

    def _find_best_match(self, tbl_part: str, preferred_schema: str = "") -> str:
        """在已知表中查找最佳匹配。"""
        exact_candidates = []
        prefix_candidates = []

        for full_key in self._known_full_names:
            upper_key = full_key.upper()
            if upper_key == f"RRP_MDL.{tbl_part}" or upper_key.endswith(f".{tbl_part}"):
                exact_candidates.append(full_key)
                continue
            for pfx in _RRP_PREFIXES:
                if upper_key.endswith(f"{pfx}{tbl_part}") or upper_key == f"RRP_MDL.{pfx}{tbl_part}":
                    prefix_candidates.append(full_key)
                    break

        candidates = exact_candidates or prefix_candidates
        if not candidates:
            return ""

        if preferred_schema:
            schema_matches = [c for c in candidates if c.upper().startswith(f"{preferred_schema}.")]
            if schema_matches:
                return min(schema_matches, key=len)

        return min(candidates, key=len)
