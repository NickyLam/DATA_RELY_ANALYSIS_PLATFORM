"""
采集器基类
提供采集器的通用接口和基础功能
"""

import asyncio
import logging
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any, Dict, Generic, List, Optional, TypeVar

from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

logger = logging.getLogger(__name__)

T = TypeVar("T")


class CollectorStatus(str, Enum):
    """采集器状态枚举"""

    PENDING = "pending"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"
    CANCELLED = "cancelled"


class DataSourceType(str, Enum):
    """数据源类型枚举"""

    ORACLE = "oracle"
    TDH = "tdh"
    OCEANBASE = "oceanbase"
    GBASE = "gbase"
    YASHAN = "yashan"


@dataclass
class CollectorConfig:
    """采集器配置"""

    data_source_id: str
    data_source_type: DataSourceType
    host: str
    port: int
    database_name: str
    username: str
    password: str
    batch_size: int = 1000
    max_retries: int = 3
    retry_delay: float = 1.0
    timeout: float = 300.0
    connection_params: Dict[str, Any] = field(default_factory=dict)

    def get_oracle_connection_url(self) -> str:
        """获取 Oracle 连接 URL"""
        service_name = self.connection_params.get("service_name", self.database_name)
        return f"oracle+oracledb://{self.username}:{self.password}@{self.host}:{self.port}/?service_name={service_name}"


@dataclass
class CollectorResult(Generic[T]):
    """采集器结果"""

    success: bool
    data: List[T] = field(default_factory=list)
    total_count: int = 0
    error_message: Optional[str] = None
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    duration_seconds: float = 0.0
    metadata: Dict[str, Any] = field(default_factory=dict)

    @property
    def is_empty(self) -> bool:
        """检查结果是否为空"""
        return self.total_count == 0


@dataclass
class TableMetadata:
    """表元数据"""

    table_id: str
    table_name: str
    owner: str
    table_type: str
    num_rows: Optional[int] = None
    avg_row_length: Optional[int] = None
    blocks: Optional[int] = None
    empty_blocks: Optional[int] = None
    last_analyzed: Optional[datetime] = None
    partitioned: str = "NO"
    temporary: str = "N"
    nested: str = "NO"
    tablespace_name: Optional[str] = None
    comments: Optional[str] = None
    created_at: Optional[datetime] = None
    data_source_id: Optional[str] = None


@dataclass
class ColumnMetadata:
    """列元数据"""

    column_id: str
    table_id: str
    column_name: str
    data_type: str
    data_length: Optional[int] = None
    data_precision: Optional[int] = None
    data_scale: Optional[int] = None
    nullable: str = "Y"
    default_value: Optional[str] = None
    column_id_num: Optional[int] = None
    comments: Optional[str] = None
    is_primary_key: bool = False
    is_foreign_key: bool = False
    data_source_id: Optional[str] = None


@dataclass
class ConstraintMetadata:
    """约束元数据"""

    constraint_id: str
    constraint_name: str
    constraint_type: str
    table_id: str
    owner: str
    status: str = "ENABLED"
    deferrable: str = "NOT DEFERRABLE"
    deferred: str = "IMMEDIATE"
    validated: str = "VALIDATED"
    generated: str = "USER NAME"
    rely: str = "DISABLED"
    search_condition: Optional[str] = None
    r_owner: Optional[str] = None
    r_constraint_name: Optional[str] = None
    delete_rule: Optional[str] = None
    data_source_id: Optional[str] = None


@dataclass
class DependencyMetadata:
    """依赖关系元数据"""

    dependency_id: str
    owner: str
    name: str
    type: str
    referenced_owner: str
    referenced_name: str
    referenced_type: str
    dependency_type: str = "HARD"
    dependency_id_num: Optional[int] = None
    data_source_id: Optional[str] = None


@dataclass
class PLSQLSourceMetadata:
    """PL/SQL 源码元数据"""

    source_id: str
    owner: str
    name: str
    type: str
    line: int
    text: str
    source_code: Optional[str] = None
    data_source_id: Optional[str] = None


