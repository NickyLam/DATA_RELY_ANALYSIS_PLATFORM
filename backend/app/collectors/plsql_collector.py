"""
PL/SQL 源码采集器
采集 Oracle PL/SQL 存储过程、函数、包等源码
"""

import logging
import re
from datetime import datetime
from typing import Any, Dict, List, Optional

from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine

from app.collectors.base_collector import (
    BaseCollector,
    CollectorConfig,
    CollectorResult,
    DataSourceType,
    PLSQLSourceMetadata,
)

logger = logging.getLogger(__name__)


class PLSQLCollector(BaseCollector[PLSQLSourceMetadata]):
    """
    PL/SQL 源码采集器

    采集 Oracle PL/SQL 存储过程、函数、包等源码，包括：
    - ALL_SOURCE: PL/SQL 源码
    - ALL_PROCEDURES: 存储过程和函数信息
    - ALL_ARGUMENTS: 参数信息
    """

    PLSQL_QUERIES = {
        "source": """
            SELECT
                s.OWNER as owner,
                s.NAME as name,
                s.TYPE as type,
                s.LINE as line,
                s.TEXT as text
            FROM ALL_SOURCE s
            WHERE s.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY s.OWNER, s.NAME, s.TYPE, s.LINE
        """,
        "source_by_owner": """
            SELECT
                s.OWNER as owner,
                s.NAME as name,
                s.TYPE as type,
                s.LINE as line,
                s.TEXT as text
            FROM ALL_SOURCE s
            WHERE s.OWNER = :owner
            ORDER BY s.NAME, s.TYPE, s.LINE
        """,
        "source_by_object": """
            SELECT
                s.OWNER as owner,
                s.NAME as name,
                s.TYPE as type,
                s.LINE as line,
                s.TEXT as text
            FROM ALL_SOURCE s
            WHERE s.OWNER = :owner AND s.NAME = :name AND s.TYPE = :type
            ORDER BY s.LINE
        """,
        "procedures": """
            SELECT
                p.OWNER as owner,
                p.OBJECT_NAME as object_name,
                p.OBJECT_TYPE as object_type,
                p.PROCEDURE_NAME as procedure_name,
                p.AGGREGATE as aggregate,
                p.PIPELINED as pipelined,
                p.IMPLTYPE_OWNER as impltype_owner,
                p.IMPLTYPE_NAME as impltype_name,
                p.PARALLEL as parallel,
                p.INTERFACE as interface,
                p.DETERMINISTIC as deterministic,
                p.AUTHID as authid,
                o.STATUS as status,
                o.CREATED as created_at,
                o.LAST_DDL_TIME as last_ddl_time
            FROM ALL_PROCEDURES p
            LEFT JOIN ALL_OBJECTS o ON p.OWNER = o.OWNER AND p.OBJECT_NAME = o.OBJECT_NAME AND p.OBJECT_TYPE = o.OBJECT_TYPE
            WHERE p.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY p.OWNER, p.OBJECT_NAME, p.OBJECT_TYPE
        """,
        "arguments": """
            SELECT
                a.OWNER as owner,
                a.OBJECT_NAME as object_name,
                a.PACKAGE_NAME as package_name,
                a.OBJECT_TYPE as object_type,
                a.ARGUMENT_NAME as argument_name,
                a.POSITION as position,
                a.SEQUENCE as sequence,
                a.DATA_LEVEL as data_level,
                a.DATA_TYPE as data_type,
                a.DEFAULT_VALUE as default_value,
                a.DEFAULT_LENGTH as default_length,
                a.IN_OUT as in_out,
                a.DATA_LENGTH as data_length,
                a.DATA_PRECISION as data_precision,
                a.DATA_SCALE as data_scale,
                a.RADIX as radix,
                a.CHARACTER_SET_NAME as character_set_name,
                a.TYPE_OWNER as type_owner,
                a.TYPE_NAME as type_name,
                a.TYPE_SUBNAME as type_subname,
                a.TYPE_LINK as type_link,
                a.PLS_TYPE as pls_type,
                a.CHAR_LENGTH as char_length,
                a.CHAR_USED as char_used
            FROM ALL_ARGUMENTS a
            WHERE a.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY a.OWNER, a.OBJECT_NAME, a.PACKAGE_NAME, a.POSITION
        """,
        "object_list": """
            SELECT DISTINCT
                s.OWNER as owner,
                s.NAME as name,
                s.TYPE as type,
                o.STATUS as status,
                o.CREATED as created_at,
                o.LAST_DDL_TIME as last_ddl_time,
                o.TIMESTAMP as timestamp
            FROM ALL_SOURCE s
            LEFT JOIN ALL_OBJECTS o ON s.OWNER = o.OWNER AND s.NAME = o.OBJECT_NAME AND s.TYPE = o.OBJECT_TYPE
            WHERE s.OWNER NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN', 'MDSYS', 'ORDSYS', 'EXFSYS', 'CTXSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'APEX_PUBLIC_USER', 'ORDPLUGINS', 'OLAPSYS', 'PUBLIC')
            ORDER BY s.OWNER, s.NAME, s.TYPE
        """,
    }

    PLSQL_OBJECT_TYPES = [
        "PROCEDURE",
        "FUNCTION",
        "PACKAGE",
        "PACKAGE BODY",
        "TYPE",
        "TYPE BODY",
        "TRIGGER",
        "JAVA SOURCE",
        "JAVA CLASS",
    ]

    def __init__(self, config: CollectorConfig):
        """
        初始化 PL/SQL 源码采集器

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
        return self.PLSQL_QUERIES

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

    async def collect(self) -> CollectorResult[PLSQLSourceMetadata]:
        """
        执行 PL/SQL 源码采集

        Returns:
            CollectorResult: 采集结果
        """
        start_time = datetime.now()
        result = CollectorResult[PLSQLSourceMetadata](success=False, start_time=start_time)

        try:
            await self.connect()
            self.update_status("running")

            sources = await self._collect_source()

            result.data = sources
            result.total_count = len(sources)
            result.success = True
            result.metadata = {
                "sources_count": len(sources),
            }

            self.update_status("completed")
            logger.info(f"Collection completed: {result.total_count} PL/SQL sources collected")

        except Exception as e:
            result.error_message = str(e)
            self.update_status("failed")
            logger.error(f"Collection failed: {e}")

        finally:
            await self.close()

        result.end_time = datetime.now()
        result.duration_seconds = (result.end_time - result.start_time).total_seconds()

        return result

    async def _collect_source(self) -> List[PLSQLSourceMetadata]:
        """
        采集 PL/SQL 源码

        Returns:
            List[PLSQLSourceMetadata]: PL/SQL 源码列表
        """
        sources: List[PLSQLSourceMetadata] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.PLSQL_QUERIES["source"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                source = PLSQLSourceMetadata(
                    source_id=self.generate_id(
                        self.config.data_source_id,
                        row_dict.get("owner", ""),
                        row_dict.get("name", ""),
                        row_dict.get("type", ""),
                        str(row_dict.get("line", 0)),
                    ),
                    owner=row_dict.get("owner", ""),
                    name=row_dict.get("name", ""),
                    type=row_dict.get("type", ""),
                    line=row_dict.get("line", 0),
                    text=row_dict.get("text", ""),
                    data_source_id=self.config.data_source_id,
                )
                sources.append(source)

        logger.info(f"Collected {len(sources)} PL/SQL source lines")
        return sources

    async def collect_source_by_owner(self, owner: str) -> List[PLSQLSourceMetadata]:
        """
        采集指定用户的 PL/SQL 源码

        Args:
            owner: 用户名

        Returns:
            List[PLSQLSourceMetadata]: PL/SQL 源码列表
        """
        sources: List[PLSQLSourceMetadata] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(
                text(self.PLSQL_QUERIES["source_by_owner"]),
                {"owner": owner},
            )
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                source = PLSQLSourceMetadata(
                    source_id=self.generate_id(
                        self.config.data_source_id,
                        owner,
                        row_dict.get("name", ""),
                        row_dict.get("type", ""),
                        str(row_dict.get("line", 0)),
                    ),
                    owner=owner,
                    name=row_dict.get("name", ""),
                    type=row_dict.get("type", ""),
                    line=row_dict.get("line", 0),
                    text=row_dict.get("text", ""),
                    data_source_id=self.config.data_source_id,
                )
                sources.append(source)

        return sources

    async def collect_source_by_object(
        self,
        owner: str,
        name: str,
        object_type: str,
    ) -> Dict[str, Any]:
        """
        采集指定对象的 PL/SQL 源码

        Args:
            owner: 用户名
            name: 对象名
            object_type: 对象类型

        Returns:
            Dict[str, Any]: PL/SQL 源码信息
        """
        async with self._engine.connect() as conn:
            result = await conn.execute(
                text(self.PLSQL_QUERIES["source_by_object"]),
                {"owner": owner, "name": name, "type": object_type},
            )
            rows = result.fetchall()

            source_lines = []
            full_source = ""

            for row in rows:
                row_dict = dict(row._mapping)
                source_lines.append({
                    "line": row_dict.get("line", 0),
                    "text": row_dict.get("text", ""),
                })
                full_source += row_dict.get("text", "") + "\n"

            return {
                "source_id": self.generate_id(self.config.data_source_id, owner, name, object_type),
                "owner": owner,
                "name": name,
                "type": object_type,
                "source_lines": source_lines,
                "source_code": full_source.strip(),
                "line_count": len(source_lines),
                "data_source_id": self.config.data_source_id,
            }

    async def collect_object_list(self) -> List[Dict[str, Any]]:
        """
        采集 PL/SQL 对象列表

        Returns:
            List[Dict[str, Any]]: PL/SQL 对象列表
        """
        objects: List[Dict[str, Any]] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.PLSQL_QUERIES["object_list"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                row_dict["object_id"] = self.generate_id(
                    self.config.data_source_id,
                    row_dict.get("owner", ""),
                    row_dict.get("name", ""),
                    row_dict.get("type", ""),
                )
                row_dict["data_source_id"] = self.config.data_source_id
                objects.append(row_dict)

        logger.info(f"Collected {len(objects)} PL/SQL objects")
        return objects

    async def collect_procedures(self) -> List[Dict[str, Any]]:
        """
        采集存储过程和函数信息

        Returns:
            List[Dict[str, Any]]: 存储过程和函数信息列表
        """
        procedures: List[Dict[str, Any]] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.PLSQL_QUERIES["procedures"]))
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

    async def collect_arguments(self) -> List[Dict[str, Any]]:
        """
        采集参数信息

        Returns:
            List[Dict[str, Any]]: 参数信息列表
        """
        arguments: List[Dict[str, Any]] = []

        async with self._engine.connect() as conn:
            result = await conn.execute(text(self.PLSQL_QUERIES["arguments"]))
            rows = result.fetchall()

            for row in rows:
                row_dict = dict(row._mapping)
                row_dict["argument_id"] = self.generate_id(
                    self.config.data_source_id,
                    row_dict.get("owner", ""),
                    row_dict.get("object_name", ""),
                    str(row_dict.get("position", 0)),
                )
                row_dict["data_source_id"] = self.config.data_source_id
                arguments.append(row_dict)

        logger.info(f"Collected {len(arguments)} arguments")
        return arguments

    async def collect_all_plsql_data(self) -> Dict[str, Any]:
        """
        采集所有 PL/SQL 数据

        Returns:
            Dict[str, Any]: 所有 PL/SQL 数据
        """
        return {
            "sources": await self._collect_source(),
            "objects": await self.collect_object_list(),
            "procedures": await self.collect_procedures(),
            "arguments": await self.collect_arguments(),
        }

    def parse_plsql_references(self, source_code: str) -> List[Dict[str, str]]:
        """
        解析 PL/SQL 源码中的表引用

        Args:
            source_code: PL/SQL 源码

        Returns:
            List[Dict[str, str]]: 表引用列表
        """
        references: List[Dict[str, str]] = []

        patterns = [
            r"FROM\s+(\w+)\.(\w+)",
            r"FROM\s+(\w+)",
            r"JOIN\s+(\w+)\.(\w+)",
            r"JOIN\s+(\w+)",
            r"INTO\s+(\w+)\.(\w+)",
            r"INTO\s+(\w+)",
            r"UPDATE\s+(\w+)\.(\w+)",
            r"UPDATE\s+(\w+)",
            r"INSERT\s+INTO\s+(\w+)\.(\w+)",
            r"INSERT\s+INTO\s+(\w+)",
            r"DELETE\s+FROM\s+(\w+)\.(\w+)",
            r"DELETE\s+FROM\s+(\w+)",
        ]

        for pattern in patterns:
            matches = re.findall(pattern, source_code, re.IGNORECASE)
            for match in matches:
                if isinstance(match, tuple):
                    owner, table_name = match
                    references.append({
                        "owner": owner,
                        "table_name": table_name,
                        "reference_type": "TABLE",
                    })
                else:
                    table_name = match
                    references.append({
                        "owner": "",
                        "table_name": table_name,
                        "reference_type": "TABLE",
                    })

        return references

    def parse_plsql_procedure_calls(self, source_code: str) -> List[Dict[str, str]]:
        """
        解析 PL/SQL 源码中的过程调用

        Args:
            source_code: PL/SQL 源码

        Returns:
            List[Dict[str, str]]: 过程调用列表
        """
        calls: List[Dict[str, str]] = []

        patterns = [
            r"(\w+)\.(\w+)\s*\(",
            r"(\w+)\s*\(",
        ]

        for pattern in patterns:
            matches = re.findall(pattern, source_code)
            for match in matches:
                if isinstance(match, tuple):
                    package_name, procedure_name = match
                    calls.append({
                        "package_name": package_name,
                        "procedure_name": procedure_name,
                        "call_type": "PROCEDURE",
                    })
                else:
                    procedure_name = match
                    calls.append({
                        "package_name": "",
                        "procedure_name": procedure_name,
                        "call_type": "PROCEDURE",
                    })

        return calls

    async def collect_source_with_references(self, owner: str, name: str, object_type: str) -> Dict[str, Any]:
        """
        采集 PL/SQL 源码并解析引用

        Args:
            owner: 用户名
            name: 对象名
            object_type: 对象类型

        Returns:
            Dict[str, Any]: PL/SQL 源码及引用信息
        """
        source_info = await self.collect_source_by_object(owner, name, object_type)

        if source_info.get("source_code"):
            source_info["table_references"] = self.parse_plsql_references(source_info["source_code"])
            source_info["procedure_calls"] = self.parse_plsql_procedure_calls(source_info["source_code"])

        return source_info

    async def collect_package_spec_and_body(self, owner: str, package_name: str) -> Dict[str, Any]:
        """
        采集包的声明和主体

        Args:
            owner: 用户名
            package_name: 包名

        Returns:
            Dict[str, Any]: 包声明和主体信息
        """
        spec = await self.collect_source_by_object(owner, package_name, "PACKAGE")
        body = await self.collect_source_by_object(owner, package_name, "PACKAGE BODY")

        return {
            "package_id": self.generate_id(self.config.data_source_id, owner, package_name, "PACKAGE"),
            "owner": owner,
            "package_name": package_name,
            "spec": spec,
            "body": body,
            "data_source_id": self.config.data_source_id,
        }

    async def close(self) -> None:
        """关闭数据库连接"""
        if self._engine:
            await self._engine.dispose()
            self._engine = None
            logger.info("Oracle connection closed")