"""
应用配置管理
集中管理所有配置项，支持环境变量覆盖和 manifest.yml 自动发现
"""

from __future__ import annotations

import contextlib
import logging
import os
from dataclasses import dataclass, field
from pathlib import Path

from app.utils.path_utils import get_base_dir

logger = logging.getLogger(__name__)


@dataclass
class DataSourceConfig:
    """单个数据源的配置"""

    name: str
    display_name: str
    data_dir: str
    schema_dirs: list[str]
    file_extensions: list[str]
    parser: str = "warehouse"
    enabled: bool = True


@dataclass
class AppConfig:
    """应用全局配置"""

    app_title: str = "数据血缘分析系统"
    app_version: str = "2.0.0"
    debug: bool = False

    host: str = "0.0.0.0"
    port: int = 8899
    workers: int = 1

    base_dir: Path = field(default_factory=get_base_dir)
    data_dir: str = "SOURCE_DATA"
    output_dir: str = "output"
    upload_temp_dir: str = "temp_uploads"

    source_data_dir: str = "SOURCE_DATA"

    schema_dirs: list[str] = field(default_factory=list)

    datasource_configs: list[DataSourceConfig] = field(
        default_factory=lambda: [
            DataSourceConfig(
                name="rrp",
                display_name="监管报送平台",
                data_dir="SOURCE_DATA/RRP",
                schema_dirs=["rrp_mdl", "rrp_east"],
                file_extensions=[".tab", ".prc"],
                parser="oracle",
            ),
            DataSourceConfig(
                name="edw",
                display_name="企业级数据仓库",
                data_dir="SOURCE_DATA/EDW",
                schema_dirs=[],
                file_extensions=[".sql", ".ctl"],
                parser="warehouse",
            ),
            DataSourceConfig(
                name="mcs",
                display_name="管理驾驶舱",
                data_dir="SOURCE_DATA/MCS",
                schema_dirs=[],
                file_extensions=[".sql", ".conf"],
                parser="warehouse",
            ),
            DataSourceConfig(
                name="fdm",
                display_name="财务数据集市",
                data_dir="SOURCE_DATA/FDM",
                schema_dirs=[],
                file_extensions=[".xlsx", ".proc"],
                parser="indicator",
            ),
        ]
    )

    max_upload_size_mb: int = 100
    allowed_extensions: list[str] = field(default_factory=lambda: [".tab", ".prc", ".sql", ".ctl"])
    parse_batch_size: int = 50

    force_reparse: bool = False  # 启动时强制重新解析（跳过缓存）

    enable_cache: bool = True
    cache_ttl_seconds: int = 3600
    max_cache_size: int = 10000

    # SQLite 存储配置
    storage_backend: str = "sqlite"  # sqlite | legacy
    sqlite_db_path: str = "output/lineage.db"
    enable_legacy_cache_write: bool = False  # 是否同时写 pickle/json
    enable_json_export: bool = True  # 是否允许手动导出 JSON

    progress_interval_ms: int = 500
    progress_keepalive_sec: int = 300

    indicator_fallback_path: str = "财务集市指标血缘分析/指标"

    virtual_scroll_item_height: int = 50
    virtual_scroll_buffer: int = 10

    @property
    def data_path(self) -> Path:
        return self._resolve_path(self.data_dir)

    @property
    def output_path(self) -> Path:
        path = self._resolve_path(self.output_dir)
        path.mkdir(parents=True, exist_ok=True)
        return path

    @property
    def upload_temp_path(self) -> Path:
        path = self._resolve_path(self.upload_temp_dir)
        path.mkdir(parents=True, exist_ok=True)
        return path

    @property
    def source_data_path(self) -> Path:
        return self._resolve_path(self.source_data_dir)

    @property
    def sqlite_db_full_path(self) -> Path:
        return self._resolve_path(self.sqlite_db_path)

    def _resolve_path(self, value: str) -> Path:
        path = Path(value)
        if path.is_absolute():
            return path
        return self.base_dir / path

    @classmethod
    def from_env(cls) -> AppConfig:
        config = cls()

        if os.getenv("DEBUG", "").lower() in ("1", "true", "yes"):
            config.debug = True

        if port := os.getenv("PORT"):
            with contextlib.suppress(ValueError):
                config.port = int(port)

        if data_dir := os.getenv("DATA_DIR"):
            config.data_dir = data_dir

        if output_dir := os.getenv("OUTPUT_DIR"):
            config.output_dir = output_dir

        if upload_temp_dir := os.getenv("UPLOAD_TEMP_DIR"):
            config.upload_temp_dir = upload_temp_dir

        if source_data_dir := os.getenv("SOURCE_DATA_DIR"):
            config.source_data_dir = source_data_dir

        # SQLite 存储配置
        if (storage_backend := os.getenv("STORAGE_BACKEND")) and storage_backend in ("sqlite", "legacy"):
            config.storage_backend = storage_backend

        if sqlite_db_path := os.getenv("SQLITE_DB_PATH"):
            config.sqlite_db_path = sqlite_db_path

        if os.getenv("ENABLE_LEGACY_CACHE_WRITE", "").lower() in ("1", "true", "yes"):
            config.enable_legacy_cache_write = True

        if os.getenv("ENABLE_JSON_EXPORT", "").lower() in ("0", "false", "no"):
            config.enable_json_export = False

        if os.getenv("FORCE_REPARSE", "").lower() in ("1", "true", "yes"):
            config.force_reparse = True

        if indicator_fallback_path := os.getenv("INDICATOR_FALLBACK_PATH"):
            config.indicator_fallback_path = indicator_fallback_path

        manifest_configs = _load_datasource_configs_from_manifest(config.source_data_path)
        if manifest_configs:
            config.datasource_configs = manifest_configs
            logger.info(
                "Loaded %d datasource configs from SOURCE_DATA/manifest.yml",
                len(manifest_configs),
            )

        tdh_dir = os.getenv("TDH_DATA_DIR")
        if tdh_dir:
            tdh_schemas = os.getenv("TDH_SCHEMA_DIRS", "dw,ods").split(",")
            config.datasource_configs.append(
                DataSourceConfig(
                    name="tdh",
                    display_name="TDH星环",
                    data_dir=tdh_dir,
                    schema_dirs=[s.strip() for s in tdh_schemas],
                    file_extensions=[".hql", ".sql"],
                    parser="warehouse",
                )
            )

        gbase_dir = os.getenv("GBASE_DATA_DIR")
        if gbase_dir:
            gbase_schemas = os.getenv("GBASE_SCHEMA_DIRS", "dws,ads").split(",")
            config.datasource_configs.append(
                DataSourceConfig(
                    name="gbase",
                    display_name="GBase南大通用",
                    data_dir=gbase_dir,
                    schema_dirs=[s.strip() for s in gbase_schemas],
                    file_extensions=[".sql"],
                    parser="warehouse",
                )
            )

        return config


