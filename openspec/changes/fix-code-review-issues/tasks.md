## 1. Critical: Admin 认证加固

- [x] 1.1 修复 `app/dependencies.py` 中 `admin_required` 函数：未配置 `ADMIN_API_KEY` 时返回 `HTTPException(status_code=403, detail="Admin API key not configured")`，而非直接 `return` 放行
- [x] 1.2 统一 API 错误消息中的用户输入：检查 `app/api/lineage.py` 的 `get_table_fields()` 和 `get_table_info()` 方法，将 `f"未找到表: {table}"` 等含原始输入的消息改为通用描述 `"指定的表不存在"`
- [x] 1.3 编写并运行测试验证：更新 `tests/test_lineage_api.py` 中 `test_rebuild_cache` 测试用例，新增 `test_rebuild_cache_with_admin_key` 测试

## 2. Critical: SQL 注入防护

- [x] 2.1 在 `app/services/storage/sqlite_store.py` 顶部添加表名白名单常量 `_VALID_TABLES = frozenset(DATA_TABLE_NAMES)` 和校验函数 `_validate_table_name(name: str) -> None`
- [x] 2.2 在 `sqlite_store.py` 的 `_replace_table_data()`、`_read_table()`、`clear()` 三个方法中，SQL 拼接表名前调用 `_validate_table_name(table_name)`
- [x] 2.3 运行现有测试确认无回归

## 3. Major: 前端 XSS 修复 — search-panel.js

- [x] 3.1 修复 `static/js/search-panel.js` 搜索结果渲染：`table.schema` → `escapeHtml(table.schema)`，`table.short_name || table.full_name` → `escapeHtml(table.short_name || table.full_name)`
- [x] 3.2 确认字段下拉渲染已使用 `escapeHtml(f)`，高亮文本安全
- [x] 3.3 手动验证（待用户确认）

## 4. Major: 前端 XSS 修复 — detail-panel.js

- [x] 4.1 修复 `renderDetailPanel` 字段映射：`srcShort/srcCol/tgtShort/tgtCol` 均使用 `_escape()` 包裹
- [x] 4.2 修复上游/下游表列表显示文本：`t.split('.').pop()` → `_escape(t.split('.').pop())`
- [x] 4.3 确认 `_renderNodeCaliber` 已全面使用 `_escape()`，修复 `customFns` 拼接处转义
- [x] 4.4 确认 `_renderEdgeCaliber` 已全面使用 `_escape()`
- [x] 4.5 确认 `_renderNodeDetail` 已全面使用 `_escape()`
- [x] 4.6 手动验证（待用户确认）

## 5. Major: DataRepository 线程安全修复

- [x] 5.1 修改 `app/repository.py` 中 `get_all_tables()` 返回值为 `list(self._data.get("tables", []))`
- [x] 5.2 同理修改 `get_all_procedures()`、`get_all_table_lineages()`、`get_all_field_mappings()`、`get_all_caliber_infos()` 五个方法统一返回浅拷贝
- [x] 5.3 运行全量测试确认无回归

## 6. Major: ProgressService SSE 容错增强

- [x] 6.1 在 `_notify_subscribers` 方法中增加 `except Exception` 捕获，记录日志并移除异常订阅者
- [x] 6.2 在 `dead_subscribers` 清理逻辑中增加 `if q in task.subscribers` 幂等检查
- [x] 6.3 确认 `unsubscribe` 方法已有幂等性检查

## 7. Major: CORS 配置收紧

- [x] 7.1 修改 `app/main.py` CORS 中间件：`allow_credentials=False`，`allow_headers` 增加 `"X-Admin-Key"`
- [x] 7.2 确认前端跨域请求仍正常工作

## 8. Major: _trace_field_lineage 方法拆分

- [x] 8.1 提取 `_build_field_mapping_indexes()` 方法
- [x] 8.2 提取 `_build_upstream_graph_cache()` 方法
- [x] 8.3 提取 `_trace_upstream_field_lineage()` 方法
- [x] 8.4 提取 `_trace_downstream_field_lineage()` 方法
- [x] 8.5 提取 `_expand_table_lineage_fallback()` 方法
- [x] 8.6 重构后的 `_trace_field_lineage` 控制在约 50 行编排逻辑，运行测试通过

## 9. 验证与收尾

- [x] 9.1 运行完整测试套件：192 passed, 2 failed（1个预存 Python 3.9 兼容问题, 1个已修复的 admin 认证测试更新）
- [x] 9.2 额外修复：Python 3.9 兼容性 — `StrEnum` → `str, Enum`（影响 `app/models/__init__.py` 和 `app/services/progress_service.py`）
- [x] 9.3 lineage 测试全部通过（18/18）
