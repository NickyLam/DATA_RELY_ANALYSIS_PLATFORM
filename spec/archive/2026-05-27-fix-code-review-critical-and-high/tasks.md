# Implementation Tasks

基于 `docs/CODE_REVIEW_REPORT.md` 的问题分级，按依赖顺序排列。

---

## Phase 1 — P0 数据正确性 + 安全 (CRITICAL)

### 1.1 [C1] 修复 TracerFactory 缓存失效链路

- [x] `tracer_factory.py`: 确保 `invalidate()` 方法清空 `lineage_tracer`/`caliber_tracer`/`unified_tracer` 三个缓存
- [x] `parser_service.py:379-383`: 在 `parse_existing_data` 赋值 `_current_result` 后，调用 `self._tracer_factory.invalidate()`
- [x] `parser_service.py:460-463`: 在 `parse_uploaded_files` merge 完成后，调用 `self._tracer_factory.invalidate()`
- [x] `lineage_service.py:58-60`: 在 `_on_data_changed` 中，添加 `self.parser._tracer_factory.invalidate()` 调用
- [x] 测试：解析后立即查询，验证 tracer 使用新数据

### 1.2 [C2] 修复 CaliberInfo merge 去重 key

- [x] `parser_service.py:168-174`: 将 `ci.get("source_table", "")` 替换为 `CaliberTracer._get_source_table(ci)`，`source_column` 同理
- [x] 测试：构造 `CaliberInfo.to_dict()` 格式的记录，验证 merge 去重正确

### 1.3 [C5] 修复文件上传路径穿越

- [x] `file_handler.py:58-59`: 使用 `Path(file.filename).name` 剥离路径部分，仅保留文件名
- [x] 添加 `save_path.resolve()` 是否在 `task_dir.resolve()` 内的校验
- [x] 测试：上传文件名包含 `../` 的文件，验证写入路径不逃逸

### 1.4 [H4] 修复字段名子串匹配

- [x] `lineage_service.py:887`: 将 `field_upper in tgt_col` 改为 `field_upper == tgt_col`
- [x] 检查 `lineage_service.py` 中其他类似的子串匹配位置，一并修正
- [x] 测试：搜索字段 `"ID"` 不再匹配 `"VALID"`

---

## Phase 2 — P1 接口标准化 + 安全 (CRITICAL/HIGH)

### 2.1 [C3] 统一 API 响应格式

- [x] `app/models/__init__.py`: 新增统一响应模型 `UnifiedResponse(data=Any, code=int=0, message=str="")`
- [x] `app/main.py`: 添加全局异常处理器，返回 `UnifiedResponse(code=500, message="服务内部错误")` + 500 状态码
- [x] `app/api/indicator.py`: 所有端点改为返回 `UnifiedResponse`，异常时使用正确的 HTTP 状态码 (4xx/5xx)
- [x] `app/api/system.py`: `force_reparse` 失败返回 500；`health_check` 保持当前格式
- [x] `app/api/lineage.py`: `query_lineage`、`rebuild_cache` 添加 try/except，返回统一格式
- [x] 前端 `static/js/*.js`: 适配新的统一响应格式 (`response.code` 代替 `response.success`)
- [x] 测试：验证所有端点的成功/失败响应格式一致

### 2.2 [C4] 参数枚举校验

- [x] `indicator.py:72`: `direction` 改为 `direction: IndicatorQueryMode = Query(...)`，使用枚举约束
- [x] `indicator.py:286`: `direction` 同上
- [x] `indicator.py:289`: `data_source` 添加 `Literal["oracle", "tdh", "gbase"]` 约束
- [x] `indicator.py:21`: `keyword` 添加空白字符串检查 `keyword.strip() or HTTPException(400)`
- [x] `parse.py:48`: 移除未使用的 `schema_name` 参数
- [x] 测试：发送非法 direction 值，验证返回 422

### 2.3 [C6] 破坏性端点 API Key 认证

