"""
数据架构层级检测（可配置化版本）

根据表名模式判断表所属的数据架构层级（ODS/DIIS/BASE/MDL/APP/EAST/CONFIG/OTHER）。
支持从 manifest.yml 动态加载层级规则，每个系统可定义独立的层级检测策略。

向后兼容：无 manifest 时回退到 RRP 硬编码规则，确保零回归。
"""

from __future__ import annotations

import logging
import re
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path

logger = logging.getLogger(__name__)


class LayerType(Enum):
    ODS = "ods"
    SRC = "src"
    MSL = "msl"
    ITL = "itl"
    IOL = "iol"
    ICL = "icl"
    IML = "iml"
    IDL = "idl"
    IEL = "iel"
    DQC = "dqc"
    DIIS = "diis"
    BASE = "base"
    MDL = "mdl"
    APP = "app"
    EAST = "east"
    CONFIG = "config"
    OTHER = "other"


@dataclass
class LayerRule:
    pattern: str
    layer: str
    label: str
    _compiled: re.Pattern | None = field(default=None, repr=False)

    @property
    def compiled(self) -> re.Pattern:
        if self._compiled is None:
            object.__setattr__(self, "_compiled", re.compile(self.pattern, re.IGNORECASE))
        return self._compiled


@dataclass
class SchemaRule:
    schema: str
    layer: str = ""
    default_layer: str = ""


@dataclass
class BareNameRule:
    pattern: str
    layer: str
    label: str
    _compiled: re.Pattern | None = field(default=None, repr=False)

    @property
    def compiled(self) -> re.Pattern:
        if self._compiled is None:
            object.__setattr__(self, "_compiled", re.compile(self.pattern))
        return self._compiled


@dataclass
class SynonymRule:
    pattern: str
    target: str
    _compiled: re.Pattern | None = field(default=None, repr=False)

    @property
    def compiled(self) -> re.Pattern:
        if self._compiled is None:
            object.__setattr__(self, "_compiled", re.compile(self.pattern, re.IGNORECASE))
        return self._compiled


@dataclass
class LayerConfig:
    rules: list[LayerRule] = field(default_factory=list)
    schema_rules: list[SchemaRule] = field(default_factory=list)
    bare_name_rules: list[BareNameRule] = field(default_factory=list)
    synonym_rules: list[SynonymRule] = field(default_factory=list)
    default_schema: str = "RRP_MDL"
    known_schemas: list[str] = field(default_factory=lambda: ["ICL", "IML", "IOL", "RRP_EAST", "RRP_MDL"])
    layer_order: list[str] = field(default_factory=lambda: ["ods", "diis", "base", "mdl", "app", "east"])
    layer_colors: dict[str, str] = field(default_factory=dict)


LAYER_CONFIG: dict[str, dict] = {
    "ods": {"label": "ODS源系统层", "color": "#4ade80", "order": 0},
    "src": {"label": "SRC原始数据层", "color": "#34d399", "order": 1},
    "msl": {"label": "MSL源系统层", "color": "#2dd4bf", "order": 2},
    "itl": {"label": "ITL接口层", "color": "#22d3ee", "order": 3},
    "iol": {"label": "IOL操作层", "color": "#38bdf8", "order": 4},
    "icl": {"label": "ICL共性加工层", "color": "#818cf8", "order": 5},
    "iml": {"label": "IML模型层", "color": "#a78bfa", "order": 6},
    "idl": {"label": "IDL接口层", "color": "#c084fc", "order": 7},
    "iel": {"label": "IEL外部层", "color": "#e879f9", "order": 8},
    "dqc": {"label": "DQC数据质量层", "color": "#f472b6", "order": 9},
    "diis": {"label": "DIIS明细层", "color": "#fb923c", "order": 10},
    "base": {"label": "B基础层", "color": "#818cf8", "order": 11},
    "mdl": {"label": "M模型层", "color": "#c084fc", "order": 12},
    "app": {"label": "A/S应用汇总层", "color": "#fb923c", "order": 13},
    "east": {"label": "EAST报送层", "color": "#f87171", "order": 14},
    "config": {"label": "配置/临时表", "color": "#6b7280", "order": 15},
    "other": {"label": "其他", "color": "#6b7280", "order": 16},
}

