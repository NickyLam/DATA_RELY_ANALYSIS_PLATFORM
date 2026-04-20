"""
Oracle 系统视图采集器
采集 Oracle 系统视图中的依赖关系和血缘信息
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
    DependencyMetadata,
    DataSourceType,
)

logger = logging.getLogger(__name__)


class OracleViewsCollector(BaseCollector[DependencyMetadata]):
    """
    Oracle 系统视图采集器

    采集 Oracle 系统视图中的依赖关系和血缘信息，包括：
    - ALL_DEPENDENCIES: 对象依赖关系
    - ALL_SOURCE: PL/SQL 源码
    - ALL_VIEWS: 视图定义
    - ALL_MVIEWS: 物化视图定义
    - ALL_TRIGGERS: 触发器定义
    """

    ORACLE_VIEWS_QUERIES = {
        "dependencies": """
            SELECT
                d.OWNER as owner,
                d.NAME as name,
                d.TYPE as type,
                d.REFERENCED_OWNER as referenced_owner,
                d.REFERENCED_NAME as referenced_name,
                d.REFERENCED_TYPE as referenced_type,
                d.DEPENDENCY_TYPE as dependency_type
            FROM ALL_DEPENDENCIES d
            WHERE d.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY d.OWNER, d.NAME, d.TYPE
        """,
        "views": """
            SELECT
                v.OWNER as owner,
                v.VIEW_NAME as view_name,
                v.TEXT_LENGTH as text_length,
                v.TEXT as text,
                v.TEXT_VC as text_vc,
                v.TYPE_TEXT as type_text,
                v.OID_TEXT as oid_text,
                v.VIEW_TYPE_OWNER as view_type_owner,
                v.VIEW_TYPE as view_type,
                v.SUPERVIEW_NAME as superview_name,
                o.CREATED as created_at,
                o.LAST_DDL_TIME as last_ddl_time,
                c.COMMENTS as comments
            FROM ALL_VIEWS v
            LEFT JOIN ALL_OBJECTS o ON v.OWNER = o.OWNER AND v.VIEW_NAME = o.OBJECT_NAME AND o.OBJECT_TYPE = 'VIEW'
            LEFT JOIN ALL_TAB_COMMENTS c ON v.OWNER = c.OWNER AND v.VIEW_NAME = c.TABLE_NAME
            WHERE v.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY v.OWNER, v.VIEW_NAME
        """,
        "mviews": """
            SELECT
                m.OWNER as owner,
                m.MVIEW_NAME as mview_name,
                m.CONTAINER_NAME as container_name,
                m.QUERY as query,
                m.QUERY_LEN as query_len,
                m.UPDATABLE as updatable,
                m.UPDATE_LOG as update_log,
                m.MASTER_LINK as master_link,
                m.REWRITE_ENABLED as rewrite_enabled,
                m.REWRITE_CAPABILITY as rewrite_capability,
                m.REFRESH_MODE as refresh_mode,
                m.REFRESH_METHOD as refresh_method,
                m.BUILD_MODE as build_mode,
                m.FAST_REFRESHABLE as fast_refreshable,
                m.LAST_REFRESH_DATE as last_refresh_date,
                m.LAST_REFRESH_TYPE as last_refresh_type,
                m.STALENESS as staleness,
                m.AFTER_FAST_REFRESH as after_fast_refresh,
                m.COMPILE_STATE as compile_state,
                o.CREATED as created_at,
                o.LAST_DDL_TIME as last_ddl_time
            FROM ALL_MVIEWS m
            LEFT JOIN ALL_OBJECTS o ON m.OWNER = o.OWNER AND m.MVIEW_NAME = o.OBJECT_NAME AND o.OBJECT_TYPE = 'MATERIALIZED VIEW'
            WHERE m.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY m.OWNER, m.MVIEW_NAME
        """,
        "triggers": """
            SELECT
                t.OWNER as owner,
                t.TRIGGER_NAME as trigger_name,
                t.TRIGGER_TYPE as trigger_type,
                t.TRIGGERING_EVENT as triggering_event,
                t.TABLE_OWNER as table_owner,
                t.BASE_OBJECT_TYPE as base_object_type,
                t.TABLE_NAME as table_name,
                t.COLUMN_NAME as column_name,
                t.REFERENCING_NAMES as referencing_names,
                t.WHEN_CLAUSE as when_clause,
                t.STATUS as status,
                t.DESCRIPTION as description,
                t.ACTION_TYPE as action_type,
                t.TRIGGER_BODY as trigger_body,
                o.CREATED as created_at,
                o.LAST_DDL_TIME as last_ddl_time
            FROM ALL_TRIGGERS t
            LEFT JOIN ALL_OBJECTS o ON t.OWNER = o.OWNER AND t.TRIGGER_NAME = o.OBJECT_NAME AND o.OBJECT_TYPE = 'TRIGGER'
            WHERE t.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY t.OWNER, t.TRIGGER_NAME
        """,
        "procedures": """
            SELECT
                p.OWNER as owner,
                p.OBJECT_NAME as object_name,
                p.OBJECT_TYPE as object_type,
                p.AGGREGATE as aggregate,
                p.PIPELINED as pipelined,
                p.IMPLTYPE_OWNER as impltype_owner,
                p.IMPLTYPE_NAME as impltype_name,
                p.PARALLEL as parallel,
                p.INTERFACE as interface,
                p.DETERMINISTIC as deterministic,
                p.AUTHID as authid,
                o.CREATED as created_at,
                o.LAST_DDL_TIME as last_ddl_time,
                o.STATUS as status
            FROM ALL_PROCEDURES p
            LEFT JOIN ALL_OBJECTS o ON p.OWNER = o.OWNER AND p.OBJECT_NAME = o.OBJECT_NAME AND p.OBJECT_TYPE = o.OBJECT_TYPE
            WHERE p.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY p.OWNER, p.OBJECT_NAME, p.OBJECT_TYPE
        """,
        "synonyms": """
            SELECT
                s.OWNER as owner,
                s.SYNONYM_NAME as synonym_name,
                s.TABLE_OWNER as table_owner,
                s.TABLE_NAME as table_name,
                s.DB_LINK as db_link,
                o.CREATED as created_at,
                o.LAST_DDL_TIME as last_ddl_time
            FROM ALL_SYNONYMS s
            LEFT JOIN ALL_OBJECTS o ON s.OWNER = o.OWNER AND s.SYNONYM_NAME = o.OBJECT_NAME AND o.OBJECT_TYPE = 'SYNONYM'
            WHERE s.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY s.OWNER, s.SYNONYM_NAME
        """,
        "db_links": """
            SELECT
                l.OWNER as owner,
                l.DB_LINK as db_link,
                l.USERNAME as username,
                l.HOST as host,
                l.CREATED as created_at
            FROM ALL_DB_LINKS l
            WHERE l.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY l.OWNER, l.DB_LINK
        """,
    }

    def __init__(self, config: CollectorConfig):
        """
        初始化 Oracle 系统视图采集器

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
        return self.ORACLE_VIEWS_QUERIES

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

    async def collect(self) -> CollectorResult[DependencyMetadata]:
        """
        执行依赖关系采集

        Returns:
            CollectorResult: 采集结果
        """
        start_time = datetime.now()
        result = CollectorResult[DependencyMetadata](success=False, start_time=start_time)

        try:
            await self.connect()
            self.update_status("running")

            dependencies = await self._collect_dependencies()

            result.data = dependencies
            result.total_count = len(dependencies)
            result.success = True
            result.metadata = {
                "dependencies_count": len(dependencies),
            }

            self.update_status("completed")
            logger.info(f"Collection completed: {result.total_count} dependencies collected")

        except Exception as e:
            result.error_message = str(e)
            self.update_status("failed")
            logger.error(f"Collection failed: {e}")

        finally:
            await self.close()

        result.end_time = datetime.now()
        result.duration_seconds = (result.end_time - result.start_time).total_seconds()

        return result

    async def _collect_dependencies(self) -> List[DependencyMetadata]:
        """
        采集依赖关系

        Returns:
            List[DependencyMetadata]: 依赖关系列表
        """
        dependencies: List[DependencyMetadata] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.ORACLE_VIEWS_QUERIES["dependencies"]))
            rows = result.fetchall()

            for idx, row in enumerate(rows):
                row_dict = dict(row._mapping)
                dependency = DependencyMetadata(
                    dependency_id=self.generate_id(
                        self.config.data_source_id,
                        row_dict.get("owner", ""),
                        row_dict.get("name", ""),
                        row_dict.get("type", ""),
                        str(idx),
                    ),
                    owner=row_dict.get("owner", ""),
                    name=row_dict.get("name", ""),
                    type=row_dict.get("type", ""),
                    referenced_owner=row_dict.get("referenced_owner", ""),
                    referenced_name=row_dict.get("referenced_name", ""),
                    referenced_type=row_dict.get("referenced_type", ""),
                    dependency_type=row_dict.get("dependency_type", "HARD"),
                    dependency_id_num=idx,
                    data_source_id=self.config.data_source_id,
                )
                dependencies.append(dependency)

        logger.info(f"Collected {len(dependencies)} dependencies")
        return dependencies

    async def collect_views(self) -> List[Dict[str, Any]]:
        """
        采集视图定义

        Returns:
            List[Dict[str, Any]]: 视图定义列表
        """
        views: List[Dict[str, Any]] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.ORACLE_VIEWS_QUERIES["views"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                row_dict["view_id"] = self.generate_id(
                    self.config.data_source_id,
                    row_dict.get("owner", ""),
                    row_dict.get("view_name", ""),
                )
                row_dict["data_source_id"] = self.config.data_source_id
                views.append(row_dict)

        logger.info(f"Collected {len(views)} views")
        return views

    async def collect_materialized_views(self) -> List[Dict[str, Any]]:
        """
        采集物化视图定义

        Returns:
            List[Dict[str, Any]]: 物化视图定义列表
        """
        mviews: List[Dict[str, Any]] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.ORACLE_VIEWS_QUERIES["mviews"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                row_dict["mview_id"] = self.generate_id(
                    self.config.data_source_id,
                    row_dict.get("owner", ""),
                    row_dict.get("mview_name", ""),
                )
                row_dict["data_source_id"] = self.config.data_source_id
                mviews.append(row_dict)

        logger.info(f"Collected {len(mviews)} materialized views")
        return mviews

    async def collect_triggers(self) -> List[Dict[str, Any]]:
        """
        采集触发器定义

        Returns:
            List[Dict[str, Any]]: 触发器定义列表
        """
        triggers: List[Dict[str, Any]] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.ORACLE_VIEWS_QUERIES["triggers"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                row_dict["trigger_id"] = self.generate_id(
                    self.config.data_source_id,
                    row_dict.get("owner", ""),
                    row_dict.get("trigger_name", ""),
                )
                row_dict["data_source_id"] = self.config.data_source_id
                triggers.append(row_dict)

        logger.info(f"Collected {len(triggers)} triggers")
        return triggers

    async def collect_procedures(self) -> List[Dict[str, Any]]:
        """
        采集存储过程和函数定义

        Returns:
            List[Dict[str, Any]]: 存储过程和函数定义列表
        """
        procedures: List[Dict[str, Any]] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.ORACLE_VIEWS_QUERIES["procedures"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                row_dict["procedure_id"] = self.generate_id(
                    self.config.data_source_id,
                    row_dict.get("owner", ""),
                    row_dict.get("object_name", ""),
                    row_dict.get("object_type", ""),
                )
                row_dict["data_source_id"] = self.config.data_source_id
                procedures.append(row_dict)

        logger.info(f"Collected {len(procedures)} procedures")
        return procedures

    async def collect_synonyms(self) -> List[Dict[str, Any]]:
        """
        采集同义词定义

        Returns:
            List[Dict[str, Any]]: 同义词定义列表
        """
        synonyms: List[Dict[str, Any]] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.ORACLE_VIEWS_QUERIES["synonyms"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                row_dict["synonym_id"] = self.generate_id(
                    self.config.data_source_id,
                    row_dict.get("owner", ""),
                    row_dict.get("synonym_name", ""),
                )
                row_dict["data_source_id"] = self.config.data_source_id
                synonyms.append(row_dict)

        logger.info(f"Collected {len(synonyms)} synonyms")
        return synonyms

    async def collect_db_links(self) -> List[Dict[str, Any]]:
        """
        采集数据库链接定义

        Returns:
            List[Dict[str, Any]]: 数据库链接定义列表
        """
        db_links: List[Dict[str, Any]] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.ORACLE_VIEWS_QUERIES["db_links"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                row_dict["db_link_id"] = self.generate_id(
                    self.config.data_source_id,
                    row_dict.get("owner", ""),
                    row_dict.get("db_link", ""),
                )
                row_dict["data_source_id"] = self.config.data_source_id
                db_links.append(row_dict)

        logger.info(f"Collected {len(db_links)} database links")
        return db_links

    async def collect_all_views_data(self) -> Dict[str, List[Dict[str, Any]]]:
        """
        采集所有系统视图数据

        Returns:
            Dict[str, List[Dict[str, Any]]]: 所有系统视图数据
        """
        return {
            "dependencies": await self._collect_dependencies(),
            "views": await self.collect_views(),
            "materialized_views": await self.collect_materialized_views(),
            "triggers": await self.collect_triggers(),
            "procedures": await self.collect_procedures(),
            "synonyms": await self.collect_synonyms(),
            "db_links": await self.collect_db_links(),
        }

    async def collect_dependencies_for_object(
        self,
        owner: str,
        object_name: str,
        object_type: str,
    ) -> List[DependencyMetadata]:
        """
        采集指定对象的依赖关系

        Args:
            owner: 对象所有者
            object_name: 对象名称
            object_type: 对象类型

        Returns:
            List[DependencyMetadata]: 依赖关系列表
        """
        query = """
            SELECT
                d.OWNER as owner,
                d.NAME as name,
                d.TYPE as type,
                d.REFERENCED_OWNER as referenced_owner,
                d.REFERENCED_NAME as referenced_name,
                d.REFERENCED_TYPE as referenced_type,
                d.DEPENDENCY_TYPE as dependency_type
            FROM ALL_DEPENDENCIES d
            WHERE d.OWNER = :owner AND d.NAME = :object_name AND d.TYPE = :object_type
            ORDER BY d.REFERENCED_OWNER, d.REFERENCED_NAME
        """

        dependencies: List[DependencyMetadata] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(
                text(query),
                {"owner": owner, "object_name": object_name, "object_type": object_type},
            )
            rows = result.fetchall()

            for idx, row in enumerate(rows):
                row_dict = dict(row._mapping)
                dependency = DependencyMetadata(
                    dependency_id=self.generate_id(
                        self.config.data_source_id,
                        owner,
                        object_name,
                        object_type,
                        str(idx),
                    ),
                    owner=owner,
                    name=object_name,
                    type=object_type,
                    referenced_owner=row_dict.get("referenced_owner", ""),
                    referenced_name=row_dict.get("referenced_name", ""),
                    referenced_type=row_dict.get("referenced_type", ""),
                    dependency_type=row_dict.get("dependency_type", "HARD"),
                    dependency_id_num=idx,
                    data_source_id=self.config.data_source_id,
                )
                dependencies.append(dependency)

        return dependencies

    async def close(self) -> None:
        """关闭数据库连接"""
        if self._engine:
            await self._engine.dispose()
            self._engine = None
            logger.info("Oracle connection closed")