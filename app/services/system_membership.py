from __future__ import annotations

from typing import Any


def normalize_data_source(value: Any) -> str:
    return str(value or "").strip().lower()


def enabled_system_names() -> set[str]:
    from app.config import config

    return {cfg.name for cfg in config.datasource_configs if cfg.enabled}


def get_enabled_system_config(system_name: str):
    from app.config import config

    return next((cfg for cfg in config.datasource_configs if cfg.enabled and cfg.name == system_name), None)


def build_schema_to_system(tables: list[dict]) -> dict[str, str]:
    from app.config import config

    schema_to_system: dict[str, str] = {}
    oracle_systems: list[str] = []
    non_oracle_system_names: list[tuple[str, str]] = []

    for ds_cfg in config.datasource_configs:
        if not ds_cfg.enabled:
            continue
        system_prefix = ds_cfg.name.upper()
        for schema_dir in ds_cfg.schema_dirs:
            schema_to_system[schema_dir.upper()] = ds_cfg.name
        if ds_cfg.parser != "oracle":
            schema_to_system[system_prefix] = ds_cfg.name
            non_oracle_system_names.append((system_prefix, ds_cfg.name))
            for schema_dir in ds_cfg.schema_dirs:
                schema_to_system[f"{system_prefix}_{schema_dir.upper()}"] = ds_cfg.name
        if ds_cfg.parser == "oracle":
            oracle_systems.append(ds_cfg.name)

    unknown_schemas: set[str] = set()
    for table in tables:
        full_name = table.get("full_name") or ""
        if not full_name or "." not in full_name:
            continue
        schema = full_name.split(".")[0].upper()
        if schema in schema_to_system:
            continue
        for system_prefix, system_name in non_oracle_system_names:
            if schema.startswith(f"{system_prefix}_"):
                schema_to_system[schema] = system_name
                break
        if schema not in schema_to_system:
            unknown_schemas.add(schema)

    if oracle_systems and unknown_schemas:
        oracle_sys = oracle_systems[0]
        for schema in unknown_schemas:
            schema_to_system[schema] = oracle_sys

    return schema_to_system


def table_system_name(
    table: dict,
    schema_to_system: dict[str, str],
    default_non_oracle: bool = True,
) -> str | None:
    from app.config import config

    data_source = normalize_data_source(table.get("data_source"))
    if data_source:
        return data_source

    full_name = table.get("full_name") or ""
    if "." in full_name:
        schema = full_name.split(".")[0].upper()
        return schema_to_system.get(schema)

    if default_non_oracle:
        first_non_oracle = next((cfg.name for cfg in config.datasource_configs if cfg.enabled and cfg.parser != "oracle"), None)
        return first_non_oracle
    return None


def table_belongs_to_system(table: dict, system_name: str, schema_to_system: dict[str, str]) -> bool:
    ds_cfg = get_enabled_system_config(system_name)
    if ds_cfg is None:
        return False

    data_source = normalize_data_source(table.get("data_source"))
    if data_source:
        return data_source == system_name

    full_name = table.get("full_name") or ""
    if "." in full_name:
        schema = full_name.split(".")[0].upper()
        return schema_to_system.get(schema) == system_name

    return ds_cfg.parser != "oracle"