def _load_datasource_configs_from_manifest(
    source_data_dir: Path,
) -> list[DataSourceConfig]:
    try:
        import yaml
    except ImportError:
        logger.warning("PyYAML not installed, skipping manifest loading")
        return []

    manifest_path = source_data_dir / "manifest.yml"
    if not manifest_path.exists():
        logger.info("No SOURCE_DATA/manifest.yml found, using default configs")
        return []

    try:
        data = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
    except Exception as e:
        logger.error("Failed to load manifest.yml: %s", e)
        return []

    if not data or "sources" not in data:
        return []

    configs: list[DataSourceConfig] = []
    for src in data["sources"]:
        try:
            name = src.get("name")
            path = src.get("path")
            if not name or not path:
                logger.warning("Skipping manifest entry with missing 'name' or 'path': %s", src)
                continue

            system_dir = source_data_dir / path
            system_manifest = _load_system_manifest(system_dir)
            schema_dirs = _discover_schema_dirs(system_dir)
            enabled = src.get("enabled", True)
            parser = system_manifest.get("parser") or src.get("parser", "warehouse")
            file_extensions = _resolve_file_extensions(
                root_extensions=src.get("file_extensions", []),
                system_extensions=system_manifest.get("file_extensions"),
            )

            env_override = src.get("env_override", {})
            if env_override and env_override.get("enabled"):
                env_var = env_override["enabled"]
                if not os.getenv(env_var):
                    enabled = False

            configs.append(
                DataSourceConfig(
                    name=name,
                    display_name=src.get("display_name", name),
                    data_dir=str(system_dir),
                    schema_dirs=schema_dirs,
                    file_extensions=file_extensions,
                    parser=parser,
                    enabled=enabled,
                )
            )
        except Exception as e:
            logger.warning("Skipping invalid manifest entry: %s (%s)", src, e)
            continue

    return configs


def _load_system_manifest(system_dir: Path) -> dict:
    try:
        import yaml
    except ImportError:
        return {}

    manifest_path = system_dir / "manifest.yml"
    if not manifest_path.exists():
        return {}

    try:
        data = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
    except Exception:
        return {}

    return data if isinstance(data, dict) else {}


def _resolve_file_extensions(
    root_extensions: list[str],
    system_extensions,
) -> list[str]:
    if not isinstance(system_extensions, dict):
        return root_extensions

    extensions: list[str] = []
    for values in system_extensions.values():
        if not isinstance(values, list):
            continue
        for ext in values:
            if isinstance(ext, str) and ext not in extensions:
                extensions.append(ext)

    return extensions or root_extensions


def _discover_schema_dirs(system_dir: Path) -> list[str]:
    if not system_dir.is_dir():
        return []

    try:
        import yaml
    except ImportError:
        return _discover_schema_dirs_by_structure(system_dir)

    manifest_path = system_dir / "manifest.yml"
    if manifest_path.exists():
        try:
            data = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
            if data and "schemas" in data:
                return [s["name"] for s in data["schemas"] if "name" in s]
        except Exception:
            pass

    return _discover_schema_dirs_by_structure(system_dir)


def _discover_schema_dirs_by_structure(system_dir: Path) -> list[str]:
    schemas: list[str] = []
    for subdir in ["ddl", "dml", "config"]:
        sub_path = system_dir / subdir
        if sub_path.is_dir():
            for child in sorted(sub_path.iterdir()):
                if child.is_dir() and child.name not in schemas:
                    schemas.append(child.name)
    return schemas


config = AppConfig.from_env()
