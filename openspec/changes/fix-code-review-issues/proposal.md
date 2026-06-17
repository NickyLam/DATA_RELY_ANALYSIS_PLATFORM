## Why

Code Review（ghb-code-review）发现 **3 个阻断级问题**、**6 个主要问题**、**5 个建议**，涵盖 SQL 注入风险、认证绕过、前端 XSS、线程安全、方法过长等安全性和可维护性问题。这些问题在默认部署下可能导致系统被未授权操作或数据泄露，必须在上线前修复。

## What Changes

### 阻断级修复（Critical）
- **修复 admin_required 认证绕过**: 未配置 `ADMIN_API_KEY` 时管理端点完全无保护，改为拒绝访问
- **修复 SQLite 表名拼接 SQL 注入风险**: `sqlite_store.py` 中 f-string 拼接表名添加白名单校验
- **修复 SSE 订阅者队列泄漏与线程安全**: `asyncio.Queue` 在同步线程中使用不安全，改用线程安全方案

### 主要修复（Major）
- **修复 search-panel.js XSS**: 搜索结果中 `table.schema`/`short_name` 未转义直接插入 innerHTML
- **修复 detail-panel.js XSS**: 字段映射显示时 `srcShort`/`srcCol` 等值未调用 `_escape()`
- **修复 DataRepository 线程安全**: `get_all_tables()` 等方法返回内部可变对象引用，改为返回浅拷贝
- **收紧 CORS 配置**: 移除不必要的 `allow_credentials=True`
- **统一错误消息**: 避免在 API 响应中包含用户输入的原始值
- **拆分 _trace_field_lineage 超长方法**: 330+ 行方法拆分为多个职责单一的私有方法

### 建议优化（Suggestion）
- 文件上传增加 Content-Type 校验
- lru_cache 依赖失效策略优化
- SQLite raw_json 冗余存储评估
- 缓存命中深拷贝性能优化
- 前端全局变量污染治理

## Capabilities

### New Capabilities
- `admin-auth-hardening`: 管理 API 认证加固 — 强制要求配置 ADMIN_API_KEY，未配置时拒绝所有管理请求
- `sql-injection-prevention`: SQL 注入防护 — SQLite 操作表名白名单校验 + 参数化查询强化
- `xss-mitigation`: 前端 XSS 防护 — 所有动态 DOM 插入点统一使用 escapeHtml/_escape 转义
- `thread-safety-fixes`: 线程安全修复 — DataRepository 返回副本 + SSE Queue 线程安全改造

### Modified Capabilities
- 无现有 spec 需修改（本次为纯代码质量修复，不涉及功能行为变更）

## Impact

**后端影响文件:**
- `app/dependencies.py` — admin_required 逻辑变更
- `app/services/storage/sqlite_store.py` — 表名白名单校验
- `app/services/progress_service.py` — Queue 线程安全改造
- `app/repository.py` — get_* 方法返回浅拷贝
- `app/main.py` — CORS 配置调整 + 错误消息统一
- `app/services/lineage_service.py` — _trace_field_lineage 方法拆分

**前端影响文件:**
- `static/js/search-panel.js` — innerHTML 转义补全
- `static/js/detail-panel.js` — innerHTML 转义补全

**测试影响:**
- `tests/test_lineage_api.py` — 新增认证测试用例
- `tests/frontend_e2e_test.py` — 可选：新增 XSS 防护回归测试

**无破坏性变更 (Breaking Changes): 无**
