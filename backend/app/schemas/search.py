"""
搜索相关 Pydantic 模型
"""
from datetime import datetime
from enum import Enum
from typing import List, Optional

from pydantic import BaseModel, Field


class SearchType(str, Enum):
    ALL = "all"
    TABLES = "tables"
    FIELDS = "fields"


class SortOrder(str, Enum):
    ASC = "asc"
    DESC = "desc"


class SortField(str, Enum):
    NAME = "name"
    CREATED_AT = "created_at"
    UPDATED_AT = "updated_at"
    COLUMN_COUNT = "column_count"
    LINEAGE_COUNT = "lineage_count"


class TableSearchResult(BaseModel):
    id: str
    name: str
    schema_name: str = ""
    database_name: str = ""
    data_source_id: str = ""
    data_source_name: str
    table_type: str = "table"
    description: Optional[str] = None
    column_count: int = 0
    lineage_count: int = 0
    upstream_count: int = 0
    downstream_count: int = 0
    owner: Optional[str] = None
    created_at: datetime
    updated_at: datetime


class FieldSearchResult(BaseModel):
    id: str
    name: str
    table_id: str
    table_name: str
    schema_name: str = ""
    database_name: str = ""
    data_source_id: str = ""
    data_source_name: str
    data_type: Optional[str] = None
    is_primary_key: bool = False
    is_foreign_key: bool = False
    is_nullable: bool = True
    description: Optional[str] = None
    position: Optional[int] = None
    lineage_count: int = 0


class SearchResult(BaseModel):
    tables: List[TableSearchResult] = []
    fields: List[FieldSearchResult] = []
    total_tables: int = 0
    total_fields: int = 0
    page: int = 1
    page_size: int = 20
    total_pages: int = 0


class SearchRequest(BaseModel):
    keyword: Optional[str] = Field(None, description="关键词（模糊查询）")
    exact_name: Optional[str] = Field(None, description="名称（精确查询）")
    data_source_id: Optional[str] = Field(None, description="数据源ID筛选")
    schema_name: Optional[str] = Field(None, description="Schema名称筛选")
    table_type: Optional[str] = Field(None, description="表类型筛选")
    owner: Optional[str] = Field(None, description="所有者筛选")
    data_type: Optional[str] = Field(None, description="数据类型筛选")
    table_name: Optional[str] = Field(None, description="所属表名筛选")
    search_type: SearchType = Field(SearchType.ALL, description="搜索类型")
    sort_by: SortField = Field(SortField.NAME, description="排序字段")
    sort_order: SortOrder = Field(SortOrder.ASC, description="排序方向")
    page: int = Field(1, ge=1, description="页码")
    page_size: int = Field(20, ge=1, le=100, description="每页数量")


class DataSourceOption(BaseModel):
    id: str
    name: str
    type: str


class FilterOptions(BaseModel):
    data_sources: List[DataSourceOption] = []
    schemas: List[str] = []
    table_types: List[str] = []
    data_types: List[str] = []