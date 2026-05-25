"""
存储后端抽象层

提供统一的存储协议和后端选择机制，
支持 SQLite（默认）和 Legacy（pickle/json 双写）两种后端。
"""

from app.services.storage.protocol import CACHE_SCHEMA_VERSION, ResultStoreProtocol

__all__ = ["CACHE_SCHEMA_VERSION", "ResultStoreProtocol"]
