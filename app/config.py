"""
应用配置管理
集中管理所有配置项，支持环境变量覆盖和 manifest.yml 自动发现
"""

from __future__ import annotations

import logging
import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

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

    datasource_configs: list[DataSourceConfig] = field(default_factory=lambda: [
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
    ])

    max_upload_size_mb: int = 100
    allowed_extensions: list[str] = field(default_factory=lambda: [".tab", ".prc", ".sql", ".ctl"])
    parse_batch_size: int = 50

    enable_cache: bool = True
    cache_ttl_seconds: int = 3600
    max_cache_size: int = 10000

    progress_interval_ms: int = 500
    progress_keepalive_sec: int = 300

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

    def _resolve_path(self, value: str) -> Path:
        path = Path(value)
        if path.is_absolute():
            return path
        return self.base_dir / path

    @classmethod
    def from_env(cls) -> "AppConfig":
        config = cls()

        if os.getenv("DEBUG", "").lower() in ("1", "true", "yes"):
            config.debug = True

        if port := os.getenv("PORT"):
            try:
                config.port = int(port)
            except ValueError:
                pass

        if data_dir := os.getenv("DATA_DIR"):
            config.data_dir = data_dir

        if output_dir := os.getenv("OUTPUT_DIR"):
            config.output_dir = output_dir

        if upload_temp_dir := os.getenv("UPLOAD_TEMP_DIR"):
            config.upload_temp_dir = upload_temp_dir

        if source_data_dir := os.getenv("SOURCE_DATA_DIR"):
            config.source_data_dir = source_data_dir

        manifest_configs = _load_datasource_configs_from_manifest(config.source_data_path)
        if manifest_configs:
            config.datasource_configs = manifest_configs
            logger.info("Loaded %d datasource configs from SOURCE_DATA/manifest.yml", len(manifest_configs))

        tdh_dir = os.getenv("TDH_DATA_DIR")
        if tdh_dir:
            tdh_schemas = os.getenv("TDH_SCHEMA_DIRS", "dw,ods").split(",")
            config.datasource_configs.append(DataSourceConfig(
                name="tdh",
                display_name="TDH星环",
                data_dir=tdh_dir,
                schema_dirs=[s.strip() for s in tdh_schemas],
                file_extensions=[".hql", ".sql"],
                parser="warehouse",
            ))

        gbase_dir = os.getenv("GBASE_DATA_DIR")
        if gbase_dir:
            gbase_schemas = os.getenv("GBASE_SCHEMA_DIRS", "dws,ads").split(",")
            config.datasource_configs.append(DataSourceConfig(
                name="gbase",
                display_name="GBase南大通用",
                data_dir=gbase_dir,
                schema_dirs=[s.strip() for s in gbase_schemas],
                file_extensions=[".sql"],
                parser="warehouse",
            ))

        return config


def _load_datasource_configs_from_manifest(source_data_dir: Path) -> list[DataSourceConfig]:
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
        system_dir = source_data_dir / src["path"]
        schema_dirs = _discover_schema_dirs(system_dir)
        enabled = src.get("enabled", True)

        env_override = src.get("env_override", {})
        if env_override and env_override.get("enabled"):
            env_var = env_override["enabled"]
            if not os.getenv(env_var):
                enabled = False

        configs.append(DataSourceConfig(
            name=src["name"],
            display_name=src.get("display_name", src["name"]),
            data_dir=str(system_dir),
            schema_dirs=schema_dirs,
            file_extensions=src.get("file_extensions", []),
            parser=src.get("parser", "warehouse"),
            enabled=enabled,
        ))

    return configs


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
