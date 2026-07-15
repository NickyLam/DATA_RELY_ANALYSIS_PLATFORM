"""查询投影快照的原子生命周期 owner。"""

from __future__ import annotations

import logging
import threading
import time
from collections.abc import Callable
from dataclasses import dataclass, replace
from enum import StrEnum
from typing import Any

from app.services.event_bus import DataChangedEvent, EventBus, EventType, get_event_bus
from app.services.index_snapshot import IndexSnapshot, ParserStateCapture
from app.services.parser_service import ParserService
from app.services.table_lineage_tracer import TableLineageTracer
from app.utils.cache_manager import CacheManager

logger = logging.getLogger(__name__)


class RefreshOutcome(StrEnum):
    """一次刷新请求的结构化结果。"""

    PUBLISHED = "published"
    FORCED_PUBLISHED = "forced_published"
    DUPLICATE = "duplicate"
    COALESCED = "coalesced"
    STALE = "stale"
    FAILED = "failed"
    NO_DATA = "no_data"
    CLOSED = "closed"


class CandidateBuildError(RuntimeError):
    """候选构建的内部结构化错误；对外只暴露 component/code。"""

    def __init__(self, component: str, code: str) -> None:
        super().__init__(code)
        self.component = component
        self.code = code


@dataclass(frozen=True)
class RefreshResult:
    attempt_id: int
    outcome: RefreshOutcome
    requested_generation: int | None
    candidate_generation: int | None
    base_publication_namespace: tuple[int, int] | None
    publication_namespace: tuple[int, int] | None = None
    failure_component: str | None = None
    failure_code: str | None = None
    completed_at: float = 0.0


@dataclass(frozen=True)
class IndexOwnerState:
    """单引用发布的快照及 committed 元数据。"""

    snapshot: IndexSnapshot | None = None
    committed_generation: int | None = None
    publication_namespace: tuple[int, int] | None = None
    ready: bool = False
    last_attempt: RefreshResult | None = None
    last_failure: RefreshResult | None = None


@dataclass
class _EventFlight:
    completed: threading.Event
    result: RefreshResult | None = None


SnapshotBuilder = Callable[[ParserStateCapture, int], IndexSnapshot]


