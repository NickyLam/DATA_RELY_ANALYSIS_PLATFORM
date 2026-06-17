"""
SQLite 数据库 schema 迁移管理

负责创建和升级 SQLite 数据库表结构。
所有建表和索引 SQL 集中在此模块管理。
"""

from __future__ import annotations

import sqlite3

SCHEMA_VERSION = 2

# ── 建表 SQL ──────────────────────────────────────────────────────

_CREATE_METADATA = """
CREATE TABLE IF NOT EXISTS storage_metadata (
    key   TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    updated_at REAL NOT NULL
)
"""

_CREATE_TABLES = """
CREATE TABLE IF NOT EXISTS tables (
    full_name    TEXT PRIMARY KEY,
    schema_name  TEXT,
    table_name   TEXT,
    description  TEXT,
    layer        TEXT,
    data_source  TEXT,
    columns_json TEXT,
    raw_json     TEXT NOT NULL,
    updated_at   REAL NOT NULL
)
"""

_CREATE_PROCEDURES = """
CREATE TABLE IF NOT EXISTS procedures (
    full_name          TEXT PRIMARY KEY,
    schema_name        TEXT,
    proc_name          TEXT,
    description        TEXT,
    data_source        TEXT,
    source_tables_json TEXT,
    target_tables_json TEXT,
    raw_json           TEXT NOT NULL,
    updated_at         REAL NOT NULL
)
"""

_CREATE_TABLE_LINEAGES = """
CREATE TABLE IF NOT EXISTS table_lineages (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    source_table   TEXT,
    target_table   TEXT,
    procedure_name TEXT,
    data_source    TEXT,
    raw_json       TEXT NOT NULL,
    updated_at     REAL NOT NULL,
    UNIQUE(source_table, target_table, procedure_name)
)
"""

_CREATE_FIELD_MAPPINGS = """
CREATE TABLE IF NOT EXISTS field_mappings (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    source_table     TEXT,
    source_column    TEXT,
    target_table     TEXT,
    target_column    TEXT,
    procedure_name   TEXT,
    confidence       REAL,
    transform_logic  TEXT,
    raw_json         TEXT NOT NULL,
    updated_at       REAL NOT NULL,
    UNIQUE(source_table, source_column, target_table, target_column, procedure_name)
)
"""

_CREATE_CALIBER_INFOS = """
CREATE TABLE IF NOT EXISTS caliber_infos (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    target_table   TEXT,
    target_column  TEXT,
    source_table   TEXT,
    source_column  TEXT,
    procedure_name TEXT,
    step_num       INTEGER,
    data_source    TEXT,
    raw_json       TEXT NOT NULL,
    updated_at     REAL NOT NULL
)
"""

# ── 索引 SQL ──────────────────────────────────────────────────────

_CREATE_INDEXES = [
    "CREATE INDEX IF NOT EXISTS idx_tables_short_name ON tables(table_name)",
    "CREATE INDEX IF NOT EXISTS idx_tables_schema ON tables(schema_name)",
    "CREATE INDEX IF NOT EXISTS idx_tables_layer ON tables(layer)",
    "CREATE INDEX IF NOT EXISTS idx_tables_data_source ON tables(data_source)",
    "CREATE INDEX IF NOT EXISTS idx_procedures_short_name ON procedures(proc_name)",
    "CREATE INDEX IF NOT EXISTS idx_procedures_schema ON procedures(schema_name)",
    "CREATE INDEX IF NOT EXISTS idx_procedures_data_source ON procedures(data_source)",
    "CREATE INDEX IF NOT EXISTS idx_table_lineages_source ON table_lineages(source_table)",
    "CREATE INDEX IF NOT EXISTS idx_table_lineages_target ON table_lineages(target_table)",
    "CREATE INDEX IF NOT EXISTS idx_table_lineages_proc ON table_lineages(procedure_name)",
    "CREATE INDEX IF NOT EXISTS idx_table_lineages_ds ON table_lineages(data_source)",
    "CREATE INDEX IF NOT EXISTS idx_field_mappings_source ON field_mappings(source_table, source_column)",
    "CREATE INDEX IF NOT EXISTS idx_field_mappings_target ON field_mappings(target_table, target_column)",
    "CREATE INDEX IF NOT EXISTS idx_field_mappings_proc ON field_mappings(procedure_name)",
    "CREATE INDEX IF NOT EXISTS idx_caliber_target ON caliber_infos(target_table, target_column)",
    "CREATE INDEX IF NOT EXISTS idx_caliber_source ON caliber_infos(source_table, source_column)",
    "CREATE INDEX IF NOT EXISTS idx_caliber_proc ON caliber_infos(procedure_name)",
    "CREATE INDEX IF NOT EXISTS idx_caliber_ds ON caliber_infos(data_source)",
]

# ── 表名列表（按依赖顺序） ──────────────────────────────────────

TABLE_NAMES = [
    "storage_metadata",
    "tables",
    "procedures",
    "table_lineages",
    "field_mappings",
    "caliber_infos",
]

# ── 数据表名（不含 metadata） ───────────────────────────────────

DATA_TABLE_NAMES = [
    "tables",
    "procedures",
    "table_lineages",
    "field_mappings",
    "caliber_infos",
]


def init_schema(conn: sqlite3.Connection) -> None:
    """初始化数据库 schema（建表 + 索引 + 版本记录）。"""
    cursor = conn.cursor()

    # 建表
    cursor.execute(_CREATE_METADATA)
    cursor.execute(_CREATE_TABLES)
    cursor.execute(_CREATE_PROCEDURES)
    cursor.execute(_CREATE_TABLE_LINEAGES)
    cursor.execute(_CREATE_FIELD_MAPPINGS)
    cursor.execute(_CREATE_CALIBER_INFOS)
    _migrate_caliber_infos_unique_constraint(cursor)

    # 建索引
    for idx_sql in _CREATE_INDEXES:
        cursor.execute(idx_sql)

    # 写入 schema 版本（如果尚未记录）
    cursor.execute(
        "INSERT OR IGNORE INTO storage_metadata (key, value, updated_at) "
        "VALUES ('cache_schema_version', ?, strftime('%s','now'))",
        (str(SCHEMA_VERSION),),
    )

    conn.commit()


def _migrate_caliber_infos_unique_constraint(cursor: sqlite3.Cursor) -> None:
    """Recreate caliber_infos when an older UNIQUE constraint would collapse rows."""
    row = cursor.execute(
        "SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'caliber_infos'"
    ).fetchone()
    create_sql = row[0] if row else ""
    if "UNIQUE(target_table, target_column, source_table, source_column, procedure_name, step_num)" not in create_sql:
        return

    cursor.execute("ALTER TABLE caliber_infos RENAME TO caliber_infos_old")
    cursor.execute(_CREATE_CALIBER_INFOS)
    cursor.execute(
        """
        INSERT INTO caliber_infos (
            target_table, target_column, source_table, source_column,
            procedure_name, step_num, data_source, raw_json, updated_at
        )
        SELECT
            target_table, target_column, source_table, source_column,
            procedure_name, step_num, data_source, raw_json, updated_at
        FROM caliber_infos_old
        """
    )
    cursor.execute("DROP TABLE caliber_infos_old")


def get_schema_version(conn: sqlite3.Connection) -> int | None:
    """读取当前数据库的 schema 版本。"""
    try:
        row = conn.execute("SELECT value FROM storage_metadata WHERE key = 'cache_schema_version'").fetchone()
        if row:
            return int(row[0])
    except sqlite3.OperationalError:
        pass
    return None
