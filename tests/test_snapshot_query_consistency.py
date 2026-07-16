from __future__ import annotations

import threading
from typing import Any

import pytest

from app.services.index_snapshot import FieldLineageTracingView, IndexSnapshot, ParserStateCapture
from app.services.lineage_service import LineageService
from app.utils.cache_manager import CacheManager


class _FieldTracer:
    def __init__(self, generation: int) -> None:
        self.generation = generation

    def trace_field_upstream(self, table: str, field: str, max_depth: int = 10) -> list[int]:
        return [self.generation]

    def trace_field_downstream(self, table: str, field: str, max_depth: int = 10) -> list[int]:
        return []

    def to_graph_result(self, chains: list[int], *, direction: str) -> tuple[set[str], list[dict], list[dict]]:
        generation = chains[0]
        source = f"SRC.GEN_{generation}"
        target = f"DWH.RESULT_{generation}"
        return (
            {source, target},
            [
                {
                    "source_table": source,
                    "target_table": target,
                    "source_field": "ID",
                    "target_field": "ID",
                    "type": "field_mapping",
                }
            ],
            [
                {
                    "source_table": source,
                    "source_column": "ID",
                    "target_table": target,
                    "target_column": "ID",
                }
            ],
        )


class _Parser:
    def __init__(self, data: dict[str, Any]) -> None:
        self.data = data

    def get_current_data(self) -> dict[str, Any]:
        return self.data

    def get_data_mtime(self) -> None:
        return None

    def get_lineage_tracer(self) -> None:
        raise AssertionError("snapshot-backed query must not fetch a live tracer")


class _Owner:
    def __init__(self, snapshot: IndexSnapshot, after_capture=None) -> None:
        self.snapshot = snapshot
        self.after_capture = after_capture
        self.capture_calls = 0

    def capture_snapshot(self) -> IndexSnapshot | None:
        self.capture_calls += 1
        captured = self.snapshot
        if self.after_capture is not None:
            self.after_capture()
        return captured


def _data(generation: int) -> dict[str, Any]:
    source = f"SRC.GEN_{generation}"
    target = f"DWH.RESULT_{generation}"
    return {
        "metadata": {},
        "tables": [
            {"full_name": source, "table_name": f"GEN_{generation}", "columns": [{"name": "ID"}]},
            {"full_name": target, "table_name": f"RESULT_{generation}", "columns": [{"name": "ID"}]},
        ],
        "procedures": [],
        "table_lineages": [{"source_table": source, "target_table": target}],
        "field_mappings": [
            {
                "source_table": source,
                "source_column": "ID",
                "target_table": target,
                "target_column": "ID",
            }
        ],
        "caliber_infos": [],
    }


def _snapshot(
    generation: int,
    revision: int = 1,
    *,
    data: dict[str, Any] | None = None,
    data_mtime: float | None = None,
) -> IndexSnapshot:
    capture = ParserStateCapture(
        generation,
        data or _data(generation),
        FieldLineageTracingView(_FieldTracer(generation)),
        data_mtime=data_mtime,
    )
    return IndexSnapshot.build(capture, publication_revision=revision)


def test_table_lineage_uses_one_captured_snapshot_after_new_publication() -> None:
    parser = _Parser(_data(1))
    owner = _Owner(_snapshot(1), after_capture=lambda: setattr(parser, "data", _data(2)))
    service = LineageService(parser, CacheManager(), owner)

    result = service.query_lineage("DWH.RESULT_1", mode="upstream", use_cache=False)

    assert owner.capture_calls == 1
    assert {node["id"] for node in result["nodes"]} == {"SRC.GEN_1", "DWH.RESULT_1"}
    assert {(edge["source_table"], edge["target_table"]) for edge in result["edges"]} == {
        ("SRC.GEN_1", "DWH.RESULT_1")
    }


