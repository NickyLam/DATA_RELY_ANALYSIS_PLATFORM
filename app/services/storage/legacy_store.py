"""
Legacy (JSON) 存储后端

从原有 CacheStore 逻辑抽取，保持与旧缓存机制的兼容。
旧版 pickle 文件不再加载（安全风险），仅记录警告后跳过。
"""

from __future__ import annotations

import json
import logging
import time
from pathlib import Path
from typing import Any

from app.services.storage.protocol import CACHE_SCHEMA_VERSION

logger = logging.getLogger(__name__)

# pickle 文件魔数前缀，用于检测旧格式文件
_PICKLE_MAGIC_PREFIXES = (
    b"\x80",  # protocol >= 2
    b"(lp0",  # protocol 1 list
    b"(dp0",  # protocol 1 dict
    b"S'",     # protocol 1 string
    b"I",      # protocol 1 int
)


class LegacyJsonPickleStore:
    """基于 JSON 的存储后端（兼容模式）。

    不再使用 pickle 进行序列化/反序列化，以消除任意代码执行风险。
    遇到旧 pickle 文件时仅记录警告，不会加载。
    """

    def __init__(self, output_dir: Path):
        self._output_dir = Path(output_dir)
        self._cache_file = self._output_dir / "lineage_data.pkl"
        self._json_file = self._output_dir / "lineage_data.json"

    def load(self) -> dict[str, Any] | None:
        """从 JSON 加载缓存数据。旧 pickle 文件仅检测并警告，不加载。"""
        # 检测旧 pickle 文件并警告
        if self._cache_file.exists():
            self._warn_old_pickle()

        # 读取 JSON
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
        """保存数据到 JSON。"""
        data = {
            **result_data,
            "metadata": {
                **result_data.get("metadata", {}),
                "cache_schema_version": CACHE_SCHEMA_VERSION,
                "last_updated": time.strftime("%Y-%m-%d %H:%M:%S"),
            },
        }
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

    def _warn_old_pickle(self) -> None:
        """检测旧 pickle 文件并记录安全警告。"""
        try:
            header = self._cache_file.read_bytes()[:4]
            if any(header.startswith(prefix) for prefix in _PICKLE_MAGIC_PREFIXES):
                logger.warning(
                    "检测到旧版 pickle 缓存文件 %s，因安全风险不再加载。"
                    "请使用 JSON 缓存或重新解析数据。"
                    "如需迁移旧数据，请运行 scripts/migrate_cache_to_sqlite.py",
                    self._cache_file,
                )
        except OSError:
            pass

    def _save_json(self, data: dict[str, Any]) -> None:
        try:
            tmp_path = self._json_file.with_suffix(".tmp")
            with open(tmp_path, "w", encoding="utf-8") as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            tmp_path.replace(self._json_file)
            logger.info("JSON 缓存已保存: %s", self._json_file)
        except Exception as e:
            logger.error("保存 JSON 失败: %s", e)