LAYER_ORDER = [
    "ods",
    "src",
    "msl",
    "itl",
    "iol",
    "icl",
    "iml",
    "idl",
    "iel",
    "dqc",
    "diis",
    "base",
    "mdl",
    "app",
    "east",
    "config",
]


def _build_rrp_default_config() -> LayerConfig:
    return LayerConfig(
        rules=[
            LayerRule(pattern="^ICL\\.V_", layer="ods", label="ODS 核心账务视图"),
            LayerRule(pattern="^O_ICL_", layer="ods", label="ODS 核心账务源数据"),
            LayerRule(pattern="^O_FDW_|^O_RDW_", layer="ods", label="ODS 外部数据源"),
            LayerRule(pattern="^O_IML_|^O_IOL_", layer="base", label="BASE 中间层操作表"),
            LayerRule(pattern="^B_", layer="base", label="BASE 基础层"),
            LayerRule(pattern="^M_", layer="mdl", label="MDL 模型层"),
            LayerRule(pattern="^A_|^S_", layer="app", label="APP 应用汇总层"),
            LayerRule(pattern="EAST", layer="east", label="EAST 报送层"),
            LayerRule(pattern="^ADD_|DIIS", layer="diis", label="DIIS 明细层"),
            LayerRule(
                pattern="^ETL_|^CONFIG|^CODE|^TMP|^SQ_|^FUN|^GET|^CHECK|^SP_",
                layer="config",
                label="CONFIG 配置/临时表",
            ),
        ],
        schema_rules=[
            SchemaRule(schema="SRC", layer="src"),
            SchemaRule(schema="MSL", layer="msl"),
            SchemaRule(schema="ITL", layer="itl"),
            SchemaRule(schema="IOL", layer="iol"),
            SchemaRule(schema="ICL", layer="icl"),
            SchemaRule(schema="IML", layer="iml"),
            SchemaRule(schema="IDL", layer="idl"),
            SchemaRule(schema="IEL", layer="iel"),
            SchemaRule(schema="DQC", layer="dqc"),
            SchemaRule(schema="RRP_EAST", default_layer="diis"),
            SchemaRule(schema="RRP_MDL", default_layer="base"),
        ],
        bare_name_rules=[
            BareNameRule(pattern="^[A-Z]{1,10}$", layer="ods", label="ODS 源系统缩写表"),
        ],
        synonym_rules=[
            SynonymRule(pattern="^O_ICL_(.*)", target="ICL_$1"),
            SynonymRule(pattern="^ICL\\.V_(.*)", target="ICL_$1"),
            SynonymRule(pattern="^ICL\\.([A-Z].*)", target="ICL_$1"),
        ],
        default_schema="RRP_MDL",
        known_schemas=[
            "SRC",
            "MSL",
            "ITL",
            "IOL",
            "ICL",
            "IML",
            "IDL",
            "IEL",
            "DQC",
            "RRP_EAST",
            "RRP_MDL",
        ],
        layer_order=[
            "ods",
            "src",
            "msl",
            "itl",
            "iol",
            "icl",
            "iml",
            "idl",
            "iel",
            "dqc",
            "diis",
            "base",
            "mdl",
            "app",
            "east",
            "config",
        ],
        layer_colors={
            "ods": "#4ade80",
            "src": "#34d399",
            "msl": "#2dd4bf",
            "itl": "#22d3ee",
            "iol": "#38bdf8",
            "icl": "#818cf8",
            "iml": "#a78bfa",
            "idl": "#c084fc",
            "iel": "#e879f9",
            "dqc": "#f472b6",
            "diis": "#fb923c",
            "base": "#818cf8",
            "mdl": "#c084fc",
            "app": "#fb923c",
            "east": "#f87171",
            "config": "#6b7280",
            "other": "#6b7280",
        },
    )


