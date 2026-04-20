"""
性能监控服务
提供查询性能监控、慢查询日志、性能报告生成等功能
"""
import json
import logging
import time
from collections import defaultdict
from contextlib import asynccontextmanager
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from enum import Enum
from typing import Any, Dict, List, Optional, Union

import redis.asyncio as redis

from app.core.config import settings

logger = logging.getLogger(__name__)

PERF_MONITOR_KEY_PREFIX = "perf_monitor"
SLOW_QUERY_THRESHOLD_MS = 1000
MAX_SLOW_QUERY_LOG_SIZE = 1000


class QueryType(str, Enum):
    """
    查询类型
    """
    LINEAGE = "lineage"
    SEARCH = "search"
    TABLE_DETAILS = "table_details"
    FIELD_LINEAGE = "field_lineage"
    IMPACT_ANALYSIS = "impact_analysis"
    FILTER_OPTIONS = "filter_options"


@dataclass
class QueryMetric:
    """
    查询指标
    """
    query_type: QueryType
    query_id: str
    params: Dict[str, Any]
    duration_ms: float
    timestamp: datetime
    is_slow: bool
    cache_hit: bool = False
    error: Optional[str] = None
    result_size: Optional[int] = None


@dataclass
class SlowQueryLog:
    """
    慢查询日志
    """
    query_type: QueryType
    query_id: str
    params: Dict[str, Any]
    duration_ms: float
    timestamp: datetime
    threshold_ms: float
    error: Optional[str] = None


@dataclass
class PerformanceStats:
    """
    性能统计
    """
    query_type: QueryType
    total_queries: int = 0
    total_duration_ms: float = 0.0
    avg_duration_ms: float = 0.0
    max_duration_ms: float = 0.0
    min_duration_ms: float = 0.0
    slow_query_count: int = 0
    cache_hit_count: int = 0
    cache_hit_rate: float = 0.0
    error_count: int = 0
    error_rate: float = 0.0
    p50_duration_ms: float = 0.0
    p90_duration_ms: float = 0.0
    p99_duration_ms: float = 0.0


@dataclass
class PerformanceReport:
    """
    性能报告
    """
    report_time: datetime
    time_range: timedelta
    stats_by_type: Dict[QueryType, PerformanceStats]
    slow_queries: List[SlowQueryLog]
    total_queries: int
    total_slow_queries: int
    overall_avg_duration_ms: float
    overall_cache_hit_rate: float
    overall_error_rate: float
    recommendations: List[str] = field(default_factory=list)


