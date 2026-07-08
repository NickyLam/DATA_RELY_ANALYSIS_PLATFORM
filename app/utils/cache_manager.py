"""
内存缓存管理器
支持 TTL 过期、LRU 淘汰、多级索引加速查询
"""

from __future__ import annotations

import logging
import threading
import time
from collections import OrderedDict
from typing import Any

logger = logging.getLogger(__name__)


class CacheManager:
    """线程安全的内存缓存管理器"""

    def __init__(self, max_size: int = 10000, ttl: int = 3600):
        self.max_size = max_size
        self.ttl = ttl
        self._cache: OrderedDict[str, dict[str, Any]] = OrderedDict()
        self._lock = threading.Lock()
        self._indexes: dict[str, dict[str, set]] = {
            "table_name": {},
            "field_name": {},
            "procedure_name": {},
        }

    def get(self, key: str) -> Any | None:
        """获取缓存值，过期则删除"""
        with self._lock:
            if key not in self._cache:
                return None

            entry = self._cache[key]
            if time.time() - entry["timestamp"] > self.ttl:
                del self._cache[key]
                self._remove_from_indexes(key, entry.get("data"))
                return None

            self._cache.move_to_end(key)
            return entry["data"]

    def set(self, key: str, value: Any, tags: list[str] | None = None) -> None:
        """设置缓存值，超出容量时淘汰最旧条目"""
        with self._lock:
            if key in self._cache:
                old_entry = self._cache[key]
                self._remove_from_indexes(key, old_entry.get("data"))
                del self._cache[key]

            while len(self._cache) >= self.max_size:
                oldest_key, oldest_val = self._cache.popitem(last=False)
                self._remove_from_indexes(oldest_key, oldest_val.get("data"))

            entry = {
                "data": value,
                "timestamp": time.time(),
                "tags": tags or [],
            }
            self._cache[key] = entry
            self._add_to_indexes(key, value)

    def delete(self, key: str) -> bool:
        """删除指定键"""
        with self._lock:
            if key not in self._cache:
                return False
            entry = self._cache.pop(key)
            self._remove_from_indexes(key, entry.get("data"))
            return True

    def clear(self) -> None:
        """清空所有缓存"""
        with self._lock:
            self._cache.clear()
            for index in self._indexes.values():
                index.clear()

    def build_index(self, tables: list[dict], procedures: list[dict]) -> None:
        """批量构建倒排索引（启动时调用）。

        D-02 修复：本方法现在自包含幂等——构建前先清空所有缓存和索引，
        避免外部未调用 clear() 时旧 table_name/procedure_name/field_name
        索引及 _cache 残留累积。
        """
        logger.info("开始构建内存索引...")
        start_time = time.time()

        with self._lock:
            # 先清空旧缓存与全部索引，保证幂等
            self._cache.clear()
            for index in self._indexes.values():
                index.clear()

            table_index: dict[str, set] = {}
            procedure_index: dict[str, set] = {}

            table_count = 0
            for table in tables:
                name = table.get("full_name", "").upper()
                if not name:
                    continue
                tokens = self._tokenize(name)
                for token in tokens:
                    table_index.setdefault(token, set()).add(name)
                table_count += 1

            proc_count = 0
            for proc in procedures:
                name = proc.get("full_name", "").upper()
                if not name:
                    continue
                tokens = self._tokenize(name)
                for token in tokens:
                    procedure_index.setdefault(token, set()).add(name)
                proc_count += 1

            self._indexes["table_name"] = table_index
            self._indexes["procedure_name"] = procedure_index

        elapsed = time.time() - start_time
        total_keys = sum(len(idx) for idx in self._indexes.values())
        logger.info(
            "索引构建完成: %d 张表, %d 个过程, %d 个索引键, 耗时 %.2fs",
            table_count,
            proc_count,
            total_keys,
            elapsed,
        )

    def search_by_keyword(self, keyword: str, index_type: str = "table_name", limit: int = 20) -> list[str]:
        """通过关键词搜索（使用倒排索引）"""
        keyword = keyword.upper().strip()
        if not keyword:
            return []

        with self._lock:
            tokens = self._tokenize(keyword)
            idx = self._indexes.get(index_type, {})

            result_sets = []
            for token in tokens:
                if token in idx:
                    result_sets.append(idx[token])

            if not result_sets:
                return []

            results = set.intersection(*result_sets) if len(result_sets) > 1 else result_sets[0]
            return list(results)[:limit]

    @property
    def size(self) -> int:
        with self._lock:
            return len(self._cache)

    @property
    def stats(self) -> dict:
        with self._lock:
            return {
                "size": len(self._cache),
                "max_size": self.max_size,
                "ttl": self.ttl,
                "index_sizes": {k: len(v) for k, v in self._indexes.items()},
            }

    def _tokenize(self, text: str) -> list[str]:
        """将文本拆分为搜索词元（按 _ 分割后生成前缀组合）"""
        text = text.upper()
        tokens = {text}

        parts = text.replace("_", " ").split()
        for i in range(len(parts)):
            for j in range(i + 1, len(parts) + 1):
                tokens.add("_".join(parts[i:j]))

        tokens.update(parts)

        if "." in text:
            schema_part = text.split(".")[0]
            tokens.add(schema_part)

        return list(tokens)

    def _add_to_indexes(self, key: str, data: Any) -> None:
        """将数据添加到倒排索引"""
        if isinstance(data, dict):
            full_name = data.get("full_name", "")
            if full_name:
                tokens = self._tokenize(full_name.upper())
                for token in tokens:
                    self._indexes["table_name"].setdefault(token, set()).add(key)

    def _remove_from_indexes(self, key: str, data: Any) -> None:
        """从倒排索引中移除数据"""
        if isinstance(data, dict):
            full_name = data.get("full_name", "")
            if full_name:
                tokens = self._tokenize(full_name.upper())
                for token in tokens:
                    if token in self._indexes["table_name"]:
                        self._indexes["table_name"][token].discard(key)
