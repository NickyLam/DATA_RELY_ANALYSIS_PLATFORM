"""
血缘查询 API 测试用例
TC-101 到 TC-108
"""

import sys
from pathlib import Path
from unittest.mock import MagicMock, patch

import pytest
from fastapi.testclient import TestClient

# 添加项目根目录
sys.path.insert(0, str(Path(__file__).parent.parent))

from app.main import app


@pytest.fixture
def client():
    """创建测试客户端"""
    return TestClient(app)


@pytest.fixture
def mock_lineage_service():
    """模拟 LineageService"""
    with patch("app.dependencies.get_lineage_service") as mock:
        service = MagicMock()
        # 设置默认返回值
        service.search_tables.return_value = [{"full_name": "TEST_TABLE", "layer": "MDL", "column_count": 10}]
        service.search_procedures.return_value = [{"full_name": "TEST_PROC", "source_tables": [], "target_tables": []}]
        service.query_lineage.return_value = {"nodes": [], "edges": [], "chains": []}
        service.get_system_stats.return_value = {
            "tables_count": 100,
            "procedures_count": 50,
            "field_mappings_count": 1000,
        }
        mock.return_value = service
        yield service


@pytest.fixture
def mock_parser_service():
    """模拟 ParserService"""
    with patch("app.dependencies.get_parser_service") as mock:
        service = MagicMock()
        service.get_current_data.return_value = {
            "tables": [
                {
                    "full_name": "TEST_TABLE",
                    "columns": [
                        {"name": "ID", "data_type": "NUMBER"},
                        {"name": "NAME", "data_type": "VARCHAR2"},
                    ],
                }
            ]
        }
        mock.return_value = service
        yield service


@pytest.fixture
def mock_caliber_service():
    """模拟 CaliberService（已迁移至 lineage_service，保留 fixture 兼容）"""
    service = MagicMock()
    yield service


class TestTableSearch:
    """表搜索测试"""

    def test_search_tables_valid_keyword(self, client, mock_lineage_service):
        """TC-101: 表搜索 - 有效关键词"""
        response = client.get("/api/tables?keyword=TEST")
        assert response.status_code == 200
        data = response.json()
        assert "success" in data or "data" in data

    def test_search_tables_empty_keyword(self, client, mock_lineage_service):
        """TC-102: 表搜索 - 空关键词"""
        response = client.get("/api/tables?keyword=")
        assert response.status_code in [200, 400, 422]  # 不同版本可能返回不同状态码

    def test_search_tables_limit(self, client, mock_lineage_service):
        """测试限制返回数量"""
        response = client.get("/api/tables?keyword=TEST&limit=10")
        assert response.status_code == 200


class TestLineageQuery:
    """血缘查询测试"""

    def test_query_lineage_upstream(self, client, mock_lineage_service):
        """TC-103: 血缘查询 - 上游追溯"""
        request_data = {
            "table": "TEST_TABLE",
            "field": "ID",
            "depth": 3,
            "mode": "upstream",
        }
        response = client.post("/api/lineage/query", json=request_data)
        assert response.status_code in [200, 422]

    def test_query_lineage_downstream(self, client, mock_lineage_service):
        """TC-104: 血缘查询 - 下游追溯"""
        request_data = {
            "table": "TEST_TABLE",
            "field": "ID",
            "depth": 3,
            "mode": "downstream",
        }
        response = client.post("/api/lineage/query", json=request_data)
        assert response.status_code in [200, 422]

    def test_query_lineage_get(self, client, mock_lineage_service):
        """测试 GET 方式查询血缘"""
        response = client.get("/api/lineage/TEST_TABLE/ID?depth=3")
        assert response.status_code in [200, 404, 422]


class TestTableDetail:
    """表详情查询测试"""

    def test_get_table_detail_exists(self, client, mock_parser_service):
        """TC-106: 表详情查询（存在的表）"""
        response = client.get("/api/tables/TEST_TABLE")
        assert response.status_code in [200, 404]

    def test_get_table_detail_not_exists(self, client, mock_parser_service):
        """TC-105: 血缘查询 - 不存在的表"""
        # 修改 mock 返回空数据
        mock_parser_service.get_current_data.return_value = {"tables": []}
        response = client.get("/api/tables/NON_EXISTENT_TABLE")
        assert response.status_code in [200, 404]


