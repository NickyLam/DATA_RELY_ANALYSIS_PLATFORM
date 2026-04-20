"""
Redis 缓存服务
提供血缘查询缓存、搜索结果缓存、缓存预热等功能
"""
import hashlib
import json
import logging
from datetime import datetime
from typing import Any, Callable, Dict, List, Optional, TypeVar, Union

import redis.asyncio as redis
from pydantic import BaseModel

from app.core.config import settings
from app.schemas.lineage import LineageGraph, LineageNode, LineagePath
from app.schemas.search import SearchResult

logger = logging.getLogger(__name__)

T = TypeVar("T", bound=BaseModel)

CACHE_KEY_PREFIX = "lineage_platform"

DEFAULT_TTL_CONFIG = {
    "lineage": 3600,
    "search": 300,
    "table_details": 1800,
    "field_lineage": 3600,
    "impact_analysis": 1800,
    "filter_options": 600,
}


class CacheService:
    """
    Redis 缓存服务
    """

    def __init__(self, redis_client: Optional[redis.Redis] = None):
        self._redis_client = redis_client
        self._connected = False

    async def connect(self) -> None:
        """
        连接 Redis
        """
        if self._redis_client is None:
            self._redis_client = redis.from_url(
                settings.REDIS_URL,
                encoding="utf-8",
                decode_responses=True,
            )
        try:
            await self._redis_client.ping()
            self._connected = True
            logger.info("Redis 缓存服务连接成功")
        except redis.RedisError as e:
            logger.warning(f"Redis 连接失败，将使用无缓存模式: {e}")
            self._connected = False

    async def disconnect(self) -> None:
        """
        断开 Redis 连接
        """
        if self._redis_client:
            await self._redis_client.close()
            self._connected = False
            logger.info("Redis 缓存服务断开连接")

    def _generate_cache_key(
        self,
        cache_type: str,
        identifier: str,
        params: Optional[Dict[str, Any]] = None,
    ) -> str:
        """
        生成缓存键

        Args:
            cache_type: 缓存类型（lineage, search, table_details 等）
            identifier: 主标识符（如 table_id）
            params: 额外参数（用于区分不同查询）

        Returns:
            str: 缓存键
        """
        base_key = f"{CACHE_KEY_PREFIX}:{cache_type}:{identifier}"

        if params:
            params_str = json.dumps(params, sort_keys=True, default=str)
            params_hash = hashlib.md5(params_str.encode()).hexdigest()[:8]
            base_key = f"{base_key}:{params_hash}"

        return base_key

    async def get(
        self,
        key: str,
        model_class: Optional[type] = None,
    ) -> Optional[Union[BaseModel, Dict[str, Any], str]]:
        """
        获取缓存值

        Args:
            key: 缓存键
            model_class: Pydantic 模型类（用于反序列化）

        Returns:
            缓存值或 None
        """
        if not self._connected or not self._redis_client:
            return None

        try:
            cached_value = await self._redis_client.get(key)
            if cached_value is None:
                return None

            data = json.loads(cached_value)

            if model_class and isinstance(data, dict):
                return model_class(**data)

            return data
        except (redis.RedisError, json.JSONDecodeError) as e:
            logger.warning(f"获取缓存失败: {key}, 错误: {e}")
            return None

    async def set(
        self,
        key: str,
        value: Union[BaseModel, Dict[str, Any], str, List[Any]],
        ttl: Optional[int] = None,
    ) -> bool:
        """
        设置缓存值

        Args:
            key: 缓存键
            value: 缓存值
            ttl: 过期时间（秒）

        Returns:
            bool: 是否成功
        """
        if not self._connected or not self._redis_client:
            return False

        try:
            if isinstance(value, BaseModel):
                serialized = value.model_dump_json()
            elif isinstance(value, (dict, list)):
                serialized = json.dumps(value, default=str)
            else:
                serialized = str(value)

            if ttl:
                await self._redis_client.setex(key, ttl, serialized)
            else:
                await self._redis_client.set(key, serialized)

            logger.debug(f"缓存设置成功: {key}, TTL: {ttl}")
            return True
        except redis.RedisError as e:
            logger.warning(f"设置缓存失败: {key}, 错误: {e}")
            return False

    async def delete(self, key: str) -> bool:
        """
        删除缓存

        Args:
            key: 缓存键

        Returns:
            bool: 是否成功
        """
        if not self._connected or not self._redis_client:
            return False

        try:
            await self._redis_client.delete(key)
            logger.debug(f"缓存删除成功: {key}")
            return True
        except redis.RedisError as e:
            logger.warning(f"删除缓存失败: {key}, 错误: {e}")
            return False

    async def delete_pattern(self, pattern: str) -> int:
        """
        删除匹配模式的缓存

        Args:
            pattern: 匹配模式（如 lineage_platform:lineage:*）

        Returns:
            int: 删除的键数量
        """
        if not self._connected or not self._redis_client:
            return 0

        try:
            keys = await self._redis_client.keys(pattern)
            if keys:
                deleted = await self._redis_client.delete(*keys)
                logger.debug(f"批量删除缓存成功: {pattern}, 数量: {deleted}")
                return deleted
            return 0
        except redis.RedisError as e:
            logger.warning(f"批量删除缓存失败: {pattern}, 错误: {e}")
            return 0

    async def get_or_set(
        self,
        key: str,
        fetch_func: Callable[[], T],
        model_class: type,
        ttl: Optional[int] = None,
    ) -> T:
        """
        获取缓存或设置缓存（缓存穿透保护）

        Args:
            key: 缓存键
            fetch_func: 数据获取函数
            model_class: Pydantic 模型类
            ttl: 过期时间

        Returns:
            模型实例
        """
        cached = await self.get(key, model_class)
        if cached is not None:
            logger.debug(f"缓存命中: {key}")
            return cached

        logger.debug(f"缓存未命中: {key}, 从数据源获取")
        result = await fetch_func()

        if result:
            await self.set(key, result, ttl)

        return result

    async def cache_lineage(
        self,
        table_id: str,
        depth: int,
        direction: str,
        lineage_graph: LineageGraph,
        ttl: Optional[int] = None,
    ) -> bool:
        """
        缓存血缘查询结果

        Args:
            table_id: 表 ID
            depth: 血缘深度
            direction: 方向
            lineage_graph: 血缘图数据
            ttl: 过期时间

        Returns:
            bool: 是否成功
        """
        key = self._generate_cache_key(
            "lineage",
            table_id,
            {"depth": depth, "direction": direction},
        )
        actual_ttl = ttl or DEFAULT_TTL_CONFIG["lineage"]
        return await self.set(key, lineage_graph, actual_ttl)

    async def get_cached_lineage(
        self,
        table_id: str,
        depth: int,
        direction: str,
    ) -> Optional[LineageGraph]:
        """
        获取缓存的血缘查询结果

        Args:
            table_id: 表 ID
            depth: 血缘深度
            direction: 方向

        Returns:
            LineageGraph 或 None
        """
        key = self._generate_cache_key(
            "lineage",
            table_id,
            {"depth": depth, "direction": direction},
        )
        return await self.get(key, LineageGraph)

    async def cache_search_result(
        self,
        search_type: str,
        params: Dict[str, Any],
        result: SearchResult,
        ttl: Optional[int] = None,
    ) -> bool:
        """
        缓存搜索结果

        Args:
            search_type: 搜索类型（tables, fields, all）
            params: 搜索参数
            result: 搜索结果
            ttl: 过期时间

        Returns:
            bool: 是否成功
        """
        key = self._generate_cache_key("search", search_type, params)
        actual_ttl = ttl or DEFAULT_TTL_CONFIG["search"]
        return await self.set(key, result, actual_ttl)

    async def get_cached_search_result(
        self,
        search_type: str,
        params: Dict[str, Any],
    ) -> Optional[SearchResult]:
        """
        获取缓存的搜索结果

        Args:
            search_type: 搜索类型
            params: 搜索参数

        Returns:
            SearchResult 或 None
        """
        key = self._generate_cache_key("search", search_type, params)
        return await self.get(key, SearchResult)

    async def cache_table_details(
        self,
        table_id: str,
        details: LineageNode,
        ttl: Optional[int] = None,
    ) -> bool:
        """
        缓存表详情

        Args:
            table_id: 表 ID
            details: 表详情
            ttl: 过期时间

        Returns:
            bool: 是否成功
        """
        key = self._generate_cache_key("table_details", table_id)
        actual_ttl = ttl or DEFAULT_TTL_CONFIG["table_details"]
        return await self.set(key, details, actual_ttl)

    async def get_cached_table_details(
        self,
        table_id: str,
    ) -> Optional[LineageNode]:
        """
        获取缓存的表详情

        Args:
            table_id: 表 ID

        Returns:
            LineageNode 或 None
        """
        key = self._generate_cache_key("table_details", table_id)
        return await self.get(key, LineageNode)

    async def cache_field_lineage(
        self,
        field_id: str,
        lineage_path: LineagePath,
        ttl: Optional[int] = None,
    ) -> bool:
        """
        缓存字段血缘

        Args:
            field_id: 字段 ID
            lineage_path: 血缘路径
            ttl: 过期时间

        Returns:
            bool: 是否成功
        """
        key = self._generate_cache_key("field_lineage", field_id)
        actual_ttl = ttl or DEFAULT_TTL_CONFIG["field_lineage"]
        return await self.set(key, lineage_path, actual_ttl)

    async def get_cached_field_lineage(
        self,
        field_id: str,
    ) -> Optional[LineagePath]:
        """
        获取缓存的字段血缘

        Args:
            field_id: 字段 ID

        Returns:
            LineagePath 或 None
        """
        key = self._generate_cache_key("field_lineage", field_id)
        return await self.get(key, LineagePath)

    async def cache_impact_analysis(
        self,
        table_id: str,
        depth: int,
        impact_graph: LineageGraph,
        ttl: Optional[int] = None,
    ) -> bool:
        """
        缓存影响分析结果

        Args:
            table_id: 表 ID
            depth: 影响深度
            impact_graph: 影响图
            ttl: 过期时间

        Returns:
            bool: 是否成功
        """
        key = self._generate_cache_key(
            "impact_analysis",
            table_id,
            {"depth": depth},
        )
        actual_ttl = ttl or DEFAULT_TTL_CONFIG["impact_analysis"]
        return await self.set(key, impact_graph, actual_ttl)

    async def get_cached_impact_analysis(
        self,
        table_id: str,
        depth: int,
    ) -> Optional[LineageGraph]:
        """
        获取缓存的影响分析结果

        Args:
            table_id: 表 ID
            depth: 影响深度

        Returns:
            LineageGraph 或 None
        """
        key = self._generate_cache_key(
            "impact_analysis",
            table_id,
            {"depth": depth},
        )
        return await self.get(key, LineageGraph)

    async def invalidate_table_cache(self, table_id: str) -> int:
        """
        清除表相关的所有缓存

        Args:
            table_id: 表 ID

        Returns:
            int: 清除的缓存数量
        """
        patterns = [
            f"{CACHE_KEY_PREFIX}:lineage:{table_id}:*",
            f"{CACHE_KEY_PREFIX}:table_details:{table_id}",
            f"{CACHE_KEY_PREFIX}:impact_analysis:{table_id}:*",
        ]

        total_deleted = 0
        for pattern in patterns:
            deleted = await self.delete_pattern(pattern)
            total_deleted += deleted

        logger.info(f"清除表缓存: {table_id}, 数量: {total_deleted}")
        return total_deleted

    async def invalidate_all_lineage_cache(self) -> int:
        """
        清除所有血缘缓存

        Returns:
            int: 清除的缓存数量
        """
        pattern = f"{CACHE_KEY_PREFIX}:lineage:*"
        deleted = await self.delete_pattern(pattern)
        logger.info(f"清除所有血缘缓存, 数量: {deleted}")
        return deleted

    async def invalidate_all_search_cache(self) -> int:
        """
        清除所有搜索缓存

        Returns:
            int: 清除的缓存数量
        """
        pattern = f"{CACHE_KEY_PREFIX}:search:*"
        deleted = await self.delete_pattern(pattern)
        logger.info(f"清除所有搜索缓存, 数量: {deleted}")
        return deleted

    async def warmup_lineage_cache(
        self,
        table_ids: List[str],
        lineage_service: Any,
        depths: List[int] = [3, 5],
        directions: List[str] = ["upstream", "downstream", "both"],
    ) -> Dict[str, int]:
        """
        缓存预热 - 预加载血缘数据

        Args:
            table_ids: 表 ID 列表
            lineage_service: 血缘服务实例
            depths: 预热的深度列表
            directions: 预热的方向列表

        Returns:
            Dict[str, int]: 预热统计
        """
        stats = {
            "total": 0,
            "success": 0,
            "failed": 0,
            "cached": 0,
        }

        for table_id in table_ids:
            for depth in depths:
                for direction in directions:
                    stats["total"] += 1

                    cached = await self.get_cached_lineage(table_id, depth, direction)
                    if cached:
                        stats["cached"] += 1
                        continue

                    try:
                        graph = await lineage_service.get_table_lineage_with_expand(
                            table_id=table_id,
                            depth=depth,
                            direction=direction,
                        )

                        if graph and graph.nodes:
                            await self.cache_lineage(table_id, depth, direction, graph)
                            stats["success"] += 1
                        else:
                            stats["failed"] += 1
                    except Exception as e:
                        logger.warning(f"预热失败: {table_id}, 错误: {e}")
                        stats["failed"] += 1

        logger.info(f"缓存预热完成: {stats}")
        return stats

    async def warmup_search_cache(
        self,
        search_service: Any,
        popular_keywords: List[str] = [],
        data_source_ids: List[str] = [],
    ) -> Dict[str, int]:
        """
        缓存预热 - 预加载搜索结果

        Args:
            search_service: 搜索服务实例
            popular_keywords: 热门关键词列表
            data_source_ids: 数据源 ID 列表

        Returns:
            Dict[str, int]: 预热统计
        """
        stats = {
            "total": 0,
            "success": 0,
            "failed": 0,
        }

        for keyword in popular_keywords:
            stats["total"] += 1
            try:
                result = await search_service.search_all(
                    keyword=keyword,
                    page=1,
                    page_size=20,
                )
                params = {"keyword": keyword, "page": 1, "page_size": 20}
                await self.cache_search_result("all", params, result)
                stats["success"] += 1
            except Exception as e:
                logger.warning(f"搜索预热失败: {keyword}, 错误: {e}")
                stats["failed"] += 1

        for data_source_id in data_source_ids:
            stats["total"] += 1
            try:
                result = await search_service.search_tables(
                    data_source_id=data_source_id,
                    page=1,
                    page_size=50,
                )
                params = {"data_source_id": data_source_id, "page": 1, "page_size": 50}
                await self.cache_search_result("tables", params, result)
                stats["success"] += 1
            except Exception as e:
                logger.warning(f"数据源搜索预热失败: {data_source_id}, 错误: {e}")
                stats["failed"] += 1

        logger.info(f"搜索缓存预热完成: {stats}")
        return stats

    async def get_cache_stats(self) -> Dict[str, Any]:
        """
        获取缓存统计信息

        Returns:
            Dict[str, Any]: 缓存统计
        """
        if not self._connected or not self._redis_client:
            return {
                "connected": False,
                "message": "Redis 未连接",
            }

        try:
            info = await self._redis_client.info("memory")
            keys_count = await self._redis_client.dbsize()

            lineage_keys = await self._redis_client.keys(f"{CACHE_KEY_PREFIX}:lineage:*")
            search_keys = await self._redis_client.keys(f"{CACHE_KEY_PREFIX}:search:*")
            details_keys = await self._redis_client.keys(f"{CACHE_KEY_PREFIX}:table_details:*")

            return {
                "connected": True,
                "total_keys": keys_count,
                "used_memory": info.get("used_memory_human", "N/A"),
                "used_memory_peak": info.get("used_memory_peak_human", "N/A"),
                "lineage_cache_count": len(lineage_keys),
                "search_cache_count": len(search_keys),
                "details_cache_count": len(details_keys),
                "timestamp": datetime.now().isoformat(),
            }
        except redis.RedisError as e:
            logger.warning(f"获取缓存统计失败: {e}")
            return {
                "connected": True,
                "error": str(e),
            }


cache_service = CacheService()


async def get_cache_service() -> CacheService:
    """
    获取缓存服务实例（依赖注入）
    """
    if not cache_service._connected:
        await cache_service.connect()
    return cache_service