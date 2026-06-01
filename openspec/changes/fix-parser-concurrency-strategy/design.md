## Context

当前解析服务采用三层并发模型：

1. **L1 数据源级**：`ParserService` 通过 `_shared_executor` 并行解析多个数据源目录（Oracle/EDW/BRT/PAM/GBASE/指标）
2. **L2 目录级**：`WarehouseSQLParser.parse_directory` 串行执行三阶段（DDL→DML→CTL）
3. **L3 文件级**：`DDLParser` 和 `DMLParser` 各自用 `ThreadPoolExecutor(max_workers=4)` 并行解析文件

**核心问题**：
- L1 并发度硬编码为 `max_workers=2`，但 `_datasource_workers=6` 已配置却未生效
- `_shared_executor` 是类变量，多实例共享同一线程池，存在资源竞争风险
- 线程池无生命周期管理，服务停止时不清理资源
- DDL→DML 两阶段依赖在并发场景下虽已正确（每个系统内部串行保证），但缺乏显式文档化

**约束**：
- DDL→DML 顺序是硬依赖，DMLParser 依赖 DDL 解析出的 `ddl_tables` 做字段映射
- 各数据源之间完全独立，无跨源依赖
- 内存使用需可控，6个数据源同时解析时内存峰值不能过高

## Goals / Non-Goals

**Goals:**
- 修复 L1 并发度配置失效问题，使 `_datasource_workers` 实际生效
- 将线程池从类变量改为实例变量，避免多实例共享
- 增加线程池生命周期管理（初始化和清理）
- 保持 DDL→DML 两阶段解析语义不变
- 预期解析总耗时降低 2~3 倍

**Non-Goals:**
- 不改变 L2 的 DDL→DML→CTL 串行顺序（这是硬依赖）
- 不改变 L3 文件级并发策略（已有效）
- 不引入跨数据源的依赖协调机制
- 不改变 `WarehouseSQLParser` 的两阶段解析内部逻辑
- 不做异步化改造（保持 ThreadPoolExecutor 方案）

## Decisions

### Decision 1: 线程池从类变量改为实例变量

**选择**: 将 `_shared_executor` 从 `ParserService` 的类变量改为实例变量，在 `__init__` 中根据 `_datasource_workers` 创建

**备选方案**:
- A) 保持类变量，仅修改 `max_workers` 值 — 风险：多实例共享线程池，一个实例的关闭影响其他实例
- B) 改为实例变量 — 优势：每个实例独立管理生命周期，资源隔离

**理由**: 实例变量更安全，生命周期可控。虽然当前只有一个 ParserService 实例，但改为实例变量是防御性设计。

### Decision 2: L1 并发度使用 `_datasource_workers` 配置值

**选择**: `_executor = ThreadPoolExecutor(max_workers=self._datasource_workers)`

**备选方案**:
- A) 硬编码改为 6 — 不灵活，不同环境可能需要不同并发度
- B) 使用配置值 — 灵活，可通过配置调整

**理由**: 已有 `_datasource_workers` 配置参数，直接使用即可。默认值 6 对应 6 个独立数据源。

### Decision 3: 增加 `shutdown()` 方法清理线程池

**选择**: 在 `ParserService` 增加 `shutdown()` 方法，调用 `_executor.shutdown(wait=True)`

**理由**: 线程池作为实例变量后，需要在服务停止时显式清理，避免线程泄漏。当前代码无此逻辑。

### Decision 4: DDL→DML 顺序保持不变

**选择**: 不修改 `WarehouseSQLParser.parse_directory` 的两阶段逻辑

**理由**: 当前实现已正确保证 DDL 先于 DML 执行（同一系统内串行），且 DDL 结果注入 DMLParser 是核心依赖。并发提升仅影响 L1（不同系统间并行），不影响 L2（系统内串行）。

### Decision 5: `ParserRegistry.parse_directory` 保持现有策略

**选择**: 保持 `needs_directory_parse` 判断逻辑，WarehouseSQLParser 仍走 `parse_directory`

**理由**: WarehouseSQLParser 的两阶段逻辑需要完整目录视图，逐文件调用会破坏 DDL→DML 依赖。

## Risks / Trade-offs

- **[内存峰值增加]** → 6个数据源同时解析时内存约为当前的 3 倍。缓解：`_datasource_workers` 可配置，必要时降低；每个数据源的 DDL 解析结果在 DML 解析完成后即可释放
- **[线程竞争]** → 多线程同时写 `ParseResult`。缓解：已有 `_result_lock` 保护，`ParseResult.merge` 操作在锁内完成
- **[日志交叉]** → 6个数据源并发时日志混合。缓解：日志中已有数据源名称标识，可按 name 过滤
- **[向后兼容]** → 无破坏性变更。`_datasource_workers` 默认值 6 大于原硬编码 2，仅提升并发度
