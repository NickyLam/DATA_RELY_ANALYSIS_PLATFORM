## Why

当前解析服务的 L1（数据源级）并发度硬编码为 `max_workers=2`，但配置了 `_datasource_workers=6`，导致 6 个独立数据源只能 2 个同时解析，CPU 利用率低下。同时，DDL→DML 的两阶段依赖关系在同一系统内是硬保证的，但跨系统并发时缺乏显式的依赖协调机制。需要修复并发度配置失效问题，并确保 DDL 优先于 DML 的语义在并发场景下依然正确。

## What Changes

- 修复 `_shared_executor` 的 `max_workers` 使用配置值 `_datasource_workers`（6）而非硬编码的 2
- 将 `_shared_executor` 从类变量改为实例变量，避免多实例共享线程池导致的资源竞争
- 为 `WarehouseSQLParser.parse_directory` 增加并发安全的 DDL→DML 两阶段保证，确保同一系统内 DDL 先完成后再解析 DML
- 优化 `ParserRegistry.parse_directory` 对 WarehouseSQLParser 的调度策略，避免重复扫描目录
- 增加并发解析的线程池生命周期管理，确保服务停止时正确清理资源

## Capabilities

### New Capabilities
- `concurrency-config`: 数据源级并发度配置化，线程池生命周期管理
- `ddl-dml-ordering-guarantee`: DDL→DML 两阶段解析的并发安全保证机制

### Modified Capabilities
- `parser-service-concurrency`: ParserService 的并发调度策略从硬编码改为配置驱动

## Impact

- **核心代码**: `app/services/parser_service.py` — 线程池创建和管理逻辑
- **核心代码**: `core/warehouse/warehouse_parser.py` — 两阶段解析的并发安全性
- **核心代码**: `core/parser_registry.py` — 目录解析调度策略
- **配置**: `_datasource_workers` 和 `_file_workers` 参数将实际生效
- **性能**: 预期解析总耗时降低 2~3 倍（6个数据源从串行2组变为并行6组）
- **向后兼容**: 无破坏性变更，DDL→DML 语义保持不变
