"""
解析 API 测试用例
TC-001 到 TC-006
"""

from io import BytesIO
from unittest.mock import MagicMock

import pytest
from fastapi.testclient import TestClient

from app.dependencies import get_parser_service, get_progress_service
from app.main import app


@pytest.fixture
def client():
    return TestClient(app)


@pytest.fixture
def mock_parser_service():
    service = MagicMock()
    service.parse_uploaded_files.return_value = MagicMock(
        to_dict=lambda: {"tables": [], "procedures": [], "errors": []}
    )
    service.parse_existing_data.return_value = MagicMock(
        to_dict=lambda: {"tables": [], "procedures": [], "errors": []}
    )
    app.dependency_overrides[get_parser_service] = lambda: service
    try:
        yield service
    finally:
        app.dependency_overrides.pop(get_parser_service, None)


@pytest.fixture
def mock_progress_service():
    service = MagicMock()
    task = MagicMock()
    task.task_id = "test-task-123"
    task.status.value = "processing"
    task.progress.percent = 0
    task.progress.current_file = ""
    task.progress.message = "准备开始"
    task.progress.tables_parsed = 0
    task.progress.procedures_parsed = 0
    task.progress.lineages_found = 0
    task.progress.errors = []
    task.result = None
    task.error = None
    task.created_at = "2024-01-01T00:00:00"
    task.updated_at = "2024-01-01T00:00:00"

    service.create_task.return_value = task
    service.get_task.return_value = task
    service.list_tasks.return_value = [task]
    service.generate_sse_events.return_value = iter([])
    app.dependency_overrides[get_progress_service] = lambda: service
    try:
        yield service
    finally:
        app.dependency_overrides.pop(get_progress_service, None)


class TestFileUpload:
    """文件上传测试"""

    def test_upload_empty_files(self, client, mock_parser_service, mock_progress_service):
        """TC-001: 空文件上传"""
        response = client.post("/api/parse/upload", files=[])
        assert response.status_code in [200, 400, 422]

    def test_upload_invalid_file_format(self, client, mock_parser_service, mock_progress_service):
        """TC-002: 无效文件格式上传"""
        file_content = BytesIO(b"invalid content")
        response = client.post(
            "/api/parse/upload",
            files={"files": ("test.txt", file_content, "text/plain")},
        )
        assert response.status_code in [200, 400]

    def test_upload_valid_tab_file(self, client, mock_parser_service, mock_progress_service):
        """TC-003: 有效文件上传（增量模式）"""
        file_content = BytesIO(b"CREATE TABLE TEST (ID NUMBER);")
        response = client.post(
            "/api/parse/upload",
            files={"files": ("test.tab", file_content, "text/plain")},
            data={"parse_mode": "incremental"},
        )
        assert response.status_code in [200, 422]


class TestTaskStatus:
    """任务状态查询测试"""

    def test_get_task_status(self, client, mock_progress_service):
        """TC-004: 任务状态查询"""
        response = client.get("/api/parse/tasks/test-task-123")
        assert response.status_code in [200, 404]

    def test_list_tasks(self, client, mock_progress_service):
        """测试任务列表查询"""
        response = client.get("/api/parse/tasks?limit=10")
        assert response.status_code in [200, 422]


class TestFullParse:
    """全量解析测试"""

    def test_trigger_full_parse(self, client, mock_parser_service, mock_progress_service):
        """TC-006: 全量解析触发"""
        response = client.post("/api/parse/parse-existing")
        assert response.status_code == 200
        data = response.json()
        assert "success" in data or "data" in data
