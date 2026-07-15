"""
血缘查询索引（LineageQueryIndex）

集中管理查询时需要的内存索引，避免每次查询重复构建全量 map/set。
构建时机：
  - 启动加载缓存后构建一次
  - 解析完成后重建一次
  - 上传增量数据合并后重建一次
  - 数据变更事件触发时清理旧索引并重建
"""

from __future__ import annotations

import logging
import time
from copy import deepcopy
from typing import Any

from core.table_name_resolver import TableNameResolver

logger = logging.getLogger(__name__)


class LineageQueryIndex:
    """血缘查询内存索引。

    提供 O(1) 或 O(k) 的表名解析、字段映射查找、表级血缘邻接读取，
    替代每次查询时对全量 tables/field_mappings/table_lineages 的扫描。
    """

    def __init__(self) -> None:
        # ── 表索引 ──
        # full_name(upper) -> table dict
        self.table_by_full: dict[str, dict] = {}
        # short_name(upper) -> list of table dicts（可能多个 schema 同名）
        self.table_by_short: dict[str, list[dict]] = {}
        # 所有完整表名集合（upper）
        self.table_full_names: set[str] = set()

        # ── 字段映射索引 ──
        # (target_table_upper, target_column_upper) -> list[mapping dict]
        self.field_mappings_by_target: dict[tuple[str, str], list[dict]] = {}
        # (source_table_upper, source_column_upper) -> list[mapping dict]
        self.field_mappings_by_source: dict[tuple[str, str], list[dict]] = {}
        # (src_bare_upper, src_col_upper, tgt_bare_upper, tgt_col_upper) -> list[mapping dict]
        self.field_mappings_by_bare_pair: dict[tuple[str, str, str, str], list[dict]] = {}

        # ── 表级血缘索引 ──
        # target_table(upper) -> list[lineage dict]
        self.table_lineages_by_target: dict[str, list[dict]] = {}
        # source_table(upper) -> list[lineage dict]
        self.table_lineages_by_source: dict[str, list[dict]] = {}

        self._built: bool = False

    @property
    def is_built(self) -> bool:
        return self._built

    def build(self, data: dict[str, Any]) -> None:
        """从完整数据字典构建所有索引。"""
        t0 = time.perf_counter()
        self.clear()

        tables = data.get("tables", [])
        field_mappings = data.get("field_mappings", [])
        table_lineages = data.get("table_lineages", [])

        self._build_table_indexes(tables)
        self._build_field_mapping_indexes(field_mappings)
        self._build_table_lineage_indexes(table_lineages)

        self._built = True
        elapsed = (time.perf_counter() - t0) * 1000
        logger.info(
            "LineageQueryIndex 构建完成: %d 表, %d 映射, %d 血缘, 耗时 %.1fms",
            len(tables),
            len(field_mappings),
            len(table_lineages),
            elapsed,
        )

    def clear(self) -> None:
        """清空所有索引。"""
        self.table_by_full.clear()
        self.table_by_short.clear()
        self.table_full_names.clear()
        self.field_mappings_by_target.clear()
        self.field_mappings_by_source.clear()
        self.field_mappings_by_bare_pair.clear()
        self.table_lineages_by_target.clear()
        self.table_lineages_by_source.clear()
        self._built = False

    def as_read_only(self) -> ReadOnlyLineageQueryIndex:
        """返回与当前构建结果隔离的只读查询外观。"""
        if not self._built:
            raise RuntimeError("LineageQueryIndex 尚未构建")
        return ReadOnlyLineageQueryIndex(self)

    # ── 表索引查询接口 ─────────────────────────────────────────

    def get_table_by_full(self, full_name: str) -> dict | None:
        """按完整表名（upper）获取表 dict。"""
        return self.table_by_full.get(full_name.upper())

    def get_tables_by_short(self, short_name: str) -> list[dict]:
        """按短名（upper）获取候选表列表。"""
        return self.table_by_short.get(short_name.upper(), [])

    def has_table(self, full_name: str) -> bool:
        """检查完整表名是否存在（upper）。"""
        return full_name.upper() in self.table_full_names

    # ── 字段映射查询接口 ───────────────────────────────────────

    def get_field_mappings_by_target(self, table: str, column: str) -> list[dict]:
        """按 (target_table, target_column) 获取映射列表。"""
        return self.field_mappings_by_target.get((table.upper(), column.upper()), [])

    def get_field_mappings_by_source(self, table: str, column: str) -> list[dict]:
        """按 (source_table, source_column) 获取映射列表。"""
        return self.field_mappings_by_source.get((table.upper(), column.upper()), [])

    def get_field_mappings_by_bare_pair(
        self, src_bare: str, src_col: str, tgt_bare: str, tgt_col: str
    ) -> list[dict]:
        """按 (src_bare, src_col, tgt_bare, tgt_col) 获取映射列表，用于 _supplement_field_mappings。"""
        return self.field_mappings_by_bare_pair.get(
            (src_bare.upper(), src_col.upper(), tgt_bare.upper(), tgt_col.upper()), []
        )

    def get_all_field_mappings_for_nodes(
        self, nodes: set[str], target_table: str = "", target_field: str = ""
    ) -> list[dict]:
        """获取源和目标表都在节点集合中的字段映射（替代原全量扫描）。

        策略：收集节点集合中所有表的字段映射，然后过滤出双端都在节点中的映射。
        这比遍历全部 field_mappings 快得多，因为只访问与节点相关的映射。
        """
        seen_keys: set[tuple] = set()
        result: list[dict] = []
        field_upper = (target_field or "").upper()

        # 通过 target 索引收集：对每个节点作为 target_table 的映射
        for node in nodes:
            node_upper = node.upper()
            # 从 target 索引中取所有以该节点为 target 的映射
            for (tgt_tbl, _tgt_col), mappings in self.field_mappings_by_target.items():
                if tgt_tbl == node_upper or tgt_tbl.split(".")[-1] == node_upper.split(".")[-1]:
                    for fm in mappings:
                        src_tbl = fm.get("source_table", "").upper()
                        src_in = self.node_in_set(src_tbl, nodes)
                        tgt_tbl_fm = fm.get("target_table", "").upper()
                        tgt_in = self.node_in_set(tgt_tbl_fm, nodes)
                        if not (src_in and tgt_in):
                            continue
                        if field_upper:
                            src_col = fm.get("source_column", "").upper()
                            tgt_col_fm = fm.get("target_column", "").upper()
                            if not (tgt_col_fm == field_upper or field_upper in tgt_col_fm or field_upper in src_col):
                                continue
                        key = (
                            fm.get("source_table", ""),
                            fm.get("source_column", ""),
                            fm.get("target_table", ""),
                            fm.get("target_column", ""),
                        )
                        if key not in seen_keys:
                            seen_keys.add(key)
                            result.append(fm)

        return result

    # ── 表级血缘查询接口 ───────────────────────────────────────

    def get_upstream_lineages(self, table: str) -> list[dict]:
        """获取指定表的上游血缘（以该表为 target）。"""
        return self.table_lineages_by_target.get(table.upper(), [])

    def get_downstream_lineages(self, table: str) -> list[dict]:
        """获取指定表的下游血缘（以该表为 source）。"""
        return self.table_lineages_by_source.get(table.upper(), [])

    # ── 短名解析（利用索引）───────────────────────────────────────

    def resolve_table_name(self, table_name: str, adjacency_keys: set[str] | None = None) -> str:
        """将短名或部分表名解析为完整表名（利用索引，替代每次扫描全量 data["tables"]）。

        解析策略（与原逻辑一致，但使用预构建索引）：
          0. 精确匹配 full_name 或 short_name
          1. 显式 schema 前缀直接返回
          2. 短名在邻接表中查找候选
        """
        table_upper = table_name.upper().strip()
        if not table_upper:
            return table_name

        # 步骤0: 精确匹配
        hit = self.table_by_full.get(table_upper)
        if hit:
            return hit.get("full_name", table_name)

        short_hits = self.table_by_short.get(table_upper)
        if short_hits:
            return short_hits[0].get("full_name", table_name)

        # 步骤1: 显式 schema 直接返回
        if "." in table_upper:
            return table_name

        # 步骤2: 邻接表候选匹配
        if adjacency_keys is None:
            adjacency_keys = set()

        candidates: list[str] = []
        for full_name in adjacency_keys:
            if full_name.upper().endswith("." + table_upper):
                candidates.append(full_name)

        if not candidates:
            return table_name

        # 优先选择在实际表定义中存在的候选
        real_candidates = [c for c in candidates if c.upper() in self.table_full_names]

        if real_candidates:
            if table_upper.startswith("EAST5_"):
                east_candidates = [c for c in real_candidates if c.upper().startswith("RRP_EAST.")]
                if east_candidates:
                    return east_candidates[0]
            schema_priority = {"RRP_EAST.": 0, "RRP_MDL.": 1, "ICL.": 2}

            def _schema_sort_key(c: str) -> tuple:
                c_upper = c.upper()
                for prefix, priority in schema_priority.items():
                    if c_upper.startswith(prefix):
                        return (priority, len(c))
                return (99, len(c))

            real_candidates.sort(key=_schema_sort_key)
            return real_candidates[0]

        return min(candidates, key=len)

    # ── 私有构建方法 ─────────────────────────────────────────────

    def _build_table_indexes(self, tables: list[dict]) -> None:
        for t in tables:
            full = t.get("full_name", "").upper()
            short = t.get("table_name", "").upper()
            if full:
                self.table_by_full[full] = t
                self.table_full_names.add(full)
            if short:
                self.table_by_short.setdefault(short, []).append(t)

    def _build_field_mapping_indexes(self, field_mappings: list[dict]) -> None:
        for fm in field_mappings:
            src_tbl = fm.get("source_table", "").upper()
            src_col = fm.get("source_column", "").upper()
            tgt_tbl = fm.get("target_table", "").upper()
            tgt_col = fm.get("target_column", "").upper()

            if tgt_tbl and tgt_col:
                self.field_mappings_by_target.setdefault((tgt_tbl, tgt_col), []).append(fm)
            if src_tbl and src_col:
                self.field_mappings_by_source.setdefault((src_tbl, src_col), []).append(fm)

            src_bare = TableNameResolver.bare_table(src_tbl).upper() if src_tbl else ""
            tgt_bare = TableNameResolver.bare_table(tgt_tbl).upper() if tgt_tbl else ""
            if src_bare and src_col and tgt_bare and tgt_col:
                self.field_mappings_by_bare_pair.setdefault(
                    (src_bare, src_col, tgt_bare, tgt_col), []
                ).append(fm)

    def _build_table_lineage_indexes(self, table_lineages: list[dict]) -> None:
        for tl in table_lineages:
            src = tl.get("source_table", "").upper()
            tgt = tl.get("target_table", "").upper()
            if tgt:
                self.table_lineages_by_target.setdefault(tgt, []).append(tl)
            if src:
                self.table_lineages_by_source.setdefault(src, []).append(tl)

    @staticmethod
    def node_in_set(table_name: str, nodes: set[str]) -> bool:
        """检查表名是否在节点集合中（支持全名和短名匹配）。"""
        upper = table_name.upper()
        if upper in nodes:
            return True
        bare = upper.split(".")[-1] if "." in upper else upper
        for node in nodes:
            node_bare = node.split(".")[-1] if "." in node else node
            if node_bare == bare:
                return True
        return False


