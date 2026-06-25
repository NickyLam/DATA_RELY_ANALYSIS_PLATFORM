import asyncio

import pytest
from fastapi.testclient import TestClient

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
