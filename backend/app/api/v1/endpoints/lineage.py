"""
血缘查询 API
"""
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query

from app.schemas.lineage import LineageGraph, LineageNode, LineagePath
from app.services.neo4j_lineage_service import Neo4jLineageService

router = APIRouter()


def get_lineage_service() -> Neo4jLineageService:
    return Neo4jLineageService()


@router.get("/table/{table_id}", response_model=LineageGraph)
async def get_table_lineage(
    table_id: str,
    depth: int = Query(5, ge=1, le=10, description="血缘深度"),
    direction: str = Query("upstream", description="方向：upstream, downstream, both"),
    service: Neo4jLineageService = Depends(get_lineage_service),
):
    """
    获取表的完整血缘

    Args:
        table_id: 表 ID
        depth: 血缘深度（1-10）
        direction: 方向（upstream, downstream, both）
    """
    try:
        graph = await service.get_table_lineage_with_expand(
            table_id=table_id,
            depth=depth,
            direction=direction,
        )
        return graph
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"查询血缘失败: {str(e)}")


@router.get("/table/{table_id}/details", response_model=LineageNode)
async def get_table_details(
    table_id: str,
    service: Neo4jLineageService = Depends(get_lineage_service),
):
    """
    获取表详情
    """
    try:
        node = await service.get_table_details(table_id)
        if not node:
            raise HTTPException(status_code=404, detail="表不存在")
        return node
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"查询表详情失败: {str(e)}")


@router.get("/field/{field_id}", response_model=LineagePath)
async def get_field_lineage(
    field_id: str,
    service: Neo4jLineageService = Depends(get_lineage_service),
):
    """
    获取字段的最小血缘链路
    """
    try:
        path = await service.get_field_lineage(field_id)
        return path
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"查询字段血缘失败: {str(e)}")


@router.get("/impact/{table_id}", response_model=LineageGraph)
async def get_impact_analysis(
    table_id: str,
    depth: int = Query(5, ge=1, le=10, description="影响深度"),
    service: Neo4jLineageService = Depends(get_lineage_service),
):
    """
    影响分析（下游血缘）
    """
    try:
        graph = await service.get_impact_analysis(table_id, depth)
        return graph
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"影响分析失败: {str(e)}")


@router.get("/job/{job_id}", response_model=LineageGraph)
async def get_job_lineage(
    job_id: str,
    service: Neo4jLineageService = Depends(get_lineage_service),
):
    """
    获取作业的血缘关系
    """
    try:
        graph = await service.get_job_lineage(job_id)
        return graph
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"查询作业血缘失败: {str(e)}")


@router.get("/search", response_model=List[LineageNode])
async def search_tables(
    name: Optional[str] = Query(None, description="表名（模糊查询）"),
    exact_name: Optional[str] = Query(None, description="表名（精确查询）"),
    data_source_id: Optional[str] = Query(None, description="数据源 ID"),
    limit: int = Query(20, ge=1, le=100, description="返回数量限制"),
    offset: int = Query(0, ge=0, description="偏移量"),
    service: Neo4jLineageService = Depends(get_lineage_service),
):
    """
    搜索表
    """
    try:
        nodes = await service.search_tables(
            name=name,
            exact_name=exact_name,
            data_source_id=data_source_id,
            limit=limit,
            offset=offset,
        )
        return nodes
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"搜索失败: {str(e)}")