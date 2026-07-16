from __future__ import annotations

import threading
from collections.abc import Callable
from pathlib import Path
from typing import Any

import pytest

from app.services.event_bus import DataChangedEvent, EventBus, EventType
from app.services.index_service import (
    CandidateBuildError,
    IndexService,
    RefreshOutcome,
    RefreshResult,
)
from app.services.index_snapshot import IndexSnapshot, ParserStateCapture
from app.services.parser_service import ParseResult, ParserService
from core.models import ColumnInfo, FieldMapping, TableInfo, TableLineage


def _result(version: int, *, with_edges: bool = True) -> ParseResult:
    source = f"SRC.GEN_{version}"
    target = f"DWH.RESULT_{version}"
    result = ParseResult()
    result.tables = [
        TableInfo(schema="SRC", table_name=f"GEN_{version}", full_name=source, columns=[ColumnInfo("ID")]),
        TableInfo(schema="DWH", table_name=f"RESULT_{version}", full_name=target, columns=[ColumnInfo("ID")]),
    ]
    if with_edges:
        result.table_lineages = [TableLineage(source_table=source, target_table=target)]
        result.field_mappings = [
            FieldMapping(
                source_table=source,
                source_column="ID",
                target_table=target,
                target_column="ID",
            )
        ]
    return result


@pytest.fixture
def parser(tmp_path: Path):
    service = ParserService(
        data_dir=str(tmp_path / "data"),
        schema_dirs=[],
        output_dir=str(tmp_path / "output"),
    )
    try:
        yield service
    finally:
        service.shutdown()


def _publish_parser_generation(parser: ParserService, version: int, *, with_edges: bool = True) -> int:
    parser._set_current_result(_result(version, with_edges=with_edges))
    return parser.data_generation


def _owner(
    parser: ParserService,
    *,
    builder: Callable[[ParserStateCapture, int], IndexSnapshot] | None = None,
) -> IndexService:
    return IndexService(
        parser,
        event_bus=EventBus(),
        snapshot_builder=builder,
        auto_start=False,
    )


def test_reader_keeps_old_snapshot_while_new_generation_publishes(parser: ParserService) -> None:
    _publish_parser_generation(parser, 1)
    owner = _owner(parser)
    try:
        assert owner.start().outcome is RefreshOutcome.PUBLISHED
        held = owner.capture_snapshot()
        assert held is not None

        _publish_parser_generation(parser, 2)
        outcome = owner.refresh(requested_generation=2)

        assert outcome.outcome is RefreshOutcome.PUBLISHED
        assert held.generation == 1
        assert held.search_tables("RESULT_1")[0]["full_name"] == "DWH.RESULT_1"
        assert owner.capture_snapshot().generation == 2  # type: ignore[union-attr]
    finally:
        owner.close()


