## 1. 线程池实例化改造

- [x] 1.1 将 `_shared_executor` 从 ParserService 类变量改为实例变量，在 `__init__` 中使用 `self._datasource_workers` 创建 `self._executor`
- [x] 1.2 删除类变量 `_shared_executor = ThreadPoolExecutor(max_workers=2)`
- [x] 1.3 在 `parse_existing_data` 中将所有 `ParserService._shared_executor` 引用替换为 `self._executor`

## 2. 线程池生命周期管理

- [x] 2.1 在 ParserService 中增加 `shutdown()` 方法，调用 `self._executor.shutdown(wait=True)`
- [x] 2.2 增加 `__del__` 方法作为 best-effort 清理兜底，调用 `shutdown()`
- [x] 2.3 在 `stop.sh` 或应用退出逻辑中调用 `shutdown()`（如适用）

## 3. DDL→DML 顺序验证

- [x] 3.1 审查 `WarehouseSQLParser.parse_directory` 的两阶段逻辑，确认并发场景下 DDL→DML 顺序不变
- [x] 3.2 审查 `ParserRegistry.parse_directory` 的 `needs_directory_parse` 判断，确认 WarehouseSQLParser 仍走 `parse_directory` 路径
- [x] 3.3 确认各数据源的 WarehouseSQLParser 实例独立（DDL 结果不跨系统污染）— 发现竞态条件并修复：`self._dml_parser` 改为局部变量 `local_dml_parser`

## 4. 测试验证

- [x] 4.1 编写单元测试：验证线程池 `max_workers` 使用配置值而非硬编码
- [x] 4.2 编写单元测试：验证 `shutdown()` 方法正确关闭线程池
- [x] 4.3 运行现有测试套件 `python -m pytest tests/` 确保无回归（102 passed）
- [ ] 4.4 手动验证：启动应用解析全部数据源，确认并发度提升且 DDL→DML 顺序正确