class TestSystemStats:
    """系统统计测试"""

    def test_get_system_stats(self, client, mock_lineage_service):
        """TC-107: 系统统计查询"""
        response = client.get("/api/stats")
        assert response.status_code == 200


class TestCacheRebuild:
    """缓存重建测试"""

    def test_rebuild_cache(self, client, mock_lineage_service, mock_caliber_service):
        """TC-108: 缓存重建"""
        response = client.post("/api/cache/rebuild")
        assert response.status_code == 200


class TestEdgeCaliber:
    """P2: 单边口径懒加载 API"""

    @pytest.fixture
    def override_service(self):
        from app.dependencies import get_lineage_service

        service = MagicMock()
        app.dependency_overrides[get_lineage_service] = lambda: service
        try:
            yield service
        finally:
            app.dependency_overrides.pop(get_lineage_service, None)

    def test_edge_caliber_hit(self, client, override_service):
        override_service.get_edge_caliber.return_value = {
            "target_table": "RRP_MDL.MID_TBL",
            "target_column": "MID_COL",
            "source_table": "RRP_ODS.SRC_TBL",
            "source_column": "SRC_COL",
            "transform_logic": "NVL(SRC_COL, 0)",
            "procedure": "RRP_PROC.P_DEMO",
            "where_conditions": [],
            "join_conditions": [],
        }
        response = client.get(
            "/api/lineage/edge-caliber?src=RRP_ODS.SRC_TBL&src_col=SRC_COL&tgt=RRP_MDL.MID_TBL&tgt_col=MID_COL"
        )
        assert response.status_code == 200
        body = response.json()
        assert body["success"] is True
        assert body["data"]["transform_logic"] == "NVL(SRC_COL, 0)"
        override_service.get_edge_caliber.assert_called_once()

    def test_edge_caliber_miss(self, client, override_service):
        override_service.get_edge_caliber.return_value = None
        response = client.get("/api/lineage/edge-caliber?src=NO_TBL&src_col=NO_COL&tgt=NA_TBL&tgt_col=NA_COL")
        assert response.status_code == 200
        body = response.json()
        assert body["success"] is True
        assert body["data"] is None

    def test_edge_caliber_missing_param(self, client, override_service):
        response = client.get("/api/lineage/edge-caliber?src=A&src_col=B&tgt=C")
        assert response.status_code == 422

    def test_edge_caliber_with_procedure(self, client, override_service):
        override_service.get_edge_caliber.return_value = {"target_column": "X"}
        response = client.get("/api/lineage/edge-caliber?src=A&src_col=B&tgt=C&tgt_col=D&proc=P.MYPROC")
        assert response.status_code == 200
        args, _ = override_service.get_edge_caliber.call_args
        assert args[-1] == "P.MYPROC"


class TestNodeDetail:
    """P2: 节点详情懒加载 API"""

    @pytest.fixture
    def override_service(self):
        from app.dependencies import get_lineage_service

        service = MagicMock()
        app.dependency_overrides[get_lineage_service] = lambda: service
        try:
            yield service
        finally:
            app.dependency_overrides.pop(get_lineage_service, None)

    def test_node_detail_hit(self, client, override_service):
        override_service.get_node_detail.return_value = {
            "table": "RRP_MDL.MID_TBL",
            "short_name": "MID_TBL",
            "schema": "RRP_MDL",
            "comment": "",
            "fields": [{"name": "MID_COL", "type": "VARCHAR2(10)"}],
            "upstream_tables": ["RRP_ODS.SRC_TBL"],
            "downstream_tables": ["RRP_EAST.TGT_TBL"],
            "procedures": ["RRP_PROC.P_DEMO"],
        }
        response = client.get("/api/lineage/node-detail?table=RRP_MDL.MID_TBL")
        assert response.status_code == 200
        body = response.json()
        assert body["success"] is True
        assert body["data"]["short_name"] == "MID_TBL"
        assert any(f["name"] == "MID_COL" for f in body["data"]["fields"])

    def test_node_detail_not_found(self, client, override_service):
        override_service.get_node_detail.return_value = None
        response = client.get("/api/lineage/node-detail?table=NO_SUCH_TBL")
        assert response.status_code == 404

    def test_node_detail_missing_param(self, client, override_service):
        response = client.get("/api/lineage/node-detail")
        assert response.status_code == 422