def test_field_lineage_uses_captured_generation_tracing_view() -> None:
    parser = _Parser(_data(2))
    owner = _Owner(_snapshot(1))
    owner.after_capture = lambda: setattr(owner, "snapshot", _snapshot(2))
    service = LineageService(parser, CacheManager(), owner)

    result = service.query_lineage(
        "DWH.RESULT_1",
        field="ID",
        mode="upstream",
        use_cache=False,
    )

    assert owner.capture_calls == 1
    assert {node["id"] for node in result["nodes"]} == {"SRC.GEN_1", "DWH.RESULT_1"}
    assert {mapping["source_table"] for mapping in result["field_mappings"]} == {"SRC.GEN_1"}


def _stable_data(marker: str) -> dict[str, Any]:
    data = _data(1)
    data["tables"][0]["full_name"] = "SRC.INPUT"
    data["tables"][0]["table_name"] = "INPUT"
    data["tables"][0]["comment"] = marker
    data["tables"][1]["full_name"] = "DWH.RESULT"
    data["tables"][1]["table_name"] = "RESULT"
    data["tables"][1]["comment"] = marker
    data["table_lineages"][0].update(source_table="SRC.INPUT", target_table="DWH.RESULT")
    data["field_mappings"][0].update(source_table="SRC.INPUT", target_table="DWH.RESULT")
    return data


def _query_marker(service: LineageService) -> tuple[bool, set[str]]:
    result = service.query_lineage("DWH.RESULT", mode="upstream")
    return result["cache_hit"], {node["comment"] for node in result["nodes"]}


def test_result_cache_isolated_by_generation_and_forced_publication_namespace() -> None:
    parser = _Parser(_stable_data("live"))
    owner = _Owner(_snapshot(1, data=_stable_data("n")))
    service = LineageService(parser, CacheManager(), owner)

    assert _query_marker(service) == (False, {"n"})
    assert _query_marker(service) == (True, {"n"})

    owner.snapshot = _snapshot(2, data=_stable_data("n+1"))
    assert _query_marker(service) == (False, {"n+1"})
    assert _query_marker(service) == (True, {"n+1"})

    owner.snapshot = _snapshot(2, revision=2, data=_stable_data("forced-n+1"))
    assert _query_marker(service) == (False, {"forced-n+1"})


class _BlockingFirstSetCache(CacheManager):
    def __init__(self) -> None:
        super().__init__()
        self.write_started = threading.Event()
        self.release_write = threading.Event()
        self._blocked = False

    def set(self, key: str, value: Any, tags: list[str] | None = None) -> None:
        if not self._blocked:
            self._blocked = True
            self.write_started.set()
            assert self.release_write.wait(timeout=2)
        super().set(key, value, tags)


def test_slow_old_reader_writes_only_to_its_captured_namespace() -> None:
    parser = _Parser(_stable_data("live"))
    owner = _Owner(_snapshot(1, data=_stable_data("n")))
    cache = _BlockingFirstSetCache()
    service = LineageService(parser, cache, owner)
    old_result: list[dict[str, Any]] = []

    reader = threading.Thread(
        target=lambda: old_result.append(service.query_lineage("DWH.RESULT", mode="upstream"))
    )
    reader.start()
    assert cache.write_started.wait(timeout=2)
    owner.snapshot = _snapshot(2, data=_stable_data("n+1"))
    cache.release_write.set()
    reader.join(timeout=2)

    assert {node["comment"] for node in old_result[0]["nodes"]} == {"n"}
    assert _query_marker(service) == (False, {"n+1"})


def _export_data(marker: str) -> dict[str, Any]:
    return {
        "metadata": {
            "total_tables": 2,
            "total_procedures": 1,
            "total_table_lineages": 1,
            "total_field_mappings": 1,
            "total_caliber_infos": 0,
        },
        "tables": [
            {
                "full_name": f"IDL.EDW_{marker}",
                "table_name": f"EDW_{marker}",
                "data_source": "edw",
                "columns": [{"name": "ID"}],
            },
            {
                "full_name": f"RRP_ODS.SRC_{marker}",
                "table_name": f"SRC_{marker}",
                "data_source": "rrp",
                "columns": [{"name": "ID"}],
            },
        ],
        "procedures": [{"full_name": f"EDW.P_{marker}"}],
        "table_lineages": [
            {"source_table": f"RRP_ODS.SRC_{marker}", "target_table": f"IDL.EDW_{marker}"}
        ],
        "field_mappings": [
            {
                "source_table": f"RRP_ODS.SRC_{marker}",
                "source_column": "ID",
                "target_table": f"IDL.EDW_{marker}",
                "target_column": "ID",
            }
        ],
        "caliber_infos": [],
    }


