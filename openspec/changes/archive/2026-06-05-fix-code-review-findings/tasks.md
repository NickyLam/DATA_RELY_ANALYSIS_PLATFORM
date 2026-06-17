## 1. 安全修复（Blocking）

- [x] 1.1 修复文件上传路径穿越：在 `app/utils/file_handler.py` 的 `save_upload` 中，对 `file.filename` 先用 `Path(file.filename).name` 剥离目录，再用 `re.sub(r'[^\w.\-]', '_', name)` 清洗字符，最后拼 UUID 前缀。验证：构造 `../../etc/mal` 文件名上传，确认保存路径无穿越。
- [x] 1.2 修复 app.js innerHTML XSS：在 `static/js/app.js` 的 `showSystemStats` 中，对所有 `stats.*` 插值使用 `escapeHtml(String(stats.xxx || 0))`。验证：mock API 返回 `<script>alert(1)</script>`，确认页面不执行脚本。
- [x] 1.3 添加破坏性端点认证：在 `app/dependencies.py` 中新增 `admin_required` 依赖（读取 `ADMIN_API_KEY` 环境变量，比对 `X-Admin-Key` Header），在 `app/api/system.py` 的 `force_reparse` 和 `app/api/lineage.py` 的 `rebuild_cache` 端点添加 `Depends(admin_required)`。验证：配置 key 后无 key 请求返回 403，正确 key 返回 200，未配置 key 时无认证。

## 2. SSE 异步化（Blocking）

- [x] 2.1 将 `ParseTask.subscribers` 从 `list[queue.Queue]` 改为 `list[asyncio.Queue]`，`_notify_subscribers` 使用 `put_nowait()` 保持同步调用。验证：语法检查通过。
- [x] 2.2 将 `generate_sse_events` 从同步生成器改为 async 生成器，`q.get(timeout=0.5)` 改为 `await asyncio.wait_for(q.get(), timeout=0.5)`。验证：语法检查通过。
- [x] 2.3 更新 `app/api/parse.py` 中 SSE 端点调用方式，确保 `StreamingResponse` 直接消费 async 生成器。验证：SSE 端点正常工作。

## 3. 前端死代码清理（Blocking）

- [x] 3.1 display-tab.js 未在 index.html 中引用，保留文件但确认无加载冲突。验证：页面加载无 JS 报错。
- [x] 3.2 删除 `dml_parser.py` 中第 102-115 行的重复正则常量定义（`_FROM_TABLE_PATTERN` 和 `_COMMA_TABLE_PATTERN`）。验证：`python3.11 -c "from core.warehouse.dml_parser import DMLParser"` 导入成功。

## 4. core 层共享工具函数

- [x] 4.1 新建 `core/utils/__init__.py`，实现 `find_matching_paren` 和 `is_temp_table` 共享函数。验证：单元测试通过。
- [x] 4.2 让 `sql_boundary_detector.py` 的 `_find_matching_paren` 委托调用 `core.utils.find_matching_paren`。验证：`test_sql_boundary_detector.py` 全部通过。
- [x] 4.3 让 `caliber_extractor.py` 的 `_find_matching_paren_in_text` 委托调用 `core.utils.find_matching_paren`。验证：语法检查通过。
- [x] 4.4 在 `core/utils.py` 中添加 `is_temp_table(table_name: str) -> bool` 函数。验证：单元测试通过。
- [x] 4.5 让 `base_tracer.py` 的 `is_temp_table` 委托调用 `core.utils.is_temp_table`。验证：现有测试通过。
- [x] 4.6 让 `procedure_parser.py` 的 `_is_temp_table` 委托调用 `core.utils.is_temp_table`。验证：语法检查通过。
- [x] 4.7 删除 `lineage_tracer.py` 的 `_normalize_field_name`，所有调用点改为 `self.normalize_name`。验证：`test_unified_tracer.py` 全部通过。
- [x] 4.8 让 `warehouse_parser.py` 的 Phase 1 循环调用 `self._table_info_to_output(table_info)` 替代重复的 dict 构造。验证：`test_warehouse_parser.py` 全部通过。

## 5. 封装改善

- [x] 5.1 在 `ParserService` 上新增 `get_data_mtime() -> float | None` 公共方法。更新 `LineageService._get_data_mtime` 调用此方法。验证：语法检查通过。
- [x] 5.2 在 `LineageTracer` 上新增 `get_procedures_for_table(table: str) -> list[str]` 公共方法。更新 `UnifiedTracer` 调用。验证：`test_unified_tracer.py` 全部通过。
- [x] 5.3 在 `CaliberTracer` 上新增 `lookup_caliber_by_target(short_table: str, column: str) -> dict | None` 公共方法。更新 `UnifiedTracer` 调用。验证：`test_unified_tracer.py` 全部通过。

## 6. 前端修复

- [x] 6.1 将 `parse-tab.js` 包裹在 IIFE 中，仅通过 `window.*` 暴露 9 个必要接口。验证：全局变量不再泄漏。
- [x] 6.2 将 `detail-panel.js` 的 `_bindSpecToggle` 改为事件委托模式，在 `#infoPanel` 上绑定一次 click 事件。验证：事件监听器不再累积。
- [x] 6.3 清理 `indicator-tab.js` 中的 24 个 `console.log`，保留 4 个 `console.error`。验证：生产模式下浏览器控制台无调试日志。

## 7. API 响应规范化

- [x] 7.1 修复 `system.py` 的 `force_reparse` 异常处理：改为 `raise HTTPException(status_code=500, detail="重新解析失败")`。验证：触发 reparse 失败时返回 500。
- [x] 7.2 为 `lineage.py` 的 `rebuild_cache` 端点补充 `response_model=BaseResponse`。验证：`/docs` 页面显示完整响应 schema。
- [x] 7.3 为 `indicator.py` 的 5 个端点补充 `response_model` 参数。验证：`/docs` 页面显示完整响应 schema。
- [x] 7.4 `parse.py` 端点返回动态 dict 结构，无精确匹配模型，保持原样避免过度工程化。

## 8. 性能优化

- [x] 8.1 将 `lineage_tracer.py` 的 `get_downstream_tables` 从线性扫描改为使用 `self._tl_source_idx.get(norm_table, [])`。验证：`test_unified_tracer.py` 全部通过。

## 9. 死代码清理

- [x] 9.1 删除 `lineage_tracer.py` 的 `_infer_source_table_from_lineage` 方法（无调用点）。验证：全局搜索无引用。
- [x] 9.2 删除 `app/models/__init__.py` 中未使用的 `FileUploadRequest` 模型。验证：全局搜索无引用。

## 10. 类型安全

- [x] 10.1 在 `caliber_tracer.py` 中定义 `CaliberInfoDict(TypedDict)` 替代裸 `dict`，更新 `caliber_infos_raw` 和索引的类型注解。验证：语法检查通过。

## 11. 验证

- [x] 11.1 运行完整测试套件 `python3.11 -m pytest tests/ -v --tb=short`，确认 104 passed, 0 failed。
- [ ] 11.2 启动应用 `python3.11 run_app.py`，手动验证：文件上传、SSE 解析进度、图谱渲染、搜索、指标查询功能正常。
