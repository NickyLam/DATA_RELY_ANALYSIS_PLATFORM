"""
字段血缘查询 API
"""
from typing import List

from fastapi import APIRouter, Depends, HTTPException, Query

from app.schemas.field_lineage import (
    FieldDetailResponse,
    FieldSearchRequest,
    FieldSearchResult,
    FieldLineageQueryRequest,
    ShortestPathResponse,
    ExportRequest,
    ExportResponse,
    FieldNodeResponse,
    FieldEdgeResponse,
    ExpressionDetailResponse,
)
from app.services.shortest_path_service import ShortestPathService

router = APIRouter()


def get_shortest_path_service():
    """获取最短路径服务"""
    service = ShortestPathService()
    try:
        yield service
    finally:
        service.close()


@router.get("/shortest-path/{field_id}", response_model=ShortestPathResponse)
async def get_field_shortest_path(
    field_id: str,
    max_depth: int = Query(10, ge=1, le=20, description="最大搜索深度"),
    include_expression: bool = Query(True, description="是否包含表达式解析"),
    service: ShortestPathService = Depends(get_shortest_path_service),
):
    """
    获取字段的最小血缘链路
    
    使用 Dijkstra 算法计算从目标字段到源字段的最短路径，
    支持多源汇聚场景。
    """
    result = service.get_field_shortest_path(
        target_field_id=field_id,
        max_depth=max_depth,
        include_expression=include_expression,
    )
    
    nodes = [
        FieldNodeResponse(
            id=node.id,
            name=node.name,
            table_name=node.table_name,
            full_name=node.full_name,
            data_type=node.data_type,
            expression=node.expression,
            is_source=node.is_source,
            properties=node.properties,
        )
        for node in result.nodes
    ]
    
    edges = []
    for edge in result.edges:
        expr_detail = None
        if "expression_detail" in edge.properties:
            detail = edge.properties["expression_detail"]
            expr_detail = ExpressionDetailResponse(
                raw_expression=detail.raw_expression,
                parsed_expression=detail.parsed_expression,
                transformation_type=detail.transformation_type,
                source_fields=detail.source_fields,
                aggregation_type=detail.aggregation_type,
                join_condition=detail.join_condition,
                filter_condition=detail.filter_condition,
                description=detail.description,
            )
        
        edges.append(FieldEdgeResponse(
            source_id=edge.source_id,
            target_id=edge.target_id,
            transformation_type=edge.transformation_type,
            expression=edge.expression,
            confidence_score=edge.confidence_score,
            sql_statement=edge.sql_statement,
            job_id=edge.job_id,
            expression_detail=expr_detail,
            properties=edge.properties,
        ))
    
    source_nodes = [
        FieldNodeResponse(
            id=node.id,
            name=node.name,
            table_name=node.table_name,
            full_name=node.full_name,
            data_type=node.data_type,
            expression=node.expression,
            is_source=node.is_source,
            properties=node.properties,
        )
        for node in result.source_nodes
    ]
    
    multi_paths = {}
    for source_id, path_nodes in result.multi_source_paths.items():
        multi_paths[source_id] = [
            FieldNodeResponse(
                id=node.id,
                name=node.name,
                table_name=node.table_name,
                full_name=node.full_name,
                data_type=node.data_type,
                expression=node.expression,
                is_source=node.is_source,
                properties=node.properties,
            )
            for node in path_nodes
        ]
    
    return ShortestPathResponse(
        nodes=nodes,
        edges=edges,
        path_length=result.path_length,
        total_weight=result.total_weight,
        source_nodes=source_nodes,
        multi_source_paths=multi_paths,
        is_multi_source=len(result.source_nodes) > 1,
    )


@router.post("/shortest-path", response_model=ShortestPathResponse)
async def query_field_shortest_path(
    request: FieldLineageQueryRequest,
    service: ShortestPathService = Depends(get_shortest_path_service),
):
    """
    查询字段的最小血缘链路（POST 方式）
    """
    return await get_field_shortest_path(
        field_id=request.target_field_id,
        max_depth=request.max_depth,
        include_expression=request.include_expression,
        service=service,
    )


@router.get("/field/{field_id}", response_model=FieldDetailResponse)
async def get_field_detail(
    field_id: str,
    service: ShortestPathService = Depends(get_shortest_path_service),
):
    """
    获取字段详细信息
    """
    detail = service.get_field_details(field_id)
    
    if not detail:
        raise HTTPException(status_code=404, detail="字段不存在")
    
    return FieldDetailResponse(**detail)


@router.post("/search", response_model=List[FieldSearchResult])
async def search_fields(
    request: FieldSearchRequest,
    service: ShortestPathService = Depends(get_shortest_path_service),
):
    """
    搜索字段
    
    支持按表名、字段名、数据源进行搜索
    """
    results = service.search_fields(
        table_name=request.table_name,
        field_name=request.field_name,
        data_source_id=request.data_source_id,
        limit=request.limit,
    )
    
    return [FieldSearchResult(**r) for r in results]


@router.get("/search", response_model=List[FieldSearchResult])
async def search_fields_get(
    table_name: str = Query(None, description="表名"),
    field_name: str = Query(None, description="字段名"),
    data_source_id: str = Query(None, description="数据源 ID"),
    limit: int = Query(50, ge=1, le=200, description="返回数量限制"),
    service: ShortestPathService = Depends(get_shortest_path_service),
):
    """
    搜索字段（GET 方式）
    """
    results = service.search_fields(
        table_name=table_name,
        field_name=field_name,
        data_source_id=data_source_id,
        limit=limit,
    )
    
    return [FieldSearchResult(**r) for r in results]


@router.post("/export/{field_id}", response_model=ExportResponse)
async def export_field_lineage(
    field_id: str,
    request: ExportRequest,
    max_depth: int = Query(10, ge=1, le=20),
    service: ShortestPathService = Depends(get_shortest_path_service),
):
    """
    导出字段血缘链路
    
    支持导出为 JSON、CSV、Markdown 格式
    """
    result = service.get_field_shortest_path(
        target_field_id=field_id,
        max_depth=max_depth,
        include_expression=True,
    )
    
    content = service.export_lineage(result, request.format_type)
    
    filename = f"field_lineage_{field_id}.{request.format_type}"
    
    return ExportResponse(
        content=content,
        format_type=request.format_type,
        filename=filename,
    )