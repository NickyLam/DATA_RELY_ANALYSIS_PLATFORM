"""
系统级联查询 API 测试
GET /api/systems, GET /api/systems/{name}/tables
"""

from __future__ import annotations

import sys
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import MagicMock, patch

import pytest
from fastapi.testclient import TestClient

from app.services.index_snapshot import FieldLineageTracingView, IndexSnapshot, ParserStateCapture
from app.services.table_query_service import TableQueryService

sys.path.insert(0, str(Path(__file__).parent.parent))


# ── Fixtures ──────────────────────────────────────────────────


@pytest.fixture
def mock_parser_service():
    """Mock ParserService with sample table data."""
    mock = MagicMock()
    mock.get_current_data.return_value = {
        "tables": [
            {
                "full_name": "RRP_EAST.EAST5_1002_JRGJXXB",
                "table_name": "EAST5_1002_JRGJXXB",
                "columns": [{"name": "ID"}, {"name": "NAME"}, {"name": "AMT"}],
            },
            {
                "full_name": "RRP_MDL.ICL_CMM_XXX",
                "table_name": "ICL_CMM_XXX",
                "columns": [{"name": "XXX_ID"}, {"name": "XXX_NAME"}],
            },
            {
                "full_name": "EDW_ICL.DW_ICL_ACCT",
                "table_name": "DW_ICL_ACCT",
                "columns": [{"name": "ACCT_NO"}, {"name": "ACCT_NAME"}],
            },
            {
                "full_name": "MCS_IDL.DM_IDL_RPT",
                "table_name": "DM_IDL_RPT",
                "columns": [{"name": "RPT_ID"}],
            },
        ],
        "procedures": [],
        "table_lineages": [],
        "field_mappings": [],
        "caliber_infos": [],
        "metadata": {"total_tables": 4},
    }
    mock.parse_existing_data.return_value = SimpleNamespace(tables=[], procedures=[], parse_time_sec=0.0)
    mock.shutdown.return_value = None
    return mock


@pytest.fixture
def mock_cache_manager():
    mock = MagicMock()
    mock.size = 0
    mock.search_by_keyword.return_value = []
    return mock


@pytest.fixture
def client_with_data(mock_parser_service, mock_cache_manager):
    """TestClient with mocked services that have data loaded."""
    mock_progress_service = MagicMock()
    with (
        patch("app.dependencies.get_parser_service", return_value=mock_parser_service),
        patch("app.dependencies.get_cache_manager", return_value=mock_cache_manager),
        patch("app.main.get_parser_service", return_value=mock_parser_service),
        patch("app.main.get_progress_service", return_value=mock_progress_service),
        patch("app.main.get_lineage_service", return_value=MagicMock()),
        patch("app.main.get_indicator_service", return_value=MagicMock()),
    ):
        from app.dependencies import get_table_query_service
        from app.main import app

        snapshot = IndexSnapshot.build(
            ParserStateCapture(
                1,
                mock_parser_service.get_current_data.return_value,
                FieldLineageTracingView(object()),
            ),
            publication_revision=1,
        )
        owner = SimpleNamespace(capture_snapshot=lambda: snapshot)
        table_query_service = TableQueryService(mock_parser_service, mock_cache_manager, owner)
        app.dependency_overrides[get_table_query_service] = lambda: table_query_service

        try:
            with TestClient(app) as client:
                yield client
        finally:
            app.dependency_overrides.pop(get_table_query_service, None)


# ── GET /api/systems ──────────────────────────────────────────


class TestGetSystems:
    def test_returns_system_list(self, client_with_data):
        resp = client_with_data.get("/api/systems")
        assert resp.status_code == 200
        data = resp.json()
        assert data["success"] is True
        assert isinstance(data["data"], list)
        assert len(data["data"]) > 0

    def test_system_has_required_fields(self, client_with_data):
        resp = client_with_data.get("/api/systems")
        systems = resp.json()["data"]
        for system in systems:
            assert "name" in system
            assert "display_name" in system
            assert "table_count" in system

    def test_systems_have_table_counts(self, client_with_data):
        resp = client_with_data.get("/api/systems")
        systems = resp.json()["data"]
        # At least rrp and edw should have tables
        rrp = next((s for s in systems if s["name"] == "rrp"), None)
        edw = next((s for s in systems if s["name"] == "edw"), None)
        assert rrp is not None
        assert edw is not None
        assert rrp["table_count"] >= 2  # RRP_EAST + RRP_MDL
        assert edw["table_count"] >= 1  # EDW_ICL


# ── GET /api/systems/{name}/tables ────────────────────────────


class TestGetSystemTables:
    def test_returns_tables_for_system(self, client_with_data):
        resp = client_with_data.get("/api/systems/rrp/tables")
        assert resp.status_code == 200
        data = resp.json()
        assert data["success"] is True
        assert isinstance(data["data"], list)
        assert data["total"] >= 2

    def test_table_has_required_fields(self, client_with_data):
        resp = client_with_data.get("/api/systems/rrp/tables")
        tables = resp.json()["data"]
        for t in tables:
            assert "full_name" in t
            assert "short_name" in t
            assert "layer" in t
            assert "field_count" in t

    def test_tables_belong_to_system(self, client_with_data):
        resp = client_with_data.get("/api/systems/rrp/tables")
        tables = resp.json()["data"]
        # RRP tables should have RRP_EAST or RRP_MDL schema prefix
        for t in tables:
            assert t["full_name"].startswith("RRP_"), f"Table {t['full_name']} doesn't belong to rrp"

    def test_keyword_filter(self, client_with_data):
        resp = client_with_data.get("/api/systems/rrp/tables?keyword=EAST5")
        assert resp.status_code == 200
        tables = resp.json()["data"]
        # Should only return tables matching "EAST5"
        for t in tables:
            assert "EAST5" in t["full_name"].upper() or "EAST5" in t["short_name"].upper()

    def test_keyword_filter_reduces_results(self, client_with_data):
        all_resp = client_with_data.get("/api/systems/rrp/tables")
        filtered_resp = client_with_data.get("/api/systems/rrp/tables?keyword=EAST5")
        all_count = all_resp.json()["total"]
        filtered_count = filtered_resp.json()["total"]
        assert filtered_count <= all_count

    def test_empty_system_returns_empty(self, client_with_data):
        resp = client_with_data.get("/api/systems/mcs/tables")
        assert resp.status_code == 200
        # MCS has 1 table in our mock data
        data = resp.json()
        assert data["success"] is True

    def test_unknown_system_returns_empty(self, client_with_data):
        resp = client_with_data.get("/api/systems/nonexistent/tables")
        assert resp.status_code == 200
        data = resp.json()
        assert data["data"] == []
        assert data["total"] == 0
