## ADDED Requirements

### Requirement: DataRepository query methods must return defensive copies
`DataRepository` 类的所有读取方法（`get_all_tables()`, `get_all_procedures()`, `get_all_table_lineages()`, `get_all_field_mappings()`, `get_all_caliber_infos()`）SHALL 返回内部数据的浅拷贝而非直接引用，防止调用方在锁外修改内部状态。

#### Scenario: 调用方修改返回值不影响内部数据
- **WHEN** 外部代码调用 `get_all_tables()` 并对返回的 list 执行 `append()` 或 `pop()` 操作
- **THEN** DataRepository 内部的 `_data["tables"]` SHALL 保持不变

#### Scenario: 多线程并发读取不产生竞态条件
- **WHEN** 线程 A 调用 `get_all_tables()` 获得引用的同时线程 B 调用 `update()` 替换数据
- **THEN** 线程 A 持有的引用 SHALL 是 update 之前的数据快照（浅拷贝）

### Requirement: ProgressService subscriber notification must be fault-tolerant
`ProgressService._notify_subscribers()` 方法在向每个订阅者推送事件时 SHALL 捕获所有异常，确保单个订阅者的错误不影响其他订阅者的事件接收。

#### Scenario: 单个订阅者 Queue 已满时不影响其他订阅者
- **WHEN** 某个订阅者的 asyncio.Queue 已满（达到 maxsize=100）
- **AND** `_notify_subscribers()` 尝试向其 put_nowait
- **THEN** 该订阅者被标记为 dead 并从 subscribers 列表中移除
- **AND** 其他订阅者仍能正常收到后续事件

#### Scenario: 订阅者断连后资源被清理
- **WHEN** SSE 客户端断开连接导致 `generate_sse_events` 生成器退出
- **THEN** 其 finally 块中 MUST 调用 `unsubscribe()` 从任务的 subscribers 列表中移除对应 Queue

### Requirement: _trace_field_lineage method must be decomposed into single-responsibility methods
`LineageService._trace_field_lineage()` 方法 SHALL 被拆分为多个私有方法，每个方法的行数不超过 80 行，职责单一。

#### Scenario: 上游追溯逻辑独立于下游追溯
- **WHEN** 需要仅追踪上游血缘
- **THEN** 仅调用 `_trace_upstream_field_lineage()` 方法
- **AND** 该方法 SHALL 不包含下游追溯的任何逻辑

#### Scenario: 索引构建与 BFS 遍历分离
- **WHEN** 执行字段级血缘查询
- **THEN** 索引映射构建（target_map / source_map / upstream cache）SHALL 在独立的 `_build_field_mapping_indexes()` 方法中完成
