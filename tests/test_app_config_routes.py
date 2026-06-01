from fastapi.testclient import TestClient

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