class LayerDetector:
    """可配置化的层级检测器。

    支持多系统：每个系统有独立的 LayerConfig，通过 system 参数切换。
    无 system 参数时回退到 RRP 默认规则，确保向后兼容。
    """

    def __init__(self, layer_configs: dict[str, LayerConfig] | None = None):
        self._configs: dict[str, LayerConfig] = layer_configs or {}
        if "rrp" not in self._configs:
            self._configs["rrp"] = _build_rrp_default_config()

    def detect_layer(self, table_name: str, system: str = "rrp") -> LayerType:
        config = self._configs.get(system, self._configs.get("rrp"))
        if config is None:
            return LayerType.OTHER

        name = table_name.upper()
        short_name = name.split(".")[-1] if "." in name else name
        schema = name.split(".")[0] if "." in name else ""

        for rule in config.rules:
            if rule.compiled.search(table_name):
                return LayerType(rule.layer)

        for sr in config.schema_rules:
            if schema == sr.schema.upper():
                if sr.layer:
                    return LayerType(sr.layer)
                if sr.default_layer and "EAST" not in short_name:
                    if any(x in short_name for x in ["TMP", "_NEW", "_OLD", "_BAK", "_ORIG"]):
                        return LayerType("diis")
                    return LayerType(sr.default_layer)

        for bnr in config.bare_name_rules:
            if bnr.compiled.match(short_name):
                return LayerType(bnr.layer)

        return LayerType.OTHER

    def get_layer_config(self, system: str = "rrp") -> LayerConfig:
        return self._configs.get(system, self._configs.get("rrp", _build_rrp_default_config()))

    def get_all_configs(self) -> dict[str, LayerConfig]:
        return dict(self._configs)

    @classmethod
    def from_manifests(cls, source_data_dir: Path) -> LayerDetector:
        configs: dict[str, LayerConfig] = {}
        if not source_data_dir.is_dir():
            logger.warning(
                "SOURCE_DATA directory not found: %s, using RRP defaults",
                source_data_dir,
            )
            return cls()

        for system_dir in sorted(source_data_dir.iterdir()):
            if not system_dir.is_dir():
                continue
            manifest_path = system_dir / "manifest.yml"
            if not manifest_path.exists():
                continue
            try:
                config = _load_layer_config_from_manifest(manifest_path)
                if config is not None:
                    system_name = system_dir.name.lower()
                    configs[system_name] = config
                    logger.info("Loaded layer config for system: %s", system_name)
            except Exception as e:
                logger.error("Failed to load manifest %s: %s", manifest_path, e)

        return cls(configs)


def _load_layer_config_from_manifest(manifest_path: Path) -> LayerConfig | None:
    try:
        import yaml
    except ImportError:
        logger.error("PyYAML not installed, cannot load manifest")
        return None

    data = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
    if not data or "layer_rules" not in data:
        return None

    lr = data["layer_rules"]

    rules = [
        LayerRule(pattern=r["pattern"], layer=r["layer"], label=r.get("label", r["layer"])) for r in lr.get("rules", [])
    ]

    schema_rules = [
        SchemaRule(
            schema=sr["schema"],
            layer=sr.get("layer", ""),
            default_layer=sr.get("default_layer", ""),
        )
        for sr in lr.get("schema_rules", [])
    ]

    bare_name_rules = [
        BareNameRule(
            pattern=bnr["pattern"],
            layer=bnr["layer"],
            label=bnr.get("label", bnr["layer"]),
        )
        for bnr in lr.get("bare_name_rules", [])
    ]

    synonym_rules = [SynonymRule(pattern=sr["pattern"], target=sr["target"]) for sr in lr.get("synonym_rules", [])]

    return LayerConfig(
        rules=rules,
        schema_rules=schema_rules,
        bare_name_rules=bare_name_rules,
        synonym_rules=synonym_rules,
        default_schema=lr.get("default_schema", "RRP_MDL"),
        known_schemas=lr.get("known_schemas", []),
        layer_order=lr.get("layer_order", LAYER_ORDER),
        layer_colors=lr.get("layer_colors", {}),
    )


def detect_layer(table_name: str) -> LayerType:
    detect_layer._default_detector = getattr(detect_layer, "_default_detector", None) or LayerDetector()
    return detect_layer._default_detector.detect_layer(table_name, system="rrp")


def detect_layer_str(table_name: str) -> str:
    return detect_layer(table_name).value
