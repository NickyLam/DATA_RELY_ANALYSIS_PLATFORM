from __future__ import annotations

from copy import deepcopy
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import pytest

from app.repository import search_table_dicts
from app.services.index_snapshot import FieldLineageTracingView, IndexSnapshot, ParserStateCapture
from app.services.lineage_query_index import LineageQueryIndex
from app.services.lineage_service import LineageService
from app.services.table_lineage_tracer import TableLineageTracer
from app.utils.cache_manager import CacheManager
from core.table_name_resolver import TableNameResolver

_IGNORED_METADATA = {
    "build_time_ms",
    "cache_hit",
    "elapsed_ms",
    "generated_at",
    "query_time_ms",
}
_UNORDERED_LISTS = {"nodes", "edges", "field_mappings", "mappings"}


class EquivalenceMismatch(AssertionError):
    """A semantic difference with a stable category for cutover diagnostics."""

    def __init__(self, category: str, path: str, legacy: Any, candidate: Any) -> None:
        self.category = category
        self.path = path
        super().__init__(
            f"{category} mismatch at {path}: legacy={legacy!r}, candidate={candidate!r}"
        )


def _semantic_sort_key(value: Any) -> str:
    return repr(value)


def _normalize(value: Any, path: tuple[str, ...] = ()) -> Any:
    if isinstance(value, dict):
        return {
            key: _normalize(item, (*path, key))
            for key, item in sorted(value.items())
            if key not in _IGNORED_METADATA and key != "publication_namespace"
        }
    if isinstance(value, set):
        return sorted((_normalize(item, path) for item in value), key=_semantic_sort_key)
    if isinstance(value, list):
        normalized = [_normalize(item, path) for item in value]
        if path and path[-1] in _UNORDERED_LISTS:
            return sorted(normalized, key=_semantic_sort_key)
        return normalized
    return value


def _mismatch_category(path: tuple[str, ...]) -> str:
    joined = ".".join(path)
    if "field_mappings" in path or "mappings" in path:
        return "mapping"
    if "edges" in path:
        return "edge"
    if "nodes" in path:
        return "node"
    if any(part in path for part in ("resolved_table", "redirected_from", "resolution")):
        return "resolution"
    if any(part in path for part in ("has_more", "truncated", "partial", "limit")):
        return "limit/truncation"
    if "error" in joined or "outcome" in path:
        return "error/outcome"
    if "generation" in path:
        return "generation"
    if "is_ready" in path or "readiness" in path:
        return "readiness"
    if "export" in path:
        return "export"
    if "search" in path:
        return "ordered-search"
    return "semantic"


def assert_semantically_equivalent(legacy: Any, candidate: Any) -> None:
    left = _normalize(legacy)
    right = _normalize(candidate)
    if left == right:
        return

    def find_path(a: Any, b: Any, path: tuple[str, ...] = ()) -> tuple[str, ...]:
        if isinstance(a, dict) and isinstance(b, dict):
            for key in sorted(set(a) | set(b)):
                if key not in a or key not in b:
                    return (*path, key)
                if a[key] != b[key]:
                    return find_path(a[key], b[key], (*path, key))
        if isinstance(a, list) and isinstance(b, list):
            for index, (left_item, right_item) in enumerate(zip(a, b, strict=False)):
                if left_item != right_item:
                    return find_path(left_item, right_item, (*path, str(index)))
            if len(a) != len(b):
                return (*path, "length")
        return path

    mismatch_path = find_path(left, right)
    display_path = ".".join(mismatch_path) or "<root>"
    raise EquivalenceMismatch(
        _mismatch_category(mismatch_path),
        display_path,
        left,
        right,
    )


@dataclass(frozen=True)
class CutoverEvidence:
    equivalence: bool
    failed_candidate_fallback: bool
    mixed_generation_concurrency: bool
    production_legacy_call_sites_absent: bool


def assert_cutover_ready(evidence: CutoverEvidence) -> None:
    missing = [
        name
        for name, passed in evidence.__dict__.items()
        if not passed
    ]
    if missing:
        raise AssertionError(f"cutover gate missing evidence: {', '.join(missing)}")


class _NoFieldTracer:
    def trace_field_upstream(self, table: str, field: str, max_depth: int = 10) -> list[Any]:
        return []

    def trace_field_downstream(self, table: str, field: str, max_depth: int = 10) -> list[Any]:
        return []

    def to_graph_result(
        self,
        chains: list[Any],
        *,
        direction: str,
    ) -> tuple[set[str], list[dict], list[dict]]:
        return set(), [], []


