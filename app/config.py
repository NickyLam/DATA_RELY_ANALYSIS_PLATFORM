"""
应用配置管理
集中管理所有配置项，支持环境变量覆盖
"""

from __future__ import annotations

import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

from app.utils.path_utils import get_base_dir


@dataclass
class DataSourceConfig:
    """单个数据源的配置"""
    name: str
    display_name: str
    data_dir: str
    schema_dirs: list[str]
    file_extensions: list[str]


@dataclass
class AppConfig:
    """应用全局配置"""

    # 基础配置
    app_title: str = "数据血缘分析系统"
    app_version: str = "2.0.0"
    debug: bool = False

    # 服务器配置
    host: str = "0.0.0.0"
    port: int = 8899
    workers: int = 1

    # 数据目录配置
    base_dir: Path = field(default_factory=get_base_dir)
    data_dir: str = "RRP_ORACLE"
    output_dir: str = "output"
    upload_temp_dir: str = "temp_uploads"

    # Schema 目录 (数据库导出文件)
    schema_dirs: list[str] = field(default_factory=lambda: ["rrp_mdl", "rrp_east"])

    # 多数据源配置
    datasource_configs: list[DataSourceConfig] = field(default_factory=lambda: [
        DataSourceConfig(
            name="oracle",
            display_name="Oracle",
            data_dir="RRP_ORACLE",
            schema_dirs=["rrp_mdl", "rrp_east"],
            file_extensions=[".tab", ".prc"],
        ),
    ])

    # 解析配置
    max_upload_size_mb: int = 100
    allowed_extensions: list[str] = field(default_factory=lambda: [".tab", ".prc", ".sql"])
    parse_batch_size: int = 50

    # 性能优化配置
    enable_cache: bool = True
    cache_ttl_seconds: int = 3600
    max_cache_size: int = 10000

    # SSE 进度推送配置
    progress_interval_ms: int = 500
    progress_keepalive_sec: int = 300

    # 虚拟滚动配置
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

    def _resolve_path(self, value: str) -> Path:
        path = Path(value)
        if path.is_absolute():
            return path
        return self.base_dir / path

    @classmethod
    def from_env(cls) -> "AppConfig":
        """从环境变量加载配置，覆盖默认值"""
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

        # 多数据源环境变量配置
        tdh_dir = os.getenv("TDH_DATA_DIR")
        if tdh_dir:
            tdh_schemas = os.getenv("TDH_SCHEMA_DIRS", "dw,ods").split(",")
            config.datasource_configs.append(DataSourceConfig(
                name="tdh",
                display_name="TDH星环",
                data_dir=tdh_dir,
                schema_dirs=[s.strip() for s in tdh_schemas],
                file_extensions=[".hql", ".sql"],
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
            ))

        return config


# 全局单例配置实例
config = AppConfig.from_env()
