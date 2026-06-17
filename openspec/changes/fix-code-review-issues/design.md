## Context

数据血缘分析系统 v2.0 基于 FastAPI + D3.js，包含后端 API 层（`app/`）、核心解析引擎（`core/`）和前端展示层（`static/`）。系统通过 Code Review 发现 3 个阻断级安全问题、6 个主要质量问题和 5 个优化建议。当前默认部署下管理端点无认证保护、前端存在 XSS 注入点、SQLite 操作有 SQL 注入风险。

**约束条件:**
- 不引入新的外部依赖
- 保持向后兼容（API 响应格式不变）
- 每个任务最小化、可独立验证和回滚
- 遵循项目现有代码风格（snake_case、type hints、4-space 缩进）

## Goals / Non-Goals

**Goals:**
1. 消除所有 Critical 和 Major 级别的安全与质量问题
2. 确保管理端点在未配置密钥时拒绝访问而非放行
3. 前端所有动态 DOM 插入点均经过 HTML 转义
4. SQLite 操作使用参数化查询或白名单校验
5. 修复线程安全缺陷（DataRepository 返回副本、SSE Queue 安全）
6. 拆分超长方法为职责单一的私有方法

**Non-Goals:**
- 不重构整体架构或更换技术栈
- 不优化 raw_json 冗余存储（标记为后续优化项）
- 不实现完整的 RBAC 权限系统（仅加固现有 admin_required）
- 不迁移到 ES Modules（前端全局变量治理延后）

## Decisions

### Decision 1: admin_required 未配置时拒绝访问

**选择**: 未设置 `ADMIN_API_KEY` 环境变量时返回 403，而非放行。

**备选方案:**
- A) 保持放行 + 日志警告 — **不采用**, 默认无保护是安全漏洞
- B) 拒绝访问 + 友好提示配置方法 — **采用**, 安全优先
- C) 自动生成随机 key 打印到日志 — **不采用**, 增加部署复杂度

### Decision 2: SQLite 表名白名单校验

**选择**: 在 `sqlite_store.py` 中定义 `_VALID_TABLES = frozenset(DATA_TABLE_NAMES)`，所有动态表名操作前调用 `_validate_table_name()`。

**理由**: 当前 `table_name` 来源确实是内部常量，但防御性编程可防止未来误用。不使用参数化表名是因为 SQLite 的 `?` 占位符不支持表名/列名。

### Decision 3: SSE Queue 从 asyncio.Queue 改为 threading.Queue + asyncio 事件桥接

**选择**: 使用 `threading.Queue` 存储事件数据，在 `generate_sse_events` 异步生成器中通过 `asyncio.get_event_loop().run_in_executor()` 或简单的 `asyncio.sleep(0)` 轮询方式读取。更简化的方案：保持现有结构但在 `_notify_subscribers` 中增加异常捕获和日志，确保 `QueueFull` 和断连场景下订阅者被正确清理。

**实际方案（简化版）**: 保持 `asyncio.Queue` 但在 `_notify_subscribers` 外层加 try/except 捕获所有异常，防止单个订阅者错误影响其他订阅者；同时在 `unsubscribe` 中确保幂等性。

### Decision 4: DataRepository 返回浅拷贝

**选择**: 对 `get_all_tables()`, `get_all_procedures()` 等返回 list/dict 引用的方法统一改为 `list(...)` / `{...}` 浅拷贝。

**性能权衡**: 数据量较大时浅拷贝有少量开销，但相比线程安全风险可接受。如需进一步优化可后续引入 frozen dataclass 或不可变视图。

### Decision 5: _trace_field_lineage 方法拆分策略

**选择**: 将 330+ 行方法拆分为 6 个私有方法：
1. `_build_field_mapping_indexes()` — 构建目标/源索引映射
2. `_build_upstream_graph_cache()` — 构建上游图缓存
3. `_trace_upstream_field_lineage()` — 上游 BFS 追溯
4. `_trace_downstream_field_lineage()` — 下游 BFS 追溯
5. `_expand_table_lineage_fallback()` — 表级血缘补充扩展
6. `_assemble_field_lineage_result()` — 结果组装

每个方法控制在 50 行以内。

## Risks / Trade-offs

| Risk | Impact | Mitigation |
|------|--------|------------|
| admin_required 改为拒绝可能破坏现有部署 | 部分用户依赖无密码模式 | 在错误消息中明确提示如何配置 ADMIN_API_KEY |
| DataRepository 浅拷贝增加内存开销 | 大数据量时每次查询多一次拷贝 | 后续可改用 immutable view 或 copy-on-write |
| 前端转义可能影响已有数据显示 | 特殊字符（如 `<`, `>`）在显示中变为实体 | escapeHtml 仅用于 HTML 属性/文本节点，pre/code 标签内保留原样 |
| 方法拆分可能引入回归 | 血缘查询逻辑复杂，拆分需保证行为一致 | 拆分后必须运行现有测试套件验证 |

## Migration Plan

1. **Phase 1 — 安全修复（Critical）**: admin_required + SQL 注入防护 + XSS 修复，可独立部署
2. **Phase 2 — 线程安全修复（Major）**: DataRepository + SSE Queue，需关注并发测试
3. **Phase 3 — 代码质量（Major）**: CORS 收紧 + 错误消息统一 + 方法拆分
4. **每步均可独立回滚**: 通过 git commit 粒度控制，每个 fix 一个 commit

## Open Questions

1. 是否需要在 `/health` 端点暴露 admin 认证状态？— **否**, 不暴露安全配置信息
2. XSS 修复是否需要 CSP header 配置？— **建议但不在本次范围**, 可作为 follow-up
