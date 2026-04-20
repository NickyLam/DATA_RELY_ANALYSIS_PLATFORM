"""
资产搜索服务
提供表和字段的模糊查询、精确查询、高级筛选功能
"""
from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from typing import Any, Dict, List, Optional

from neo4j import AsyncGraphDatabase

from app.core.config import settings


class SortOrder(str, Enum):
    ASC = "asc"
    DESC = "desc"


class SortField(str, Enum):
    NAME = "name"
    CREATED_AT = "created_at"
    UPDATED_AT = "updated_at"
    COLUMN_COUNT = "column_count"
    LINEAGE_COUNT = "lineage_count"


@dataclass
class TableSearchResult:
    id: str
    name: str
    schema_name: str
    database_name: str
    data_source_id: str
    data_source_name: str
    table_type: str
    description: Optional[str]
    column_count: int
    lineage_count: int
    upstream_count: int
    downstream_count: int
    owner: Optional[str]
    created_at: datetime
    updated_at: datetime


@dataclass
class FieldSearchResult:
    id: str
    name: str
    table_id: str
    table_name: str
    schema_name: str
    database_name: str
    data_source_id: str
    data_source_name: str
    data_type: Optional[str]
    is_primary_key: bool
    is_foreign_key: bool
    is_nullable: bool
    description: Optional[str]
    position: Optional[int]
    lineage_count: int


@dataclass
class SearchResult:
    tables: List[TableSearchResult]
    fields: List[FieldSearchResult]
    total_tables: int
    total_fields: int
    page: int
    page_size: int
    total_pages: int


