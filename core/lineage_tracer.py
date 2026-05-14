"""
字段级数据血缘 BFS 递归上溯引擎

核心算法：
  1. 从目标字段出发，按 BFS 逐层向上追溯上游来源
  2. 每层查找"加工了当前表"的存储过程，再从过程的 field_mappings 中定位来源字段
  3. 支持 TMP 表内部链路（同一过程内 INSERT→SELECT 多步链路）
  4. 支持多链路（UNION ALL 等合并场景返回多条 FieldLineageChain）
  5. 循环依赖检测，避免无限递归
"""

from __future__ import annotations

import logging
import time
from collections import deque
from dataclasses import dataclass, field as dataclass_field
from typing import Optional

from core.models import (
    FieldLineageChain,
    FieldLineageNode,
    FieldLineageResult,
    FieldMapping,
    ProcedureInfo,
    TableInfo,
    TableLineage,
    detect_layer,
)

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# 内部数据结构：BFS 遍历中的节点
# ---------------------------------------------------------------------------
@dataclass
class _BFSNode:
    """BFS 队列中的一个待探索节点"""

    table_name: str
    field_name: str
    layer: int
    procedure: str = ""
    transform_logic: str = ""
    parent_key: str = ""  # 父节点的唯一标识，用于回溯构建链路


@dataclass
class _SourceRecord:
    """_find_source_fields 返回的一条来源记录"""

    source_table: str
    source_field: str
    transform_logic: str
    procedure: str
    confidence: float


@dataclass
class _TargetRecord:
    """_find_target_fields 返回的一条下游目标记录"""

    target_table: str
    target_field: str
    transform_logic: str
    procedure: str
    confidence: float


