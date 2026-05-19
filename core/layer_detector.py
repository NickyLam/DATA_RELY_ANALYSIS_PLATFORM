"""
数据架构层级检测
根据表名模式判断表所属的数据架构层级（ODS/DIIS/BASE/MDL/APP/EAST/CONFIG/OTHER）
"""

from __future__ import annotations

from enum import Enum
from typing import Optional


class LayerType(Enum):
    """数据架构层级"""
    ODS = "ods"
    DIIS = "diis"
    BASE = "base"
    MDL = "mdl"
    APP = "app"
    EAST = "east"
    CONFIG = "config"
    OTHER = "other"


# 架构层级配置（后端权威定义）
LAYER_CONFIG: dict[str, dict] = {
    "ods":    {"label": "ODS源系统层",   "color": "#4ade80", "order": 0},
    "diis":  {"label": "DIIS明细层",     "color": "#38bdf8", "order": 1},
    "base":  {"label": "B基础层",       "color": "#818cf8", "order": 2},
    "mdl":   {"label": "M模型层",       "color": "#c084fc", "order": 3},
    "app":  {"label": "A/S应用汇总层", "color": "#fb923c", "order": 4},
    "east":  {"label": "EAST报送层",     "color": "#f87171", "order": 5},
    "config": {"label": "配置/临时表",   "color": "#6b7280", "order": 6},
    "other":  {"label": "其他",          "color": "#6b7280", "order": 7},
}

LAYER_ORDER = ["ods", "diis", "base", "mdl", "app", "east"]


def detect_layer(table_name: str) -> LayerType:
    """根据表名模式检测所属层级（增强版：支持 schema.table 全限定名）"""
    name = table_name.upper()

    # 提取短名（去掉 schema 前缀），用于前缀匹配
    short_name = name.split(".")[-1] if "." in name else name

    # 1. ODS 源系统层（优先检测，避免被 schema 名干扰）
    #    O_ICL_*: 核心账务系统(ICL)源数据，是真正的外部源系统 → ODS
    #    O_IML_*: 中间层(IML)操作表，有上游 V_* 视图 → BASE（非 ODS）
    #    O_IOL_*: 同理待定，目前暂归 BASE
    #    O_FDW_* / O_RDW_*: 外部数据源 → ODS
    if short_name.startswith("O_ICL_"):
        return LayerType.ODS
    if short_name.startswith("O_IML_") or short_name.startswith("O_IOL_"):
        return LayerType.BASE
    if short_name.startswith("O_FDW_") or short_name.startswith("O_RDW_"):
        return LayerType.ODS

    # 2. EAST 报送层（只检查短名中的 EAST，避免 RRP_EAST schema 误判）
    if "EAST" in short_name:
        return LayerType.EAST

    # 3. M 模型层 / B 基础层 / A/S 应用汇总层（检查短名前缀）
    if short_name.startswith("M_"):
        return LayerType.MDL
    if short_name.startswith("B_"):
        return LayerType.BASE
    if short_name.startswith("A_") or short_name.startswith("S_"):
        return LayerType.APP

    # 4. DIIS 明细层
    if short_name.startswith("ADD_") or "DIIS" in short_name:
        return LayerType.DIIS

    # 5. 配置/临时表
    if short_name.startswith("ETL_") or short_name.startswith("CONFIG") or short_name.startswith("CODE") or \
       short_name.startswith("TMP") or short_name.startswith("SQ_") or short_name.startswith("FUN") or \
       short_name.startswith("GET") or short_name.startswith("CHECK") or short_name.startswith("SP_"):
        return LayerType.CONFIG

    # 6. Schema 感知推断（RRP 项目特有逻辑）
    #    RRP_EAST schema 的非 EAST 表 → 可能是 staging 层
    if "RRP_EAST" in name and "EAST" not in short_name:
        return LayerType.DIIS

    #    RRP_MDL schema 的非 M_/B_ 表 → 可能是引用表或配置表
    if "RRP_MDL" in name:
        if any(x in short_name for x in ["TMP", "_NEW", "_OLD", "_BAK", "_ORIG"]):
            return LayerType.DIIS
        return LayerType.BASE  # RRP_MDL schema 内的表默认归入基础层

    # 7. 纯大写缩写且无已知前缀 → 归类为 ODS 源表
    if "_" not in short_name and short_name.isupper() and len(short_name) <= 10:
        return LayerType.ODS

    return LayerType.OTHER


def detect_layer_str(table_name: str) -> str:
    """返回层级的字符串标识（用于API序列化）"""
    return detect_layer(table_name).value
