"""
JDBC 元数据采集器
通过 JDBC 连接采集 Oracle 数据库元数据
"""

import logging
from datetime import datetime
from typing import Any, Dict, List, Optional

from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine

from app.collectors.base_collector import (
    BaseCollector,
    CollectorConfig,
    CollectorResult,
    ColumnMetadata,
    ConstraintMetadata,
    DataSourceType,
    TableMetadata,
)

logger = logging.getLogger(__name__)


class JDBCCollector(BaseCollector[TableMetadata]):
    """
    JDBC 元数据采集器

    通过 JDBC 连接采集 Oracle 数据库的表、列、约束等元数据。
    支持批量采集和错误重试。
    """

    ORACLE_QUERIES = {
        "tables": """
            SELECT
                t.OWNER as owner,
                t.TABLE_NAME as table_name,
                t.TABLE_TYPE as table_type,
                t.NUM_ROWS as num_rows,
                t.AVG_ROW_LEN as avg_row_length,
                t.BLOCKS as blocks,
                t.EMPTY_BLOCKS as empty_blocks,
                t.LAST_ANALYZED as last_analyzed,
                t.PARTITIONED as partitioned,
                t.TEMPORARY as temporary,
                t.NESTED as nested,
                t.TABLESPACE_NAME as tablespace_name,
                c.COMMENTS as comments,
                o.CREATED as created_at
            FROM ALL_TABLES t
            LEFT JOIN ALL_TAB_COMMENTS c ON t.OWNER = c.OWNER AND t.TABLE_NAME = c.TABLE_NAME
            LEFT JOIN ALL_OBJECTS o ON t.OWNER = o.OWNER AND t.TABLE_NAME = o.OBJECT_NAME AND o.OBJECT_TYPE = 'TABLE'
            WHERE t.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY t.OWNER, t.TABLE_NAME
        """,
        "columns": """
            SELECT
                c.OWNER as owner,
                c.TABLE_NAME as table_name,
                c.COLUMN_NAME as column_name,
                c.DATA_TYPE as data_type,
                c.DATA_LENGTH as data_length,
                c.DATA_PRECISION as data_precision,
                c.DATA_SCALE as data_scale,
                c.NULLABLE as nullable,
                c.DATA_DEFAULT as default_value,
                c.COLUMN_ID as column_id_num,
                cc.COMMENTS as comments,
                CASE WHEN pk.COLUMN_NAME IS NOT NULL THEN 'Y' ELSE 'N' END as is_primary_key,
                CASE WHEN fk.COLUMN_NAME IS NOT NULL THEN 'Y' ELSE 'N' END as is_foreign_key
            FROM ALL_TAB_COLUMNS c
            LEFT JOIN ALL_COL_COMMENTS cc ON c.OWNER = cc.OWNER AND c.TABLE_NAME = cc.TABLE_NAME AND c.COLUMN_NAME = cc.COLUMN_NAME
            LEFT JOIN (
                SELECT cols.OWNER, cols.TABLE_NAME, cols.COLUMN_NAME
                FROM ALL_CONSTRAINTS cons
                JOIN ALL_CONS_COLUMNS cols ON cons.OWNER = cols.OWNER AND cons.CONSTRAINT_NAME = cols.CONSTRAINT_NAME
                WHERE cons.CONSTRAINT_TYPE = 'P'
            ) pk ON c.OWNER = pk.OWNER AND c.TABLE_NAME = pk.TABLE_NAME AND c.COLUMN_NAME = pk.COLUMN_NAME
            LEFT JOIN (
                SELECT cols.OWNER, cols.TABLE_NAME, cols.COLUMN_NAME
                FROM ALL_CONSTRAINTS cons
                JOIN ALL_CONS_COLUMNS cols ON cons.OWNER = cols.OWNER AND cons.CONSTRAINT_NAME = cols.CONSTRAINT_NAME
                WHERE cons.CONSTRAINT_TYPE = 'R'
            ) fk ON c.OWNER = fk.OWNER AND c.TABLE_NAME = fk.TABLE_NAME AND c.COLUMN_NAME = fk.COLUMN_NAME
            WHERE c.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY c.OWNER, c.TABLE_NAME, c.COLUMN_ID
        """,
        "constraints": """
            SELECT
                c.OWNER as owner,
                c.CONSTRAINT_NAME as constraint_name,
                c.CONSTRAINT_TYPE as constraint_type,
                c.TABLE_NAME as table_name,
                c.STATUS as status,
                c.DEFERRABLE as deferrable,
                c.DEFERRED as deferred,
                c.VALIDATED as validated,
                c.GENERATED as generated,
                c.RELY as rely,
                c.SEARCH_CONDITION as search_condition,
                c.R_OWNER as r_owner,
                c.R_CONSTRAINT_NAME as r_constraint_name,
                c.DELETE_RULE as delete_rule
            FROM ALL_CONSTRAINTS c
            WHERE c.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY c.OWNER, c.TABLE_NAME, c.CONSTRAINT_TYPE
        """,
        "constraint_columns": """
            SELECT
                cc.OWNER as owner,
                cc.CONSTRAINT_NAME as constraint_name,
                cc.TABLE_NAME as table_name,
                cc.COLUMN_NAME as column_name,
                cc.POSITION as position
            FROM ALL_CONS_COLUMNS cc
            WHERE cc.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY cc.OWNER, cc.CONSTRAINT_NAME, cc.POSITION
        """,
        "indexes": """
            SELECT
                i.OWNER as owner,
                i.INDEX_NAME as index_name,
                i.TABLE_NAME as table_name,
                i.INDEX_TYPE as index_type,
                i.UNIQUENESS as uniqueness,
                i.TABLESPACE_NAME as tablespace_name,
                i.STATUS as status,
                ic.COLUMN_NAME as column_name,
                ic.COLUMN_POSITION as column_position,
                ic.DESCEND as descend
            FROM ALL_INDEXES i
            JOIN ALL_IND_COLUMNS ic ON i.OWNER = ic.INDEX_OWNER AND i.INDEX_NAME = ic.INDEX_NAME
            WHERE i.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY i.OWNER, i.TABLE_NAME, i.INDEX_NAME, ic.COLUMN_POSITION
        """,
    }

    def __init__(self, config: CollectorConfig):
        """
        初始化 JDBC 采集器

        Args:
            config: 采集器配置
        """
        super().__init__(config)
        self._engine = None

    def get_collection_queries(self) -> Dict[str, str]:
        """
        获取采集查询语句

        Returns:
            Dict[str, str]: 查询名称到 SQL 语句的映射
        """
        return self.ORACLE_QUERIES

    async def connect(self) -> None:
        """建立数据库连接"""
        if self.config.data_source_type != DataSourceType.ORACLE:
            raise ValueError(f"Unsupported data source type: {self.config.data_source_type}")

        connection_url = self._build_oracle_connection_url()
        self._engine = create_async_engine(
            connection_url,
            echo=False,
            pool_pre_ping=True,
            pool_size=5,
            max_overflow=10,
        )

        async with self._engine.connect() as conn:
            await conn.execute(text("SELECT 1 FROM DUAL"))

        logger.info(f"Connected to Oracle database: {self.config.host}:{self.config.port}")

    def _build_oracle_connection_url(self) -> str:
        """
        构建 Oracle 连接 URL

        Returns:
            str: 连接 URL
        """
        service_name = self.config.connection_params.get("service_name", self.config.database_name)
        return f"oracle+oracledb://{self.config.username}:{self.config.password}@{self.config.host}:{self.config.port}/?service_name={service_name}"

    async def collect(self) -> CollectorResult[TableMetadata]:
        """
        执行元数据采集

        Returns:
            CollectorResult: 采集结果
        """
        start_time = datetime.now()
        result = CollectorResult[TableMetadata](success=False, start_time=start_time)

        try:
            await self.connect()
            self.update_status("running")

            tables = await self._collect_tables()
            columns = await self._collect_columns()
            constraints = await self._collect_constraints()

            result.data = tables
            result.total_count = len(tables)
            result.success = True
            result.metadata = {
                "tables_count": len(tables),
                "columns_count": len(columns),
                "constraints_count": len(constraints),
            }

            self.update_status("completed")
            logger.info(f"Collection completed: {result.total_count} tables collected")

        except Exception as e:
            result.error_message = str(e)
            self.update_status("failed")
            logger.error(f"Collection failed: {e}")

        finally:
            await self.close()

        result.end_time = datetime.now()
        result.duration_seconds = (result.end_time - result.start_time).total_seconds()

        return result

    async def _collect_tables(self) -> List[TableMetadata]:
        """
        采集表元数据

        Returns:
            List[TableMetadata]: 表元数据列表
        """
        tables: List[TableMetadata] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.ORACLE_QUERIES["tables"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                table = TableMetadata(
                    table_id=self.generate_id(
                        self.config.data_source_id,
                        row_dict.get("owner", ""),
                        row_dict.get("table_name", ""),
                    ),
                    table_name=row_dict.get("table_name", ""),
                    owner=row_dict.get("owner", ""),
                    table_type=row_dict.get("table_type", "TABLE"),
                    num_rows=row_dict.get("num_rows"),
                    avg_row_length=row_dict.get("avg_row_length"),
                    blocks=row_dict.get("blocks"),
                    empty_blocks=row_dict.get("empty_blocks"),
                    last_analyzed=row_dict.get("last_analyzed"),
                    partitioned=row_dict.get("partitioned", "NO"),
                    temporary=row_dict.get("temporary", "N"),
                    nested=row_dict.get("nested", "NO"),
                    tablespace_name=row_dict.get("tablespace_name"),
                    comments=row_dict.get("comments"),
                    created_at=row_dict.get("created_at"),
                    data_source_id=self.config.data_source_id,
                )
                tables.append(table)

        logger.info(f"Collected {len(tables)} tables")
        return tables

    async def _collect_columns(self) -> List[ColumnMetadata]:
        """
        采集列元数据

        Returns:
            List[ColumnMetadata]: 列元数据列表
        """
        columns: List[ColumnMetadata] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.ORACLE_QUERIES["columns"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                table_id = self.generate_id(
                    self.config.data_source_id,
                    row_dict.get("owner", ""),
                    row_dict.get("table_name", ""),
                )
                column = ColumnMetadata(
                    column_id=self.generate_id(table_id, row_dict.get("column_name", "")),
                    table_id=table_id,
                    column_name=row_dict.get("column_name", ""),
                    data_type=row_dict.get("data_type", ""),
                    data_length=row_dict.get("data_length"),
                    data_precision=row_dict.get("data_precision"),
                    data_scale=row_dict.get("data_scale"),
                    nullable=row_dict.get("nullable", "Y"),
                    default_value=row_dict.get("default_value"),
                    column_id_num=row_dict.get("column_id_num"),
                    comments=row_dict.get("comments"),
                    is_primary_key=row_dict.get("is_primary_key") == "Y",
                    is_foreign_key=row_dict.get("is_foreign_key") == "Y",
                    data_source_id=self.config.data_source_id,
                )
                columns.append(column)

        logger.info(f"Collected {len(columns)} columns")
        return columns

    async def _collect_constraints(self) -> List[ConstraintMetadata]:
        """
        采集约束元数据

        Returns:
            List[ConstraintMetadata]: 约束元数据列表
        """
        constraints: List[ConstraintMetadata] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.ORACLE_QUERIES["constraints"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                table_id = self.generate_id(
                    self.config.data_source_id,
                    row_dict.get("owner", ""),
                    row_dict.get("table_name", ""),
                )
                constraint = ConstraintMetadata(
                    constraint_id=self.generate_id(table_id, row_dict.get("constraint_name", "")),
                    constraint_name=row_dict.get("constraint_name", ""),
                    constraint_type=row_dict.get("constraint_type", ""),
                    table_id=table_id,
                    owner=row_dict.get("owner", ""),
                    status=row_dict.get("status", "ENABLED"),
                    deferrable=row_dict.get("deferrable", "NOT DEFERRABLE"),
                    deferred=row_dict.get("deferred", "IMMEDIATE"),
                    validated=row_dict.get("validated", "VALIDATED"),
                    generated=row_dict.get("generated", "USER NAME"),
                    rely=row_dict.get("rely", "DISABLED"),
                    search_condition=row_dict.get("search_condition"),
                    r_owner=row_dict.get("r_owner"),
                    r_constraint_name=row_dict.get("r_constraint_name"),
                    delete_rule=row_dict.get("delete_rule"),
                    data_source_id=self.config.data_source_id,
                )
                constraints.append(constraint)

        logger.info(f"Collected {len(constraints)} constraints")
        return constraints

    async def collect_tables_for_owner(self, owner: str) -> List[TableMetadata]:
        """
        采集指定用户的表元数据

        Args:
            owner: 用户名

        Returns:
            List[TableMetadata]: 表元数据列表
        """
        query = f"""
            SELECT
                t.OWNER as owner,
                t.TABLE_NAME as table_name,
                t.TABLE_TYPE as table_type,
                t.NUM_ROWS as num_rows,
                t.AVG_ROW_LEN as avg_row_length,
                t.BLOCKS as blocks,
                t.EMPTY_BLOCKS as empty_blocks,
                t.LAST_ANALYZED as last_analyzed,
                t.PARTITIONED as partitioned,
                t.TEMPORARY as temporary,
                t.NESTED as nested,
                t.TABLESPACE_NAME as tablespace_name,
                c.COMMENTS as comments,
                o.CREATED as created_at
            FROM ALL_TABLES t
            LEFT JOIN ALL_TAB_COMMENTS c ON t.OWNER = c.OWNER AND t.TABLE_NAME = c.TABLE_NAME
            LEFT JOIN ALL_OBJECTS o ON t.OWNER = o.OWNER AND t.TABLE_NAME = o.OBJECT_NAME AND o.OBJECT_TYPE = 'TABLE'
            WHERE t.OWNER = :owner
            ORDER BY t.TABLE_NAME
        """

        tables: List[TableMetadata] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(query), {"owner": owner})
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                table = TableMetadata(
                    table_id=self.generate_id(
                        self.config.data_source_id,
                        owner,
                        row_dict.get("table_name", ""),
                    ),
                    table_name=row_dict.get("table_name", ""),
                    owner=owner,
                    table_type=row_dict.get("table_type", "TABLE"),
                    num_rows=row_dict.get("num_rows"),
                    avg_row_length=row_dict.get("avg_row_length"),
                    blocks=row_dict.get("blocks"),
                    empty_blocks=row_dict.get("empty_blocks"),
                    last_analyzed=row_dict.get("last_analyzed"),
                    partitioned=row_dict.get("partitioned", "NO"),
                    temporary=row_dict.get("temporary", "N"),
                    nested=row_dict.get("nested", "NO"),
                    tablespace_name=row_dict.get("tablespace_name"),
                    comments=row_dict.get("comments"),
                    created_at=row_dict.get("created_at"),
                    data_source_id=self.config.data_source_id,
                )
                tables.append(table)

        return tables

    async def collect_table_details(self, owner: str, table_name: str) -> Dict[str, Any]:
        """
        采集指定表的详细信息

        Args:
            owner: 用户名
            table_name: 表名

        Returns:
            Dict[str, Any]: 表详细信息
        """
        table_query = """
            SELECT
                t.*,
                c.COMMENTS as comments,
                o.CREATED as created_at,
                o.LAST_DDL_TIME as last_ddl_time
            FROM ALL_TABLES t
            LEFT JOIN ALL_TAB_COMMENTS c ON t.OWNER = c.OWNER AND t.TABLE_NAME = c.TABLE_NAME
            LEFT JOIN ALL_OBJECTS o ON t.OWNER = o.OWNER AND t.TABLE_NAME = o.OBJECT_NAME AND o.OBJECT_TYPE = 'TABLE'
            WHERE t.OWNER = :owner AND t.TABLE_NAME = :table_name
        """

        columns_query = """
            SELECT
                c.*,
                cc.COMMENTS as comments
            FROM ALL_TAB_COLUMNS c
            LEFT JOIN ALL_COL_COMMENTS cc ON c.OWNER = cc.OWNER AND c.TABLE_NAME = cc.TABLE_NAME AND c.COLUMN_NAME = cc.COLUMN_NAME
            WHERE c.OWNER = :owner AND c.TABLE_NAME = :table_name
            ORDER BY c.COLUMN_ID
        """

        constraints_query = """
            SELECT
                c.*,
                (SELECT LISTAGG(cc.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY cc.POSITION)
                 FROM ALL_CONS_COLUMNS cc
                 WHERE cc.OWNER = c.OWNER AND cc.CONSTRAINT_NAME = c.CONSTRAINT_NAME) as columns
            FROM ALL_CONSTRAINTS c
            WHERE c.OWNER = :owner AND c.TABLE_NAME = :table_name
        """

        indexes_query = """
            SELECT
                i.*,
                (SELECT LISTAGG(ic.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY ic.COLUMN_POSITION)
                 FROM ALL_IND_COLUMNS ic
                 WHERE ic.INDEX_OWNER = i.OWNER AND ic.INDEX_NAME = i.INDEX_NAME) as columns
            FROM ALL_INDEXES i
            WHERE i.OWNER = :owner AND i.TABLE_NAME = :table_name
        """

        result: Dict[str, Any] = {
            "table": None,
            "columns": [],
            "constraints": [],
            "indexes": [],
        }

        async with self._engine.connect() as conn:
            table_result = await conn.execute(text(table_query), {"owner": owner, "table_name": table_name})
            table_row = table_result.fetchone()
            if table_row:
                result["table"] = dict(table_row._mapping)

            columns_result = await conn.execute(text(columns_query), {"owner": owner, "table_name": table_name})
            result["columns"] = [dict(row._mapping) for row in columns_result.fetchall()]

            constraints_result = await conn.execute(
                text(constraints_query), {"owner": owner, "table_name": table_name}
            )
            result["constraints"] = [dict(row._mapping) for row in constraints_result.fetchall()]

            indexes_result = await conn.execute(text(indexes_query), {"owner": owner, "table_name": table_name})
            result["indexes"] = [dict(row._mapping) for row in indexes_result.fetchall()]

        return result

    async def close(self) -> None:
        """关闭数据库连接"""
        if self._engine:
            await self._engine.dispose()
            self._engine = None
            logger.info("Oracle connection closed")