"""
文件解析器协议与统一产出模型
定义所有文件解析器（.tab/.prc/.sql/.ctl）的统一接口，
采用 Protocol（非 ABC）允许鸭子类型，不强制继承。
"""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Protocol, runtime_checkable


@dataclass
class ParseOutput:
    """所有解析器的统一产出

    数据结构对齐 ParserService.ParseResult（均为 dict 列表），
    方便通过 ParseResult.merge() 直接合并去重。
    """

    tables: list[dict] = field(default_factory=list)
    procedures: list[dict] = field(default_factory=list)
    table_lineages: list[dict] = field(default_factory=list)
    field_mappings: list[dict] = field(default_factory=list)
    caliber_infos: list[dict] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)

    def is_empty(self) -> bool:
        """是否所有产出列表都为空"""
        return (
            not self.tables
            and not self.procedures
            and not self.table_lineages
            and not self.field_mappings
            and not self.caliber_infos
        )

    def summary(self) -> dict:
        """产出摘要"""
        return {
            "tables": len(self.tables),
            "procedures": len(self.procedures),
            "table_lineages": len(self.table_lineages),
            "field_mappings": len(self.field_mappings),
            "caliber_infos": len(self.caliber_infos),
            "errors": len(self.errors),
        }

    def merge(self, other: ParseOutput) -> None:
        """合并另一个 ParseOutput（追加，不去重 — 去重由 ParseResult.merge 处理）"""
        self.tables.extend(other.tables)
        self.procedures.extend(other.procedures)
        self.table_lineages.extend(other.table_lineages)
        self.field_mappings.extend(other.field_mappings)
        self.caliber_infos.extend(other.caliber_infos)
        self.errors.extend(other.errors)


@runtime_checkable
class FileParser(Protocol):
    """文件解析器协议 — 按文件类型路由

    所有解析器（Oracle .tab/.prc、数仓 .sql/.ctl 等）只需实现此协议即可
    自动被 ParserRegistry 识别和路由，无需继承任何基类。
    """

    def supported_extensions(self) -> list[str]:
        """该解析器支持的文件扩展名列表（如 ['.tab']、['.sql', '.ctl']）"""
        ...

    def parse_file(self, file_path: Path) -> ParseOutput:
        """解析单个文件，返回统一产出"""
        ...

    def parse_directory(self, dir_path: Path) -> ParseOutput:
        """递归解析目录下所有支持的文件，返回统一产出"""
        ...
