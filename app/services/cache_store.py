from __future__ import annotations

import json
import logging
import pickle
import time
from pathlib import Path
from typing import Any, Optional

logger = logging.getLogger(__name__)

CACHE_SCHEMA_VERSION = "v4"


class CacheStore:

    def __init__(self, output_dir: Path, config=None):
        self.output_dir = Path(output_dir)
        self.config = config
        self.cache_file = self.output_dir / "lineage_data.pkl"
        self.json_file = self.output_dir / "lineage_data.json"
        self._repository = None

    def load_from_cache(self) -> Optional[dict[str, Any]]:
        if self.cache_file.exists():
            try:
                with open(self.cache_file, "rb") as f:
                    data = pickle.load(f)
                metadata = data.get("metadata", {})
                version = metadata.get("cache_schema_version", "")
                if version and version != CACHE_SCHEMA_VERSION:
                    logger.warning("缓存版本不匹配(%s != %s)，强制重新解析", version, CACHE_SCHEMA_VERSION)
                    self.cache_file.unlink(missing_ok=True)
                    return None
                if not metadata or not metadata.get("total_tables"):
                    logger.info("缓存数据为空或格式不兼容，将重新解析")
                    return None
                logger.info("成功加载缓存数据: %s 个表, %s 个过程",
                           metadata.get("total_tables", 0), metadata.get("total_procedures", 0))
                logger.info("缓存数据来源: %s", ", ".join(metadata.get("data_sources", ["未知"])))
                logger.info("最后更新时间: %s", metadata.get("last_updated", "未知"))
                logger.info("解析器版本: %s", metadata.get("parser_version", "未知"))
                self._update_repository(data)
                return data
            except Exception as e:
                logger.error("加载缓存失败: %s", e)
                self.cache_file.unlink(missing_ok=True)
        else:
            logger.debug("缓存文件不存在: %s", self.cache_file)
        if self.json_file.exists():
            try:
                with open(self.json_file, "r", encoding="utf-8") as f:
                    data = json.load(f)
                metadata = data.get("metadata", {})
                version = metadata.get("cache_schema_version", "")
                if version and version != CACHE_SCHEMA_VERSION:
                    logger.warning("JSON 缓存版本不匹配，强制重新解析")
                    return None
                if not metadata or not metadata.get("total_tables"):
                    return None
                logger.info("从 JSON 文件加载缓存: %s", self.json_file)
                self._update_repository(data)
                return data
            except Exception as e:
                logger.error("读取 JSON 缓存失败: %s", e)
        return None

    def save_to_cache(self, result_data: dict[str, Any]) -> None:
        try:
            data = {
                **result_data,
                "metadata": {
                    **result_data.get("metadata", {}),
                    "cache_schema_version": CACHE_SCHEMA_VERSION,
                    "last_updated": time.strftime("%Y-%m-%d %H:%M:%S"),
                },
            }
            self._save_pickle_cache(data)
            with open(self.json_file, "w", encoding="utf-8") as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            if self._repository:
                self._repository.update(data)
            logger.info("JSON 数据缓存已保存: %s", self.json_file)
        except Exception as e:
            logger.error("保存缓存数据失败: %s", e)

    def _save_pickle_cache(self, data: dict[str, Any]) -> None:
        try:
            import tempfile
            tmp_path = self.cache_file.with_suffix('.tmp')
            with open(tmp_path, "wb") as f:
                pickle.dump(data, f, protocol=pickle.HIGHEST_PROTOCOL)
            tmp_path.replace(self.cache_file)
            logger.info("Pickle 数据已保存到: %s (%.2f KB)", self.cache_file, self.cache_file.stat().st_size / 1024)
        except Exception as e:
            logger.error("保存 Pickle 失败: %s", e)

    def _update_repository(self, data: dict) -> None:
        if self._repository is None:
            from app.repository import DataRepository
            self._repository = DataRepository(self.json_file)
        self._repository.update(data)

    def get_json_file(self) -> Path:
        return self.json_file

    def get_repository(self):
        if self._repository is None:
            from app.repository import DataRepository
            self._repository = DataRepository(self.json_file)
        return self._repository

    def clear_cache(self) -> None:
        self.cache_file.unlink(missing_ok=True)
        self.json_file.unlink(missing_ok=True)
        self._repository = None
        logger.info("缓存已清除")
