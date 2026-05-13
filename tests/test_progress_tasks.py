from app.services.progress_service import ProgressService, TaskStatus


def test_create_task_starts_pending():
    service = ProgressService()

    task = service.create_task(files_count=2)

    assert task.status == TaskStatus.PENDING
    assert task.files_received == 2


def test_start_task_sets_processing():
    service = ProgressService()
    task = service.create_task()

    started = service.start_task(task.task_id)

    assert started is True
    assert service.get_task(task.task_id).status == TaskStatus.PROCESSING


def test_update_progress_moves_pending_task_to_processing():
    service = ProgressService()
    task = service.create_task()

    service.update_progress(task.task_id, percent=25, message="解析中")

    updated = service.get_task(task.task_id)
    assert updated.status == TaskStatus.PROCESSING
    assert updated.progress.percent == 25
    assert updated.progress.message == "解析中"


def test_list_tasks_returns_sorted_summaries_without_private_task_access():
    service = ProgressService()
    older = service.create_task(files_count=1)
    newer = service.create_task(files_count=3)
    service.start_task(older.task_id)
    service.update_progress(newer.task_id, percent=30)

    summaries = service.list_tasks()

    assert [item["task_id"] for item in summaries] == [newer.task_id, older.task_id]
    assert summaries[0] == {
        "task_id": newer.task_id,
        "status": TaskStatus.PROCESSING.value,
        "files_received": 3,
        "progress_percent": 30,
        "created_at": newer.created_at,
        "updated_at": newer.updated_at,
    }


def test_list_tasks_filters_status_and_limits_results():
    service = ProgressService()
    first = service.create_task()
    second = service.create_task()
    third = service.create_task()
    service.start_task(first.task_id)
    service.start_task(third.task_id)

    summaries = service.list_tasks(limit=1, status=TaskStatus.PROCESSING.value)

    assert len(summaries) == 1
    assert summaries[0]["task_id"] == third.task_id
    assert second.task_id not in {item["task_id"] for item in summaries}
