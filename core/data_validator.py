"""
数据完整性校验器
检查解析后的数据是否存在孤立节点、断链、自环等问题。
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field

logger = logging.getLogger(__name__)


@dataclass
class ValidationReport:
    errors: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    info: list[str] = field(default_factory=list)

    def add_error(self, msg: str) -> None:
        self.errors.append(msg)

    def add_warning(self, msg: str) -> None:
        self.warnings.append(msg)

    def add_info(self, msg: str) -> None:
        self.info.append(msg)

    @property
    def is_valid(self) -> bool:
        return len(self.errors) == 0

    def summary(self) -> str:
        parts = [f"错误: {len(self.errors)}", f"警告: {len(self.warnings)}", f"信息: {len(self.info)}"]
        return " | ".join(parts)


class DataValidator:
    """数据完整性校验器"""

    def validate(self, data: dict) -> ValidationReport:
        report = ValidationReport()

        tables = data.get("tables", [])
        lineages = data.get("table_lineages", [])
        mappings = data.get("field_mappings", [])
        procedures = data.get("procedures", [])

        known_tables = {t.get("full_name", "").upper() for t in tables if t.get("full_name")}

        self._check_orphan_references(mappings, lineages, known_tables, report)
        self._check_self_loops(lineages, report)
        self._check_coverage(tables, mappings, report)
        self._check_procedure_consistency(procedures, lineages, report)

        logger.info("数据校验完成: %s", report.summary())
        return report

    @staticmethod
    def _check_orphan_references(
        mappings: list[dict],
        lineages: list[dict],
        known_tables: set[str],
        report: ValidationReport,
    ) -> None:
        for fm in mappings:
            src = fm.get("source_table", "").upper()
            tgt = fm.get("target_table", "").upper()
            if src and src not in known_tables:
                report.add_warning(f"字段映射引用了未知源表: {src}")
            if tgt and tgt not in known_tables:
                report.add_warning(f"字段映射引用了未知目标表: {tgt}")

        for tl in lineages:
            src = tl.get("source_table", "").upper()
            tgt = tl.get("target_table", "").upper()
            if src and src not in known_tables:
                report.add_warning(f"表级血缘引用了未知源表: {src}")
            if tgt and tgt not in known_tables:
                report.add_warning(f"表级血缘引用了未知目标表: {tgt}")

    @staticmethod
    def _check_self_loops(lineages: list[dict], report: ValidationReport) -> None:
        for tl in lineages:
            src = tl.get("source_table", "").upper()
            tgt = tl.get("target_table", "").upper()
            if src and tgt and src == tgt:
                report.add_warning(f"自环血缘: {src}")

    @staticmethod
    def _check_coverage(
        tables: list[dict],
        mappings: list[dict],
        report: ValidationReport,
    ) -> None:
        tables_with_mappings = {fm.get("target_table", "").upper() for fm in mappings if fm.get("target_table")}
        tables_without_mappings = set()
        for t in tables:
            full = t.get("full_name", "").upper()
            if full and full not in tables_with_mappings:
                tables_without_mappings.add(full)

        if tables_without_mappings:
            report.add_info(f"有 {len(tables_without_mappings)} 张表无字段映射（可能仅作为源表）")

    @staticmethod
    def _check_procedure_consistency(
        procedures: list[dict],
        lineages: list[dict],
        report: ValidationReport,
    ) -> None:
        proc_names = {p.get("full_name", "").upper() for p in procedures if p.get("full_name")}
        lineage_procs = {tl.get("procedure", "").upper() for tl in lineages if tl.get("procedure")}

        orphan_procs = lineage_procs - proc_names
        if orphan_procs:
            report.add_warning(f"有 {len(orphan_procs)} 个血缘记录引用了未知过程")