class _FixtureFieldTracer(_NoFieldTracer):
    def trace_field_upstream(self, table: str, field: str, max_depth: int = 10) -> list[Any]:
        return [(table, field, max_depth)]

    def to_graph_result(
        self,
        chains: list[Any],
        *,
        direction: str,
    ) -> tuple[set[str], list[dict], list[dict]]:
        if not chains:
            return set(), [], []
        return (
            {"EXTERNAL.CRM_ACCOUNT", "RRP_EAST.EAST5_ACCOUNT"},
            [
                {
                    "source_table": "EXTERNAL.CRM_ACCOUNT",
                    "target_table": "RRP_EAST.EAST5_ACCOUNT",
                    "source_field": "ID",
                    "target_field": "ACCOUNT_ID",
                }
            ],
            [
                {
                    "source_table": "EXTERNAL.CRM_ACCOUNT",
                    "source_column": "ID",
                    "target_table": "RRP_EAST.EAST5_ACCOUNT",
                    "target_column": "ACCOUNT_ID",
                }
            ],
        )


def _representative_data() -> dict[str, Any]:
    return {
        "metadata": {"source": "equivalence-characterization"},
        "tables": [
            {
                "full_name": "RRP_EAST.EAST5_ACCOUNT",
                "table_name": "EAST5_ACCOUNT",
                "data_source": "oracle",
                "columns": [{"name": "ACCOUNT_ID", "data_type": "NUMBER"}],
            },
            {
                "full_name": "RRP_MDL.EAST5_ACCOUNT",
                "table_name": "EAST5_ACCOUNT",
                "data_source": "oracle",
                "columns": [{"name": "ACCOUNT_ID", "data_type": "NUMBER"}],
            },
            {
                "full_name": "ODS.WH_ACCOUNT",
                "table_name": "WH_ACCOUNT",
                "data_source": "warehouse",
                "columns": [{"name": "ACCOUNT_ID", "data_type": "BIGINT"}],
            },
            {
                "full_name": "DWD.WH_ACCOUNT_DETAIL",
                "table_name": "WH_ACCOUNT_DETAIL",
                "data_source": "warehouse",
                "columns": [{"name": "ACCOUNT_ID", "data_type": "BIGINT"}],
            },
            {
                "full_name": "RRP_EAST.ZERO_EDGE",
                "table_name": "ZERO_EDGE",
                "data_source": "oracle",
                "columns": [{"name": "ID", "data_type": "NUMBER"}],
            },
        ],
        "procedures": [
            {"full_name": "RRP.P_LOAD_ACCOUNT"},
            {"full_name": "EDW.P_LOAD_WH_ACCOUNT"},
        ],
        "table_lineages": [
            {
                "source_table": "EXTERNAL.CRM_ACCOUNT",
                "target_table": "RRP_EAST.EAST5_ACCOUNT",
                "procedure": "RRP.P_LOAD_ACCOUNT",
            },
            {
                "source_table": "ODS.WH_ACCOUNT",
                "target_table": "DWD.WH_ACCOUNT_DETAIL",
                "procedure": "EDW.P_LOAD_WH_ACCOUNT",
            },
        ],
        "field_mappings": [
            {
                "source_table": "EXTERNAL.CRM_ACCOUNT",
                "source_column": "ID",
                "target_table": "RRP_EAST.EAST5_ACCOUNT",
                "target_column": "ACCOUNT_ID",
                "procedure": "RRP.P_LOAD_ACCOUNT",
            },
            {
                "source_table": "ODS.WH_ACCOUNT",
                "source_column": "ACCOUNT_ID",
                "target_table": "DWD.WH_ACCOUNT_DETAIL",
                "target_column": "ACCOUNT_ID",
                "procedure": "EDW.P_LOAD_WH_ACCOUNT",
            },
        ],
        "caliber_infos": [],
    }


