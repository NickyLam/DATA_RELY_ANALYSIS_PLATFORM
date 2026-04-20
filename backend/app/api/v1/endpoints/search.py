"""
资产搜索 API
提供表和字段的搜索、筛选、排序、分页功能
"""
from typing import List, Optional

from fastapi import APIRouter, Depends, Query

from app.schemas.search import (
    DataSourceOption,
    FieldSearchResult,
    FilterOptions,
    SearchRequest,
    SearchResult,
    SearchType,
    SortField,
    SortOrder,
    TableSearchResult,
)
from app.services.search_service import SearchService, get_search_service

router = APIRouter()


@router.get("/tables", response_model=SearchResult)
async def search_tables(
    keyword: Optional[str] = Query(None, description="关键词（模糊查询表名、描述）"),
    exact_name: Optional[str] = Query(None, description="表名（精确查询）"),
    data_source_id: Optional[str] = Query(None, description="数据源ID筛选"),
    schema_name: Optional[str] = Query(None, description="Schema名称筛选"),
    table_type: Optional[str] = Query(None, description="表类型筛选（table, view, materialized_view）"),
    owner: Optional[str] = Query(None, description="所有者筛选"),
    sort_by: SortField = Query(SortField.NAME, description="排序字段"),
    sort_order: SortOrder = Query(SortOrder.ASC, description="排序方向"),
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    search_service: SearchService = Depends(get_search_service),
):
    """
    搜索表

    支持功能：
    - 模糊查询：通过 keyword 参数模糊匹配表名和描述
    - 精确查询：通过 exact_name 参数精确匹配表名
    - 高级筛选：数据源、Schema、表类型、所有者
    - 排序：支持按名称、创建时间、更新时间、字段数、血缘数排序
    - 分页：支持页码和每页数量设置

    返回结果包含：
    - 表基本信息（名称、Schema、数据库、类型等）
    - 字段数统计
    - 血缘关系数统计（上游数、下游数）
    """
    return await search_service.search_tables(
        keyword=keyword,
        exact_name=exact_name,
        data_source_id=data_source_id,
        schema_name=schema_name,
        table_type=table_type,
        owner=owner,
        sort_by=sort_by,
        sort_order=sort_order,
        page=page,
        page_size=page_size,
    )


@router.get("/fields", response_model=SearchResult)
async def search_fields(
    keyword: Optional[str] = Query(None, description="关键词（模糊查询字段名、描述）"),
    exact_name: Optional[str] = Query(None, description="字段名（精确查询）"),
    table_name: Optional[str] = Query(None, description="所属表名筛选"),
    data_source_id: Optional[str] = Query(None, description="数据源ID筛选"),
    schema_name: Optional[str] = Query(None, description="Schema名称筛选"),
    data_type: Optional[str] = Query(None, description="数据类型筛选"),
    sort_by: SortField = Query(SortField.NAME, description="排序字段"),
    sort_order: SortOrder = Query(SortOrder.ASC, description="排序方向"),
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    search_service: SearchService = Depends(get_search_service),
):
    """
    搜索字段

    支持功能：
    - 模糊查询：通过 keyword 参数模糊匹配字段名和描述
    - 精确查询：通过 exact_name 参数精确匹配字段名
    - 高级筛选：所属表名、数据源、Schema、数据类型
    - 排序：支持按名称、创建时间、更新时间排序
    - 分页：支持页码和每页数量设置

    返回结果包含：
    - 字段基本信息（名称、数据类型、是否主键/外键等）
    - 所属表信息
    - 血缘关系数统计
    """
    return await search_service.search_fields(
        keyword=keyword,
        exact_name=exact_name,
        table_name=table_name,
        data_source_id=data_source_id,
        schema_name=schema_name,
        data_type=data_type,
        sort_by=sort_by,
        sort_order=sort_order,
        page=page,
        page_size=page_size,
    )


