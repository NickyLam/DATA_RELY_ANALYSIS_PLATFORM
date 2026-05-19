"""
指标血缘 API 测试用例
TC-301 到 TC-305
"""
import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

from app.main import app


@pytest.fixture
def client():
    return TestClient(app)


@pytest.fixture
def mock_indicator_service():
    with patch("app.dependencies.get_indicator_service") as mock:
        service = MagicMock()
        service.search_indicators.return_value = [
            {"index_no": "FM0100011", "index_name": "测试指标"}
        ]
        service.get_indicator_detail.return_value = {
            "index_no": "FM0100011",
            "index_name": "测试指标",
            "index_bclass": "1"
        }
        service.trace_indicator.return_value = {
            "nodes": [],
            "edges": []
        }
        service.get_pipeline_steps.return_value = []
        service.get_stats.return_value = {
            "total_indicators": 100,
            "total_dependencies": 500
        }
        service.get_indicator_source_tables.return_value = []
        service.bridge_to_field_lineage.return_value = {
            "success": True,
            "data": {}
        }
        mock.return_value = service
        yield service


class TestIndicatorSearch:
    """指标搜索测试"""

    def test_search_indicators(self, client, mock_indicator_service):
        """TC-301: 指标搜索"""
        response = client.get("/api/indicator/search?keyword=FM0100011")
        assert response.status_code == 200
        data = response.json()
        assert "success" in data or "data" in data


class TestIndicatorDetail:
    """指标详情测试"""

    def test_get_indicator_detail(self, client, mock_indicator_service):
        """TC-302: 指标详情查询"""
        response = client.get("/api/indicator/detail?index_no=FM0100011")
        assert response.status_code == 200


class TestIndicatorLineage:
    """指标血缘测试"""

    def test_get_indicator_lineage(self, client, mock_indicator_service):
        """TC-303: 指标血缘查询"""
        response = client.get(
            "/api/indicator/lineage?index_no=FM0100011&direction=upstream&depth=10"
        )
        assert response.status_code == 200


class TestIndicatorPipeline:
    """指标流水线测试"""

    def test_get_indicator_pipeline(self, client, mock_indicator_service):
        """TC-304: 指标流水线"""
        response = client.get("/api/indicator/pipeline?index_no=FM0100011")
        assert response.status_code == 200


class TestIndicatorStats:
    """指标统计测试"""

    def test_get_indicator_stats(self, client, mock_indicator_service):
        """TC-305: 指标统计"""
        response = client.get("/api/indicator/stats")
        assert response.status_code == 200

    def test_get_source_tables(self, client, mock_indicator_service):
        """测试获取指标源表"""
        response = client.get("/api/indicator/source-tables?index_no=FM0100011")
        assert response.status_code == 200

    def test_bridge_to_field_lineage(self, client, mock_indicator_service):
        """测试桥接到字段血缘"""
        response = client.get("/api/indicator/bridge-lineage?table_name=TEST_TABLE")
        assert response.status_code == 200