class ReadOnlyLineageQueryIndex:
    """不暴露 builder 状态、查询结果使用防御性副本的索引视图。"""

    def __init__(self, source: LineageQueryIndex) -> None:
        self._index = deepcopy(source)

    @property
    def is_built(self) -> bool:
        return self._index.is_built

    def get_table_by_full(self, full_name: str) -> dict | None:
        return deepcopy(self._index.get_table_by_full(full_name))

    def get_tables_by_short(self, short_name: str) -> list[dict]:
        return deepcopy(self._index.get_tables_by_short(short_name))

    def has_table(self, full_name: str) -> bool:
        return self._index.has_table(full_name)

    def get_field_mappings_by_target(self, table: str, column: str) -> list[dict]:
        return deepcopy(self._index.get_field_mappings_by_target(table, column))

    def get_field_mappings_by_source(self, table: str, column: str) -> list[dict]:
        return deepcopy(self._index.get_field_mappings_by_source(table, column))

    def get_field_mappings_by_bare_pair(
        self,
        src_bare: str,
        src_col: str,
        tgt_bare: str,
        tgt_col: str,
    ) -> list[dict]:
        return deepcopy(
            self._index.get_field_mappings_by_bare_pair(src_bare, src_col, tgt_bare, tgt_col)
        )

    def get_all_field_mappings_for_nodes(
        self,
        nodes: set[str],
        target_table: str = "",
        target_field: str = "",
    ) -> list[dict]:
        return deepcopy(
            self._index.get_all_field_mappings_for_nodes(nodes, target_table, target_field)
        )

    def get_upstream_lineages(self, table: str) -> list[dict]:
        return deepcopy(self._index.get_upstream_lineages(table))

    def get_downstream_lineages(self, table: str) -> list[dict]:
        return deepcopy(self._index.get_downstream_lineages(table))

    def resolve_table_name(self, table_name: str, adjacency_keys: set[str] | None = None) -> str:
        return self._index.resolve_table_name(table_name, adjacency_keys)

    @staticmethod
    def node_in_set(table_name: str, nodes: set[str]) -> bool:
        return LineageQueryIndex.node_in_set(table_name, nodes)