def _build_snapshot(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
    return IndexSnapshot.build(capture, publication_revision=revision)


class IndexService:
    """构建、验证并以单引用方式发布不可变查询快照。"""

    def __init__(
        self,
        parser_service: ParserService,
        cache_manager: CacheManager | None = None,
        table_tracer: TableLineageTracer | None = None,
        *,
        event_bus: EventBus | None = None,
        snapshot_builder: SnapshotBuilder | None = None,
        auto_start: bool = True,
    ) -> None:
        self._parser = parser_service
        # U3 切换 reader 前保留旧构造参数；候选构建绝不改写这些外部可变对象。
        self._cache = cache_manager
        self._table_tracer = table_tracer
        self._snapshot_builder = snapshot_builder or _build_snapshot
        self._event_bus = event_bus or get_event_bus()

        self._lock = threading.RLock()
        self._force_lock = threading.Lock()
        self._state = IndexOwnerState()
        self._started = False
        self._starting = False
        self._start_completed = threading.Event()
        self._closed = False
        self._lifecycle_epoch = 0
        self._next_attempt_id = 0
        self._next_publication_revision = 0
        self._event_flights: dict[int, _EventFlight] = {}
        self._start_result: RefreshResult | None = None

        # U6 在迁移出口删除；U2 期间保持旧 API 兼容，但不再参与快照发布。
        self._transitive_cache: dict[tuple, set] = {}
        self._last_data_mtime = 0.0

        if auto_start:
            self.start()

    @property
    def state(self) -> IndexOwnerState:
        with self._lock:
            return self._state

    @property
    def diagnostics(self) -> dict[str, Any]:
        state = self.state
        return {
            "ready": state.ready,
            "committed_generation": state.committed_generation,
            "publication_namespace": state.publication_namespace,
            "last_refresh_outcome": state.last_attempt.outcome.value if state.last_attempt else None,
            "last_failure": self._public_attempt(state.last_failure),
        }

    @staticmethod
    def _public_attempt(attempt: RefreshResult | None) -> dict[str, Any] | None:
        if attempt is None:
            return None
        return {
            "attempt_id": attempt.attempt_id,
            "outcome": attempt.outcome.value,
            "requested_generation": attempt.requested_generation,
            "candidate_generation": attempt.candidate_generation,
            "failure_component": attempt.failure_component,
            "failure_code": attempt.failure_code,
            "completed_at": attempt.completed_at,
        }

    def capture_snapshot(self) -> IndexSnapshot | None:
        """捕获一次 committed 引用；调用方可在后续刷新期间安全持有。"""
        return self.state.snapshot

    def start(self) -> RefreshResult:
        """幂等订阅并尝试首次发布。"""
        with self._lock:
            if self._closed:
                return self._new_terminal_result(RefreshOutcome.CLOSED, None, None)
            if self._start_result is not None:
                return self._start_result
            if self._starting:
                start_completed = self._start_completed
                is_leader = False
                epoch = self._lifecycle_epoch
            else:
                self._starting = True
                self._started = True
                self._start_completed.clear()
                start_completed = self._start_completed
                is_leader = True
                epoch = self._lifecycle_epoch
                self._event_bus.subscribe(EventType.DATA_CHANGED, self._on_data_changed)
                self._event_bus.subscribe(EventType.CACHE_INVALIDATED, self._on_cache_invalidated)

        if not is_leader:
            start_completed.wait()
            with self._lock:
                if self._start_result is not None:
                    return self._start_result
            return self._new_terminal_result(RefreshOutcome.CLOSED, None, None)

        result = self.refresh(trigger="startup", _epoch=epoch)
        with self._lock:
            self._start_result = result
            self._starting = False
            self._start_completed.set()
        if result.outcome is RefreshOutcome.FAILED and self.state.snapshot is None:
            # 构造期首次发布失败时，调用方拿不到 owner 引用，必须在抛错前退订。
            self.close()
            raise CandidateBuildError(
                result.failure_component or "candidate",
                result.failure_code or "build_failed",
            )
        return result

    def close(self) -> None:
        """幂等关闭；epoch gate 阻止已在运行的候选发布或改写诊断。"""
        with self._lock:
            if self._closed:
                return
            self._closed = True
            self._lifecycle_epoch += 1
            self._starting = False
            self._start_completed.set()
            if self._started:
                self._event_bus.unsubscribe(EventType.DATA_CHANGED, self._on_data_changed)
                self._event_bus.unsubscribe(EventType.CACHE_INVALIDATED, self._on_cache_invalidated)
            # 保存一个新引用，使测试和诊断能识别关闭边界；运行中 attempt 不得再替换它。
            self._state = replace(self._state)

    def refresh(
        self,
        *,
        requested_generation: int | None = None,
        force: bool = False,
        trigger: str = "explicit",
        _epoch: int | None = None,
    ) -> RefreshResult:
        """构建并尝试发布一个候选。

        capture.generation 是候选身份的唯一权威；requested_generation 仅用于关联诊断。
        """
        if force:
            with self._force_lock:
                return self._refresh_once(requested_generation, True, trigger, _epoch)
        return self._refresh_once(requested_generation, False, trigger, _epoch)

    def _refresh_once(
        self,
        requested_generation: int | None,
        force: bool,
        trigger: str,
        epoch: int | None,
    ) -> RefreshResult:
        with self._lock:
            active_epoch = self._lifecycle_epoch if epoch is None else epoch
            if self._closed or active_epoch != self._lifecycle_epoch:
                return self._new_terminal_result(RefreshOutcome.CLOSED, requested_generation, None)
            attempt_id = self._next_attempt()
            base_namespace = self._state.publication_namespace

        capture = self._parser.capture_query_state()
        if capture is None:
            result = RefreshResult(
                attempt_id,
                RefreshOutcome.NO_DATA,
                requested_generation,
                None,
                base_namespace,
                completed_at=time.time(),
            )
            self._record_attempt(result, active_epoch)
            return result

        candidate_generation = capture.generation
        is_event = trigger == "event"

        with self._lock:
            if self._closed or active_epoch != self._lifecycle_epoch:
                return self._new_terminal_result(RefreshOutcome.CLOSED, requested_generation, candidate_generation)
            committed = self._state.committed_generation
            if committed is not None and candidate_generation < committed:
                result = RefreshResult(
                    attempt_id,
                    RefreshOutcome.STALE,
                    requested_generation,
                    candidate_generation,
                    base_namespace,
                    completed_at=time.time(),
                )
                self._record_attempt_locked(result)
                return result
            if committed == candidate_generation and not force:
                result = RefreshResult(
                    attempt_id,
                    RefreshOutcome.DUPLICATE,
                    requested_generation,
                    candidate_generation,
                    base_namespace,
                    publication_namespace=self._state.publication_namespace,
                    completed_at=time.time(),
                )
                self._record_attempt_locked(result)
                return result

            flight: _EventFlight | None = None
            is_leader = True
            if is_event:
                flight = self._event_flights.get(candidate_generation)
                if flight is None:
                    flight = _EventFlight(threading.Event())
                    self._event_flights[candidate_generation] = flight
                else:
                    is_leader = False

            if is_leader:
                self._next_publication_revision += 1
                revision = self._next_publication_revision
            else:
                revision = 0

        if not is_leader:
            assert flight is not None
            flight.completed.wait()
            leader_result = flight.result
            if leader_result is None:
                return self._new_terminal_result(RefreshOutcome.CLOSED, requested_generation, candidate_generation)
            result = RefreshResult(
                attempt_id,
                RefreshOutcome.COALESCED,
                requested_generation,
                candidate_generation,
                base_namespace,
                publication_namespace=leader_result.publication_namespace,
                failure_component=leader_result.failure_component,
                failure_code=leader_result.failure_code,
                completed_at=time.time(),
            )
            self._record_attempt(result, active_epoch)
            return result

        try:
            candidate = self._snapshot_builder(capture, revision)
            self._validate_candidate(candidate, capture, revision)
        except Exception as exc:
            failure = self._failure_result(
                attempt_id,
                requested_generation,
                candidate_generation,
                base_namespace,
                exc,
            )
            self._record_attempt(failure, active_epoch)
            self._complete_flight(candidate_generation, flight, failure)
            logger.warning("查询快照候选构建失败: component=%s code=%s", failure.failure_component, failure.failure_code)
            return failure

        with self._lock:
            if self._closed or active_epoch != self._lifecycle_epoch:
                result = self._new_terminal_result(RefreshOutcome.CLOSED, requested_generation, candidate_generation)
            else:
                committed = self._state.committed_generation
                if committed is not None and candidate_generation < committed:
                    result = RefreshResult(
                        attempt_id,
                        RefreshOutcome.STALE,
                        requested_generation,
                        candidate_generation,
                        base_namespace,
                        completed_at=time.time(),
                    )
                    self._record_attempt_locked(result)
                elif committed == candidate_generation and not force:
                    result = RefreshResult(
                        attempt_id,
                        RefreshOutcome.DUPLICATE,
                        requested_generation,
                        candidate_generation,
                        base_namespace,
                        publication_namespace=self._state.publication_namespace,
                        completed_at=time.time(),
                    )
                    self._record_attempt_locked(result)
                else:
                    outcome = (
                        RefreshOutcome.FORCED_PUBLISHED
                        if force and committed == candidate_generation
                        else RefreshOutcome.PUBLISHED
                    )
                    result = RefreshResult(
                        attempt_id,
                        outcome,
                        requested_generation,
                        candidate_generation,
                        base_namespace,
                        publication_namespace=candidate.publication_namespace,
                        completed_at=time.time(),
                    )
                    self._state = IndexOwnerState(
                        snapshot=candidate,
                        committed_generation=candidate.generation,
                        publication_namespace=candidate.publication_namespace,
                        ready=candidate.is_ready,
                        last_attempt=result,
                        last_failure=self._state.last_failure,
                    )

        self._complete_flight(candidate_generation, flight, result)
        return result

    @staticmethod
    def _validate_candidate(
        candidate: IndexSnapshot,
        capture: ParserStateCapture,
        revision: int,
    ) -> None:
        if not isinstance(candidate, IndexSnapshot):
            raise CandidateBuildError("validation", "candidate_type_invalid")
        if candidate.generation != capture.generation:
            raise CandidateBuildError("validation", "generation_mismatch")
        if candidate.publication_namespace != (capture.generation, revision):
            raise CandidateBuildError("validation", "namespace_mismatch")
        if not candidate.is_ready:
            raise CandidateBuildError("validation", "candidate_incomplete")

    @staticmethod
    def _failure_result(
        attempt_id: int,
        requested_generation: int | None,
        candidate_generation: int,
        base_namespace: tuple[int, int] | None,
        exc: Exception,
    ) -> RefreshResult:
        if isinstance(exc, CandidateBuildError):
            allowed_components = {
                "source_data",
                "query_index",
                "table_adjacency",
                "field_tracing",
                "validation",
                "candidate",
            }
            allowed_codes = {
                "build_failed",
                "candidate_incomplete",
                "candidate_type_invalid",
                "generation_mismatch",
                "namespace_mismatch",
            }
            component = exc.component if exc.component in allowed_components else "candidate"
            code = exc.code if exc.code in allowed_codes else "build_failed"
        else:
            component = "candidate"
            code = "build_failed"
        return RefreshResult(
            attempt_id,
            RefreshOutcome.FAILED,
            requested_generation,
            candidate_generation,
            base_namespace,
            failure_component=component,
            failure_code=code,
            completed_at=time.time(),
        )

    def _record_attempt(self, result: RefreshResult, epoch: int) -> None:
        with self._lock:
            if self._closed or epoch != self._lifecycle_epoch:
                return
            self._record_attempt_locked(result)

    def _record_attempt_locked(self, result: RefreshResult) -> None:
        self._state = replace(
            self._state,
            last_attempt=result,
            last_failure=result if result.outcome is RefreshOutcome.FAILED else self._state.last_failure,
        )

    def _complete_flight(
        self,
        generation: int,
        flight: _EventFlight | None,
        result: RefreshResult,
    ) -> None:
        if flight is None:
            return
        with self._lock:
            flight.result = result
            self._event_flights.pop(generation, None)
            flight.completed.set()

    def _next_attempt(self) -> int:
        self._next_attempt_id += 1
        return self._next_attempt_id

    def _new_terminal_result(
        self,
        outcome: RefreshOutcome,
        requested_generation: int | None,
        candidate_generation: int | None,
    ) -> RefreshResult:
        with self._lock:
            attempt_id = self._next_attempt()
            namespace = self._state.publication_namespace
        return RefreshResult(
            attempt_id,
            outcome,
            requested_generation,
            candidate_generation,
            namespace,
            publication_namespace=namespace,
            completed_at=time.time(),
        )

    def _on_data_changed(
        self,
        event: DataChangedEvent | None = None,
        generation: int | None = None,
        **_kwargs: Any,
    ) -> None:
        requested = event.generation if event is not None else generation
        self.refresh(requested_generation=requested, trigger="event")

    def _on_cache_invalidated(self, **_kwargs: Any) -> None:
        # 缓存失效不是数据 generation，不能绕过同代去重。
        self.refresh(requested_generation=self._parser.data_generation, trigger="event")

    # ---- U2 迁移期旧调用面；U3/U6 完成后移除 ----
    def build_indexes(self) -> None:
        self.refresh(trigger="legacy")

    def rebuild_indexes(self) -> RefreshResult:
        return self.refresh(force=True, trigger="explicit")

    def check_and_refresh_cache(self) -> None:
        current_mtime = self._get_data_mtime()
        if current_mtime is None:
            return
        if self._last_data_mtime == 0:
            self._last_data_mtime = current_mtime
            return
        if current_mtime > self._last_data_mtime:
            self.refresh(requested_generation=self._parser.data_generation, trigger="event")
            self._last_data_mtime = current_mtime

    def clear_transitive_cache(self) -> None:
        self._transitive_cache.clear()

    @property
    def transitive_cache(self) -> dict[tuple, set]:
        return self._transitive_cache

    def _get_data_mtime(self) -> float | None:
        try:
            repo = self._parser.get_repository()
            metadata = repo.get_metadata()
            last_updated = metadata.get("last_updated", "")
            if last_updated:
                from datetime import datetime

                return datetime.strptime(str(last_updated), "%Y-%m-%d %H:%M:%S").timestamp()
        except Exception:
            pass
        cache_file = self._parser.output_dir / "lineage_data.json"
        return cache_file.stat().st_mtime if cache_file.exists() else None