class _LegacyProjection:
    """Test-only capture of the mutable owner behavior that U6 will remove."""

    def __init__(self, capture: ParserStateCapture) -> None:
        self.generation = capture.generation
        self.data = capture.get_source_data()
        self.field_tracing = capture.field_tracing
        self.index = LineageQueryIndex()
        self.index.build(self.data)
        self.tracer = TableLineageTracer(TableNameResolver())
        self.tracer.build_graph(self.data.get("table_lineages", []))

    @property
    def is_ready(self) -> bool:
        return self.index.is_built and self.tracer.is_built

    def search_tables(self, keyword: str, limit: int) -> list[dict]:
        return deepcopy(search_table_dicts(self.data.get("tables", []), keyword, limit))

    def search_procedures(self, keyword: str, limit: int) -> list[dict]:
        normalized = keyword.upper().strip()
        if not normalized:
            return []
        return deepcopy(
            [
                procedure
                for procedure in self.data.get("procedures", [])
                if normalized in procedure.get("full_name", "").upper()
            ][:limit]
        )

    def resolve(self, table: str) -> str:
        return self.tracer.resolve_table_name(table, self.data)

    def trace(self, table: str, depth: int, direction: str) -> tuple[set[str], list[dict]]:
        return self.tracer.trace(table, self.data, depth, direction, self.index)

    def mappings_by_target(self, table: str, column: str) -> list[dict]:
        return deepcopy(self.index.get_field_mappings_by_target(table, column))

    def trace_field(self) -> tuple[set[str], list[dict], list[dict]]:
        chains = self.field_tracing.trace_field_upstream(
            "RRP_EAST.EAST5_ACCOUNT",
            "ACCOUNT_ID",
            2,
        )
        return self.field_tracing.to_graph_result(chains, direction="upstream")


def _observation(projection: Any) -> dict[str, Any]:
    if isinstance(projection, IndexSnapshot):
        def trace(table: str, depth: int, direction: str) -> tuple[set[str], list[dict]]:
            return projection.trace_tables(table, max_depth=depth, direction=direction)

        adjacency_keys = set(projection.adjacency_up) | set(projection.adjacency_down)

        def resolve(table: str) -> str:
            return projection.query_index.resolve_table_name(table, adjacency_keys)

        mappings_by_target = projection.query_index.get_field_mappings_by_target

        def trace_field() -> tuple[set[str], list[dict], list[dict]]:
            chains = projection.field_tracing.trace_field_upstream(
                "RRP_EAST.EAST5_ACCOUNT",
                "ACCOUNT_ID",
                2,
            )
            return projection.field_tracing.to_graph_result(chains, direction="upstream")
    else:
        trace = projection.trace
        resolve = projection.resolve
        mappings_by_target = projection.mappings_by_target
        trace_field = projection.trace_field

    oracle_nodes, oracle_edges = trace("EAST5_ACCOUNT", 2, "up")
    warehouse_nodes, warehouse_edges = trace("WH_ACCOUNT_DETAIL", 2, "up")
    zero_nodes, zero_edges = trace("ZERO_EDGE", 2, "up")
    return {
        "table_search": projection.search_tables("ACCOUNT", 3),
        "procedure_search": projection.search_procedures("LOAD", 1),
        "resolution": {
            "duplicate_short_name": resolve("EAST5_ACCOUNT"),
            "warehouse": resolve("WH_ACCOUNT_DETAIL"),
            "unresolved": resolve("UNRESOLVED_TABLE"),
        },
        "oracle_lineage": {"nodes": oracle_nodes, "edges": oracle_edges},
        "warehouse_lineage": {"nodes": warehouse_nodes, "edges": warehouse_edges},
        "zero_edge_lineage": {"nodes": zero_nodes, "edges": zero_edges},
        "field_mappings": mappings_by_target("DWD.WH_ACCOUNT_DETAIL", "ACCOUNT_ID"),
        "field_lineage": dict(zip(("nodes", "edges", "mappings"), trace_field(), strict=True)),
        "generation": projection.generation,
        "is_ready": projection.is_ready,
    }


class _ParserView:
    data_generation = 7

    def __init__(self, data: dict[str, Any]) -> None:
        self.data = data

    def get_current_data(self) -> dict[str, Any]:
        return self.data

    def get_data_mtime(self) -> float:
        return 1710000000.0


class _Owner:
    def __init__(self, snapshot: IndexSnapshot | None) -> None:
        self.snapshot = snapshot

    def capture_snapshot(self) -> IndexSnapshot | None:
        return self.snapshot