class PerformanceMonitor:
    """
    性能监控服务
    """

    def __init__(
        self,
        redis_client: Optional[redis.Redis] = None,
        slow_query_threshold_ms: float = SLOW_QUERY_THRESHOLD_MS,
    ):
        self._redis_client = redis_client
        self._connected = False
        self._slow_query_threshold_ms = slow_query_threshold_ms
        self._metrics_buffer: List[QueryMetric] = []
        self._stats_cache: Dict[QueryType, PerformanceStats] = {}
        self._durations_by_type: Dict[QueryType, List[float]] = defaultdict(list)

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
            logger.info("性能监控服务连接成功")
        except redis.RedisError as e:
            logger.warning(f"Redis 连接失败，将使用本地存储模式: {e}")
            self._connected = False

    async def disconnect(self) -> None:
        """
        断开 Redis 连接
        """
        if self._redis_client:
            await self._redis_client.close()
            self._connected = False
            logger.info("性能监控服务断开连接")

    @asynccontextmanager
    async def monitor_query(
        self,
        query_type: QueryType,
        query_id: str,
        params: Dict[str, Any],
        cache_hit: bool = False,
    ):
        """
        查询性能监控上下文

        Args:
            query_type: 查询类型
            query_id: 查询标识
            params: 查询参数
            cache_hit: 是否缓存命中

        Yields:
            None
        """
        start_time = time.time()
        error = None
        result_size = None

        try:
            yield
        except Exception as e:
            error = str(e)
            raise
        finally:
            end_time = time.time()
            duration_ms = (end_time - start_time) * 1000

            metric = QueryMetric(
                query_type=query_type,
                query_id=query_id,
                params=params,
                duration_ms=duration_ms,
                timestamp=datetime.now(),
                is_slow=duration_ms >= self._slow_query_threshold_ms,
                cache_hit=cache_hit,
                error=error,
                result_size=result_size,
            )

            await self._record_metric(metric)

    async def _record_metric(self, metric: QueryMetric) -> None:
        """
        记录查询指标

        Args:
            metric: 查询指标
        """
        self._metrics_buffer.append(metric)
        self._durations_by_type[metric.query_type].append(metric.duration_ms)

        if len(self._metrics_buffer) > 1000:
            await self._flush_metrics()

        if metric.is_slow:
            await self._log_slow_query(metric)

        if metric.error:
            logger.warning(
                f"查询错误: {metric.query_type.value}, "
                f"ID: {metric.query_id}, "
                f"耗时: {metric.duration_ms:.2f}ms, "
                f"错误: {metric.error}"
            )

    async def _flush_metrics(self) -> None:
        """
        刷新指标到 Redis
        """
        if not self._metrics_buffer:
            return

        if self._connected and self._redis_client:
            try:
                metrics_data = [
                    {
                        "query_type": m.query_type.value,
                        "query_id": m.query_id,
                        "params": m.params,
                        "duration_ms": m.duration_ms,
                        "timestamp": m.timestamp.isoformat(),
                        "is_slow": m.is_slow,
                        "cache_hit": m.cache_hit,
                        "error": m.error,
                        "result_size": m.result_size,
                    }
                    for m in self._metrics_buffer
                ]

                key = f"{PERF_MONITOR_KEY_PREFIX}:metrics:{datetime.now().strftime('%Y%m%d%H%M%S')}"
                await self._redis_client.set(key, json.dumps(metrics_data))
                await self._redis_client.expire(key, 86400)

                self._metrics_buffer.clear()
            except redis.RedisError as e:
                logger.warning(f"刷新指标到 Redis 失败: {e}")

    async def _log_slow_query(self, metric: QueryMetric) -> None:
        """
        记录慢查询日志

        Args:
            metric: 查询指标
        """
        slow_query = SlowQueryLog(
            query_type=metric.query_type,
            query_id=metric.query_id,
            params=metric.params,
            duration_ms=metric.duration_ms,
            timestamp=metric.timestamp,
            threshold_ms=self._slow_query_threshold_ms,
            error=metric.error,
        )

        logger.warning(
            f"慢查询: {slow_query.query_type.value}, "
            f"ID: {slow_query.query_id}, "
            f"耗时: {slow_query.duration_ms:.2f}ms, "
            f"阈值: {slow_query.threshold_ms}ms, "
            f"参数: {json.dumps(slow_query.params, default=str)}"
        )

        if self._connected and self._redis_client:
            try:
                log_data = {
                    "query_type": slow_query.query_type.value,
                    "query_id": slow_query.query_id,
                    "params": slow_query.params,
                    "duration_ms": slow_query.duration_ms,
                    "timestamp": slow_query.timestamp.isoformat(),
                    "threshold_ms": slow_query.threshold_ms,
                    "error": slow_query.error,
                }

                key = f"{PERF_MONITOR_KEY_PREFIX}:slow_queries"
                await self._redis_client.lpush(key, json.dumps(log_data))
                await self._redis_client.ltrim(key, 0, MAX_SLOW_QUERY_LOG_SIZE - 1)
            except redis.RedisError as e:
                logger.warning(f"记录慢查询日志失败: {e}")

    async def get_slow_queries(
        self,
        query_type: Optional[QueryType] = None,
        limit: int = 100,
    ) -> List[SlowQueryLog]:
        """
        获取慢查询日志

        Args:
            query_type: 查询类型过滤
            limit: 返回数量限制

        Returns:
            List[SlowQueryLog]: 慢查询日志列表
        """
        slow_queries = []

        if self._connected and self._redis_client:
            try:
                key = f"{PERF_MONITOR_KEY_PREFIX}:slow_queries"
                raw_logs = await self._redis_client.lrange(key, 0, limit - 1)

                for raw_log in raw_logs:
                    log_data = json.loads(raw_log)
                    slow_query = SlowQueryLog(
                        query_type=QueryType(log_data["query_type"]),
                        query_id=log_data["query_id"],
                        params=log_data["params"],
                        duration_ms=log_data["duration_ms"],
                        timestamp=datetime.fromisoformat(log_data["timestamp"]),
                        threshold_ms=log_data["threshold_ms"],
                        error=log_data.get("error"),
                    )

                    if query_type is None or slow_query.query_type == query_type:
                        slow_queries.append(slow_query)
            except redis.RedisError as e:
                logger.warning(f"获取慢查询日志失败: {e}")

        return slow_queries

    def _calculate_percentile(self, values: List[float], percentile: float) -> float:
        """
        计算百分位数

        Args:
            values: 数值列表
            percentile: 百分位（如 50, 90, 99）

        Returns:
            float: 百分位数值
        """
        if not values:
            return 0.0

        sorted_values = sorted(values)
        index = int(len(sorted_values) * percentile / 100)
        index = min(index, len(sorted_values) - 1)
        return sorted_values[index]

    async def get_stats(
        self,
        query_type: QueryType,
        time_range: timedelta = timedelta(hours=1),
    ) -> PerformanceStats:
        """
        获取查询类型统计

        Args:
            query_type: 查询类型
            time_range: 时间范围

        Returns:
            PerformanceStats: 性能统计
        """
        durations = self._durations_by_type.get(query_type, [])

        if not durations:
            return PerformanceStats(query_type=query_type)

        total_queries = len(durations)
        total_duration = sum(durations)
        avg_duration = total_duration / total_queries
        max_duration = max(durations)
        min_duration = min(durations)

        slow_count = sum(1 for d in durations if d >= self._slow_query_threshold_ms)

        cache_hits = sum(
            1 for m in self._metrics_buffer
            if m.query_type == query_type and m.cache_hit
        )
        cache_hit_rate = cache_hits / total_queries if total_queries > 0 else 0.0

        errors = sum(
            1 for m in self._metrics_buffer
            if m.query_type == query_type and m.error
        )
        error_rate = errors / total_queries if total_queries > 0 else 0.0

        p50 = self._calculate_percentile(durations, 50)
        p90 = self._calculate_percentile(durations, 90)
        p99 = self._calculate_percentile(durations, 99)

        return PerformanceStats(
            query_type=query_type,
            total_queries=total_queries,
            total_duration_ms=total_duration,
            avg_duration_ms=avg_duration,
            max_duration_ms=max_duration,
            min_duration_ms=min_duration,
            slow_query_count=slow_count,
            cache_hit_count=cache_hits,
            cache_hit_rate=cache_hit_rate,
            error_count=errors,
            error_rate=error_rate,
            p50_duration_ms=p50,
            p90_duration_ms=p90,
            p99_duration_ms=p99,
        )

    async def get_all_stats(
        self,
        time_range: timedelta = timedelta(hours=1),
    ) -> Dict[QueryType, PerformanceStats]:
        """
        获取所有查询类型统计

        Args:
            time_range: 时间范围

        Returns:
            Dict[QueryType, PerformanceStats]: 各类型性能统计
        """
        stats = {}
        for query_type in QueryType:
            stats[query_type] = await self.get_stats(query_type, time_range)
        return stats

    async def generate_report(
        self,
        time_range: timedelta = timedelta(hours=1),
    ) -> PerformanceReport:
        """
        生成性能报告

        Args:
            time_range: 时间范围

        Returns:
            PerformanceReport: 性能报告
        """
        stats_by_type = await self.get_all_stats(time_range)
        slow_queries = await self.get_slow_queries(limit=50)

        total_queries = sum(s.total_queries for s in stats_by_type.values())
        total_slow_queries = sum(s.slow_query_count for s in stats_by_type.values())

        total_duration = sum(s.total_duration_ms for s in stats_by_type.values())
        overall_avg_duration = total_duration / total_queries if total_queries > 0 else 0.0

        total_cache_hits = sum(s.cache_hit_count for s in stats_by_type.values())
        overall_cache_hit_rate = total_cache_hits / total_queries if total_queries > 0 else 0.0

        total_errors = sum(s.error_count for s in stats_by_type.values())
        overall_error_rate = total_errors / total_queries if total_queries > 0 else 0.0

        recommendations = self._generate_recommendations(
            stats_by_type,
            slow_queries,
            overall_cache_hit_rate,
            overall_error_rate,
        )

        return PerformanceReport(
            report_time=datetime.now(),
            time_range=time_range,
            stats_by_type=stats_by_type,
            slow_queries=slow_queries,
            total_queries=total_queries,
            total_slow_queries=total_slow_queries,
            overall_avg_duration_ms=overall_avg_duration,
            overall_cache_hit_rate=overall_cache_hit_rate,
            overall_error_rate=overall_error_rate,
            recommendations=recommendations,
        )

    def _generate_recommendations(
        self,
        stats_by_type: Dict[QueryType, PerformanceStats],
        slow_queries: List[SlowQueryLog],
        cache_hit_rate: float,
        error_rate: float,
    ) -> List[str]:
        """
        生成优化建议

        Args:
            stats_by_type: 各类型统计
            slow_queries: 慢查询列表
            cache_hit_rate: 缓存命中率
            error_rate: 错误率

        Returns:
            List[str]: 优化建议列表
        """
        recommendations = []

        if cache_hit_rate < 0.3:
            recommendations.append(
                f"缓存命中率较低 ({cache_hit_rate:.1%})，建议增加缓存预热或延长缓存 TTL"
            )

        if error_rate > 0.05:
            recommendations.append(
                f"错误率较高 ({error_rate:.1%})，建议检查数据库连接和查询逻辑"
            )

        for query_type, stats in stats_by_type.items():
            if stats.avg_duration_ms > 500:
                recommendations.append(
                    f"{query_type.value} 查询平均耗时 {stats.avg_duration_ms:.0f}ms，"
                    f"建议优化查询语句或添加索引"
                )

            if stats.p99_duration_ms > 5000:
                recommendations.append(
                    f"{query_type.value} 查询 P99 耗时 {stats.p99_duration_ms:.0f}ms，"
                    f"存在极端慢查询，建议排查具体查询"
                )

        lineage_slow = [q for q in slow_queries if q.query_type == QueryType.LINEAGE]
        if len(lineage_slow) > 10:
            recommendations.append(
                f"血缘查询慢查询较多 ({len(lineage_slow)} 条)，"
                f"建议限制查询深度或优化 Neo4j 查询"
            )

        search_slow = [q for q in slow_queries if q.query_type == QueryType.SEARCH]
        if len(search_slow) > 10:
            recommendations.append(
                f"搜索查询慢查询较多 ({len(search_slow)} 条)，"
                f"建议优化搜索索引或减少返回字段"
            )

        if not recommendations:
            recommendations.append("系统性能良好，继续保持监控")

        return recommendations

    async def clear_stats(self) -> None:
        """
        清除统计数据
        """
        self._metrics_buffer.clear()
        self._durations_by_type.clear()
        self._stats_cache.clear()

        if self._connected and self._redis_client:
            try:
                keys = await self._redis_client.keys(f"{PERF_MONITOR_KEY_PREFIX}:*")
                if keys:
                    await self._redis_client.delete(*keys)
                logger.info("性能监控数据已清除")
            except redis.RedisError as e:
                logger.warning(f"清除性能监控数据失败: {e}")

    async def set_slow_query_threshold(self, threshold_ms: float) -> None:
        """
        设置慢查询阈值

        Args:
            threshold_ms: 阈值（毫秒）
        """
        self._slow_query_threshold_ms = threshold_ms
        logger.info(f"慢查询阈值已更新为 {threshold_ms}ms")


performance_monitor = PerformanceMonitor()


async def get_performance_monitor() -> PerformanceMonitor:
    """
    获取性能监控实例（依赖注入）
    """
    if not performance_monitor._connected:
        await performance_monitor.connect()
    return performance_monitor