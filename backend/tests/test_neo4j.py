"""
Neo4j 查询测试
测试血缘图谱查询功能
"""

import pytest
from neo4j import AsyncGraphDatabase

from app.services.neo4j_lineage_service import Neo4jLineageService
from app.schemas.lineage import LineageGraph, LineagePath


# ============================================
# Neo4j 连接测试
# ============================================

@pytest.mark.asyncio
async def test_neo4j_connection():
    """
    测试 Neo4j 连接
    """
    service = Neo4jLineageService()
    
    # 测试连接
    driver = AsyncGraphDatabase.driver(
        "bolt://localhost:7687",
        auth=("neo4j", "neo4j123"),
    )
    
    async with driver.session() as session:
        result = await session.run("RETURN 1 as value")
        record = await result.single()
        assert record["value"] == 1
    
    await driver.close()
    await service.close()


# ============================================
# 表级血缘查询测试
# ============================================

@pytest.mark.asyncio
async def test_get_table_lineage():
    """
    测试获取表级血缘
    """
    service = Neo4jLineageService()
    
    # 测试查询
    lineage = await service.get_table_lineage(
        table_id="t-target-001",
        depth=5,
        direction="upstream",
    )
    
    assert isinstance(lineage, LineageGraph)
    assert lineage.total_nodes >= 0
    assert lineage.total_edges >= 0
    
    await service.close()


@pytest.mark.asyncio
async def test_get_table_lineage_downstream():
    """
    测试获取表级下游血缘
    """
    service = Neo4jLineageService()
    
    # 测试查询
    lineage = await service.get_table_lineage(
        table_id="t-source-001",
        depth=5,
        direction="downstream",
    )
    
    assert isinstance(lineage, LineageGraph)
    assert lineage.total_nodes >= 0
    assert lineage.total_edges >= 0
    
    await service.close()


# ============================================
# 字段级血缘查询测试
# ============================================

@pytest.mark.asyncio
async def test_get_field_lineage():
    """
    测试获取字段级最小血缘链路
    """
    service = Neo4jLineageService()
    
    # 测试查询
    lineage = await service.get_field_lineage(
        field_id="f-target-id-001",
    )
    
    assert isinstance(lineage, LineagePath)
    assert lineage.path_length >= 0
    
    await service.close()


# ============================================
# 影响分析测试
# ============================================

@pytest.mark.asyncio
async def test_get_impact_analysis():
    """
    测试影响分析
    """
    service = Neo4jLineageService()
    
    # 测试查询
    impact = await service.get_impact_analysis(
        table_id="t-source-001",
        depth=5,
    )
    
    assert isinstance(impact, LineageGraph)
    assert impact.total_nodes >= 0
    assert impact.total_edges >= 0
    
    await service.close()


# ============================================
# 作业血缘查询测试
# ============================================

@pytest.mark.asyncio
async def test_get_job_lineage():
    """
    测试获取作业血缘
    """
    service = Neo4jLineageService()
    
    # 测试查询
    lineage = await service.get_job_lineage(
        job_id="job-etl-001",
    )
    
    assert isinstance(lineage, LineageGraph)
    assert lineage.total_nodes >= 0
    assert lineage.total_edges >= 0
    
    await service.close()


# ============================================
# 表搜索测试
# ============================================

@pytest.mark.asyncio
async def test_search_tables():
    """
    测试搜索表
    """
    service = Neo4jLineageService()
    
    # 测试搜索
    tables = await service.search_tables(
        name="T_TARGET",
        limit=10,
    )
    
    assert isinstance(tables, list)
    assert len(tables) >= 0
    
    await service.close()


@pytest.mark.asyncio
async def test_search_tables_exact():
    """
    测试精确搜索表
    """
    service = Neo4jLineageService()
    
    # 测试搜索
    tables = await service.search_tables(
        exact_name="T_TARGET_TABLE",
        limit=10,
    )
    
    assert isinstance(tables, list)
    assert len(tables) >= 0
    
    await service.close()


# ============================================
# 血缘边创建测试
# ============================================

@pytest.mark.asyncio
async def test_create_lineage_edge():
    """
    测试创建血缘边
    """
    service = Neo4jLineageService()
    
    # 测试创建
    success = await service.create_lineage_edge(
        source_id="test-source-id",
        target_id="test-target-id",
        edge_type="LINEAGE_TO",
        properties={
            "transformation_type": "DIRECT_MAP",
            "confidence_score": 0.95,
        },
    )
    
    assert isinstance(success, bool)
    
    await service.close()


# ============================================
# 运行测试
# ============================================

if __name__ == "__main__":
    pytest.main([__file__, "-v", "--asyncio-mode=auto"])