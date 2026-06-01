"""
口径 API 测试用例（已迁移至 /api/lineage/* 子路由）
测试 edge-caliber、node-detail、node-caliber 端点
"""

import sys
from pathlib import Path
from unittest.mock import MagicMock

import pytest
from fastapi.testclient import TestClient

sys.path.insert(0, str(Path(__file__).parent.parent))

from app.dependencies import get_lineage_service
from app.main import app


@pytest.fixture
def client():
    return TestClient(app)


@pytest.fixture
def mock_lineage_service():
    """使用 dependency_overrides 注入 mock LineageService"""
    service = MagicMock()
    service.get_edge_caliber.return_value = {
        "transform_logic": "SELECT a, b FROM src",
        "where_conditions": [],
    }
    service.get_node_detail.return_value = {
        "table_name": "TEST_TABLE",
        "fields": ["ID", "NAME"],
        "upstream_tables": [],
        "downstream_tables": [],
        "procedures": [],
    }
    service.build_summary_card.return_value = {
        "success": True,
        "data": {"summary": "test"},
    }
    app.dependency_overrides[get_lineage_service] = lambda: service
    yield service
    app.dependency_overrides.pop(get_lineage_service, None)


class TestEdgeCaliber:
    """边口径查询测试"""

    def test_get_edge_caliber(self, client, mock_lineage_service):
        """TC-201: 边口径详情查询"""
        response = client.get("/api/lineage/edge-caliber?src=SRC_TABLE&src_col=ID&tgt=TGT_TABLE&tgt_col=ID")
        assert response.status_code == 200

    def test_edge_caliber_missing_params(self, client, mock_lineage_service):
        """缺少必要参数应返回 422"""
        response = client.get("/api/lineage/edge-caliber?src=SRC_TABLE")
        assert response.status_code == 422


class TestNodeDetail:
    """节点详情查询测试"""

    def test_get_node_detail(self, client, mock_lineage_service):
        """TC-202: 节点详情查询"""
        response = client.get("/api/lineage/node-detail?table=TEST_TABLE")
        assert response.status_code == 200

    def test_node_detail_not_found(self, client, mock_lineage_service):
        """节点不存在应返回 404"""
        mock_lineage_service.get_node_detail.return_value = None
        response = client.get("/api/lineage/node-detail?table=NONEXISTENT")
        assert response.status_code == 404


class TestNodeCaliber:
    """节点口径概览卡测试"""

    def test_get_node_caliber(self, client, mock_lineage_service):
        """TC-203: 节点口径概览卡"""
        response = client.get("/api/lineage/node-caliber?table=TEST_TABLE&field=ID")
        assert response.status_code == 200

    def test_node_caliber_with_direction(self, client, mock_lineage_service):
        """带方向参数的口径查询"""
        response = client.get("/api/lineage/node-caliber?table=TEST_TABLE&field=ID&direction=downstream")
        assert response.status_code == 200


class TestCaliberDeprecation:
    """P4: /api/caliber/* 弃用头测试 — 已在 P5 中删除路由，此测试保留兼容性验证"""

    def test_lineage_routes_not_deprecated(self, client):
        """lineage 路由不应有弃用头"""
        response = client.get("/api/stats")
        assert response.headers.get("Deprecation") is None
        assert response.headers.get("Sunset") is None