class BaseCollector(ABC, Generic[T]):
    """
    采集器基类

    提供采集器的通用接口和基础功能，包括：
    - 连接管理
    - 批量处理
    - 错误重试
    - 结果写入
    """

    def __init__(self, config: CollectorConfig):
        """
        初始化采集器

        Args:
            config: 采集器配置
        """
        self.config = config
        self.status = CollectorStatus.PENDING
        self._session: Optional[AsyncSession] = None
        self._neo4j_driver = None

    @abstractmethod
    async def collect(self) -> CollectorResult[T]:
        """
        执行采集（抽象方法，子类必须实现）

        Returns:
            CollectorResult: 采集结果
        """
        pass

    @abstractmethod
    def get_collection_queries(self) -> Dict[str, str]:
        """
        获取采集查询语句（抽象方法，子类必须实现）

        Returns:
            Dict[str, str]: 查询名称到 SQL 语句的映射
        """
        pass

    async def execute_with_retry(
        self,
        query: str,
        params: Optional[Dict[str, Any]] = None,
    ) -> List[Dict[str, Any]]:
        """
        带重试机制的查询执行

        Args:
            query: SQL 查询语句
            params: 查询参数

        Returns:
            List[Dict[str, Any]]: 查询结果列表

        Raises:
            Exception: 重试次数耗尽后抛出异常
        """
        last_error: Optional[Exception] = None

        for attempt in range(self.config.max_retries):
            try:
                if self._session is None:
                    raise RuntimeError("Database session not initialized")

                result = await self._session.execute(text(query), params or {})
                rows = result.fetchall()
                return [dict(row._mapping) for row in rows]

            except Exception as e:
                last_error = e
                logger.warning(
                    f"Query execution failed (attempt {attempt + 1}/{self.config.max_retries}): {e}"
                )
                if attempt < self.config.max_retries - 1:
                    await asyncio.sleep(self.config.retry_delay * (attempt + 1))

        raise last_error or RuntimeError("Unknown error occurred")

    async def execute_batch(
        self,
        query: str,
        params_list: List[Dict[str, Any]],
    ) -> int:
        """
        批量执行查询

        Args:
            query: SQL 查询语句
            params_list: 参数列表

        Returns:
            int: 成功执行的记录数
        """
        success_count = 0

        for i in range(0, len(params_list), self.config.batch_size):
            batch = params_list[i : i + self.config.batch_size]

            for params in batch:
                try:
                    if self._session is None:
                        raise RuntimeError("Database session not initialized")

                    await self._session.execute(text(query), params)
                    success_count += 1
                except Exception as e:
                    logger.error(f"Batch execution failed for params {params}: {e}")

            await self._session.commit()

        return success_count

    def generate_id(self, *parts: str) -> str:
        """
        生成唯一 ID

        Args:
            *parts: ID 组成部分

        Returns:
            str: 唯一 ID
        """
        return ":".join(parts)

    def update_status(self, status: CollectorStatus) -> None:
        """
        更新采集器状态

        Args:
            status: 新状态
        """
        self.status = status
        logger.info(f"Collector status updated: {status.value}")

    async def write_to_postgresql(
        self,
        data: List[T],
        table_name: str,
        session: AsyncSession,
    ) -> int:
        """
        将采集结果写入 PostgreSQL

        Args:
            data: 采集数据列表
            table_name: 目标表名
            session: 数据库会话

        Returns:
            int: 写入记录数
        """
        if not data:
            return 0

        written_count = 0

        for item in data:
            try:
                item_dict = self._dataclass_to_dict(item)
                columns = ", ".join(item_dict.keys())
                placeholders = ", ".join([f":{k}" for k in item_dict.keys()])
                insert_query = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders}) ON CONFLICT DO NOTHING"

                await session.execute(text(insert_query), item_dict)
                written_count += 1
            except Exception as e:
                logger.error(f"Failed to write item to PostgreSQL: {e}")

        await session.commit()
        return written_count

    async def write_to_neo4j(
        self,
        data: List[T],
        node_label: str,
        driver: Any,
    ) -> int:
        """
        将采集结果写入 Neo4j

        Args:
            data: 采集数据列表
            node_label: 节点标签
            driver: Neo4j 驱动

        Returns:
            int: 写入记录数
        """
        if not data:
            return 0

        written_count = 0

        async with driver.session() as neo4j_session:
            for item in data:
                try:
                    item_dict = self._dataclass_to_dict(item)
                    props_str = ", ".join([f"{k}: ${k}" for k in item_dict.keys()])
                    merge_query = f"MERGE (n:{node_label} {{id: $id}}) SET n += {{{props_str}}}"

                    await neo4j_session.run(merge_query, item_dict)
                    written_count += 1
                except Exception as e:
                    logger.error(f"Failed to write item to Neo4j: {e}")

        return written_count

    def _dataclass_to_dict(self, obj: Any) -> Dict[str, Any]:
        """
        将 dataclass 对象转换为字典

        Args:
            obj: dataclass 对象

        Returns:
            Dict[str, Any]: 字典表示
        """
        if hasattr(obj, "__dataclass_fields__"):
            result = {}
            for field_name in obj.__dataclass_fields__:
                value = getattr(obj, field_name)
                if isinstance(value, datetime):
                    result[field_name] = value.isoformat()
                elif value is not None:
                    result[field_name] = value
            return result
        return obj if isinstance(obj, dict) else {}

    async def close(self) -> None:
        """关闭采集器，释放资源"""
        if self._session:
            await self._session.close()
            self._session = None

        if self._neo4j_driver:
            await self._neo4j_driver.close()
            self._neo4j_driver = None