# ===========================================================================
# 主类：LineageTracer
# ===========================================================================
class LineageTracer:
    """字段级血缘 BFS 递归追溯引擎。

    使用方式::

        tracer = LineageTracer(tables, procedures, table_lineages, field_mappings)
        result = tracer.trace_field("EAST5_KHXXB", "KHTYBH")
        for chain in result.chains:
            for node in chain.chain:
                print(f"  L{node.layer}: {node.table_name}.{node.field_name}")
    """

    def __init__(
        self,
        tables: dict[str, TableInfo],
        procedures: dict[str, ProcedureInfo],
        table_lineages: list[TableLineage],
        field_mappings: list[FieldMapping],
        max_depth: int = 10,
    ) -> None:
        self.tables: dict[str, TableInfo] = tables
        self.procedures: dict[str, ProcedureInfo] = procedures
        self.table_lineages: list[TableLineage] = table_lineages
        self.field_mappings: list[FieldMapping] = field_mappings
        self.max_depth: int = max_depth

        # 索引（在 _build_index 中填充）
        self._table_lineage_idx: dict[str, list[TableLineage]] = {}
        self._field_mapping_idx: dict[str, dict[str, list[FieldMapping]]] = {}
        self._source_field_mapping_idx: dict[str, dict[str, list[FieldMapping]]] = {}  # 反向索引
        self._proc_target_idx: dict[str, list[ProcedureInfo]] = {}
        self._table_proc_idx: dict[str, list[ProcedureInfo]] = {}

        self._build_index()
        logger.info(
            "LineageTracer 初始化完成: %d 张表, %d 个过程, %d 条表级血缘, %d 条字段映射",
            len(tables),
            len(procedures),
            len(table_lineages),
            len(field_mappings),
        )

    # ===================================================================
    # 公开 API
    # ===================================================================

    def trace_field(self, target_table: str, target_field: str) -> FieldLineageResult:
        """追溯单个字段的完整上游链路，返回 FieldLineageResult（可能含多条链路）。

        Args:
            target_table: 目标表名（如 EAST5_KHXXB）
            target_field:  目标字段名（如 KHTYBH）

        Returns:
            FieldLineageResult，包含所有可能的追溯链路及统计信息。
        """
        t0 = time.perf_counter()

        norm_table = self._normalize_table_name(target_table)
        norm_field = self._normalize_field_name(target_field)

        logger.info("开始追溯字段: %s.%s", norm_table, norm_field)

        chains = self.trace_field_upstream(norm_table, norm_field, self.max_depth)

        elapsed_ms = (time.perf_counter() - t0) * 1000

        all_tables: set[str] = set()
        all_procs: set[str] = set()
        total_nodes = 0
        max_depth_found = 0

        for chain in chains:
            total_nodes += chain.node_count
            all_tables.update(chain.tables_involved)
            all_procs.update(chain.procedures_involved)
            if chain.depth > max_depth_found:
                max_depth_found = chain.depth

        result = FieldLineageResult(
            target_table=norm_table,
            target_field=norm_field,
            chains=chains,
            total_nodes=total_nodes,
            total_tables=len(all_tables),
            total_procedures=len(all_procs),
            max_depth=max_depth_found,
            query_time_ms=round(elapsed_ms, 2),
        )

        logger.info(
            "追溯完成: %s.%s → %d 条链路, %d 个节点, 耗时 %.2fms",
            norm_table,
            norm_field,
            len(chains),
            total_nodes,
            elapsed_ms,
        )
        return result

    def trace_field_upstream(
        self, target_table: str, target_field: str, max_depth: int = 10
    ) -> list[FieldLineageChain]:
        """返回所有可能的上溯链路列表。

        Args:
            target_table: 目标表名
            target_field:  目标字段名
            max_depth:     最大追溯深度

        Returns:
            所有完整链路的列表，每条链路从源头到目标的节点序列。
        """
        norm_table = self._normalize_table_name(target_table)
        norm_field = self._normalize_field_name(target_field)
        bfs_tree = self._bfs_trace(norm_table, norm_field, max_depth)
        chains = self._build_chains_from_bfs_tree(bfs_tree, (norm_table, norm_field))
        return chains

    def get_upstream_tables(self, table_name: str) -> list[str]:
        """获取直接上游表（一层）。

        Args:
            table_name: 表名

        Returns:
            直接上游表名列表。
        """
        norm_table = self._normalize_table_name(table_name)
        lineages = self._table_lineage_idx.get(norm_table, [])
        upstream: set[str] = set()
        for tl in lineages:
            src = self._normalize_table_name(tl.source_table)
            if src and src != norm_table:
                upstream.add(src)
        return sorted(upstream)

    def get_downstream_tables(self, table_name: str) -> list[str]:
        """获取直接下游表（一层）。

        Args:
            table_name: 表名

        Returns:
            直接下游表名列表。
        """
        norm_table = self._normalize_table_name(table_name)
        downstream: set[str] = set()
        for tl in self.table_lineages:
            src = self._normalize_table_name(tl.source_table)
            tgt = self._normalize_table_name(tl.target_table)
            if src == norm_table and tgt != norm_table:
                downstream.add(tgt)
        return sorted(downstream)

    # ===================================================================
    # 索引预构建
    # ===================================================================

    def _build_index(self) -> None:
        """预构建 4 个字典索引，将 O(N) 查询降为 O(1)。

        构建的索引：
          - _table_lineage_idx: {target_table: [TableLineage]}
          - _field_mapping_idx: {target_table: {target_field: [FieldMapping]}}
          - _proc_target_idx:   {target_table: [ProcedureInfo]}
          - _table_proc_idx:   {table_name: [ProcedureInfo]}
        """
        # 1) 表级血缘索引：按目标表聚合
        for tl in self.table_lineages:
            tgt = self._normalize_table_name(tl.target_table)
            self._table_lineage_idx.setdefault(tgt, []).append(tl)

        # 2) 字段映射索引：按 (目标表, 目标字段) 二级聚合
        for fm in self.field_mappings:
            tgt_tbl = self._normalize_table_name(fm.target_table)
            tgt_col = self._normalize_field_name(fm.target_column)
            inner = self._field_mapping_idx.setdefault(tgt_tbl, {})
            inner.setdefault(tgt_col, []).append(fm)

        # 3) 过程→目标表反向索引：哪些过程加工了某表
        for proc in self.procedures.values():
            for tgt in proc.target_tables:
                norm_tgt = self._normalize_table_name(tgt)
                self._proc_target_idx.setdefault(norm_tgt, []).append(proc)

        # 4) 表→过程正向索引：某表出现在哪些过程里（source/target/temp 均计入）
        for proc in self.procedures.values():
            all_tables_in_proc: set[str] = set()
            all_tables_in_proc.update(proc.source_tables)
            all_tables_in_proc.update(proc.target_tables)
            all_tables_in_proc.update(proc.temp_tables)
            for t in all_tables_in_proc:
                norm_t = self._normalize_table_name(t)
                self._table_proc_idx.setdefault(norm_t, []).append(proc)

        # 5) 反向索引：按 (source_table, source_column) 聚合，用于下游追溯
        for fm in self.field_mappings:
            src_tbl = self._normalize_table_name(fm.source_table)
            src_col = self._normalize_field_name(fm.source_column)
            if not src_tbl or not src_col:
                continue
            inner = self._source_field_mapping_idx.setdefault(src_tbl, {})
            inner.setdefault(src_col, []).append(fm)

        logger.debug(
            "索引构建完成: table_lineage_idx=%d, field_mapping_idx=%d, "
            "source_field_mapping_idx=%d, proc_target_idx=%d, table_proc_idx=%d",
            len(self._table_lineage_idx),
            len(self._field_mapping_idx),
            len(self._source_field_mapping_idx),
            len(self._proc_target_idx),
            len(self._table_proc_idx),
        )

    # ===================================================================
    # 核心 BFS 算法
    # ===================================================================

    def _bfs_trace(
        self, target_table: str, target_field: str, max_depth: int = 10
    ) -> dict[str, _BFSNode]:
        """BFS 核心算法：逐层上溯字段的全部上游来源。

        算法流程：
          1. 队列初始节点：(target_table, target_field, layer=0)
          2. 出队一个节点 → 查找加工它的存储过程
          3. 在该过程的 field_mappings 中找到 target_field 的来源字段
          4. 每个来源字段入队（layer+1），记录边信息
          5. 重复直到队列为空或超过 max_depth
          6. 收集所有完整链路（从叶子到根的路径）

        Args:
            target_table: 目标表名
            target_field:  目标字段名
            max_depth:     最大追溯层数

        Returns:
            bfs_tree: {node_key: _BFSNode}，其中 node_key = "TABLE.FIELD"
        """
        norm_table = self._normalize_table_name(target_table)
        norm_field = self._normalize_field_name(target_field)

        root_key = f"{norm_table}.{norm_field}"
        visited: set[str] = set()

        # bfs_tree 记录所有访问过的节点及其父子关系
        bfs_tree: dict[str, _BFSNode] = {}

        root_node = _BFSNode(
            table_name=norm_table,
            field_name=norm_field,
            layer=0,
            procedure="",
            transform_logic="(目标字段)",
            parent_key="",
        )
        bfs_tree[root_key] = root_node
        visited.add(root_key)

        queue: deque[_BFSNode] = deque([root_node])

        while queue:
            current = queue.popleft()

            if current.layer >= max_depth:
                logger.debug(
                    "达到最大深度 %d，停止扩展: %s.%s",
                    max_depth,
                    current.table_name,
                    current.field_name,
                )
                continue

            sources = self._find_source_fields(
                current.table_name, current.field_name
            )

            if not sources:
                logger.debug(
                    "L%d %s.%s → 无上游来源（叶子节点）",
                    current.layer,
                    current.table_name,
                    current.field_name,
                )
                continue

            current_key = f"{current.table_name}.{current.field_name}"

            for src in sources:
                src_norm_table = self._normalize_table_name(src.source_table)
                src_norm_field = self._normalize_field_name(src.source_field)
                src_key = f"{src_norm_table}.{src_norm_field}"

                if not src_norm_table or not src_norm_field:
                    continue

                # 循环依赖检测：同时检查完整 key 和裸表名 key（防止 schema 变体环路）
                bare_key = ""
                if "." in src_norm_table:
                    bare_tbl = src_norm_table.split(".")[-1]
                    bare_key = f"{bare_tbl}.{src_norm_field}"

                if src_key in visited or (bare_key and bare_key in visited):
                    logger.debug(
                        "检测到循环依赖，跳过: %s → %s (bare=%s)",
                        current_key,
                        src_key,
                        bare_key,
                    )
                    continue

                visited.add(src_key)
                if bare_key:
                    visited.add(bare_key)

                src_layer = current.layer + 1
                src_node = _BFSNode(
                    table_name=src_norm_table,
                    field_name=src_norm_field,
                    layer=src_layer,
                    procedure=src.procedure,
                    transform_logic=src.transform_logic,
                    parent_key=current_key,
                )
                bfs_tree[src_key] = src_node
                queue.append(src_node)

                logger.debug(
                    "L%d %s.%s ← L%d %s.%s [%s] %s",
                    src_layer,
                    src_norm_table,
                    src_norm_field,
                    current.layer,
                    current.table_name,
                    current.field_name,
                    src.procedure,
                    src.transform_logic or "(直传)",
                )

        logger.info(
            "BFS 遍历结束: 根节点=%s, 共访问 %d 个节点",
            root_key,
            len(bfs_tree),
        )
        return bfs_tree

    def trace_field_downstream(
        self, source_table: str, source_field: str, max_depth: int = 10
    ) -> list[FieldLineageChain]:
        """返回所有可能的下游追溯链路列表。

        Args:
            source_table: 起始表名
            source_field:  起始字段名
            max_depth:     最大追溯深度

        Returns:
            所有完整链路的列表，每条链路从源头到目标的节点序列。
        """
        norm_table = self._normalize_table_name(source_table)
        norm_field = self._normalize_field_name(source_field)
        bfs_tree = self._bfs_trace_downstream(norm_table, norm_field, max_depth)
        chains = self._build_chains_from_bfs_tree(bfs_tree, (norm_table, norm_field), reverse=True)
        return chains

    def _bfs_trace_downstream(
        self, source_table: str, source_field: str, max_depth: int = 10
    ) -> dict[str, _BFSNode]:
        """BFS 核心算法：逐层向下追溯字段的全部下游去向。

        与 _bfs_trace 方向相反：从起始字段出发，查找所有以该字段为来源的目标字段。

        Args:
            source_table: 起始表名
            source_field:  起始字段名
            max_depth:     最大追溯层数

        Returns:
            bfs_tree: {node_key: _BFSNode}
        """
        norm_table = self._normalize_table_name(source_table)
        norm_field = self._normalize_field_name(source_field)

        root_key = f"{norm_table}.{norm_field}"
        visited: set[str] = set()

        bfs_tree: dict[str, _BFSNode] = {}

        root_node = _BFSNode(
            table_name=norm_table,
            field_name=norm_field,
            layer=0,
            procedure="",
            transform_logic="(起始字段)",
            parent_key="",
        )
        bfs_tree[root_key] = root_node
        visited.add(root_key)

        queue: deque[_BFSNode] = deque([root_node])

        while queue:
            current = queue.popleft()

            if current.layer >= max_depth:
                logger.debug(
                    "达到最大深度 %d，停止扩展: %s.%s",
                    max_depth,
                    current.table_name,
                    current.field_name,
                )
                continue

            targets = self._find_target_fields(
                current.table_name, current.field_name
            )

            if not targets:
                logger.debug(
                    "L%d %s.%s → 无下游去向（叶子节点）",
                    current.layer,
                    current.table_name,
                    current.field_name,
                )
                continue

            current_key = f"{current.table_name}.{current.field_name}"

            for tgt in targets:
                tgt_norm_table = self._normalize_table_name(tgt.target_table)
                tgt_norm_field = self._normalize_field_name(tgt.target_field)
                tgt_key = f"{tgt_norm_table}.{tgt_norm_field}"

                if not tgt_norm_table or not tgt_norm_field:
                    continue

                # 循环依赖检测：同时检查完整 key 和裸表名 key（防止 schema 变体环路）
                bare_key = ""
                if "." in tgt_norm_table:
                    bare_tbl = tgt_norm_table.split(".")[-1]
                    bare_key = f"{bare_tbl}.{tgt_norm_field}"

                if tgt_key in visited or (bare_key and bare_key in visited):
                    logger.debug(
                        "检测到循环依赖，跳过: %s → %s (bare=%s)",
                        current_key,
                        tgt_key,
                        bare_key,
                    )
                    continue

                visited.add(tgt_key)
                if bare_key:
                    visited.add(bare_key)

                tgt_layer = current.layer + 1
                tgt_node = _BFSNode(
                    table_name=tgt_norm_table,
                    field_name=tgt_norm_field,
                    layer=tgt_layer,
                    procedure=tgt.procedure,
                    transform_logic=tgt.transform_logic,
                    parent_key=current_key,
                )
                bfs_tree[tgt_key] = tgt_node
                queue.append(tgt_node)

                logger.debug(
                    "L%d %s.%s → L%d %s.%s [%s] %s",
                    current.layer,
                    current.table_name,
                    current.field_name,
                    tgt_layer,
                    tgt_norm_table,
                    tgt_norm_field,
                    tgt.procedure,
                    tgt.transform_logic or "(直传)",
                )

        logger.info(
            "下游 BFS 遍历结束: 根节点=%s, 共访问 %d 个节点",
            root_key,
            len(bfs_tree),
        )
        return bfs_tree

    def _find_target_fields(
        self, source_table: str, source_field: str
    ) -> list[_TargetRecord]:
        """查找 source_table.source_field 的所有下游目标字段。

        使用反向索引 _source_field_mapping_idx，按 (source_table, source_field) 查找
        所有 FieldMapping 记录，返回 target_table / target_field。

        同时支持模糊匹配（schema 前缀差异），并合并所有同裸表名的 schema 变体结果。

        Args:
            source_table: 来源表名
            source_field:  来源字段名

        Returns:
            下游目标字段列表。
        """
        norm_table = self._normalize_table_name(source_table)
        norm_field = self._normalize_field_name(source_field)
        results: list[_TargetRecord] = []
        seen_keys: set[str] = set()  # 用于去重：(target_table, target_field)

        def _bare_table(table_name: str) -> str:
            """获取裸表名并处理 O_ICL_*/ICL.*/ICL.V_* 同义词映射。"""
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

        def _collect_from_idx(tbl_key: str) -> None:
            """从反向索引中收集指定 key 的映射，去重后追加到 results。"""
            tbl_idx = self._source_field_mapping_idx.get(tbl_key)
            if not tbl_idx:
                return
            mappings = tbl_idx.get(norm_field, [])
            for fm in mappings:
                tgt_tbl = self._normalize_table_name(fm.target_table)
                tgt_col = self._normalize_table_name(fm.target_column)
                if not tgt_tbl or not tgt_col:
                    continue
                # 使用同义裸表名去重
                dedup_key = f"{_bare_table(tgt_tbl)}.{tgt_col}"
                if dedup_key in seen_keys:
                    continue
                seen_keys.add(dedup_key)
                results.append(
                    _TargetRecord(
                        target_table=tgt_tbl,
                        target_field=tgt_col,
                        transform_logic=fm.transform_logic,
                        procedure=fm.procedure,
                        confidence=fm.confidence,
                    )
                )

        # 策略1: 精确匹配
        _collect_from_idx(norm_table)

        # 策略2: 模糊匹配（schema 前缀差异）
        if not results:
            fuzzy_table = self._fuzzy_match_source_table_key(norm_table)
            if fuzzy_table:
                _collect_from_idx(fuzzy_table)

        # 策略3: 合并所有同裸表名的 schema 变体
        bare_name = norm_table.split(".")[-1] if "." in norm_table else norm_table
        if bare_name != norm_table:
            _collect_from_idx(bare_name)
        else:
            for key in self._source_field_mapping_idx:
                if "." in key:
                    key_bare = key.split(".")[-1]
                    if key_bare.upper() == bare_name.upper():
                        _collect_from_idx(key)

        if not results:
            logger.debug(
                "未找到 %s.%s 的任何下游目标字段",
                norm_table,
                norm_field,
            )

        return results

    def _fuzzy_match_source_table_key(self, table_name: str) -> Optional[str]:
        """在 source_field_mapping_idx 的所有 key 中模糊匹配表名。

        与 _fuzzy_match_table_key 相同策略：后缀匹配 + 裸表名跨 schema 匹配。
        """
        upper_name = table_name.upper()
        bare_name = upper_name.split(".")[-1] if "." in upper_name else upper_name

        for key in self._source_field_mapping_idx:
            key_upper = key.upper()
            if key_upper.endswith(upper_name):
                return key
            if bare_name and "." in key_upper:
                key_bare = key_upper.split(".")[-1]
                if key_bare == bare_name:
                    return key
        return None

    def _find_source_fields(
        self, target_table: str, target_field: str
    ) -> list[_SourceRecord]:
        """在给定存储过程中，查找 target_table.target_field 的所有来源字段。

        查找策略（按优先级）：
          0. 如果目标表无直接映射，尝试通过同名 TMP 表桥接（ETL 常见模式）
          1. 从全局 field_mapping_idx 中查找该 (target_table, target_field) 的映射
          2. 索引未命中，回退到加工该表的过程的 field_mappings 中查找
          3. 尝试表名模糊匹配（处理 schema 前缀差异）

        Args:
            target_table: 目标表名
            target_field:  目标字段名

        Returns:
            来源字段列表，每个元素包含 source_table / source_field /
            transform_logic / procedure / confidence。
        """
        norm_table = self._normalize_table_name(target_table)
        norm_field = self._normalize_field_name(target_field)
        results: list[_SourceRecord] = []

        # ---- 策略一：从预建索引中直接查找 ----
        # 索引 key 可能是短表名或带 schema 前缀的表名
        # 同时收集所有同裸表名的 schema 变体结果
        seen_keys: set[str] = set()  # 用于去重：(source_table, source_field)

        def _bare_table(table_name: str) -> str:
            """获取裸表名并处理 O_ICL_*/ICL.* 同义词映射。

            O_ICL_* → 去掉 O_ 前缀（O_ICL_CMM_XXX → ICL_CMM_XXX）
            ICL.V_* → 去掉 V_ 视图前缀后加 ICL_ 前缀（ICL.V_CMM_XXX → ICL_CMM_XXX）
            ICL.XXX → 加 ICL_ 前缀（ICL.CMM_XXX → ICL_CMM_XXX）
            这样 O_ICL_CMM_XXX / ICL.V_CMM_XXX / ICL.CMM_XXX 都映射到 ICL_CMM_XXX，实现同义去重。
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

        def _collect_source_from_idx(tbl_key: str) -> None:
            tbl_idx = self._field_mapping_idx.get(tbl_key)
            if not tbl_idx:
                return
            mappings = tbl_idx.get(norm_field, [])
            for fm in mappings:
                src_table = self._normalize_table_name(fm.source_table)
                src_col = self._normalize_field_name(fm.source_column)
                if not src_col:
                    continue
                if not src_table:
                    src_table = self._infer_source_table_from_lineage(
                        norm_table, fm.procedure
                    )
                if not src_table:
                    continue
                # 使用同义裸表名去重，O_ICL_*/ICL.* 映射到相同 key，
                # 避免同一逻辑来源被重复收集
                dedup_key = f"{_bare_table(src_table)}.{src_col}"
                if dedup_key in seen_keys:
                    continue
                seen_keys.add(dedup_key)
                results.append(
                    _SourceRecord(
                        source_table=src_table,
                        source_field=src_col,
                        transform_logic=fm.transform_logic,
                        procedure=fm.procedure,
                        confidence=fm.confidence,
                    )
                )

        # 1a) 精确匹配
        _collect_source_from_idx(norm_table)

        # 1b) 模糊匹配（schema 前缀差异）
        if not results:
            fuzzy_table = self._fuzzy_match_table_key(norm_table)
            if fuzzy_table:
                _collect_source_from_idx(fuzzy_table)

        # 1c) 合并所有同裸表名的 schema 变体
        # 当精确匹配无结果时，尝试从不同 schema 前缀的索引 key 中查找
        bare_name = norm_table.split(".")[-1] if "." in norm_table else norm_table
        if bare_name != norm_table:
            _collect_source_from_idx(bare_name)
        else:
            for key in self._field_mapping_idx:
                if "." in key:
                    key_bare = key.split(".")[-1]
                    if key_bare.upper() == bare_name.upper():
                        _collect_source_from_idx(key)

        if results:
            return results

        # ---- 策略二：TMP 表桥接 ----
        # ETL 常见模式：正式表 ← TMP表 ← 来源表
        # 当正式表无直接映射时，检查是否存在同名 TMP 表有该字段的映射
        tmp_bridge = self._try_tmp_bridge(norm_table, norm_field)
        if tmp_bridge:
            logger.info(
                "TMP 桥接命中: %s.%s → %s.%s",
                norm_table, norm_field,
                tmp_bridge.source_table, tmp_bridge.source_field,
            )
            return [tmp_bridge]

        # ---- 策略三：通过过程查找 ----
        procs = self._find_procedures_for_table(norm_table)
        for proc in procs:
            proc_results = self._find_source_fields_in_procedure(
                norm_table, norm_field, proc
            )
            results.extend(proc_results)

        if not results:
            logger.debug(
                "未找到 %s.%s 的任何来源字段（%d 个候选过程）",
                norm_table,
                norm_field,
                len(procs),
            )

        return results

    def _try_tmp_bridge(self, target_table: str, target_field: str) -> Optional[_SourceRecord]:
        """尝试通过 TMP 表桥接查找来源。

        当目标正式表（如 EAST5_KHXXB）没有直接的 field_mapping 时，
        检查其对应的临时表（如 EAST5_KHXXB_TMP）是否有同名字段的映射。
        支持模糊匹配：用户可能输入不带 schema 前缀的表名。

        Args:
            target_table: 目标正式表名
            target_field:  目标字段名

        Returns:
            找到时返回以 TMP 表为 source 的 _SourceRecord，否则 None。
        """
        base_name = target_table.split(".")[-1] if "." in target_table else target_table
        candidates = [
            f"{base_name}_TMP",
            f"{base_name}_TEMP",
            f"{base_name}TMP",
            f"{target_table}_TMP",
            f"{target_table}_TEMP",
        ]

        for tmp_name in candidates:
            tmp_idx = self._field_mapping_idx.get(tmp_name)
            if tmp_idx and target_field in tmp_idx:
                fms = tmp_idx[target_field]
                proc_hint = fms[0].procedure if fms else ""
                return _SourceRecord(
                    source_table=tmp_name,
                    source_field=target_field,
                    transform_logic="(TMP 表桥接)",
                    procedure=proc_hint,
                    confidence=0.7,
                )

        for tmp_name in candidates:
            matched_key = self._fuzzy_match_table_key(tmp_name)
            if matched_key:
                tbl_idx = self._field_mapping_idx.get(matched_key)
                if tbl_idx and target_field in tbl_idx:
                    fms = tbl_idx[target_field]
                    proc_hint = fms[0].procedure if fms else ""
                    return _SourceRecord(
                        source_table=matched_key,
                        source_field=target_field,
                        transform_logic="(TMP 表桥接)",
                        procedure=proc_hint,
                        confidence=0.7,
                    )

        return None

    def _fuzzy_match_table_key(self, table_name: str) -> Optional[str]:
        """在 field_mapping_idx 的所有 key 中模糊匹配表名。

        匹配策略（按优先级）：
          1. 后缀匹配：key 以 table_name 结尾（支持不带 schema 前缀的输入）
             例如: "EAST5_KHXXB_TMP" → 匹配 "RRP_EAST.EAST5_KHXXB_TMP"
          2. 裸表名匹配：去掉 schema 前缀后比较表名部分（支持跨 schema 查询）
             例如: "RRP_MDL.EAST5_201_GRJCXXB" → 匹配 "RRP_EAST.EAST5_201_GRJCXXB"
        """
        upper_name = table_name.upper()
        bare_name = upper_name.split(".")[-1] if "." in upper_name else upper_name

        for key in self._field_mapping_idx:
            key_upper = key.upper()
            # 策略1：后缀匹配
            if key_upper.endswith(upper_name):
                return key
            # 策略2：裸表名匹配（去掉双方 schema 前缀后比较）
            if bare_name and "." in key_upper:
                key_bare = key_upper.split(".")[-1]
                if key_bare == bare_name:
                    return key
        return None

    def _infer_source_table_from_lineage(
        self, target_table: str, procedure_name: str
    ) -> str:
        """当 field_mapping 的 source_table 为空时，从 table_lineages 推断来源表。

        场景：外部视图（如 ICL.V_CMM_INDV_CUST_BASIC_INFO）不在 .tab 文件中，
        解析器无法将 SELECT 列的裸列名（如 CUST_NAME）关联到来源表，
        导致 field_mapping.source_table 为空。但 table_lineages 正确记录了
        表间依赖关系，可据此推断来源表。

        多候选策略：当同一目标表有多个来源表时，按以下优先级选择：
          1. 同过程的来源表（最可靠）
          2. 与 field_mapping_idx 中有该目标表字段映射的来源表
          3. 第一个候选（兜底）

        Args:
            target_table: 目标表名
            procedure_name: 存储过程全名

        Returns:
            推断出的来源表名，无法推断时返回空字符串。
        """
        norm_target = self._normalize_table_name(target_table)
        candidates: list[str] = []
        same_proc_candidates: list[str] = []

        for tl in self.table_lineages:
            tl_tgt = self._normalize_table_name(tl.target_table)
            tl_src = self._normalize_table_name(tl.source_table)
            if tl_tgt == norm_target and tl_src and tl_src != norm_target:
                tl_proc = self._normalize_table_name(tl.procedure or "")
                if procedure_name and tl_proc == self._normalize_table_name(procedure_name):
                    same_proc_candidates.append(tl_src)
                candidates.append(tl_src)

        if same_proc_candidates:
            if len(same_proc_candidates) == 1:
                return same_proc_candidates[0]
            # 多个同过程候选：优先选择在 field_mapping_idx 中有记录的来源表
            for src in same_proc_candidates:
                if src in self._field_mapping_idx:
                    return src
            return same_proc_candidates[0]

        if not candidates:
            return ""

        if len(candidates) == 1:
            return candidates[0]

        # 多候选无过程匹配：优先选择在 field_mapping_idx 中有记录的来源表
        for src in candidates:
            if src in self._field_mapping_idx:
                return src

        return candidates[0]

    def _find_source_fields_in_procedure(
        self, target_table: str, target_field: str, procedure: ProcedureInfo
    ) -> list[_SourceRecord]:
        """在指定存储过程中精确查找目标字段的来源。

        特别处理 TMP 表场景：TMP 表的写入和读取在同一过程内，
        需要在过程的 field_mappings 中查找 target_table=target_field 的记录，
        其 source 即为更早步骤的数据来源。

        Args:
            target_table: 目标表名
            target_field:  目标字段名
            procedure:    存储过程信息

        Returns:
            该过程内匹配到的来源字段列表。
        """
        results: list[_SourceRecord] = []
        norm_table = self._normalize_table_name(target_table)
        norm_field = self._normalize_field_name(target_field)

        for fm in procedure.field_mappings:
            fm_tgt_tbl = self._normalize_table_name(fm.target_table)
            fm_tgt_col = self._normalize_field_name(fm.target_column)

            if fm_tgt_tbl == norm_table and fm_tgt_col == norm_field:
                src_table = self._normalize_table_name(fm.source_table)
                src_col = self._normalize_field_name(fm.source_column)
                if not src_col:
                    continue
                # 兜底：source_table 为空时，从 table_lineages 推断
                if not src_table:
                    src_table = self._infer_source_table_from_lineage(
                        norm_table, procedure.full_name
                    )
                if not src_table:
                    continue
                results.append(
                    _SourceRecord(
                        source_table=src_table,
                        source_field=src_col,
                        transform_logic=fm.transform_logic,
                        procedure=procedure.full_name,
                        confidence=fm.confidence,
                    )
                )

        return results

    def _find_procedures_for_table(self, table_name: str) -> list[ProcedureInfo]:
        """找出所有加工了指定目标表的存储过程。

        查找逻辑：
          1. 先查 _proc_target_idx（过程的目标表中包含该表）
          2. 再查 _table_proc_idx（该表出现在过程的所有表中），补充遗漏

        Args:
            table_name: 表名

        Returns:
            加工了该表的存储过程列表。
        """
        norm_table = self._normalize_table_name(table_name)

        primary = self._proc_target_idx.get(norm_table, [])
        if primary:
            return primary

        secondary = self._table_proc_idx.get(norm_table, [])
        filtered = [
            p
            for p in secondary
            if norm_table in [self._normalize_table_name(t) for t in p.target_tables]
        ]
        return filtered

    # ===================================================================
    # 从 BFS 树构建链路
    # ===================================================================

    def _build_chains_from_bfs_tree(
        self, bfs_tree: dict[str, _BFSNode], target: tuple[str, str], reverse: bool = False
    ) -> list[FieldLineageChain]:
        """从 BFS 遍历树中回溯构建所有完整链路。

        BFS 树是一个有向无环图（检测到环已被截断），从根节点（目标字段）
        出发沿 parent_key 回溯到叶子节点（无上游来源的节点），每条根→叶子
        路径即为一条 FieldLineageChain。

        由于一个节点可能有多个子节点指向它（多对一合并场景如 UNION ALL），
        这里需要收集所有"终止于叶子"的路径。

        实际策略：
          - 找出所有叶子节点（parent_key 不被任何其他节点引用的节点）
          - 对每个叶子节点回溯到根，构建一条链路

        Args:
            bfs_tree: _bfs_trace 返回的遍历树 {node_key: _BFSNode}
            target:   (target_table, target_field) 根节点标识
            reverse:  是否反转链路方向（下游追溯时需要反转，因为 leaf→root 是终点→起点）

        Returns:
            完整链路列表。
        """
        if not bfs_tree:
            return []

        root_key = f"{target[0]}.{target[1]}"
        if root_key not in bfs_tree:
            return []

        # 找出所有叶子节点：那些 key 不作为任何节点的 parent_key 的节点
        non_leaf_keys: set[str] = {n.parent_key for n in bfs_tree.values() if n.parent_key}
        leaf_keys = [k for k in bfs_tree if k != root_key and k not in non_leaf_keys]

        if not leaf_keys:
            leaf_keys = [root_key]

        chains: list[FieldLineageChain] = []
        seen_chains: set[str] = set()

        for leaf_key in leaf_keys:
            path: list[str] = []
            current_key = leaf_key

            while current_key:
                path.append(current_key)
                node = bfs_tree.get(current_key)
                if node is None:
                    break
                current_key = node.parent_key

            # 上游追溯：path 是 leaf→root（源头→目标），不需要反转
            # 下游追溯：path 是 leaf→root（终点→起点），需要反转为 起点→终点
            if reverse:
                path = path[::-1]
            # 重新编号 layer：path[0]=源头(layer=0), path[-1]=目标(layer=max)
            max_layer = len(path) - 1

            chain_id = "→".join(path)
            if chain_id in seen_chains:
                continue
            seen_chains.add(chain_id)

            chain_nodes: list[FieldLineageNode] = []
            for i, node_key in enumerate(path):
                node = bfs_tree[node_key]
                is_temp = self._is_temp_table(node.table_name)
                layer_type_str = detect_layer(node.table_name).value

                display_layer = i
                source_fields_for_node: list[str] = []
                parent_keys = [
                    k for k, n in bfs_tree.items() if n.parent_key == node_key
                ]
                for pk in parent_keys:
                    parent_node = bfs_tree[pk]
                    source_fields_for_node.append(
                        f"{parent_node.table_name}.{parent_node.field_name}"
                    )

                fl_node = FieldLineageNode(
                    layer=display_layer,
                    table_name=node.table_name,
                    field_name=node.field_name,
                    procedure=node.procedure,
                    transform_logic=node.transform_logic,
                    source_fields=source_fields_for_node,
                    is_temp=is_temp,
                    layer_type=layer_type_str,
                )
                chain_nodes.append(fl_node)

            chain = FieldLineageChain(
                target_table=target[0],
                target_field=target[1],
                chain=chain_nodes,
                depth=len(chain_nodes) - 1,
            )
            chains.append(chain)

        chains.sort(key=lambda c: c.depth, reverse=True)
        return chains

    # ===================================================================
    # 工具方法
    # ===================================================================

    @staticmethod
    def _normalize_table_name(name: str) -> str:
        """标准化表名（大写、去首尾空白）。"""
        if not name:
            return ""
        return name.strip().upper()

    @staticmethod
    def _normalize_field_name(name: str) -> str:
        """标准化字段名（大写、去首尾空白）。"""
        if not name:
            return ""
        return name.strip().upper()

    @staticmethod
    def _is_temp_table(table_name: str) -> bool:
        """判断是否为临时表（基于命名约定：以 TMP/_TMP/TEMP/_TEMP 结尾）。"""
        if not table_name:
            return False
        upper_name = table_name.upper()
        temp_suffixes = ("TMP", "_TMP", "TEMP", "_TEMP")
        return any(upper_name.endswith(s) for s in temp_suffixes)

    def to_graph_result(
        self,
        chains: list[FieldLineageChain],
        direction: str = "upstream",
    ) -> tuple[set[str], list[dict], list[dict]]:
        """将 FieldLineageChain 列表转换为图查询所需的 (nodes, edges, field_mappings)。

        Args:
            chains: trace_field_upstream / trace_field_downstream 返回的链路列表
            direction: "upstream" 或 "downstream"，影响边的方向

        Returns:
            (node_names, edges, field_mappings)
            - node_names: 涉及的表名集合
            - edges: [{source_table, target_table, source_field, target_field, type}, ...]
            - field_mappings: [{source_table, source_column, target_table, target_column, ...}, ...]
        """
        node_names: set[str] = set()
        edges: list[dict] = []
        mappings: list[dict] = []
        seen_edges: set[tuple] = set()
        seen_mappings: set[tuple] = set()

        for chain in chains:
            for i, node in enumerate(chain.chain):
                node_names.add(node.table_name)

                if i > 0:
                    prev_node = chain.chain[i - 1]

                    if direction == "upstream":
                        src_table = node.table_name
                        tgt_table = prev_node.table_name
                        src_field = node.field_name
                        tgt_field = prev_node.field_name
                    else:
                        src_table = prev_node.table_name
                        tgt_table = node.table_name
                        src_field = prev_node.field_name
                        tgt_field = node.field_name

                    edge_key = (src_table, tgt_table, src_field, tgt_field)
                    if edge_key not in seen_edges:
                        seen_edges.add(edge_key)
                        edges.append({
                            "source_table": src_table,
                            "target_table": tgt_table,
                            "source_field": src_field,
                            "target_field": tgt_field,
                            "type": "field_mapping",
                        })

                    mapping_key = (src_table, src_field, tgt_table, tgt_field)
                    if mapping_key not in seen_mappings:
                        seen_mappings.add(mapping_key)
                        mappings.append({
                            "source_table": src_table,
                            "source_column": src_field,
                            "target_table": tgt_table,
                            "target_column": tgt_field,
                            "transform_logic": node.transform_logic,
                            "procedure": node.procedure,
                        })

        return node_names, edges, mappings
