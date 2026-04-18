"""
API 单元测试
测试各个 API endpoint 的功能
"""

import pytest
from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


# ============================================
# 健康检查 API 测试
# ============================================

def test_health_check():
    """
    测试健康检查 API
    """
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_root():
    """
    测试根路径 API
    """
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()
    assert "version" in response.json()


# ============================================
# 资产搜索 API 测试
# ============================================

def test_search_tables():
    """
    测试搜索表 API
    """
    response = client.get("/api/v1/search/tables")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_search_tables_with_name():
    """
    测试带表名参数的搜索表 API
    """
    response = client.get("/api/v1/search/tables?name=test")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_search_fields():
    """
    测试搜索字段 API
    """
    response = client.get("/api/v1/search/fields")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


# ============================================
# 数据源管理 API 测试
# ============================================

def test_list_data_sources():
    """
    测试获取所有数据源 API
    """
    response = client.get("/api/v1/data-sources")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_create_data_source():
    """
    测试创建数据源 API
    """
    data_source_data = {
        "name": "Test Oracle",
        "type": "oracle",
        "host": "localhost",
        "port": 1521,
        "database_name": "ORCL",
    }
    response = client.post("/api/v1/data-sources", json=data_source_data)
    assert response.status_code == 200
    assert response.json()["name"] == "Test Oracle"


def test_get_data_source():
    """
    测试获取数据源详情 API
    """
    response = client.get("/api/v1/data-sources/test-id")
    assert response.status_code == 404  # 数据源不存在


# ============================================
# 血缘查询 API 测试
# ============================================

def test_get_table_lineage():
    """
    测试获取表级血缘 API
    """
    response = client.get("/api/v1/lineage/table/test-table-id")
    assert response.status_code == 200
    assert "nodes" in response.json()
    assert "edges" in response.json()


def test_get_field_lineage():
    """
    测试获取字段级血缘 API
    """
    response = client.get("/api/v1/lineage/field/test-field-id")
    assert response.status_code == 200
    assert "nodes" in response.json()
    assert "edges" in response.json()


def test_get_impact_analysis():
    """
    测试影响分析 API
    """
    response = client.get("/api/v1/lineage/impact/test-table-id")
    assert response.status_code == 200
    assert "nodes" in response.json()
    assert "edges" in response.json()


def test_get_job_lineage():
    """
    测试获取作业血缘 API
    """
    response = client.get("/api/v1/lineage/job/test-job-id")
    assert response.status_code == 200
    assert "nodes" in response.json()
    assert "edges" in response.json()


# ============================================
# 运行测试
# ============================================

if __name__ == "__main__":
    pytest.main([__file__, "-v"])