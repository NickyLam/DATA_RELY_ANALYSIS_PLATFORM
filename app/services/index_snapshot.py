"""不可变查询快照及其只读查询接口。"""

from __future__ import annotations

from copy import deepcopy
from typing import Any

from app.repository import search_table_dicts
from app.services.lineage_query_index import LineageQueryIndex, ReadOnlyLineageQueryIndex
from app.services.table_lineage_tracer import ReadOnlyTableLineageTracer, TableLineageTracer
from core.table_name_resolver import TableNameResolver


class FieldLineageTracingView:
    """仅开放字段血缘读取操作的 generation-bound tracer 外观。"""

    __slots__ = ("_tracer",)

    def __init__(self, tracer: Any) -> None:
        self._tracer = tracer

    def trace_field(self, target_table: str, target_field: str) -> Any:
        return deepcopy(self._tracer.trace_field(target_table, target_field))

    def trace_field_upstream(
        self,
        target_table: str,
        target_field: str,
        max_depth: int = 10,
    ) -> list[Any]:
        return deepcopy(self._tracer.trace_field_upstream(target_table, target_field, max_depth))

    def trace_field_downstream(
        self,
        source_table: str,
        source_field: str,
        max_depth: int = 10,
    ) -> list[Any]:
        return deepcopy(self._tracer.trace_field_downstream(source_table, source_field, max_depth))

    def to_graph_result(
        self,
        chains: list[Any],
        *,
        direction: str,
    ) -> tuple[set[str], list[dict], list[dict]]:
        return deepcopy(self._tracer.to_graph_result(chains, direction=direction))


class ParserStateCapture:
    """Parser 在同一锁边界内捕获的 generation、数据和字段追踪视图。"""

    __slots__ = ("_data_mtime", "_field_tracing", "_generation", "_source_data")

    def __init__(
        self,
        generation: int,
        source_data: dict[str, Any],
        field_tracing: FieldLineageTracingView,
        data_mtime: float | None = None,
        *,
        _take_ownership: bool = False,
    ) -> None:
        self._generation = generation
        self._data_mtime = data_mtime
        self._source_data = source_data if _take_ownership else deepcopy(source_data)
        self._field_tracing = field_tracing

    @property
    def generation(self) -> int:
        return self._generation

    @property
    def field_tracing(self) -> FieldLineageTracingView:
        return self._field_tracing

    @property
    def data_mtime(self) -> float | None:
        return self._data_mtime

    def get_source_data(self) -> dict[str, Any]:
        return deepcopy(self._source_data)


class IndexSnapshot:
    """一代数据及其所有不可变查询投影的只读聚合。"""

    __slots__ = (
        "_field_tracing",
        "_generation",
        "_data_mtime",
        "_publication_namespace",
        "_query_index",
        "_source_data",
        "_table_tracer",
    )

    def __init__(
        self,
        *,
        generation: int,
        publication_namespace: tuple[int, int],
        source_data: dict[str, Any],
        query_index: ReadOnlyLineageQueryIndex,
        table_tracer: ReadOnlyTableLineageTracer,
        field_tracing: FieldLineageTracingView,
        data_mtime: float | None = None,
    ) -> None:
        self._generation = generation
        self._data_mtime = data_mtime
        self._publication_namespace = publication_namespace
        self._source_data = source_data
        self._query_index = query_index
        self._table_tracer = table_tracer
        self._field_tracing = field_tracing

    @classmethod
    def build(
        cls,
        capture: ParserStateCapture | None,
        *,
        publication_revision: int,
    ) -> IndexSnapshot:
        if capture is None:
            raise ValueError("parser capture is required")
        if publication_revision < 1:
            raise ValueError("publication revision must be positive")

        data = capture.get_source_data()

        query_index_builder = LineageQueryIndex()
        query_index_builder.build(data)

        table_tracer_builder = TableLineageTracer(TableNameResolver())
        table_tracer_builder.build_graph(data.get("table_lineages", []))

        return cls(
            generation=capture.generation,
            publication_namespace=(capture.generation, publication_revision),
            source_data=data,
            query_index=query_index_builder.as_read_only(),
            table_tracer=table_tracer_builder.as_read_only(),
            field_tracing=capture.field_tracing,
            data_mtime=capture.data_mtime,
        )

    @property
    def is_ready(self) -> bool:
        return self._query_index.is_built and self._table_tracer.is_built

    @property
    def generation(self) -> int:
        return self._generation

    @property
    def data_mtime(self) -> float | None:
        return self._data_mtime

    @property
    def publication_namespace(self) -> tuple[int, int]:
        return self._publication_namespace

    @property
    def query_index(self) -> ReadOnlyLineageQueryIndex:
        return self._query_index

    @property
    def field_tracing(self) -> FieldLineageTracingView:
        return self._field_tracing

    @property
    def adjacency_up(self) -> dict[str, set[str]]:
        return self._table_tracer.adjacency_up

    @property
    def adjacency_down(self) -> dict[str, set[str]]:
        return self._table_tracer.adjacency_down

    def get_source_data(self) -> dict[str, Any]:
        return deepcopy(self._source_data)

    def search_tables(self, keyword: str, limit: int = 50) -> list[dict]:
        return deepcopy(search_table_dicts(self._source_data.get("tables", []), keyword, limit))

    def search_procedures(self, keyword: str, limit: int = 50) -> list[dict]:
        return self._query_index.search_procedures(keyword, limit)

    def trace_tables(
        self,
        start_table: str,
        *,
        max_depth: int,
        direction: str = "up",
    ) -> tuple[set[str], list[dict]]:
        return self._table_tracer.trace(
            start_table,
            self._source_data,
            max_depth,
            direction,
            self._query_index,
        )
