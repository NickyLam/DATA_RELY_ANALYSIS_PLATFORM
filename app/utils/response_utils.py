"""Unified API response helpers."""

from __future__ import annotations

from typing import Any


def success(data: Any = None, message: str = "") -> dict:
    """Return a standard success response dict."""
    return {"code": 0, "message": message, "data": data}


def error(code: int = -1, message: str = "操作失败") -> dict:
    """Return a standard error response dict."""
    return {"code": code, "message": message, "data": None}