def test_export_generation_metadata_and_rows_use_one_snapshot() -> None:
    parser = _Parser(_export_data("N2"))
    owner = _Owner(_snapshot(1, data=_export_data("N1"), data_mtime=101.0))
    owner.after_capture = lambda: setattr(
        owner,
        "snapshot",
        _snapshot(2, data=_export_data("N2"), data_mtime=202.0),
    )
    service = LineageService(parser, CacheManager(), owner)

    result = service.export_system_full_lineage("edw")

    assert owner.capture_calls == 1
    assert result["summary"]["parser_generation"] == 1
    assert result["summary"]["data_mtime"] == 101.0
    assert {row["full_name"] for row in result["tables"]} == {
        "IDL.EDW_N1",
        "RRP_ODS.SRC_N1",
    }


def test_snapshot_backed_readers_preserve_shapes_and_capture_once_each() -> None:
    data = _export_data("N1")
    owner = _Owner(_snapshot(1, data=data))
    service = LineageService(_Parser(_export_data("LIVE")), CacheManager(), owner)

    tables = service.search_tables("EDW_N1")
    assert owner.capture_calls == 1
    assert tables == [
        {
            "full_name": "IDL.EDW_N1",
            "short_name": "EDW_N1",
            "layer": "idl",
            "field_count": 1,
            "columns": ["ID"],
        }
    ]

    assert service.search_procedures("P_N1") == [
        {"full_name": "EDW.P_N1", "short_name": "P_N1"}
    ]
    assert owner.capture_calls == 2
    assert service.get_system_stats()["total_tables"] == 2
    assert owner.capture_calls == 3
    assert service.is_index_ready() is True
    assert owner.capture_calls == 4


def test_no_snapshot_never_exposes_parser_only_data() -> None:
    owner = _Owner(None)  # type: ignore[arg-type]
    service = LineageService(_Parser(_export_data("LIVE")), CacheManager(), owner)

    assert service.query_lineage("IDL.EDW_LIVE")["nodes"] == []
    assert service.search_tables("EDW") == []
    assert service.search_procedures("P_") == []
    assert service.get_system_stats()["total_tables"] == 0
    assert service.is_index_ready() is False
    with pytest.raises(ValueError, match="no parsed data"):
        service.export_system_full_lineage("edw")


def test_standalone_caliber_readers_fetch_one_parser_owned_tracer_per_call() -> None:
    class _UnifiedTracer:
        @staticmethod
        def get_edge_caliber(*args, **kwargs):
            return {"kind": "edge"}

        @staticmethod
        def get_node_detail(*args, **kwargs):
            return {"kind": "node"}

        @staticmethod
        def trace_caliber(*args, **kwargs):
            return None

    class _StandaloneParser(_Parser):
        def __init__(self, data: dict[str, Any]) -> None:
            super().__init__(data)
            self.tracer_calls = 0
            self.tracer = _UnifiedTracer()

        def get_unified_tracer(self):
            self.tracer_calls += 1
            return self.tracer

    parser = _StandaloneParser(_data(1))
    owner = _Owner(_snapshot(1))
    service = LineageService(parser, CacheManager(), owner)

    assert service.get_edge_caliber("A", "ID", "B", "ID") == {"kind": "edge"}
    assert parser.tracer_calls == 1
    assert service.get_node_detail("A") == {"kind": "node"}
    assert parser.tracer_calls == 2
    assert service.build_summary_card("A", "ID")["success"] is False
    assert parser.tracer_calls == 3
    assert owner.capture_calls == 0
