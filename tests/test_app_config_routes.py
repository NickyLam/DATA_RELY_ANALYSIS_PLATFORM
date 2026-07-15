import asyncio
from unittest.mock import MagicMock, patch

import pytest
from fastapi.testclient import TestClient

from app import dependencies
from app import main as app_main
from app.config import AppConfig
from app.main import app


def test_data_dir_env_overrides_data_path(monkeypatch, tmp_path):
    custom_data_dir = tmp_path / "custom_data"
    monkeypatch.setenv("DATA_DIR", str(custom_data_dir))

    cfg = AppConfig.from_env()

    assert cfg.data_path == custom_data_dir


def test_root_serves_frontend_index():
    client = TestClient(app)

    response = client.get("/")

    assert response.status_code == 200
    assert response.headers["content-type"].startswith("text/html")
    assert "数据血缘分析系统" in response.text


def test_lifespan_raises_startup_initialization_errors(monkeypatch):
    def fail_parser_service():
        raise RuntimeError("parser unavailable")

    monkeypatch.setattr(app_main, "get_parser_service", fail_parser_service)

    async def run_lifespan():
        async with app_main.lifespan(app):
            pass

    with pytest.raises(RuntimeError, match="parser unavailable"):
        asyncio.run(run_lifespan())


@pytest.fixture(autouse=True)
def clear_service_caches():
    providers = (
        dependencies.get_indicator_service,
        dependencies.get_lineage_service,
        dependencies.get_table_query_service,
        dependencies.get_index_service,
        dependencies.get_parser_service,
        dependencies.get_cache_manager,
    )
    for provider in providers:
        provider.cache_clear()
    yield
    for provider in providers:
        provider.cache_clear()


def test_index_owner_is_cached_and_injected_into_query_services():
    parser = MagicMock()
    cache = MagicMock()
    owner = MagicMock()

    with (
        patch.object(dependencies, "get_parser_service", return_value=parser),
        patch.object(dependencies, "get_cache_manager", return_value=cache),
        patch.object(dependencies, "IndexService", return_value=owner) as index_type,
        patch.object(dependencies, "LineageService") as lineage_type,
        patch.object(dependencies, "TableQueryService") as table_query_type,
    ):
        assert dependencies.get_index_service() is owner
        assert dependencies.get_index_service() is owner
        dependencies.get_lineage_service()
        dependencies.get_table_query_service()

    index_type.assert_called_once_with(parser_service=parser, auto_start=False)
    lineage_type.assert_called_once_with(
        parser_service=parser,
        cache_manager=cache,
        index_service=owner,
    )
    table_query_type.assert_called_once_with(
        cache_manager=cache,
        index_service=owner,
    )


def test_index_owner_provider_clears_failed_construction():
    parser = MagicMock()
    owner = MagicMock()

    with (
        patch.object(dependencies, "get_parser_service", return_value=parser),
        patch.object(dependencies, "IndexService", side_effect=[RuntimeError("boom"), owner]) as index_type,
    ):
        with pytest.raises(RuntimeError, match="boom"):
            dependencies.get_index_service()
        assert dependencies.get_index_service() is owner

    assert index_type.call_count == 2


def _parse_result():
    return MagicMock(
        tables=[],
        procedures=[],
        parse_time_sec=0.0,
    )


def test_lifespan_starts_owner_and_closes_it_before_parser(monkeypatch, tmp_path):
    calls = []
    parser = MagicMock()
    parser.parse_existing_data.return_value = _parse_result()
    parser.shutdown.side_effect = lambda: calls.append("parser.shutdown")
    owner = MagicMock()
    owner.start.side_effect = lambda: calls.append("owner.start")
    owner.close.side_effect = lambda: calls.append("owner.close")

    monkeypatch.setattr(app_main.config, "data_dir", str(tmp_path))
    monkeypatch.setattr(app_main, "get_parser_service", MagicMock(return_value=parser))
    monkeypatch.setattr(app_main, "get_index_service", MagicMock(return_value=owner))
    monkeypatch.setattr(app_main, "get_progress_service", MagicMock(return_value=MagicMock()))
    monkeypatch.setattr(app_main, "get_lineage_service", MagicMock(return_value=MagicMock()))
    monkeypatch.setattr(app_main, "get_indicator_service", MagicMock(return_value=MagicMock()))

    async def run_lifespan():
        async with app_main.lifespan(app):
            assert calls == ["owner.start"]

    asyncio.run(run_lifespan())

    assert calls == ["owner.start", "owner.close", "parser.shutdown"]


def test_lifespan_cleans_owner_and_provider_caches_after_partial_startup_failure(monkeypatch, tmp_path):
    parser = MagicMock()
    parser.parse_existing_data.return_value = _parse_result()
    owner = MagicMock()
    index_provider = MagicMock(return_value=owner)

    monkeypatch.setattr(app_main.config, "data_dir", str(tmp_path))
    monkeypatch.setattr(app_main, "get_parser_service", MagicMock(return_value=parser))
    monkeypatch.setattr(app_main, "get_index_service", index_provider)
    monkeypatch.setattr(app_main, "get_progress_service", MagicMock(return_value=MagicMock()))
    monkeypatch.setattr(app_main, "get_lineage_service", MagicMock(return_value=MagicMock()))
    monkeypatch.setattr(app_main, "get_indicator_service", MagicMock(side_effect=RuntimeError("indicator unavailable")))

    async def run_lifespan():
        async with app_main.lifespan(app):
            pass

    with pytest.raises(RuntimeError, match="indicator unavailable"):
        asyncio.run(run_lifespan())

    owner.close.assert_called_once_with()
    parser.shutdown.assert_called_once_with()
    index_provider.cache_clear.assert_called_once_with()


def test_two_lifespan_cycles_resolve_distinct_live_owners(monkeypatch, tmp_path):
    parsers = [MagicMock(), MagicMock()]
    owners = [MagicMock(), MagicMock()]
    for parser in parsers:
        parser.parse_existing_data.return_value = _parse_result()
    parser_provider = MagicMock(side_effect=parsers)
    index_provider = MagicMock(side_effect=owners)
    cache_provider = MagicMock()

    monkeypatch.setattr(app_main.config, "data_dir", str(tmp_path))
    monkeypatch.setattr(app_main, "get_parser_service", parser_provider)
    monkeypatch.setattr(app_main, "get_index_service", index_provider)
    monkeypatch.setattr(app_main, "get_cache_manager", cache_provider)
    monkeypatch.setattr(app_main, "get_progress_service", MagicMock(return_value=MagicMock()))
    monkeypatch.setattr(app_main, "get_lineage_service", MagicMock(return_value=MagicMock()))
    monkeypatch.setattr(app_main, "get_indicator_service", MagicMock(return_value=MagicMock()))

    async def run_lifespan_twice():
        async with app_main.lifespan(app):
            pass
        async with app_main.lifespan(app):
            pass

    asyncio.run(run_lifespan_twice())

    assert index_provider.call_count == 2
    for owner in owners:
        owner.start.assert_called_once_with()
        owner.close.assert_called_once_with()
    assert index_provider.cache_clear.call_count == 2
    assert cache_provider.cache_clear.call_count == 2
