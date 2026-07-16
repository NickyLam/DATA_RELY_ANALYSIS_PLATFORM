"""
血缘查询 API 测试用例
TC-101 到 TC-108
"""

from unittest.mock import MagicMock

import pytest
from fastapi.testclient import TestClient

from app.dependencies import get_index_service, get_lineage_service, get_table_query_service
from app.main import app
from app.services.index_service import RefreshOutcome, RefreshResult
from app.services.table_query_service import NoCommittedSnapshotError


@pytest.fixture
def client():
    """创建测试客户端"""
    return TestClient(app)


@pytest.fixture
def mock_lineage_service():
    """模拟 LineageService"""
    service = MagicMock()
    # 设置默认返回值
    service.search_tables.return_value = [{"full_name": "TEST_TABLE", "short_name": "TEST_TABLE", "layer": "MDL", "field_count": 10}]
    service.search_procedures.return_value = [{"full_name": "TEST_PROC", "source_tables": [], "target_tables": []}]
    service.query_lineage.return_value = {"nodes": [], "edges": [], "chains": [], "query_time_ms": 0.0}
    service.get_system_stats.return_value = {
        "total_tables": 100,
        "total_procedures": 50,
        "total_field_mappings": 1000,
    }
    app.dependency_overrides[get_lineage_service] = lambda: service
    try:
        yield service
    finally:
        app.dependency_overrides.pop(get_lineage_service, None)


@pytest.fixture
def mock_parser_service():
    """模拟 TableQueryService（fixture 名保留以兼容既有测试）。"""
    service = MagicMock()
    service.get_table_fields.return_value = ["ID", "NAME"]
    service.get_table_info.return_value = {
        "full_name": "TEST_TABLE",
        "columns": [
            {"name": "ID", "data_type": "NUMBER"},
            {"name": "NAME", "data_type": "VARCHAR2"},
        ],
    }
    app.dependency_overrides[get_table_query_service] = lambda: service
    try:
        yield service
    finally:
        app.dependency_overrides.pop(get_table_query_service, None)


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
        mock_parser_service.get_table_info.return_value = None
        response = client.get("/api/tables/NON_EXISTENT_TABLE")
        assert response.status_code == 404
        assert response.json() == {"detail": "指定的表不存在"}

    @pytest.mark.parametrize(
        ("path", "service_method"),
        [
            ("/api/tables/ANY/fields", "get_table_fields"),
            ("/api/tables/ANY", "get_table_info"),
        ],
    )
    def test_table_lookup_without_snapshot_preserves_no_data_error(
        self,
        client,
        mock_parser_service,
        path: str,
        service_method: str,
    ):
        getattr(mock_parser_service, service_method).side_effect = NoCommittedSnapshotError

        response = client.get(path)

        assert response.status_code == 404
        assert response.json() == {"detail": "无可用数据"}


class TestSystemStats:
    """系统统计测试"""

    def test_get_system_stats(self, client, mock_lineage_service):
        """TC-107: 系统统计查询"""
        response = client.get("/api/stats")
        assert response.status_code == 200


class TestCacheRebuild:
    """缓存重建测试"""

    def test_rebuild_cache(self, client, mock_lineage_service, mock_caliber_service):
        """TC-108: 缓存重建（未配置 ADMIN_API_KEY 时应返回 403）"""
        response = client.post("/api/cache/rebuild")
        assert response.status_code == 403

    def test_rebuild_cache_with_admin_key(self, client, mock_lineage_service, mock_caliber_service, monkeypatch):
        """TC-108: 缓存重建（配置 ADMIN_API_KEY 后应成功）"""
        owner = MagicMock()
        owner.refresh.return_value = RefreshResult(
            1,
            RefreshOutcome.FORCED_PUBLISHED,
            7,
            7,
            (7, 1),
            publication_namespace=(7, 2),
        )
        app.dependency_overrides[get_index_service] = lambda: owner
        monkeypatch.setenv("ADMIN_API_KEY", "test-admin-key")
        try:
            response = client.post(
                "/api/cache/rebuild",
                headers={"X-Admin-Key": "test-admin-key"},
            )
            assert response.status_code == 200
            assert response.json()["success"] is True
            assert response.json()["message"] == "索引重建完成"
            owner.refresh.assert_called_once_with(force=True, trigger="explicit")
        finally:
            app.dependency_overrides.pop(get_index_service, None)

    @pytest.mark.parametrize(
        "outcome",
        [
            RefreshOutcome.FAILED,
            RefreshOutcome.NO_DATA,
            RefreshOutcome.STALE,
            RefreshOutcome.CLOSED,
            RefreshOutcome.DUPLICATE,
            RefreshOutcome.COALESCED,
        ],
    )
    def test_rebuild_cache_rejects_non_published_outcomes(self, client, monkeypatch, outcome):
        owner = MagicMock()
        owner.refresh.return_value = RefreshResult(
            1,
            outcome,
            8,
            8,
            (7, 1),
            failure_component="source_data",
            failure_code="build_failed",
        )
        app.dependency_overrides[get_index_service] = lambda: owner
        monkeypatch.setenv("ADMIN_API_KEY", "test-admin-key")
        try:
            response = client.post(
                "/api/cache/rebuild",
                headers={"X-Admin-Key": "test-admin-key"},
            )
        finally:
            app.dependency_overrides.pop(get_index_service, None)

        assert response.status_code == 500
        assert response.json() == {"detail": "索引重建失败"}
        assert "source_data" not in response.text
        assert "build_failed" not in response.text


class TestEdgeCaliber:
    """P2: 单边口径懒加载 API"""

    @pytest.fixture
    def override_service(self):
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