@router.get("/all", response_model=SearchResult)
async def search_all(
    keyword: Optional[str] = Query(None, description="关键词（模糊查询）"),
    exact_name: Optional[str] = Query(None, description="名称（精确查询）"),
    data_source_id: Optional[str] = Query(None, description="数据源ID筛选"),
    schema_name: Optional[str] = Query(None, description="Schema名称筛选"),
    search_type: SearchType = Query(SearchType.ALL, description="搜索类型（all, tables, fields）"),
    sort_by: SortField = Query(SortField.NAME, description="排序字段"),
    sort_order: SortOrder = Query(SortOrder.ASC, description="排序方向"),
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    search_service: SearchService = Depends(get_search_service),
):
    """
    综合搜索（表和字段）

    支持功能：
    - 模糊查询：通过 keyword 参数模糊匹配表名、字段名、描述
    - 精确查询：通过 exact_name 参数精确匹配名称
    - 高级筛选：数据源、Schema
    - 搜索类型：可选择只搜索表、只搜索字段、或综合搜索
    - 排序：支持按名称、创建时间、更新时间、字段数、血缘数排序
    - 分页：支持页码和每页数量设置

    返回结果包含：
    - 表搜索结果（基本信息、字段数、血缘数）
    - 字段搜索结果（基本信息、所属表、血缘数）
    - 总数统计
    """
    return await search_service.search_all(
        keyword=keyword,
        exact_name=exact_name,
        data_source_id=data_source_id,
        schema_name=schema_name,
        search_type=search_type,
        sort_by=sort_by,
        sort_order=sort_order,
        page=page,
        page_size=page_size,
    )


@router.post("/search", response_model=SearchResult)
async def advanced_search(
    request: SearchRequest,
    search_service: SearchService = Depends(get_search_service),
):
    """
    高级搜索（POST 方式）

    支持所有搜索参数，适合复杂查询场景

    请求体参数：
    - keyword: 关键词（模糊查询）
    - exact_name: 名称（精确查询）
    - data_source_id: 数据源ID筛选
    - schema_name: Schema名称筛选
    - table_type: 表类型筛选
    - owner: 所有者筛选
    - data_type: 数据类型筛选
    - table_name: 所属表名筛选
    - search_type: 搜索类型（all, tables, fields）
    - sort_by: 排序字段
    - sort_order: 排序方向
    - page: 页码
    - page_size: 每页数量
    """
    return await search_service.search_all(
        keyword=request.keyword,
        exact_name=request.exact_name,
        data_source_id=request.data_source_id,
        schema_name=request.schema_name,
        search_type=request.search_type,
        sort_by=request.sort_by,
        sort_order=request.sort_order,
        page=request.page,
        page_size=request.page_size,
    )


@router.get("/filter-options", response_model=FilterOptions)
async def get_filter_options(
    data_source_id: Optional[str] = Query(None, description="数据源ID（用于过滤Schema列表）"),
    search_service: SearchService = Depends(get_search_service),
):
    """
    获取筛选选项

    返回所有可用的筛选选项，用于前端下拉框：
    - 数据源列表
    - Schema列表
    - 表类型列表
    - 数据类型列表

    参数：
    - data_source_id: 可选，用于过滤Schema列表（只返回该数据源下的Schema）
    """
    data_sources = await search_service.get_data_sources()
    schemas = await search_service.get_schemas(data_source_id)
    table_types = await search_service.get_table_types()
    data_types = await search_service.get_data_types()

    return FilterOptions(
        data_sources=[
            DataSourceOption(id=ds["id"], name=ds["name"], type=ds["type"])
            for ds in data_sources
        ],
        schemas=schemas,
        table_types=table_types,
        data_types=data_types,
    )


@router.get("/data-sources", response_model=List[DataSourceOption])
async def get_data_sources(
    search_service: SearchService = Depends(get_search_service),
):
    """
    获取数据源列表

    返回所有数据源，用于前端筛选下拉框
    """
    data_sources = await search_service.get_data_sources()
    return [
        DataSourceOption(id=ds["id"], name=ds["name"], type=ds["type"])
        for ds in data_sources
    ]


@router.get("/schemas", response_model=List[str])
async def get_schemas(
    data_source_id: Optional[str] = Query(None, description="数据源ID（可选）"),
    search_service: SearchService = Depends(get_search_service),
):
    """
    获取Schema列表

    返回所有Schema名称，用于前端筛选下拉框

    参数：
    - data_source_id: 可选，只返回该数据源下的Schema
    """
    return await search_service.get_schemas(data_source_id)


@router.get("/table-types", response_model=List[str])
async def get_table_types():
    """
    获取表类型列表

    返回所有表类型，用于前端筛选下拉框
    """
    return ["table", "view", "materialized_view"]


@router.get("/data-types", response_model=List[str])
async def get_data_types(
    search_service: SearchService = Depends(get_search_service),
):
    """
    获取数据类型列表

    返回所有数据类型，用于前端筛选下拉框
    """
    return await search_service.get_data_types()