def test_comparator_normalizes_only_genuinely_unordered_and_nondeterministic_values() -> None:
    legacy = {
        "nodes": [{"id": "B"}, {"id": "A"}],
        "edges": [{"source_table": "B"}, {"source_table": "A"}],
        "field_mappings": [{"target_column": "B"}, {"target_column": "A"}],
        "search": [{"full_name": "A"}, {"full_name": "B"}],
        "cache_hit": False,
        "query_time_ms": 1.25,
        "publication_namespace": (7, 1),
    }
    candidate = {
        "nodes": list(reversed(legacy["nodes"])),
        "edges": list(reversed(legacy["edges"])),
        "field_mappings": list(reversed(legacy["field_mappings"])),
        "search": deepcopy(legacy["search"]),
        "cache_hit": True,
        "query_time_ms": 99.0,
        "publication_namespace": (7, 99),
    }

    assert_semantically_equivalent(legacy, candidate)

    candidate["search"].reverse()
    with pytest.raises(EquivalenceMismatch) as mismatch:
        assert_semantically_equivalent(legacy, candidate)
    assert mismatch.value.category == "ordered-search"


@pytest.mark.parametrize(
    ("path", "replacement", "category"),
    [
        (("nodes", 0, "id"), "CHANGED", "node"),
        (("edges", 0, "target_table"), "CHANGED", "edge"),
        (("field_mappings", 0, "target_column"), "CHANGED", "mapping"),
        (("resolved_table",), "CHANGED", "resolution"),
        (("has_more",), True, "limit/truncation"),
        (("error", "code"), "changed", "error/outcome"),
        (("generation",), 8, "generation"),
    ],
)
def test_comparator_reports_deliberate_semantic_drift_category(
    path: tuple[str | int, ...],
    replacement: Any,
    category: str,
) -> None:
    legacy = {
        "nodes": [{"id": "A"}],
        "edges": [{"source_table": "A", "target_table": "B"}],
        "field_mappings": [{"source_column": "ID", "target_column": "ID"}],
        "resolved_table": "S.A",
        "has_more": False,
        "error": {"code": "no_snapshot"},
        "generation": 7,
    }
    candidate = deepcopy(legacy)
    cursor: Any = candidate
    for part in path[:-1]:
        cursor = cursor[part]
    cursor[path[-1]] = replacement

    with pytest.raises(EquivalenceMismatch) as mismatch:
        assert_semantically_equivalent(legacy, candidate)
    assert mismatch.value.category == category


def test_candidate_matches_legacy_projection_from_one_atomic_capture() -> None:
    capture = ParserStateCapture(
        7,
        _representative_data(),
        FieldLineageTracingView(_FixtureFieldTracer()),
        data_mtime=1710000000.0,
    )
    legacy = _LegacyProjection(capture)
    candidate = IndexSnapshot.build(capture, publication_revision=1)

    assert_semantically_equivalent(_observation(legacy), _observation(candidate))


def test_public_lineage_limits_cache_and_no_snapshot_error_match_characterization() -> None:
    data = _representative_data()
    capture = ParserStateCapture(
        7,
        data,
        FieldLineageTracingView(_NoFieldTracer()),
        data_mtime=1710000000.0,
    )
    snapshot = IndexSnapshot.build(capture, publication_revision=1)
    parser = _ParserView(data)
    service = LineageService(parser, CacheManager(), _Owner(snapshot))  # type: ignore[arg-type]

    first = service.query_lineage("WH_ACCOUNT_DETAIL", depth=2, mode="upstream", limit=1)
    second = service.query_lineage("WH_ACCOUNT_DETAIL", depth=2, mode="upstream", limit=1)
    legacy_characterization = {
        "nodes_count": 2,
        "edges_count": 1,
        "nodes": [
            {
                "id": "DWD.WH_ACCOUNT_DETAIL",
                "short_name": "WH_ACCOUNT_DETAIL",
                "full_name": "DWD.WH_ACCOUNT_DETAIL",
                "layer": "other",
                "comment": "",
                "columns": ["ACCOUNT_ID"],
                "field": {"name": "ACCOUNT_ID", "data_type": "BIGINT"},
            }
        ],
        "edges": [
            {
                "source_table": "ODS.WH_ACCOUNT",
                "target_table": "DWD.WH_ACCOUNT_DETAIL",
            }
        ],
        "has_more": True,
        "tables_involved": 2,
        "max_depth_reached": 0,
        "query_target": {"table": "DWD.WH_ACCOUNT_DETAIL", "field": None},
        "field_mappings": [],
        "field_mapping_count": 0,
    }

    assert first["cache_hit"] is False
    assert second["cache_hit"] is True
    assert_semantically_equivalent(legacy_characterization, first)
    assert_semantically_equivalent(first, second)

    no_snapshot = LineageService(parser, CacheManager(), _Owner(None))  # type: ignore[arg-type]
    assert_semantically_equivalent(
        {
            "nodes_count": 0,
            "edges_count": 0,
            "nodes": [],
            "edges": [],
            "has_more": False,
        },
        no_snapshot.query_lineage("DWD.WH_ACCOUNT_DETAIL"),
    )
    with pytest.raises(ValueError, match="no parsed data available"):
        no_snapshot.export_system_full_lineage("edw")


