"""
Pytest 测试配置和共享夹具
"""
import pytest
import asyncio
from unittest.mock import MagicMock, AsyncMock, patch


@pytest.fixture(scope="session")
def event_loop():
    """创建事件循环用于异步测试"""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()


@pytest.fixture
def mock_neo4j_driver():
    """
    模拟 Neo4j 驱动夹具
    用于所有需要 Neo4j 连接的测试
    """
    driver = MagicMock()
    session = AsyncMock()
    session.__aenter__ = AsyncMock(return_value=session)
    session.__aexit__ = AsyncMock(return_value=None)
    driver.session.return_value = session
    return driver


@pytest.fixture
def mock_neo4j_sync_driver():
    """
    模拟同步 Neo4j 驱动夹具
    用于使用同步驱动的测试（如 shortest_path_service）
    """
    driver = MagicMock()
    session = MagicMock()
    session.__enter__ = MagicMock(return_value=session)
    session.__exit__ = MagicMock(return_value=None)
    driver.session.return_value = session
    return driver


@pytest.fixture
def sample_table_data():
    """示例表数据"""
    return {
        'id': 'table_001',
        'name': 'users',
        'schema_name': 'public',
        'database_name': 'test_db',
        'data_source_id': 'ds_001',
        'data_source_name': 'Test Oracle',
        'table_type': 'TABLE',
        'description': '用户表',
        'column_count': 10,
        'lineage_count': 5,
        'upstream_count': 2,
        'downstream_count': 3,
        'owner': 'admin',
    }


@pytest.fixture
def sample_field_data():
    """示例字段数据"""
    return {
        'id': 'field_001',
        'name': 'user_id',
        'table_id': 'table_001',
        'table_name': 'users',
        'schema_name': 'public',
        'database_name': 'test_db',
        'data_source_id': 'ds_001',
        'data_source_name': 'Test Oracle',
        'data_type': 'NUMBER',
        'is_primary_key': True,
        'is_foreign_key': False,
        'is_nullable': False,
        'description': '用户 ID',
        'position': 1,
        'lineage_count': 3,
    }


@pytest.fixture
def sample_lineage_graph():
    """示例血缘图数据"""
    return {
        'nodes': [
            {'id': 'table_001', 'name': 'users', 'type': 'Table'},
            {'id': 'table_002', 'name': 'orders', 'type': 'Table'},
        ],
        'edges': [
            {'source_id': 'table_001', 'target_id': 'table_002', 'type': 'LINEAGE_TO'},
        ],
    }


@pytest.fixture
def sample_search_results():
    """示例搜索结果"""
    return {
        'tables': [],
        'fields': [],
        'total_tables': 0,
        'total_fields': 0,
        'page': 1,
        'page_size': 20,
        'total_pages': 0,
    }


@pytest.fixture
def mock_async_query_result():
    """模拟异步查询结果"""
    result = MagicMock()
    result.list = AsyncMock(return_value=[])
    result.single = AsyncMock(return_value=None)
    return result


@pytest.fixture
def mock_sync_query_result():
    """模拟同步查询结果"""
    result = MagicMock()
    result.list = MagicMock(return_value=[])
    result.single = MagicMock(return_value=None)
    return result


# 性能测试辅助函数
def calculate_percentile(data, percentile):
    """
    计算百分位数
    兼容 Python 3.9 及以下版本
    """
    sorted_data = sorted(data)
    k = (len(sorted_data) - 1) * percentile / 100
    f = int(k)
    c = f + 1 if f + 1 < len(sorted_data) else f
    return sorted_data[f] + (sorted_data[c] - sorted_data[f]) * (k - f)


@pytest.fixture
def performance_thresholds():
    """性能阈值配置"""
    return {
        'search_p95_ms': 2000,  # 搜索 P95 ≤ 2 秒
        'lineage_table_p95_ms': 3000,  # 表级血缘 P95 ≤ 3 秒
        'lineage_field_p95_ms': 5000,  # 字段级血缘 P95 ≤ 5 秒
        'concurrent_users': 50,  # 并发用户数
        'max_total_time_ms': 10000,  # 最大总时间
    }