import json
from pathlib import Path

from app.repository import DataRepository
from app.services.lineage_service import LineageService
from app.services.parser_service import ParseResult, ParserService
from core.models import ColumnInfo, TableInfo


def test_search_tables_ranks_exact_short_name_before_contains_match(tmp_path: Path):
    repo = DataRepository()
    exact_table = {
        "full_name": "LONG_SCHEMA.CUSTOMER",
        "table_name": "CUSTOMER",
        "columns": [{"name": "ID"}],
    }
    contains_table = {
        "full_name": "S.CUSTOMER_ARCHIVE",
        "table_name": "CUSTOMER_ARCHIVE",
        "columns": [{"name": "ID"}, {"name": "CUSTOMER_ID"}],
    }
    repo.update({"tables": [contains_table, exact_table]})

    results = repo.search_tables("customer")

    assert results == [exact_table, contains_table]
    assert all(isinstance(result, dict) for result in results)


def test_repository_search_preserves_partial_schema_limit_and_no_match_contract():
    repo = DataRepository()
    exact_table = {
        "full_name": "DWH.CUSTOMER",
        "table_name": "CUSTOMER",
        "columns": [],
    }
    archive_table = {
        "full_name": "DWH.CUSTOMER_ARCHIVE",
        "table_name": "CUSTOMER_ARCHIVE",
        "columns": [],
    }
    repo.update({"tables": [archive_table, exact_table]})

    assert repo.search_tables("CUSTOM", limit=1) == [exact_table]
    assert repo.search_tables("DWH.CUSTOMER") == [exact_table, archive_table]
    assert repo.search_tables("NO_MATCH") == []


def test_parser_service_search_tables_delegates_to_repository(tmp_path: Path):
    output_dir = tmp_path / "output"
    output_dir.mkdir()
    exact_table = {
        "full_name": "LONG_SCHEMA.CUSTOMER",
        "table_name": "CUSTOMER",
        "columns": [{"name": "ID"}],
    }
    contains_table = {
        "full_name": "S.CUSTOMER_ARCHIVE",
        "table_name": "CUSTOMER_ARCHIVE",
        "columns": [{"name": "CUSTOMER_ID"}],
    }
    (output_dir / "lineage_data.json").write_text(
        json.dumps({"tables": [contains_table, exact_table]}),
        encoding="utf-8",
    )
    parser = ParserService(data_dir=str(tmp_path / "data"), schema_dirs=[], output_dir=str(output_dir))
    json_path = output_dir / "lineage_data.json"
    parser._get_repository().load_from_json(json_path)

    results = parser.search_tables("customer")

    assert results == [exact_table, contains_table]


def test_parser_service_search_tables_uses_current_result_without_loading_repository(
    tmp_path: Path,
):
    parser = ParserService(
        data_dir=str(tmp_path / "data"),
        schema_dirs=[],
        output_dir=str(tmp_path / "output"),
    )
    result = ParseResult()
    exact_table = TableInfo(
        schema="LONG_SCHEMA",
        table_name="CUSTOMER",
        full_name="LONG_SCHEMA.CUSTOMER",
        columns=[ColumnInfo(name="ID")],
    )
    result.tables = [
        TableInfo(
            schema="S",
            table_name="CUSTOMER_ARCHIVE",
            full_name="S.CUSTOMER_ARCHIVE",
            columns=[ColumnInfo(name="CUSTOMER_ID")],
        ),
        exact_table,
    ]
    parser._current_result = result

    def fail_if_repository_loads():
        raise AssertionError("search should not load repository when current parse result is available")

    parser._get_repository = fail_if_repository_loads

    assert parser.search_tables("customer", limit=1) == [exact_table.to_dict()]


class _ParserWithRepositorySearch:
    def __init__(self):
        self.search_calls = []

    def get_current_data(self):
        return {
            "tables": [],
            "procedures": [],
            "table_lineages": [],
        }

    def search_tables(self, keyword: str, limit: int = 50):
        self.search_calls.append((keyword, limit))
        return [
            {
                "full_name": "RRP_MDL.CUSTOMER",
                "table_name": "CUSTOMER",
                "columns": [{"name": "ID"}, {"name": "NAME"}],
            }
        ]


class _NoopCache:
    def build_index(self, tables, procedures):
        pass


def test_lineage_service_search_tables_uses_captured_snapshot():
    from app.services.index_snapshot import FieldLineageTracingView, IndexSnapshot, ParserStateCapture

    parser = _ParserWithRepositorySearch()
    snapshot_data = {
        "tables": [
            {
                "full_name": "RRP_MDL.CUSTOMER",
                "table_name": "CUSTOMER",
                "columns": [{"name": "ID"}, {"name": "NAME"}],
            }
        ],
        "procedures": [],
        "table_lineages": [],
        "field_mappings": [],
    }

    class _Tracer:
        pass

    snapshot = IndexSnapshot.build(
        ParserStateCapture(1, snapshot_data, FieldLineageTracingView(_Tracer())),
        publication_revision=1,
    )

    class _Owner:
        @staticmethod
        def capture_snapshot():
            return snapshot

    service = LineageService(parser, _NoopCache(), _Owner())

    results = service.search_tables("customer", limit=10)

    assert parser.search_calls == []
    assert results == [
        {
            "full_name": "RRP_MDL.CUSTOMER",
            "short_name": "CUSTOMER",
            "layer": "base",
            "field_count": 2,
            "columns": ["ID", "NAME"],
        }
    ]
