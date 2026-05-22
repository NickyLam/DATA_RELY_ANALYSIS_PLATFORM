from __future__ import annotations

import logging

from core.layer_detector import LayerType, detect_layer
from core.models import FieldMapping, ProcedureInfo, TableInfo, TableLineage
from core.table_name_resolver import TableNameResolver

logger = logging.getLogger(__name__)


class BaseTracer:

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
        self._resolver = TableNameResolver()

        self._proc_target_idx: dict[str, list[ProcedureInfo]] = {}
        self._table_proc_idx: dict[str, list[ProcedureInfo]] = {}
        self._fm_target_idx: dict[str, dict[str, list[FieldMapping]]] = {}
        self._fm_source_idx: dict[str, dict[str, list[FieldMapping]]] = {}
        self._tl_target_idx: dict[str, list[TableLineage]] = {}
        self._tl_source_idx: dict[str, list[TableLineage]] = {}

        self._build_common_indexes()

    def _build_common_indexes(self) -> None:
        for proc in self.procedures.values():
            for tgt in proc.target_tables:
                norm_tgt = self.normalize_name(tgt)
                self._proc_target_idx.setdefault(norm_tgt, []).append(proc)

        for proc in self.procedures.values():
            all_tables_in_proc: set[str] = set()
            all_tables_in_proc.update(proc.source_tables)
            all_tables_in_proc.update(proc.target_tables)
            all_tables_in_proc.update(proc.temp_tables)
            for t in all_tables_in_proc:
                norm_t = self.normalize_name(t)
                self._table_proc_idx.setdefault(norm_t, []).append(proc)

        for fm in self.field_mappings:
            tgt_tbl = self.normalize_name(fm.target_table)
            tgt_col = self.normalize_name(fm.target_column)
            self._fm_target_idx.setdefault(tgt_tbl, {}).setdefault(tgt_col, []).append(fm)

            src_tbl = self.normalize_name(fm.source_table)
            src_col = self.normalize_name(fm.source_column)
            if src_tbl and src_col:
                self._fm_source_idx.setdefault(src_tbl, {}).setdefault(src_col, []).append(fm)

        for tl in self.table_lineages:
            tgt = self.normalize_name(tl.target_table)
            self._tl_target_idx.setdefault(tgt, []).append(tl)
            src = self.normalize_name(tl.source_table)
            self._tl_source_idx.setdefault(src, []).append(tl)

        logger.debug(
            "公共索引构建完成: proc_target_idx=%d, table_proc_idx=%d, "
            "fm_target_idx=%d, fm_source_idx=%d, tl_target_idx=%d, tl_source_idx=%d",
            len(self._proc_target_idx),
            len(self._table_proc_idx),
            len(self._fm_target_idx),
            len(self._fm_source_idx),
            len(self._tl_target_idx),
            len(self._tl_source_idx),
        )

    @staticmethod
    def normalize_name(name: str) -> str:
        if not name:
            return ""
        return name.strip().upper()

    @staticmethod
    def bare_table(table_name: str) -> str:
        return TableNameResolver.bare_table(table_name)

    @staticmethod
    def make_key(table: str, column: str) -> tuple[str, str]:
        short = table.split(".")[-1] if "." in table else table
        return (short.upper(), column.upper())

    _WAREHOUSE_LAYERS = frozenset({
        LayerType.SRC, LayerType.MSL, LayerType.ITL, LayerType.IOL,
        LayerType.ICL, LayerType.IML, LayerType.IDL, LayerType.IEL,
        LayerType.DQC,
    })

    def is_layer_compatible(self, src_table: str, tgt_table: str) -> bool:
        tgt_layer = detect_layer(tgt_table)
        src_layer = detect_layer(src_table)

        if tgt_layer == LayerType.EAST and src_layer in (LayerType.ODS, LayerType.DIIS):
            return False
        if tgt_layer == LayerType.EAST and src_layer in self._WAREHOUSE_LAYERS:
            return False

        return True

    def is_upstream_layer_compatible(self, src_table: str, tgt_table: str) -> bool:
        return self.is_layer_compatible(src_table, tgt_table)

    def is_downstream_layer_compatible(self, tgt_table: str, src_table: str) -> bool:
        src_layer = detect_layer(src_table)
        tgt_layer = detect_layer(tgt_table)

        if src_layer == LayerType.EAST and tgt_layer in (LayerType.ODS, LayerType.DIIS):
            return False
        if src_layer == LayerType.EAST and tgt_layer in self._WAREHOUSE_LAYERS:
            return False

        return True

    @staticmethod
    def is_temp_table(table_name: str) -> bool:
        if not table_name:
            return False
        upper_name = table_name.upper()
        temp_suffixes = ("TMP", "_TMP", "TEMP", "_TEMP")
        return any(upper_name.endswith(s) for s in temp_suffixes)
