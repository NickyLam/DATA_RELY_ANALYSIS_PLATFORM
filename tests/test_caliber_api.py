"""
指标口径 API 测试用例
TC-201 到 TC-209
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
def mock_caliber_service():
    with patch("app.dependencies.get_caliber_service") as mock:
        service = MagicMock()
        service.query_caliber.return_value = {
            "chains": [],
            "summary": {}
        }
        service.build_pipeline_view.return_value = {
            "success": True,
            "data": {"steps": []}
        }
        service.build_summary_card.return_value = {
            "success": True,
            "data": {}
        }
        service.build_step_detail.return_value = {
            "success": True,
            "data": {}
        }
        service.get_direct_sources.return_value = []
        service.get_direct_targets.return_value = []
        service.search_indicators.return_value = []
        service.get_fields_with_caliber.return_value = []
        service.get_datasources.return_value = ["oracle", "tdh", "gbase"]
        service.query_caliber_summary.return_value = "# 口径摘要"
        mock.return_value = service
        yield service


class TestCaliberQuery:
    """口径查询测试"""

    def test_query_caliber_upstream(self, client, mock_caliber_service):
        """TC-201: 口径查询 - 上游追溯"""
        request_data = {
            "table": "TEST_TABLE",
            "field": "ID",
            "depth": 10,
            "direction": "upstream"
        }
        response = client.post("/api/caliber/query", json=request_data)
        assert response.status_code in [200, 422]

    def test_query_caliber_summary(self, client, mock_caliber_service):
        """测试口径摘要查询"""
        response = client.get("/api/caliber/summary?table=TEST_TABLE&field=ID")
        assert response.status_code == 200


class TestCaliberPipeline:
    """Pipeline 视图测试"""

    def test_get_pipeline_view(self, client, mock_caliber_service):
        """TC-202: 口径 Pipeline 视图"""
        response = client.get("/api/caliber/pipeline?table=TEST_TABLE&field=ID")
        assert response.status_code == 200

    def test_get_summary_card(self, client, mock_caliber_service):
        """TC-205: 口径概览卡"""
        response = client.get("/api/caliber/card-summary?table=TEST_TABLE&field=ID")
        assert response.status_code == 200

    def test_get_step_detail(self, client, mock_caliber_service):
        """TC-206: 步骤详情查询"""
        response = client.get("/api/caliber/step-detail?table=TEST_TABLE&field=ID&step_num=1")
        assert response.status_code == 200


class TestDirectLineage:
    """直接上下游测试"""

    def test_get_direct_sources(self, client, mock_caliber_service):
        """TC-203: 直接上游查询"""
        response = client.get("/api/caliber/sources?table=TEST_TABLE&field=ID")
        assert response.status_code == 200

    def test_get_direct_targets(self, client, mock_caliber_service):
        """TC-204: 直接下游查询"""
        response = client.get("/api/caliber/targets?table=TEST_TABLE&field=ID")
        assert response.status_code == 200


class TestCaliberSearch:
    """口径搜索测试"""

    def test_search_caliber(self, client, mock_caliber_service):
        """TC-207: 口径搜索"""
        response = client.get("/api/caliber/search?keyword=TEST")
        assert response.status_code == 200

    def test_get_caliber_fields(self, client, mock_caliber_service):
        """TC-208: 口径字段列表"""
        response = client.get("/api/caliber/fields?table=TEST_TABLE")
        assert response.status_code == 200

    def test_get_datasources(self, client, mock_caliber_service):
        """测试获取数据源列表"""
        response = client.get("/api/caliber/datasources/list")
        assert response.status_code == 200


class TestCaliberExport:
    """口径导出测试"""

    def test_export_caliber(self, client, mock_caliber_service):
        """TC-209: 口径文档导出"""
        request_data = {
            "table": "TEST_TABLE",
            "field": "ID",
            "format": "markdown"
        }
        response = client.post("/api/caliber/export", json=request_data)
        assert response.status_code in [200, 422]
