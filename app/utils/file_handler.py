"""
文件上传处理工具
验证文件类型、大小限制、临时存储管理
"""

from __future__ import annotations

import re
import shutil
import uuid
from pathlib import Path

from fastapi import UploadFile

from app.config import config


class FileHandler:
    """文件上传处理器"""

    ALLOWED_EXTENSIONS = set(config.allowed_extensions)

    @classmethod
    def validate_file(cls, file: UploadFile) -> tuple[bool, str]:
        """
        验证上传文件

        Returns:
            (是否有效, 错误信息)
        """
        if not file.filename:
            return False, "文件名为空"

        ext = Path(file.filename).suffix.lower()
        if ext not in cls.ALLOWED_EXTENSIONS:
            return (
                False,
                f"不支持的文件类型: {ext}，允许的类型: {', '.join(cls.ALLOWED_EXTENSIONS)}",
            )

        return True, ""

    @classmethod
    async def save_upload(cls, file: UploadFile, task_id: str) -> tuple[Path | None, str]:
        """
        保存上传的文件到临时目录

        Returns:
            (保存路径, 错误信息)
        """
        is_valid, error_msg = cls.validate_file(file)
        if not is_valid:
            return None, error_msg

        try:
            task_dir = config.upload_temp_path / task_id
            task_dir.mkdir(parents=True, exist_ok=True)

            # 防止路径穿越：剥离目录部分，清洗危险字符
            safe_name = Path(file.filename).name
            safe_name = re.sub(r'[^\w.\-]', '_', safe_name)
            safe_filename = f"{uuid.uuid4().hex}_{safe_name}"
            save_path = task_dir / safe_filename

            max_bytes = config.max_upload_size_mb * 1024 * 1024
            chunk_size = 1024 * 1024  # 1MB
            total_size = 0
            chunks: list[bytes] = []

            while True:
                chunk = await file.read(chunk_size)
                if not chunk:
                    break
                total_size += len(chunk)
                if total_size > max_bytes:
                    return (
                        None,
                        f"文件过大: {total_size / 1024 / 1024:.1f}MB (限制: {config.max_upload_size_mb}MB)",
                    )
                chunks.append(chunk)

            with open(save_path, "wb") as f:
                for chunk in chunks:
                    f.write(chunk)

            return save_path, ""

        except Exception as e:
            return None, f"文件保存失败: {str(e)}"

    @classmethod
    def cleanup_task_files(cls, task_id: str) -> None:
        """清理任务相关的临时文件"""
        task_dir = config.upload_temp_path / task_id
        if task_dir.exists():
            shutil.rmtree(task_dir, ignore_errors=True)

    @classmethod
    def get_task_files(cls, task_id: str) -> list[Path]:
        """获取任务目录下的所有文件"""
        task_dir = config.upload_temp_path / task_id
        if not task_dir.exists():
            return []
        return list(task_dir.iterdir())

    @staticmethod
    def detect_schema(filename: str) -> str | None:
        """根据文件名推断所属 Schema"""
        filename_upper = filename.upper()

        if any(x in filename_upper for x in ["EAST", "EAST5"]):
            return "rrp_east"
        elif any(x in filename_upper for x in ["MDL", "MODEL", "M_"]):
            return "rrp_mdl"

        return None