def test_redirect_target_resolution_matches_legacy_characterization() -> None:
    data = _representative_data()
    snapshot = IndexSnapshot.build(
        ParserStateCapture(7, data, FieldLineageTracingView(_NoFieldTracer())),
        publication_revision=1,
    )
    service = LineageService(_ParserView(data), CacheManager(), _Owner(snapshot))  # type: ignore[arg-type]

    legacy_characterization = {
        "redirected_from": "RRP_MDL.EAST5_ACCOUNT",
        "resolved_table": "RRP_EAST.EAST5_ACCOUNT",
    }
    candidate = {
        "redirected_from": "RRP_MDL.EAST5_ACCOUNT",
        "resolved_table": service._find_alternate_schema_table(
            "RRP_MDL.EAST5_ACCOUNT",
            snapshot,
        ),
    }

    assert_semantically_equivalent(legacy_characterization, candidate)


def test_export_generation_external_nodes_and_order_match_characterization() -> None:
    data = {
        "metadata": {},
        "tables": [
            {
                "full_name": "IDL.EDW_ACCOUNT",
                "table_name": "EDW_ACCOUNT",
                "data_source": "edw",
                "columns": [{"name": "ACCOUNT_ID", "data_type": "NUMBER"}],
            },
            {
                "full_name": "RRP_ODS.RRP_ACCOUNT",
                "table_name": "RRP_ACCOUNT",
                "data_source": "rrp",
                "columns": [{"name": "ACCOUNT_ID", "data_type": "NUMBER"}],
            },
        ],
        "procedures": [{"full_name": "RRP.P_LOAD_ACCOUNT"}],
        "table_lineages": [
            {
                "source_table": "RRP_ODS.RRP_ACCOUNT",
                "target_table": "IDL.EDW_ACCOUNT",
                "procedure": "RRP.P_LOAD_ACCOUNT",
            }
        ],
        "field_mappings": [
            {
                "source_table": "RRP_ODS.RRP_ACCOUNT",
                "source_column": "ACCOUNT_ID",
                "target_table": "IDL.EDW_ACCOUNT",
                "target_column": "ACCOUNT_ID",
                "procedure": "RRP.P_LOAD_ACCOUNT",
            }
        ],
        "caliber_infos": [],
    }
    snapshot = IndexSnapshot.build(
        ParserStateCapture(
            7,
            data,
            FieldLineageTracingView(_NoFieldTracer()),
            data_mtime=1710000000.0,
        ),
        publication_revision=1,
    )
    service = LineageService(_ParserView(data), CacheManager(), _Owner(snapshot))  # type: ignore[arg-type]

    export = service.export_system_full_lineage("edw")
    candidate_observation = {
        "export": {
            "summary": export["summary"],
            "table_names": [row["full_name"] for row in export["tables"]],
            "table_lineages": export["table_lineages"],
            "field_mappings": export["field_mappings"],
        }
    }
    legacy_characterization = {
        "export": {
            "summary": {
                "system_name": "edw",
                "data_mtime": 1710000000.0,
                "parser_generation": 7,
                "total_nodes": 2,
                "system_nodes": 1,
                "external_nodes": 1,
                "table_lineages": 1,
                "field_mappings": 1,
            },
            "table_names": [
                "IDL.EDW_ACCOUNT",
                "RRP_ODS.RRP_ACCOUNT",
            ],
            "table_lineages": [
                {
                    "source_table": "RRP_ODS.RRP_ACCOUNT",
                    "target_table": "IDL.EDW_ACCOUNT",
                        "procedure": "RRP.P_LOAD_ACCOUNT",
                        "operation_type": "",
                        "data_source": "",
                }
            ],
            "field_mappings": [
                {
                    "source_table": "RRP_ODS.RRP_ACCOUNT",
                    "source_column": "ACCOUNT_ID",
                    "target_table": "IDL.EDW_ACCOUNT",
                    "target_column": "ACCOUNT_ID",
                        "procedure": "RRP.P_LOAD_ACCOUNT",
                        "transform_logic": "",
                        "condition_metadata": "",
                }
            ],
        }
    }

    assert_semantically_equivalent(legacy_characterization, candidate_observation)


