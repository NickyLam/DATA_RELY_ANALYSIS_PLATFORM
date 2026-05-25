from __future__ import annotations

import logging
import time
from pathlib import Path
from typing import Any, Optional

from app.services.storage.protocol import CACHE_SCHEMA_VERSION, ResultStoreProtocol

logger = logging.getLogger(__name__)


class CacheStore:
    """缓存存储 facade，根据配置委派到 SQLite 或 legacy 后端。"""

    def __init__(self, output_dir: Path, config=None):
        self.output_dir = Path(output_dir)
        self.config = config
        self._repository = None
        self._store: ResultStoreProtocol = self._create_store()

    def _create_store(self) -> ResultStoreProtocol:
        """根据配置创建存储后端。"""
        backend = "sqlite"
        if self.config:
            backend = getattr(self.config, "storage_backend", "sqlite")

        if backend == "sqlite":
            from app.services.storage.sqlite_store import SQLiteResultStore

            db_path = self.output_dir / "lineage.db"
            if self.config:
                config_db_path = getattr(self.config, "sqlite_db_path", "")
                if config_db_path:
                    db_path = Path(config_db_path)
                    if not db_path.is_absolute():
                        db_path = self.output_dir / config_db_path

            logger.info("使用 SQLite 存储后端: %s", db_path)
            return SQLiteResultStore(db_path)
        else:
            from app.services.storage.legacy_store import LegacyJsonPickleStore

            logger.info("使用 Legacy (pickle/json) 存储后端")
            return LegacyJsonPickleStore(self.output_dir)

    def load_from_cache(self) -> Optional[dict[str, Any]]:
        data = self._store.load()
        if data is None:
            return None

        metadata = data.get("metadata", {})
        version = metadata.get("cache_schema_version", "")
        if version and version != CACHE_SCHEMA_VERSION:
            logger.warning(
                "缓存版本不匹配(%s != %s)，强制重新解析",
                version, CACHE_SCHEMA_VERSION,
            )
            self._store.clear()
            return None

        if not metadata or not metadata.get("total_tables"):
            logger.info("缓存数据为空或格式不兼容，将重新解析")
            return None

        logger.info(
            "成功加载缓存数据: %s 个表, %s 个过程",
            metadata.get("total_tables", 0),
            metadata.get("total_procedures", 0),
        )
        logger.info(
            "缓存数据来源: %s",
            ", ".join(metadata.get("data_sources", ["未知"])),
        )
        logger.info("最后更新时间: %s", metadata.get("last_updated", "未知"))
        logger.info("解析器版本: %s", metadata.get("parser_version", "未知"))
        self._update_repository(data)
        return data

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
            self._store.save(data)

            # 如果启用了 legacy 双写，同时写 pickle/json
            if self.config and getattr(self.config, "enable_legacy_cache_write", False):
                from app.services.storage.legacy_store import LegacyJsonPickleStore

                legacy = LegacyJsonPickleStore(self.output_dir)
                legacy.save(data)

            if self._repository:
                self._repository.update(data)
        except Exception as e:
            logger.error("保存缓存数据失败: %s", e)

    def _update_repository(self, data: dict) -> None:
        if self._repository is None:
            from app.repository import DataRepository

            self._repository = DataRepository()
        self._repository.update(data)

    def get_json_file(self) -> Path:
        """返回 JSON 文件路径（兼容旧代码，仅 legacy 模式下有效）。"""
        return self.output_dir / "lineage_data.json"

    def get_repository(self):
        if self._repository is None:
            from app.repository import DataRepository

            self._repository = DataRepository()
        return self._repository

    def clear_cache(self) -> None:
        self._store.clear()
        self._repository = None
        logger.info("缓存已清除")

    def export_json(self, path: Path) -> None:
        """将存储数据导出为 JSON 文件。

        受 enable_json_export 配置控制。
        """
        if self.config and not getattr(self.config, "enable_json_export", True):
            logger.warning("JSON 导出已禁用 (enable_json_export=False)")
            return
        self._store.export_json(path)

    def get_store(self) -> ResultStoreProtocol:
        """获取底层存储后端实例。"""
        return self._store
