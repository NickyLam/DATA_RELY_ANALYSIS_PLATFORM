"""
PAM 解析器包
从 Oracle PL/SQL*Plus 导出格式的 DDL/DML 文件中解析表结构和存储过程血缘。
"""

from core.pam.pam_parser import PamParser

__all__ = ["PamParser"]
