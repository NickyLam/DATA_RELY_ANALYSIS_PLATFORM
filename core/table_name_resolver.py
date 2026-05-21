"""
统一表名解析器（可配置化版本）

集中管理表名的标准化、模糊匹配、短名解析、临时表判断等逻辑。
支持从 LayerDetector 的 LayerConfig 获取 known_schemas / default_schema / synonym_rules，
实现多系统可配置化，同时完全保留 RRP 原有行为确保零回归。
"""

from __future__ import annotations

import logging
from typing import Optional

from core.layer_detector import LayerDetector, LayerConfig

logger = logging.getLogger(__name__)

TEMP_TABLE_SUFFIXES: frozenset[str] = frozenset({
    "TMP", "_TMP", "TEMP", "_TEMP",
})

INVALID_TABLE_PREFIXES: tuple[str, ...] = (
    "DUAL", "ETL_", "FUN_", "SQL", "ALTER", "EXECUTE", "COMMIT", "ROLLBACK",
)

_RRP_PREFIXES: tuple[str, ...] = ("O_ICL_", "O_IML_", "O_IOL_", "O_RDW_")

_RRP_KNOWN_SCHEMAS: frozenset[str] = frozenset({
    "ICL", "IML", "IOL", "RRP_EAST", "RRP_MDL",
})


class TableNameResolver:
    """统一的表名标准化与解析器（可配置化版本）。

    支持两种初始化模式：
      1. 传入 LayerDetector：从 manifest 配置动态获取 known_schemas / default_schema / synonym_rules
      2. 不传 LayerDetector：回退到 RRP 硬编码默认值，确保向后兼容

    职责：
      - normalize: 将任意格式的表名标准化为 SCHEMA.TABLE_NAME
      - resolve: 将短名/部分名解析为完整表名
      - is_valid_table: 判断是否为有效表名
      - is_temp_table: 判断是否为临时表
      - match: 表名模糊匹配（支持 schema 差异）
    """

    def __init__(
        self,
        known_full_names: Optional[set[str]] = None,
        layer_detector: Optional[LayerDetector] = None,
    ):
        self._known_full_names: set[str] = {n.upper() for n in (known_full_names or set())}
        self._bare_name_index: dict[str, list[str]] = {}
        self._layer_detector = layer_detector
        self._build_bare_name_index()

    def _get_config(self, system: str = "rrp") -> LayerConfig:
        if self._layer_detector:
            return self._layer_detector.get_layer_config(system)
        return LayerConfig()

    def _get_known_schemas(self, system: str = "rrp") -> frozenset[str]:
        config = self._get_config(system)
        if config.known_schemas:
            return frozenset(s.upper() for s in config.known_schemas)
        return _RRP_KNOWN_SCHEMAS

    def _get_default_schema(self, system: str = "rrp") -> str:
        config = self._get_config(system)
        return config.default_schema or "RRP_MDL"

    def _build_bare_name_index(self) -> None:
        for full_name in self._known_full_names:
            bare = self._extract_bare_name(full_name)
            self._bare_name_index.setdefault(bare, []).append(full_name)

    @staticmethod
    def _extract_bare_name(full_name: str) -> str:
        upper = full_name.upper()
        return upper.split(".")[-1] if "." in upper else upper

    def normalize(self, raw_name: str, default_schema: str = "", system: str = "rrp") -> str:
        effective_schema = default_schema or self._get_default_schema(system)
        known_schemas = self._get_known_schemas(system)

        raw = raw_name.strip().upper()
        if not raw:
            return ""

        if "." in raw:
            schema_part, tbl_part = raw.split(".", 1)
            if schema_part in known_schemas:
                best = self._find_best_match(tbl_part, preferred_schema=schema_part)
                if best:
                    return best
                return f"{schema_part}.{tbl_part}"
            return raw

        best = self._find_best_match(raw)
        if best:
            return best
        return f"{effective_schema}.{raw}"

    def resolve(self, query: str) -> list[str]:
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
    def bare_table(table_name: str, system: str = "rrp") -> str:
        parts = table_name.split(".")
        bare = parts[-1].upper()
        schema = parts[0].upper() if len(parts) > 1 else ""

        if bare.startswith("O_ICL_"):
            return bare[2:]

        if schema == "ICL" and bare.startswith("V_"):
            return f"ICL_{bare[2:]}"

        if schema == "ICL" and not bare.startswith("ICL_"):
            return f"ICL_{bare}"

        return bare

    @staticmethod
    def is_valid_table(table_name: str) -> bool:
        if not table_name:
            return False
        if table_name.startswith(INVALID_TABLE_PREFIXES):
            return False
        if len(table_name) < 2:
            return False
        return True

    @staticmethod
    def is_temp_table(table_name: str) -> bool:
        if not table_name:
            return False
        upper = table_name.upper()
        return any(upper.endswith(suffix) for suffix in TEMP_TABLE_SUFFIXES)

    @staticmethod
    def match_field(field_a: str, field_b: str) -> bool:
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
