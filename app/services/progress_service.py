"""
进度管理服务
管理异步解析任务的进度状态，支持 SSE 实时推送
"""

from __future__ import annotations

import logging
import queue
import threading
import time
import uuid
from dataclasses import dataclass, field
from enum import StrEnum
from typing import Any

logger = logging.getLogger(__name__)


class TaskStatus(StrEnum):
    PENDING = "pending"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"
    CANCELLED = "cancelled"


@dataclass
class ProgressUpdate:
    """进度更新事件"""

    percent: float = 0.0
    current_file: str = ""
    message: str = ""
    level: str = "info"

    tables_parsed: int = 0
    procedures_parsed: int = 0
    lineages_found: int = 0
    errors: list[str] = field(default_factory=list)


@dataclass
class ParseTask:
    """解析任务"""

    task_id: str = field(default_factory=lambda: uuid.uuid4().hex)
    status: TaskStatus = TaskStatus.PENDING
    created_at: float = field(default_factory=time.time)
    updated_at: float = field(default_factory=time.time)

    files_received: int = 0
    progress: ProgressUpdate = field(default_factory=ProgressUpdate)
    result: Any | None = None
    error: str | None = None

    subscribers: list[queue.Queue] = field(default_factory=list)
    lock: threading.Lock = field(default_factory=threading.Lock)


