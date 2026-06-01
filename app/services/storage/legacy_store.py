"""
Legacy (pickle/json 双写) 存储后端

从原有 CacheStore 逻辑抽取，保持与旧缓存机制的完全兼容。
"""

from __future__ import annotations

import json
import logging
import pickle
import time
from pathlib import Path
from typing import Any

from app.services.storage.protocol import CACHE_SCHEMA_VERSION

logger = logging.getLogger(__name__)


class LegacyJsonPickleStore:
    """基于 pickle/json 双写的存储后端（兼容模式）。"""

    def __init__(self, output_dir: Path):
        self._output_dir = Path(output_dir)
        self._cache_file = self._output_dir / "lineage_data.pkl"
        self._json_file = self._output_dir / "lineage_data.json"

    def load(self) -> dict[str, Any] | None:
        """从 pickle 或 JSON 加载缓存数据。"""
        # 优先读取 pickle
        if self._cache_file.exists():
            try:
                with open(self._cache_file, "rb") as f:
                    data = pickle.load(f)
                metadata = data.get("metadata", {})
                version = metadata.get("cache_schema_version", "")
                if version and version != CACHE_SCHEMA_VERSION:
                    logger.warning(
                        "缓存版本不匹配(%s != %s)，强制重新解析",
                        version,
                        CACHE_SCHEMA_VERSION,
                    )
                    self._cache_file.unlink(missing_ok=True)
                    return None
                if not metadata or not metadata.get("total_tables"):
                    logger.info("缓存数据为空或格式不兼容，将重新解析")
                    return None
                logger.info(
                    "成功加载 pickle 缓存: %s 个表, %s 个过程",
                    metadata.get("total_tables", 0),
                    metadata.get("total_procedures", 0),
                )
                return data
            except Exception as e:
                logger.error("加载 pickle 缓存失败: %s", e)
                self._cache_file.unlink(missing_ok=True)

        # fallback 读取 JSON
        if self._json_file.exists():
            try:
                with open(self._json_file, encoding="utf-8") as f:
                    data = json.load(f)
                metadata = data.get("metadata", {})
                version = metadata.get("cache_schema_version", "")
                if version and version != CACHE_SCHEMA_VERSION:
                    logger.warning("JSON 缓存版本不匹配，强制重新解析")
                    return None
                if not metadata or not metadata.get("total_tables"):
                    return None
                logger.info("从 JSON 文件加载缓存: %s", self._json_file)
                return data
            except Exception as e:
                logger.error("读取 JSON 缓存失败: %s", e)

        return None

    def save(self, result_data: dict[str, Any]) -> None:
        """保存数据到 pickle 和 JSON。"""
        data = {
            **result_data,
            "metadata": {
                **result_data.get("metadata", {}),
                "cache_schema_version": CACHE_SCHEMA_VERSION,
                "last_updated": time.strftime("%Y-%m-%d %H:%M:%S"),
            },
        }
        self._save_pickle(data)
        self._save_json(data)

    def clear(self) -> None:
        """删除 pickle 和 JSON 缓存文件。"""
        self._cache_file.unlink(missing_ok=True)
        self._json_file.unlink(missing_ok=True)
        logger.info("Legacy 缓存已清除")

    def export_json(self, path: Path) -> None:
        """导出数据到指定 JSON 路径。"""
        data = self.load()
        if data is None:
            logger.warning("无缓存数据可导出")
            return
        path.parent.mkdir(parents=True, exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        logger.info("JSON 导出完成: %s", path)

    @property
    def json_file(self) -> Path:
        return self._json_file

    @property
    def cache_file(self) -> Path:
        return self._cache_file

    def _save_pickle(self, data: dict[str, Any]) -> None:
        try:
            tmp_path = self._cache_file.with_suffix(".tmp")
            with open(tmp_path, "wb") as f:
                pickle.dump(data, f, protocol=pickle.HIGHEST_PROTOCOL)
            tmp_path.replace(self._cache_file)
            logger.info(
                "Pickle 已保存: %s (%.2f KB)",
                self._cache_file,
                self._cache_file.stat().st_size / 1024,
            )
        except Exception as e:
            logger.error("保存 Pickle 失败: %s", e)

    def _save_json(self, data: dict[str, Any]) -> None:
        try:
            with open(self._json_file, "w", encoding="utf-8") as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            logger.info("JSON 缓存已保存: %s", self._json_file)
        except Exception as e:
            logger.error("保存 JSON 失败: %s", e)
