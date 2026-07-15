"""
内存缓存管理器
支持 TTL 过期和 LRU 淘汰
"""

from __future__ import annotations

import threading
import time
from collections import OrderedDict
from typing import Any


class CacheManager:
    """线程安全的内存缓存管理器"""

    def __init__(self, max_size: int = 10000, ttl: int = 3600):
        self.max_size = max_size
        self.ttl = ttl
        self._cache: OrderedDict[str, dict[str, Any]] = OrderedDict()
        self._lock = threading.Lock()

    def get(self, key: str) -> Any | None:
        """获取缓存值，过期则删除"""
        with self._lock:
            if key not in self._cache:
                return None

            entry = self._cache[key]
            if time.time() - entry["timestamp"] > self.ttl:
                del self._cache[key]
                return None

            self._cache.move_to_end(key)
            return entry["data"]

    def set(self, key: str, value: Any, tags: list[str] | None = None) -> None:
        """设置缓存值，超出容量时淘汰最旧条目"""
        with self._lock:
            if key in self._cache:
                del self._cache[key]

            while len(self._cache) >= self.max_size:
                self._cache.popitem(last=False)

            entry = {
                "data": value,
                "timestamp": time.time(),
                "tags": tags or [],
            }
            self._cache[key] = entry

    def delete(self, key: str) -> bool:
        """删除指定键"""
        with self._lock:
            if key not in self._cache:
                return False
            self._cache.pop(key)
            return True

    def clear(self) -> None:
        """清空所有缓存"""
        with self._lock:
            self._cache.clear()

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
            }
