from __future__ import annotations

import logging
from enum import Enum, auto
from typing import Any, Callable

logger = logging.getLogger(__name__)


class EventType(Enum):
    DATA_CHANGED = auto()
    CACHE_INVALIDATED = auto()
    PARSE_STARTED = auto()
    PARSE_COMPLETED = auto()
    PARSE_FAILED = auto()


class EventBus:

    def __init__(self):
        self._handlers: dict[EventType, list[Callable]] = {}

    def subscribe(self, event_type: EventType, handler: Callable) -> None:
        if event_type not in self._handlers:
            self._handlers[event_type] = []
        self._handlers[event_type].append(handler)

    def unsubscribe(self, event_type: EventType, handler: Callable) -> None:
        if event_type in self._handlers:
            self._handlers[event_type] = [
                h for h in self._handlers[event_type] if h != handler
            ]

    def publish(self, event_type: EventType, **kwargs: Any) -> None:
        handlers = self._handlers.get(event_type, [])
        if not handlers:
            return
        for handler in handlers:
            try:
                handler(**kwargs)
            except Exception as e:
                logger.error("事件处理器 %s 处理 %s 时出错: %s", handler.__name__, event_type.name, e)

    def clear(self) -> None:
        self._handlers.clear()


_event_bus: EventBus | None = None


def get_event_bus() -> EventBus:
    global _event_bus
    if _event_bus is None:
        _event_bus = EventBus()
    return _event_bus