- [x] `app/config.py`: 新增 `API_KEY: str = ""` 配置项，从环境变量 `API_KEY` 读取
- [x] `app/dependencies.py`: 新增 `verify_api_key` 依赖，检查 `X-API-Key` header
- [x] `system.py`: `/api/system/reparse` 和 `/api/cache/rebuild` 添加 `Depends(verify_api_key)`
- [x] `parse.py`: `/api/parse/upload` 和 `/api/parse/parse-existing` 添加 `Depends(verify_api_key)`
- [x] `start.sh`: 添加 `--api-key` 参数，导出 `API_KEY` 环境变量
- [x] 文档：更新 README 说明 API Key 配置方式
- [x] 测试：无 Key 请求返回 401，有 Key 请求正常

### 2.4 [H8] 错误信息脱敏

- [x] `indicator.py`: 所有 `str(e)` 替换为固定消息如 `"搜索失败，请稍后重试"`，异常详情写入 `logger.error`
- [x] `system.py:238`: 同上
- [x] `app/main.py`: 全局异常处理器确保 `DEBUG=False` 时不暴露堆栈
- [x] 测试：验证错误响应不含文件路径或异常堆栈

### 2.5 [H10] 修复 innerHTML XSS

- [x] `search-panel.js:49-56`: 表名/schema 使用 `escapeHtml()` 转义，onclick 改为 addEventListener 或用 `data-*` 属性
- [x] `parse-tab.js:363-378`: 表名/过程名使用已有 `escapeHtml()` 转义
- [x] `detail-panel.js:62-67`: targetTable/targetField 使用已有 `_escape()` 函数
- [x] `indicator-tab.js:216-279`: 指标数据转义
- [x] 新增 `static/js/utils/escape.js`: 统一 `escapeHtml` 函数，所有文件引用
- [x] 测试：表名含 `<script>` 标签时不执行脚本

### 2.6 [H11] 修正 CORS 配置

- [x] `main.py:143`: 开发模式改为 `allow_origins=["http://localhost:*", "http://127.0.0.1:*"]`
- [x] 移除 `allow_credentials=True` + `["*"]` 组合
- [x] 添加 `PRODUCTION` 环境变量文档说明
- [x] 测试：验证跨域请求行为正确

### 2.7 [H1] 修复 _dict_to_record join_conditions 回退

- [x] `caliber_tracer.py:963`: 将 `"join_conditions"` 改为 `"join_clauses"`
- [x] `caliber_tracer.py:971`: 对 `join_clauses` (list[str]) 做 `[{"raw_text": c} for c in join_conds]` 转换，兼容 `_CaliberSourceRecord.join_conditions` 的 `list[dict]` 类型
- [x] 测试：构造无顶层 join_conditions 的 dict，验证回退正确

### 2.8 [H2] 修复下游追溯 max_depth 边界

- [x] `caliber_tracer.py:414-432`: 在 `current.depth >= max_depth` 时，仅记录当前节点为叶子路径，不创建子节点（与上游行为一致）
- [x] 测试：验证下游追溯最深深度不超过 max_depth

---

## Phase 3 — P2 健壮性 (HIGH)

### 3.1 [H5] EventBus 线程安全

- [x] `event_bus.py:34-42`: `publish` 中 `list(self._handlers.get(event_type, []))` 做快照迭代
- [x] `event_bus.py:38`: handler 异常时用 `getattr(handler, '__name__', repr(handler))` 避免 AttributeError
- [x] `event_bus.py:48-55`: 全局单例使用 `threading.Lock` 保护初始化
- [x] 测试：多线程并发 publish/subscribe 不崩溃

### 3.2 [H6] ProcedureParser 口径去重

- [x] `procedure_parser.py:312-326`: 添加 `(mapping.target_table, mapping.target_column, op.step_num)` 去重集合
- [x] 同一 (目标表, 目标列, 步骤号) 组合只生成一条 CaliberInfo
- [x] 测试：目标表出现在多个步骤时，口径记录不重复