@pytest.mark.parametrize("component", ["source_data", "query_index", "table_adjacency", "field_tracing", "validation"])
def test_candidate_failure_preserves_committed_snapshot_and_sanitizes_diagnostics(
    parser: ParserService,
    component: str,
) -> None:
    fail = False

    def builder(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
        if fail:
            raise CandidateBuildError(component, "candidate_incomplete") from RuntimeError(
                "/secret/source.sql token=do-not-expose"
            )
        return IndexSnapshot.build(capture, publication_revision=revision)

    _publish_parser_generation(parser, 1)
    owner = _owner(parser, builder=builder)
    try:
        owner.start()
        committed = owner.capture_snapshot()
        fail = True
        _publish_parser_generation(parser, 2)

        outcome = owner.refresh(requested_generation=2)
        diagnostics = owner.diagnostics

        assert outcome.outcome is RefreshOutcome.FAILED
        assert outcome.failure_component == component
        assert outcome.failure_code == "candidate_incomplete"
        assert owner.capture_snapshot() is committed
        assert diagnostics["committed_generation"] == 1
        assert diagnostics["ready"] is True
        assert "/secret" not in repr(diagnostics)
        assert "do-not-expose" not in repr(diagnostics)
    finally:
        owner.close()


def test_capture_failure_preserves_committed_snapshot_and_records_sanitized_failure(
    parser: ParserService,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    _publish_parser_generation(parser, 1)
    owner = _owner(parser)
    try:
        owner.start()
        committed = owner.capture_snapshot()

        def fail_capture() -> ParserStateCapture | None:
            raise RuntimeError("/secret/source.sql token=do-not-expose")

        monkeypatch.setattr(parser, "capture_query_state", fail_capture)
        outcome = owner.refresh(requested_generation=2)

        assert outcome.outcome is RefreshOutcome.FAILED
        assert outcome.candidate_generation is None
        assert outcome.failure_component == "source_data"
        assert outcome.failure_code == "build_failed"
        assert owner.capture_snapshot() is committed
        assert owner.state.committed_generation == 1
        assert owner.state.last_failure is outcome
        assert "/secret" not in repr(owner.diagnostics)
        assert "do-not-expose" not in repr(owner.diagnostics)
    finally:
        owner.close()


def test_duplicate_event_skips_build_but_force_republishes_same_generation(parser: ParserService) -> None:
    builds = 0

    def builder(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
        nonlocal builds
        builds += 1
        return IndexSnapshot.build(capture, publication_revision=revision)

    generation = _publish_parser_generation(parser, 1)
    owner = _owner(parser, builder=builder)
    try:
        first = owner.start()
        duplicate = owner.refresh(requested_generation=generation, trigger="event")
        forced = owner.refresh(requested_generation=generation, force=True)

        assert first.outcome is RefreshOutcome.PUBLISHED
        assert duplicate.outcome is RefreshOutcome.DUPLICATE
        assert forced.outcome is RefreshOutcome.FORCED_PUBLISHED
        assert builds == 2
        assert first.publication_namespace != forced.publication_namespace
    finally:
        owner.close()


def test_slower_older_candidate_cannot_regress_newer_commit(parser: ParserService) -> None:
    entered_old = threading.Event()
    release_old = threading.Event()

    def builder(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
        if capture.generation == 2:
            entered_old.set()
            assert release_old.wait(2)
        return IndexSnapshot.build(capture, publication_revision=revision)

    _publish_parser_generation(parser, 1)
    owner = _owner(parser, builder=builder)
    owner.start()
    _publish_parser_generation(parser, 2)
    outcomes: list[Any] = []
    slow = threading.Thread(target=lambda: outcomes.append(owner.refresh(requested_generation=2)))
    slow.start()
    assert entered_old.wait(2)

    _publish_parser_generation(parser, 3)
    newer = owner.refresh(requested_generation=3)
    release_old.set()
    slow.join(2)
    try:
        assert newer.outcome is RefreshOutcome.PUBLISHED
        assert outcomes[0].outcome is RefreshOutcome.STALE
        assert owner.diagnostics["committed_generation"] == 3
    finally:
        owner.close()


def test_late_failure_does_not_relabel_committed_identity(parser: ParserService) -> None:
    entered = threading.Event()
    release = threading.Event()

    def builder(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
        if capture.generation == 2:
            entered.set()
            assert release.wait(2)
            raise CandidateBuildError("query_index", "build_failed")
        return IndexSnapshot.build(capture, publication_revision=revision)

    _publish_parser_generation(parser, 1)
    owner = _owner(parser, builder=builder)
    owner.start()
    _publish_parser_generation(parser, 2)
    thread = threading.Thread(target=lambda: owner.refresh(requested_generation=2))
    thread.start()
    assert entered.wait(2)
    _publish_parser_generation(parser, 3)
    owner.refresh(requested_generation=3)
    release.set()
    thread.join(2)
    try:
        state = owner.state
        assert state.snapshot is not None and state.snapshot.generation == 3
        assert state.committed_generation == 3
        assert state.ready is True
        assert state.last_attempt is not None
        assert state.last_attempt.outcome is RefreshOutcome.FAILED
    finally:
        owner.close()


def test_start_close_are_idempotent_and_closed_owner_ignores_events(parser: ParserService) -> None:
    bus = EventBus()
    builds = 0

    def builder(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
        nonlocal builds
        builds += 1
        return IndexSnapshot.build(capture, publication_revision=revision)

    _publish_parser_generation(parser, 1)
    owner = IndexService(parser, event_bus=bus, snapshot_builder=builder, auto_start=False)
    owner.start()
    owner.start()
    assert len(bus._handlers[EventType.DATA_CHANGED]) == 1

    _publish_parser_generation(parser, 2)
    bus.publish(EventType.DATA_CHANGED, event=DataChangedEvent(2, "test", 0.0), generation=2)
    assert builds == 2

    owner.close()
    owner.close()

    _publish_parser_generation(parser, 3)
    bus.publish(EventType.DATA_CHANGED, event=DataChangedEvent(3, "test", 0.0), generation=3)

    assert builds == 2
    assert owner.capture_snapshot() is not None
    assert owner.capture_snapshot().generation == 2  # type: ignore[union-attr]


def test_close_during_build_prevents_publication_and_diagnostic_overwrite(parser: ParserService) -> None:
    entered = threading.Event()
    release = threading.Event()

    def builder(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
        entered.set()
        assert release.wait(2)
        return IndexSnapshot.build(capture, publication_revision=revision)

    _publish_parser_generation(parser, 1)
    owner = _owner(parser, builder=builder)
    thread = threading.Thread(target=owner.start)
    thread.start()
    assert entered.wait(2)
    owner.close()
    state_after_close = owner.state
    release.set()
    thread.join(2)

    assert owner.state is state_after_close
    assert owner.capture_snapshot() is None


def test_auto_start_failure_removes_global_event_subscriptions(parser: ParserService) -> None:
    bus = EventBus()
    _publish_parser_generation(parser, 1)

    def fail(_capture: ParserStateCapture, _revision: int) -> IndexSnapshot:
        raise CandidateBuildError("query_index", "build_failed")

    with pytest.raises(CandidateBuildError):
        IndexService(parser, event_bus=bus, snapshot_builder=fail)

    assert bus._handlers.get(EventType.DATA_CHANGED, []) == []
    assert bus._handlers.get(EventType.CACHE_INVALIDATED, []) == []


def test_close_wakes_concurrent_start_waiter_before_builder_finishes(parser: ParserService) -> None:
    entered = threading.Event()
    release = threading.Event()

    def builder(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
        entered.set()
        assert release.wait(2)
        return IndexSnapshot.build(capture, publication_revision=revision)

    _publish_parser_generation(parser, 1)
    owner = _owner(parser, builder=builder)
    leader = threading.Thread(target=owner.start)
    follower_result: list[Any] = []
    follower = threading.Thread(target=lambda: follower_result.append(owner.start()))
    leader.start()
    assert entered.wait(2)
    follower.start()

    owner.close()
    follower.join(0.2)
    try:
        assert not follower.is_alive()
        assert follower_result[0].outcome is RefreshOutcome.CLOSED
    finally:
        release.set()
        leader.join(2)
        follower.join(2)


def test_capture_failure_wakes_concurrent_start_waiter(
    parser: ParserService,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    entered = threading.Event()
    release = threading.Event()
    _publish_parser_generation(parser, 1)

    def fail_capture() -> ParserStateCapture | None:
        entered.set()
        assert release.wait(2)
        raise RuntimeError("capture failed")

    monkeypatch.setattr(parser, "capture_query_state", fail_capture)
    owner = _owner(parser)
    leader_errors: list[Exception] = []
    follower_results: list[RefreshResult] = []

    def start_leader() -> None:
        try:
            owner.start()
        except Exception as exc:
            leader_errors.append(exc)

    leader = threading.Thread(target=start_leader)
    follower = threading.Thread(target=lambda: follower_results.append(owner.start()))
    leader.start()
    assert entered.wait(2)
    follower.start()
    release.set()
    leader.join(2)
    follower.join(0.2)
    try:
        assert not leader.is_alive()
        assert not follower.is_alive()
        assert len(leader_errors) == 1
        assert isinstance(leader_errors[0], CandidateBuildError)
        assert follower_results[0].outcome is RefreshOutcome.FAILED
    finally:
        owner.close()
        leader.join(2)
        follower.join(2)


def test_no_data_is_degraded_first_failure_raises_and_zero_edge_is_ready(parser: ParserService) -> None:
    empty_owner = _owner(parser)
    try:
        result = empty_owner.start()
        assert result.outcome is RefreshOutcome.NO_DATA
        assert empty_owner.diagnostics["ready"] is False
    finally:
        empty_owner.close()

    _publish_parser_generation(parser, 1)

    def fail(_capture: ParserStateCapture, _revision: int) -> IndexSnapshot:
        raise CandidateBuildError("query_index", "build_failed")

    failing_owner = _owner(parser, builder=fail)
    with pytest.raises(CandidateBuildError):
        failing_owner.start()
    failing_owner.close()

    _publish_parser_generation(parser, 2, with_edges=False)
    zero_edge_owner = _owner(parser)
    try:
        assert zero_edge_owner.start().outcome is RefreshOutcome.PUBLISHED
        assert zero_edge_owner.diagnostics["ready"] is True
        assert zero_edge_owner.capture_snapshot().adjacency_up == {}  # type: ignore[union-attr]
    finally:
        zero_edge_owner.close()


def test_concurrent_duplicate_event_is_single_flight(parser: ParserService) -> None:
    entered = threading.Event()
    release = threading.Event()
    captures_ready = threading.Barrier(2)
    builds = 0

    original_capture = parser.capture_query_state

    def capture_together() -> ParserStateCapture | None:
        capture = original_capture()
        captures_ready.wait(timeout=2)
        return capture

    parser.capture_query_state = capture_together  # type: ignore[method-assign]

    def builder(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
        nonlocal builds
        builds += 1
        entered.set()
        assert release.wait(2)
        return IndexSnapshot.build(capture, publication_revision=revision)

    generation = _publish_parser_generation(parser, 1)
    owner = _owner(parser, builder=builder)
    outcomes: list[Any] = []
    threads = [
        threading.Thread(
            target=lambda: outcomes.append(owner.refresh(requested_generation=generation, trigger="event"))
        )
        for _ in range(2)
    ]
    for thread in threads:
        thread.start()
    assert entered.wait(2)
    release.set()
    for thread in threads:
        thread.join(2)
    try:
        assert builds == 1
        assert {outcome.outcome for outcome in outcomes} == {
            RefreshOutcome.PUBLISHED,
            RefreshOutcome.COALESCED,
        }
        assert owner.state.last_attempt is not None
        assert owner.state.last_attempt.outcome is RefreshOutcome.COALESCED
    finally:
        owner.close()


def test_same_generation_published_during_capture_is_coalesced(parser: ParserService) -> None:
    generation = _publish_parser_generation(parser, 1)
    owner = _owner(parser)
    owner.start()
    entered = threading.Event()
    release = threading.Event()
    worker_id: int | None = None
    original_capture = parser.capture_query_state

    def capture_with_pause() -> ParserStateCapture | None:
        capture = original_capture()
        if threading.get_ident() == worker_id:
            entered.set()
            assert release.wait(2)
        return capture

    parser.capture_query_state = capture_with_pause  # type: ignore[method-assign]
    outcomes: list[RefreshResult] = []

    def refresh_in_worker() -> None:
        nonlocal worker_id
        worker_id = threading.get_ident()
        outcomes.append(owner.refresh(requested_generation=generation))

    thread = threading.Thread(target=refresh_in_worker)
    thread.start()
    assert entered.wait(2)
    forced = owner.refresh(requested_generation=generation, force=True)
    release.set()
    thread.join(2)
    try:
        assert forced.outcome is RefreshOutcome.FORCED_PUBLISHED
        assert [result.outcome for result in outcomes] == [RefreshOutcome.COALESCED]
        assert outcomes[0].base_publication_namespace == (generation, 1)
        assert outcomes[0].publication_namespace == (generation, 2)
    finally:
        owner.close()


def test_same_generation_published_during_build_is_coalesced(parser: ParserService) -> None:
    entered = threading.Event()
    release = threading.Event()
    build_count = 0

    def builder(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
        nonlocal build_count
        build_count += 1
        if build_count == 2:
            entered.set()
            assert release.wait(2)
        return IndexSnapshot.build(capture, publication_revision=revision)

    generation_one = _publish_parser_generation(parser, 1)
    owner = _owner(parser, builder=builder)
    assert owner.start().outcome is RefreshOutcome.PUBLISHED
    generation_two = _publish_parser_generation(parser, 2)
    outcomes: list[RefreshResult] = []
    thread = threading.Thread(
        target=lambda: outcomes.append(owner.refresh(requested_generation=generation_two))
    )
    thread.start()
    assert entered.wait(2)
    forced = owner.refresh(requested_generation=generation_two, force=True)
    release.set()
    thread.join(2)
    try:
        assert generation_one == 1
        assert forced.outcome is RefreshOutcome.PUBLISHED
        assert [result.outcome for result in outcomes] == [RefreshOutcome.COALESCED]
        assert outcomes[0].base_publication_namespace == (generation_one, 1)
        assert outcomes[0].publication_namespace == (generation_two, 3)
    finally:
        owner.close()


def test_forced_rebuilds_serialize_and_capture_generation_is_authoritative(parser: ParserService) -> None:
    active = 0
    max_active = 0
    lock = threading.Lock()

    def builder(capture: ParserStateCapture, revision: int) -> IndexSnapshot:
        nonlocal active, max_active
        with lock:
            active += 1
            max_active = max(max_active, active)
        threading.Event().wait(0.02)
        with lock:
            active -= 1
        return IndexSnapshot.build(capture, publication_revision=revision)

    generation = _publish_parser_generation(parser, 1)
    owner = _owner(parser, builder=builder)
    owner.start()
    outcomes: list[Any] = []
    threads = [threading.Thread(target=lambda: outcomes.append(owner.refresh(force=True))) for _ in range(2)]
    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join(2)
    try:
        assert max_active == 1
        assert [outcome.outcome for outcome in outcomes].count(RefreshOutcome.FORCED_PUBLISHED) == 2

        _publish_parser_generation(parser, 2)
        delayed_event = owner.refresh(requested_generation=generation, trigger="event")
        assert delayed_event.candidate_generation == 2
        assert delayed_event.request_superseded is True
        assert delayed_event.outcome is RefreshOutcome.PUBLISHED
        assert owner.capture_snapshot().generation == 2  # type: ignore[union-attr]
    finally:
        owner.close()


def test_state_read_is_coherent_during_publication(parser: ParserService) -> None:
    _publish_parser_generation(parser, 1)
    owner = _owner(parser)
    owner.start()
    failures: list[tuple[Any, ...]] = []

    def read_state() -> None:
        for _ in range(500):
            state = owner.state
            if state.snapshot is None:
                continue
            if (
                state.committed_generation != state.snapshot.generation
                or state.publication_namespace != state.snapshot.publication_namespace
                or state.ready != state.snapshot.is_ready
            ):
                failures.append((state,))

    reader = threading.Thread(target=read_state)
    reader.start()
    for version in range(2, 8):
        _publish_parser_generation(parser, version)
        owner.refresh(requested_generation=version)
    reader.join(2)
    try:
        assert failures == []
    finally:
        owner.close()
