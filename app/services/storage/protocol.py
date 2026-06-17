"""
存储后端协议定义

所有存储后端必须实现 ResultStoreProtocol 接口，
确保 CacheStore 可以透明切换底层实现。
"""

from __future__ import annotations

from pathlib import Path
from typing import Any, Protocol, runtime_checkable

CACHE_SCHEMA_VERSION = "v5"


@runtime_checkable
class ResultStoreProtocol(Protocol):
    """解析结果存储后端协议。"""

    def load(self) -> dict[str, Any] | None:
        """加载解析结果数据。

        Returns:
            解析结果字典，结构兼容 ParseResult.from_serializable()；
            如果缓存不存在或无效则返回 None。
        """
        ...

    def save(self, result_data: dict[str, Any]) -> None:
        """保存解析结果数据。

        Args:
            result_data: 解析结果字典，包含 metadata、tables、procedures 等键。
        """
        ...

    def clear(self) -> None:
        """清空存储的解析结果数据。"""
        ...

    def export_json(self, path: Path) -> None:
        """将存储数据导出为 JSON 文件。

        Args:
            path: JSON 文件输出路径。
        """
        ...