def test_empty_capture_and_zero_edge_dataset_remain_ready_and_equivalent() -> None:
    for data in (
        {"tables": [], "procedures": [], "table_lineages": [], "field_mappings": []},
        {
            "tables": [{"full_name": "S.T", "table_name": "T", "columns": []}],
            "procedures": [],
            "table_lineages": [],
            "field_mappings": [],
        },
    ):
        capture = ParserStateCapture(3, data, FieldLineageTracingView(_NoFieldTracer()))
        legacy = _LegacyProjection(capture)
        candidate = IndexSnapshot.build(capture, publication_revision=1)

        assert_semantically_equivalent(
            {
                "generation": legacy.generation,
                "is_ready": legacy.is_ready,
                "table_search": legacy.search_tables("T", 50),
                "trace": legacy.trace("T", 2, "up"),
            },
            {
                "generation": candidate.generation,
                "is_ready": candidate.is_ready,
                "table_search": candidate.search_tables("T", 50),
                "trace": candidate.trace_tables("T", max_depth=2, direction="up"),
            },
        )


def test_cutover_gate_requires_all_four_independent_evidence_classes() -> None:
    with pytest.raises(AssertionError, match="production_legacy_call_sites_absent"):
        assert_cutover_ready(
            CutoverEvidence(
                equivalence=True,
                failed_candidate_fallback=True,
                mixed_generation_concurrency=True,
                production_legacy_call_sites_absent=False,
            )
        )

    assert_cutover_ready(
        CutoverEvidence(
            equivalence=True,
            failed_candidate_fallback=True,
            mixed_generation_concurrency=True,
            production_legacy_call_sites_absent=True,
        )
    )


def test_production_legacy_projection_call_sites_are_absent() -> None:
    """U6 structural gate: IndexService is the only production projection writer."""
    repository_root = Path(__file__).resolve().parents[1]
    service_sources = {
        path.name: path.read_text(encoding="utf-8")
        for path in (repository_root / "app" / "services").glob("*.py")
    }
    lineage_source = service_sources["lineage_service.py"]
    table_query_source = service_sources["table_query_service.py"]
    owner_source = service_sources["index_service.py"]
    cache_source = (repository_root / "app" / "utils" / "cache_manager.py").read_text(
        encoding="utf-8"
    )

    for event_type in ("DATA_CHANGED", "CACHE_INVALIDATED"):
        subscribers = [
            name
            for name, source in service_sources.items()
            if f"subscribe(EventType.{event_type}" in source
        ]
        assert subscribers == ["index_service.py"]

    forbidden_lineage_state = (
        "_transitive_cache",
        "_last_data_mtime",
        "_index_generation",
        "self._table_tracer",
        "self._index = LineageQueryIndex()",
        "adjacency_up.clear()",
        "adjacency_down.clear()",
        "def _build_indexes(",
        "def rebuild_indexes(",
        "def _check_and_refresh_cache(",
        "if self._index_service is None",
    )
    assert not [token for token in forbidden_lineage_state if token in lineage_source]
    assert "if self._index_service is None" not in table_query_source

    forbidden_owner_facades = (
        "_transitive_cache",
        "_last_data_mtime",
        "def build_indexes(",
        "def rebuild_indexes(",
        "def check_and_refresh_cache(",
        "def clear_transitive_cache(",
        "def transitive_cache(",
        "def _get_data_mtime(",
    )
    assert not [token for token in forbidden_owner_facades if token in owner_source]

    forbidden_cache_search = (
        "self._indexes",
        "def build_index(",
        "def search_by_keyword(",
        "def _tokenize(",
        "def _add_to_indexes(",
        "def _remove_from_indexes(",
    )
    assert not [token for token in forbidden_cache_search if token in cache_source]

    query_index_builders = [
        name
        for name, source in service_sources.items()
        if "LineageQueryIndex()" in source
    ]
    assert query_index_builders == ["index_snapshot.py"]

    assert_cutover_ready(
        CutoverEvidence(
            equivalence=True,
            failed_candidate_fallback=True,
            mixed_generation_concurrency=True,
            production_legacy_call_sites_absent=True,
        )
    )