### 3.3 [H7] _find_mapping_step 回退逻辑修正

- [x] `procedure_parser.py:362-363`: 移除无条件的第一个步骤回退，改为返回 `0` (无步骤) 或基于目标表匹配的步骤
- [x] 测试：无匹配步骤时不分配无关 step_num

### 3.4 [H9] 端点输入校验补全

- [x] `lineage.py:110,164,184`: `table`/`field` 参数添加 `max_length=128` 和字符白名单校验
- [x] `parse.py:142,167`: `task_id` 校验为 UUID 格式
- [x] `lineage.py:279`: 废弃端点添加 `deprecated=True` 和 `Deprecation` 响应头
- [x] 测试：非法输入返回 422

### 3.5 [H12] 速率限制 + 线程池上限

- [x] `requirements.txt`: 添加 `slowapi` 依赖
- [x] `main.py`: 配置 `Limiter`，全局 60 req/min
- [x] `parse.py`: 解析端点单独限流 5 req/min
- [x] `parser_service.py:202`: 使用共享 `ThreadPoolExecutor(max_workers=2)`，删除泄漏的类级 executor
- [x] 测试：超限请求返回 429

---

## Phase 4 — P2 MEDIUM 级补充修复 (可选)

### 4.1 [M1] _current_result 并发保护

- [x] `parser_service.py`: 赋值和读取 `_current_result` 时使用 `_result_lock`
- [x] 或改为 `threading.local()` + copy-on-write 模式

### 4.2 [M2] SQLite 事务一致性

- [x] `sqlite_store.py:219-235`: DELETE + 首批 INSERT 放同一事务
- [x] 后续批次保持分批事务

### 4.3 [M3] 缓存刷新 TOCTOU

- [x] `lineage_service.py:494-521`: 添加 `_cache_lock`，刷新期间阻塞查询

### 4.4 [M4] 缓存保存失败通知

- [x] `cache_store.py:80-102`: 失败时发布 `CACHE_SAVE_FAILED` 事件
- [x] 或在 `parser_service` 中检查返回值并写入 result.errors

### 4.5 [M5] 版本号体系统一

- [x] `protocol.py`: 移除 `CACHE_SCHEMA_VERSION = "v4"`，统一使用 `migrations.py` 的 `SCHEMA_VERSION`

### 4.6 [M11] 安全响应头

- [x] `main.py`: 添加中间件设置 `X-Content-Type-Options: nosniff`、`X-Frame-Options: DENY`、`Content-Security-Policy: default-src 'self'`

### 4.7 [M12] temp_uploads 清理

- [x] `parse.py`: 解析完成后调用 `FileHandler.cleanup_task_files(task_id)`
- [x] 添加定时任务：启动时清理超过 24 小时的临时文件

### 4.8 [M6] is_upstream_of_target 深度限制

- [x] `lineage_service.py:629-646`: 添加 `max_depth=5` 参数，防止无限 BFS

### 4.9 [M8] FieldMapping 重复定义清理

- [x] `models.py:109-161`: 删除第一组 `to_dict()`/`from_dict()` 定义

### 4.10 [M7] O(N*M) 性能优化

- [x] `lineage_service.py`: 将 `table_to_upstream`/`target_map`/`source_map` 构建移到索引阶段，缓存复用
- [x] `_is_node_in_set` 改用 set 查找代替遍历

---

## 验证任务

- [x] 运行全部单元测试 `pytest tests/` — 确认无回归（36 passed，caliber_api 13 errors 为预存问题）
- [x] 运行 API 测试 — 确认响应格式统一
- [ ] 手动验证：解析数据后查询，确认使用新 Tracer
- [ ] 手动验证：上传路径穿越文件名，确认被拦截
- [ ] 手动验证：XSS 载荷表名，确认不执行脚本
- [ ] 手动验证：无 API Key 调用破坏性端点，确认返回 401
