from __future__ import annotations

from typing import Any

from app.services.index_snapshot import FieldLineageTracingView, IndexSnapshot, ParserStateCapture
from app.services.table_query_service import TableQueryService


class _Parser:
    def __init__(self, data: dict[str, Any]) -> None:
        self.data = data

    def get_current_data(self) -> dict[str, Any]:
        return self.data


class _Cache:
    size = 7

    def search_by_keyword(self, *args, **kwargs) -> list[str]:
        return ["LIVE.P_LIVE"]


class _Owner:
    def __init__(self, snapshot: IndexSnapshot | None) -> None:
        self.snapshot = snapshot
        self.capture_calls = 0
        self.after_capture = None

    def capture_snapshot(self) -> IndexSnapshot | None:
        self.capture_calls += 1
        snapshot = self.snapshot
        if self.after_capture is not None:
            self.after_capture()
        return snapshot


def _data(marker: str) -> dict[str, Any]:
    return {
        "metadata": {
            "total_tables": 1,
            "total_procedures": 1,
            "total_table_lineages": 0,
            "total_field_mappings": 1,
            "total_caliber_infos": 0,
        },
        "tables": [
            {
                "full_name": f"RRP_MDL.T_{marker}",
                "table_name": f"T_{marker}",
                "data_source": "rrp",
                "columns": [{"name": f"F_{marker}"}],
            }
        ],
        "procedures": [{"full_name": f"RRP.P_{marker}"}],
        "table_lineages": [],
        "field_mappings": [
            {
                "target_table": f"RRP_MDL.T_{marker}",
                "target_column": f"F_{marker}",
            }
        ],
        "caliber_infos": [],
    }


def _snapshot(marker: str, generation: int) -> IndexSnapshot:
    capture = ParserStateCapture(
        generation,
        _data(marker),
        FieldLineageTracingView(object()),
    )
    return IndexSnapshot.build(capture, publication_revision=1)


def test_each_table_query_reader_uses_one_captured_generation() -> None:
    owner = _Owner(_snapshot("N1", 1))
    parser = _Parser(_data("LIVE"))
    service = TableQueryService(parser, _Cache(), owner)
    owner.after_capture = lambda: setattr(owner, "snapshot", _snapshot("N2", 2))

    readers = [
        (lambda: service.search_tables("T_N1"), lambda value: value[0]["full_name"] == "RRP_MDL.T_N1"),
        (lambda: service.search_procedures("P_N1"), lambda value: value == [{"full_name": "RRP.P_N1", "short_name": "P_N1"}]),
        (lambda: service.get_table_fields("T_N1"), lambda value: value == ["F_N1"]),
        (lambda: service.get_table_info("RRP_MDL.T_N1"), lambda value: value["table_name"] == "T_N1"),
        (lambda: service.get_system_stats(), lambda value: value["total_tables"] == 1),
        (lambda: service.get_runtime_stats(), lambda value: value["tables"] == 1 and value["index_status"] == "ready"),
        (lambda: service.get_systems(), lambda value: next(item for item in value if item["name"] == "rrp")["table_count"] == 1),
        (lambda: service.get_schemas("rrp"), lambda value: value == [{"schema_name": "RRP_MDL", "table_count": 1}]),
        (lambda: service.get_tables_by_system("rrp"), lambda value: value[0]["full_name"] == "RRP_MDL.T_N1"),
        (lambda: service.get_tables_by_schema("rrp", "RRP_MDL"), lambda value: value[0]["full_name"] == "RRP_MDL.T_N1"),
    ]

    for read, assertion in readers:
        owner.snapshot = _snapshot("N1", 1)
        before = owner.capture_calls
        assert assertion(read())
        assert owner.capture_calls == before + 1


def test_no_snapshot_never_falls_back_to_live_parser_or_cache_projection() -> None:
    owner = _Owner(None)
    service = TableQueryService(_Parser(_data("LIVE")), _Cache(), owner)

    assert service.search_tables("LIVE") == []
    assert service.search_procedures("LIVE") == []
    assert service.get_table_fields("T_LIVE") is None
    assert service.get_table_info("RRP_MDL.T_LIVE") is None
    assert service.get_system_stats()["total_tables"] == 0
    runtime_stats = service.get_runtime_stats()
    assert runtime_stats["loaded"] is False
    assert runtime_stats["index_status"] == "empty"
    assert all(system["table_count"] == 0 for system in service.get_systems())
    assert service.get_schemas("rrp") == []
    assert service.get_tables_by_system("rrp") == []
    assert service.get_tables_by_schema("rrp", "RRP_MDL") == []
    assert owner.capture_calls == 10