class ProgressService:
    """任务进度管理服务"""

    def __init__(self, keepalive_sec: int = 300):
        self.keepalive_sec = keepalive_sec
        self._tasks: dict[str, ParseTask] = {}
        self._lock = threading.Lock()

    def create_task(self, files_count: int = 0) -> ParseTask:
        """创建新的解析任务"""
        task = ParseTask(files_received=files_count)

        with self._lock:
            self._tasks[task.task_id] = task

        logger.info("创建任务: %s, 文件数: %d", task.task_id, files_count)
        return task

    def get_task(self, task_id: str) -> ParseTask | None:
        """获取任务信息"""
        with self._lock:
            return self._tasks.get(task_id)

    def start_task(self, task_id: str) -> bool:
        """标记任务开始处理"""
        task = self.get_task(task_id)
        if not task:
            return False

        with task.lock:
            if task.status == TaskStatus.PENDING:
                task.status = TaskStatus.PROCESSING
                task.updated_at = time.time()

        self._notify_subscribers(task)
        return True

    def list_tasks(
        self,
        limit: int | None = 20,
        status: str | None = None,
    ) -> list[dict[str, Any]]:
        """返回按更新时间倒序排列的任务摘要"""
        with self._lock:
            tasks = list(self._tasks.values())

        summaries = []
        for task in tasks:
            with task.lock:
                if status and task.status.value != status:
                    continue

                summaries.append(
                    {
                        "task_id": task.task_id,
                        "status": task.status.value,
                        "files_received": task.files_received,
                        "progress_percent": round(task.progress.percent, 2),
                        "created_at": task.created_at,
                        "updated_at": task.updated_at,
                    }
                )

        summaries.sort(key=lambda x: x["updated_at"], reverse=True)
        if limit is None:
            return summaries
        return summaries[:limit]

    def update_progress(
        self,
        task_id: str,
        percent: float,
        current_file: str = "",
        message: str = "",
        level: str = "info",
        **kwargs,
    ) -> None:
        """更新任务进度并推送给所有订阅者"""
        task = self.get_task(task_id)
        if not task:
            logger.warning("任务不存在: %s", task_id)
            return

        with task.lock:
            if task.status == TaskStatus.PENDING:
                task.status = TaskStatus.PROCESSING

            task.progress.percent = min(percent, 100.0)
            task.progress.current_file = current_file
            task.progress.message = message
            task.progress.level = level

            for key, value in kwargs.items():
                if hasattr(task.progress, key):
                    setattr(task.progress, key, value)

            task.updated_at = time.time()

        self._notify_subscribers(task)

    def complete_task(self, task_id: str, result: Any = None) -> None:
        """标记任务完成"""
        task = self.get_task(task_id)
        if not task:
            return

        with task.lock:
            task.status = TaskStatus.COMPLETED
            task.progress.percent = 100.0
            task.progress.message = "解析完成"
            task.result = result

            # 从结果中更新统计数据
            if result and isinstance(result, dict):
                task.progress.tables_parsed = result.get("tables_parsed", 0)
                task.progress.procedures_parsed = result.get("procedures_parsed", 0)
                task.progress.lineages_found = result.get("table_lineages", 0) + result.get("field_mappings", 0)

            task.updated_at = time.time()

        self._notify_subscribers(task)
        logger.info(
            "任务完成: %s, 表=%d, 过程=%d, 血缘=%d",
            task_id,
            task.progress.tables_parsed,
            task.progress.procedures_parsed,
            task.progress.lineages_found,
        )

    def fail_task(self, task_id: str, error: str) -> None:
        """标记任务失败"""
        task = self.get_task(task_id)
        if not task:
            return

        with task.lock:
            task.status = TaskStatus.FAILED
            task.error = error
            task.progress.message = f"解析失败: {error}"
            task.progress.level = "error"
            task.progress.errors.append(error)
            task.updated_at = time.time()

        self._notify_subscribers(task)
        logger.error("任务失败: %s - %s", task_id, error)

    def subscribe(self, task_id: str) -> queue.Queue:
        """订阅任务进度事件（用于 SSE 推送）"""
        task = self.get_task(task_id)
        if not task:
            raise ValueError(f"任务不存在: {task_id}")

        q: queue.Queue = queue.Queue(maxsize=100)

        with task.lock:
            task.subscribers.append(q)

        logger.debug("新订阅者加入任务: %s (当前订阅数: %d)", task_id, len(task.subscribers))
        return q

    def unsubscribe(self, task_id: str, q: queue.Queue) -> None:
        """取消订阅"""
        task = self.get_task(task_id)
        if not task:
            return

        with task.lock:
            if q in task.subscribers:
                task.subscribers.remove(q)

    def generate_sse_events(self, task_id: str):
        """
        SSE 事件生成器（供 FastAPI StreamingResponse 使用）

        Yields:
            str: SSE 格式的事件字符串
        """
        task = self.get_task(task_id)
        if not task:
            yield self._format_sse_event("error", {"message": f"任务不存在: {task_id}"})
            return

        q = self.subscribe(task_id)
        last_keepalive = time.time()

        try:
            while True:
                try:
                    event = q.get(timeout=self.keepalive_sec)
                    yield self._format_sse_event(event["type"], event["data"])

                    if event["type"] in ("complete", "error"):
                        break

                except queue.Empty:
                    if task.status in (
                        TaskStatus.COMPLETED,
                        TaskStatus.FAILED,
                        TaskStatus.CANCELLED,
                    ):
                        break

                    now = time.time()
                    if now - last_keepalive >= 30:
                        yield self._format_sse_event(
                            "progress",
                            {
                                "percent": task.progress.percent,
                                "message": "保持连接...",
                            },
                        )
                        last_keepalive = now

        finally:
            self.unsubscribe(task_id, q)

    def cleanup_old_tasks(self, max_age_sec: int = 3600) -> int:
        """清理过期的任务记录"""
        now = time.time()
        removed = 0

        with self._lock:
            expired_ids = [
                tid
                for tid, task in self._tasks.items()
                if now - task.updated_at > max_age_sec
                and task.status in (TaskStatus.COMPLETED, TaskStatus.FAILED, TaskStatus.CANCELLED)
            ]

            for tid in expired_ids:
                del self._tasks[tid]
                removed += 1

        if removed > 0:
            logger.info("清理了 %d 个过期任务", removed)

        return removed

    @property
    def active_tasks_count(self) -> int:
        """当前活跃任务数量"""
        with self._lock:
            return sum(1 for t in self._tasks.values() if t.status == TaskStatus.PROCESSING)

    @property
    def stats(self) -> dict:
        """服务统计信息"""
        with self._lock:
            total = len(self._tasks)
            by_status = {}
            active = 0

            for task in self._tasks.values():
                status = task.status.value
                by_status[status] = by_status.get(status, 0) + 1
                if task.status == TaskStatus.PROCESSING:
                    active += 1

            return {
                "total_tasks": total,
                "by_status": by_status,
                "active_tasks": active,
            }

    def _notify_subscribers(self, task: ParseTask) -> None:
        """向所有订阅者推送进度更新"""
        event_data = {
            "type": "complete"
            if task.status == TaskStatus.COMPLETED
            else "error"
            if task.status == TaskStatus.FAILED
            else "progress",
            "data": {
                "percent": task.progress.percent,
                "current_file": task.progress.current_file,
                "message": task.progress.message,
                "level": task.progress.level,
                "tables_parsed": task.progress.tables_parsed,
                "procedures_parsed": task.progress.procedures_parsed,
                "lineages_found": task.progress.lineages_found,
                "errors": task.progress.errors,
            },
        }

        dead_subscribers = []
        for q in task.subscribers:
            try:
                q.put_nowait(event_data)
            except queue.Full:
                dead_subscribers.append(q)

        for q in dead_subscribers:
            task.subscribers.remove(q)

    @staticmethod
    def _format_sse_event(event_type: str, data: dict) -> str:
        """格式化为 SSE 事件字符串"""
        import json

        return f"event: {event_type}\ndata: {json.dumps(data, ensure_ascii=False)}\n\n"