class SearchService:
    """
    资产搜索服务
    基于 Neo4j 图数据库实现搜索功能
    """

    def __init__(self):
        self.driver = AsyncGraphDatabase.driver(
            settings.NEO4J_URI,
            auth=(settings.NEO4J_USER, settings.NEO4J_PASSWORD),
        )

    async def close(self):
        await self.driver.close()

    async def search_tables(
        self,
        keyword: Optional[str] = None,
        exact_name: Optional[str] = None,
        data_source_id: Optional[str] = None,
        schema_name: Optional[str] = None,
        table_type: Optional[str] = None,
        owner: Optional[str] = None,
        sort_by: SortField = SortField.NAME,
        sort_order: SortOrder = SortOrder.ASC,
        page: int = 1,
        page_size: int = 20,
    ) -> SearchResult:
        """
        搜索表

        Args:
            keyword: 关键词（模糊查询表名、字段名）
            exact_name: 表名（精确查询）
            data_source_id: 数据源ID筛选
            schema_name: Schema名称筛选
            table_type: 表类型筛选（table, view, materialized_view）
            owner: 所有者筛选
            sort_by: 排序字段
            sort_order: 排序方向
            page: 页码
            page_size: 每页数量

        Returns:
            SearchResult: 搜索结果
        """
        async with self.driver.session() as session:
            conditions = []
            params: Dict[str, Any] = {}

            if exact_name:
                conditions.append("t.name = $exact_name")
                params["exact_name"] = exact_name
            elif keyword:
                conditions.append(
                    "(t.name CONTAINS $keyword OR t.description CONTAINS $keyword)"
                )
                params["keyword"] = keyword

            if data_source_id:
                conditions.append("t.data_source_id = $data_source_id")
                params["data_source_id"] = data_source_id

            if schema_name:
                conditions.append("t.schema_name = $schema_name")
                params["schema_name"] = schema_name

            if table_type:
                conditions.append("t.table_type = $table_type")
                params["table_type"] = table_type

            if owner:
                conditions.append("t.owner CONTAINS $owner")
                params["owner"] = owner

            where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""

            sort_field_map = {
                SortField.NAME: "t.name",
                SortField.CREATED_AT: "t.created_at",
                SortField.UPDATED_AT: "t.updated_at",
                SortField.COLUMN_COUNT: "column_count",
                SortField.LINEAGE_COUNT: "lineage_count",
            }
            sort_field = sort_field_map.get(sort_by, "t.name")
            sort_direction = "ASC" if sort_order == SortOrder.ASC else "DESC"

            offset = (page - 1) * page_size

            count_query = f"""
            MATCH (t:Table)
            {where_clause}
            RETURN count(t) as total
            """

            count_result = await session.run(count_query, **params)
            count_record = await count_result.single()
            total_tables = count_record["total"] if count_record else 0

            search_query = f"""
            MATCH (t:Table)
            {where_clause}
            OPTIONAL MATCH (t)-[:HAS_FIELD]->(f:Field)
            WITH t, count(DISTINCT f) as column_count
            OPTIONAL MATCH (t)-[upstream:LINEAGE_TO]->(:Table)
            WITH t, column_count, count(DISTINCT upstream) as upstream_count
            OPTIONAL MATCH (:Table)-[downstream:LINEAGE_TO]->(t)
            WITH t, column_count, upstream_count, count(DISTINCT downstream) as downstream_count
            WITH t, column_count, upstream_count, downstream_count,
                 (upstream_count + downstream_count) as lineage_count
            OPTIONAL MATCH (ds:DataSource {{id: t.data_source_id}})
            RETURN t.id as id,
                   t.name as name,
                   t.schema_name as schema_name,
                   t.database_name as database_name,
                   t.data_source_id as data_source_id,
                   COALESCE(ds.name, 'Unknown') as data_source_name,
                   COALESCE(t.table_type, 'table') as table_type,
                   t.description as description,
                   column_count,
                   lineage_count,
                   upstream_count,
                   downstream_count,
                   t.owner as owner,
                   t.created_at as created_at,
                   t.updated_at as updated_at
            ORDER BY {sort_field} {sort_direction}
            SKIP $offset
            LIMIT $limit
            """

            params["offset"] = offset
            params["limit"] = page_size

            result = await session.run(search_query, **params)
            records = await result.list()

            tables = []
            for record in records:
                tables.append(
                    TableSearchResult(
                        id=record["id"],
                        name=record["name"],
                        schema_name=record["schema_name"] or "",
                        database_name=record["database_name"] or "",
                        data_source_id=record["data_source_id"] or "",
                        data_source_name=record["data_source_name"],
                        table_type=record["table_type"],
                        description=record["description"],
                        column_count=record["column_count"] or 0,
                        lineage_count=record["lineage_count"] or 0,
                        upstream_count=record["upstream_count"] or 0,
                        downstream_count=record["downstream_count"] or 0,
                        owner=record["owner"],
                        created_at=self._parse_datetime(record["created_at"]),
                        updated_at=self._parse_datetime(record["updated_at"]),
                    )
                )

            total_pages = (total_tables + page_size - 1) // page_size if page_size > 0 else 0

            return SearchResult(
                tables=tables,
                fields=[],
                total_tables=total_tables,
                total_fields=0,
                page=page,
                page_size=page_size,
                total_pages=total_pages,
            )

    async def search_fields(
        self,
        keyword: Optional[str] = None,
        exact_name: Optional[str] = None,
        table_name: Optional[str] = None,
        data_source_id: Optional[str] = None,
        schema_name: Optional[str] = None,
        data_type: Optional[str] = None,
        sort_by: SortField = SortField.NAME,
        sort_order: SortOrder = SortOrder.ASC,
        page: int = 1,
        page_size: int = 20,
    ) -> SearchResult:
        """
        搜索字段

        Args:
            keyword: 关键词（模糊查询字段名）
            exact_name: 字段名（精确查询）
            table_name: 所属表名筛选
            data_source_id: 数据源ID筛选
            schema_name: Schema名称筛选
            data_type: 数据类型筛选
            sort_by: 排序字段
            sort_order: 排序方向
            page: 页码
            page_size: 每页数量

        Returns:
            SearchResult: 搜索结果
        """
        async with self.driver.session() as session:
            conditions = []
            params: Dict[str, Any] = {}

            if exact_name:
                conditions.append("f.name = $exact_name")
                params["exact_name"] = exact_name
            elif keyword:
                conditions.append(
                    "(f.name CONTAINS $keyword OR f.description CONTAINS $keyword)"
                )
                params["keyword"] = keyword

            if table_name:
                conditions.append("t.name CONTAINS $table_name")
                params["table_name"] = table_name

            if data_source_id:
                conditions.append("t.data_source_id = $data_source_id")
                params["data_source_id"] = data_source_id

            if schema_name:
                conditions.append("t.schema_name = $schema_name")
                params["schema_name"] = schema_name

            if data_type:
                conditions.append("f.data_type CONTAINS $data_type")
                params["data_type"] = data_type

            where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""

            sort_field_map = {
                SortField.NAME: "f.name",
                SortField.CREATED_AT: "f.created_at",
                SortField.UPDATED_AT: "f.updated_at",
            }
            sort_field = sort_field_map.get(sort_by, "f.name")
            sort_direction = "ASC" if sort_order == SortOrder.ASC else "DESC"

            offset = (page - 1) * page_size

            count_query = f"""
            MATCH (t:Table)-[:HAS_FIELD]->(f:Field)
            {where_clause}
            RETURN count(f) as total
            """

            count_result = await session.run(count_query, **params)
            count_record = await count_result.single()
            total_fields = count_record["total"] if count_record else 0

            search_query = f"""
            MATCH (t:Table)-[:HAS_FIELD]->(f:Field)
            {where_clause}
            OPTIONAL MATCH (f)-[lineage:LINEAGE_TO]->(:Field)
            WITH t, f, count(DISTINCT lineage) as lineage_count
            OPTIONAL MATCH (ds:DataSource {{id: t.data_source_id}})
            RETURN f.id as id,
                   f.name as name,
                   t.id as table_id,
                   t.name as table_name,
                   t.schema_name as schema_name,
                   t.database_name as database_name,
                   t.data_source_id as data_source_id,
                   COALESCE(ds.name, 'Unknown') as data_source_name,
                   f.data_type as data_type,
                   COALESCE(f.is_primary_key, false) as is_primary_key,
                   COALESCE(f.is_foreign_key, false) as is_foreign_key,
                   COALESCE(f.is_nullable, true) as is_nullable,
                   f.description as description,
                   f.position as position,
                   lineage_count
            ORDER BY {sort_field} {sort_direction}
            SKIP $offset
            LIMIT $limit
            """

            params["offset"] = offset
            params["limit"] = page_size

            result = await session.run(search_query, **params)
            records = await result.list()

            fields = []
            for record in records:
                fields.append(
                    FieldSearchResult(
                        id=record["id"],
                        name=record["name"],
                        table_id=record["table_id"],
                        table_name=record["table_name"],
                        schema_name=record["schema_name"] or "",
                        database_name=record["database_name"] or "",
                        data_source_id=record["data_source_id"] or "",
                        data_source_name=record["data_source_name"],
                        data_type=record["data_type"],
                        is_primary_key=record["is_primary_key"],
                        is_foreign_key=record["is_foreign_key"],
                        is_nullable=record["is_nullable"],
                        description=record["description"],
                        position=record["position"],
                        lineage_count=record["lineage_count"] or 0,
                    )
                )

            total_pages = (total_fields + page_size - 1) // page_size if page_size > 0 else 0

            return SearchResult(
                tables=[],
                fields=fields,
                total_tables=0,
                total_fields=total_fields,
                page=page,
                page_size=page_size,
                total_pages=total_pages,
            )

    async def search_all(
        self,
        keyword: Optional[str] = None,
        exact_name: Optional[str] = None,
        data_source_id: Optional[str] = None,
        schema_name: Optional[str] = None,
        search_type: str = "all",
        sort_by: SortField = SortField.NAME,
        sort_order: SortOrder = SortOrder.ASC,
        page: int = 1,
        page_size: int = 20,
    ) -> SearchResult:
        """
        综合搜索（表和字段）

        Args:
            keyword: 关键词
            exact_name: 名称（精确查询）
            data_source_id: 数据源ID筛选
            schema_name: Schema名称筛选
            search_type: 搜索类型（all, tables, fields）
            sort_by: 排序字段
            sort_order: 排序方向
            page: 页码
            page_size: 每页数量

        Returns:
            SearchResult: 搜索结果
        """
        if search_type == "tables":
            return await self.search_tables(
                keyword=keyword,
                exact_name=exact_name,
                data_source_id=data_source_id,
                schema_name=schema_name,
                sort_by=sort_by,
                sort_order=sort_order,
                page=page,
                page_size=page_size,
            )
        elif search_type == "fields":
            return await self.search_fields(
                keyword=keyword,
                exact_name=exact_name,
                data_source_id=data_source_id,
                schema_name=schema_name,
                sort_by=sort_by,
                sort_order=sort_order,
                page=page,
                page_size=page_size,
            )
        else:
            half_page = page_size // 2
            tables_result = await self.search_tables(
                keyword=keyword,
                exact_name=exact_name,
                data_source_id=data_source_id,
                schema_name=schema_name,
                sort_by=sort_by,
                sort_order=sort_order,
                page=1,
                page_size=half_page,
            )
            fields_result = await self.search_fields(
                keyword=keyword,
                exact_name=exact_name,
                data_source_id=data_source_id,
                schema_name=schema_name,
                sort_by=sort_by,
                sort_order=sort_order,
                page=1,
                page_size=half_page,
            )

            return SearchResult(
                tables=tables_result.tables,
                fields=fields_result.fields,
                total_tables=tables_result.total_tables,
                total_fields=fields_result.total_fields,
                page=page,
                page_size=page_size,
                total_pages=max(tables_result.total_pages, fields_result.total_pages),
            )

    async def get_data_sources(self) -> List[Dict[str, Any]]:
        """
        获取所有数据源列表（用于筛选下拉框）

        Returns:
            List[Dict]: 数据源列表
        """
        async with self.driver.session() as session:
            query = """
            MATCH (ds:DataSource)
            RETURN ds.id as id, ds.name as name, ds.type as type
            ORDER BY ds.name
            """
            result = await session.run(query)
            records = await result.list()

            return [
                {
                    "id": record["id"],
                    "name": record["name"],
                    "type": record["type"],
                }
                for record in records
            ]

    async def get_schemas(self, data_source_id: Optional[str] = None) -> List[str]:
        """
        获取 Schema 列表（用于筛选下拉框）

        Args:
            data_source_id: 数据源ID（可选，用于过滤）

        Returns:
            List[str]: Schema名称列表
        """
        async with self.driver.session() as session:
            if data_source_id:
                query = """
                MATCH (t:Table {data_source_id: $data_source_id})
                WHERE t.schema_name IS NOT NULL
                RETURN DISTINCT t.schema_name as schema_name
                ORDER BY t.schema_name
                """
                result = await session.run(query, data_source_id=data_source_id)
            else:
                query = """
                MATCH (t:Table)
                WHERE t.schema_name IS NOT NULL
                RETURN DISTINCT t.schema_name as schema_name
                ORDER BY t.schema_name
                """
                result = await session.run(query)

            records = await result.list()
            return [record["schema_name"] for record in records if record["schema_name"]]

    async def get_table_types(self) -> List[str]:
        """
        获取表类型列表（用于筛选下拉框）

        Returns:
            List[str]: 表类型列表
        """
        return ["table", "view", "materialized_view"]

    async def get_data_types(self) -> List[str]:
        """
        获取数据类型列表（用于筛选下拉框）

        Returns:
            List[str]: 数据类型列表
        """
        async with self.driver.session() as session:
            query = """
            MATCH (f:Field)
            WHERE f.data_type IS NOT NULL
            RETURN DISTINCT f.data_type as data_type
            ORDER BY f.data_type
            """
            result = await session.run(query)
            records = await result.list()

            return [record["data_type"] for record in records if record["data_type"]]

    def _parse_datetime(self, value: Any) -> datetime:
        """
        解析日期时间

        Args:
            value: 日期时间值

        Returns:
            datetime: 解析后的日期时间
        """
        if value is None:
            return datetime.now()

        if isinstance(value, datetime):
            return value

        if isinstance(value, str):
            try:
                return datetime.fromisoformat(value.replace("Z", "+00:00"))
            except ValueError:
                pass

        return datetime.now()


search_service = SearchService()


async def get_search_service() -> SearchService:
    """
    获取搜索服务实例（依赖注入）
    """
    return search_service