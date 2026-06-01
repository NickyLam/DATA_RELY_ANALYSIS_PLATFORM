# Proposal: Code Review Critical & High 修复

**Change ID**: `fix-code-review-critical-and-high`
**Status**: DRAFT
**Created**: 2026-05-27
**Source**: `docs/CODE_REVIEW_REPORT.md` — 全量 Code Review

---

## Why

全量 Code Review 发现 **6 个 CRITICAL + 12 个 HIGH** 级问题，涉及：

1. **数据正确性**：TracerFactory 缓存失效链路断裂，解析后查询仍返回旧数据；CaliberInfo 去重 key 与序列化格式不匹配导致口径记录错误合并或遗漏；字段名子串匹配返回不相关映射
2. **接口规范性**：5 种不同的响应格式并存；direction 等参数无枚举校验；错误信息泄露内部实现
3. **安全性**：文件上传路径穿越；innerHTML XSS 6 处；CORS 配置不当；无认证无限流；破坏性端点完全开放

这些问题可导致生产环境数据查询错误、接口不可用、安全漏洞被利用。需要分优先级系统性修复。

---

## What Changes

### Phase 1 — P0 数据正确性 + 安全 (CRITICAL)

| # | 变更 | 影响范围 |
|---|------|---------|
| C1 | TracerFactory 缓存失效：解析完成后调用 `invalidate()` | `parser_service.py`, `lineage_service.py`, `tracer_factory.py` |
| C2 | CaliberInfo merge 去重 key 使用 `_get_source_table`/`_get_source_column` | `parser_service.py` |
| C5 | 文件上传路径穿越防护 | `file_handler.py` |
| H4 | 字段名子串匹配改为精确匹配 | `lineage_service.py` |

### Phase 2 — P1 接口标准化 + 安全 (CRITICAL/HIGH)

| # | 变更 | 影响范围 |
|---|------|---------|
| C3 | 统一 API 响应信封 + 正确 HTTP 状态码 | `app/api/*`, `app/models/__init__.py` |
| C4 | direction/data_source 参数枚举校验 | `indicator.py`, `lineage.py` |
| C6 | 破坏性端点添加 API Key 认证 | `main.py`, `dependencies.py`, `system.py`, `parse.py` |
| H8 | 错误信息脱敏，不暴露内部实现 | `indicator.py`, `system.py` |
| H10 | innerHTML XSS 修复 — 使用已有 `_escape`/`escapeHtml` | `static/js/*` |
| H11 | 修正 CORS 配置 | `main.py` |
| H1 | `_dict_to_record` join_conditions 回退 key + 类型修正 | `caliber_tracer.py` |
| H2 | 下游追溯 max_depth 边界修复 | `caliber_tracer.py` |

### Phase 3 — P2 健壮性 (HIGH)

| # | 变更 | 影响范围 |
|---|------|---------|
| H5 | EventBus 线程安全 — 快照迭代 + 锁 | `event_bus.py` |
| H6 | ProcedureParser 口径去重 — 按步骤+目标表过滤 | `procedure_parser.py` |
| H7 | `_find_mapping_step` 回退逻辑修正 | `procedure_parser.py` |
| H9 | 端点输入校验补全 | `lineage.py`, `indicator.py`, `parse.py` |
| H12 | 速率限制 + 线程池上限 | `main.py`, `parse.py` |

---

## Impact

### 受影响的规格

- `docs/DESIGN_SPEC_ZH.md` — API 响应格式需统一
- `docs/indicator-spec-design.md` — 口径 API 端点参数校验
- `app/models/__init__.py` — 新增统一响应模型

### 受影响的代码

- `app/api/` — 全部路由文件 (响应格式、参数校验、错误处理)
- `app/services/parser_service.py` — 缓存失效链路、merge 去重
- `app/services/lineage_service.py` — 字段匹配、缓存刷新
- `app/services/tracer_factory.py` — invalidate 逻辑
- `app/services/event_bus.py` — 线程安全
- `core/caliber_tracer.py` — join_conditions、max_depth
- `core/procedure_parser.py` — 口径去重、步骤匹配
- `app/utils/file_handler.py` — 路径穿越防护
- `app/main.py` — CORS、认证中间件、速率限制
- `static/js/` — XSS 修复

### API 兼容性

- **响应格式变更**：breaking change — 前端需适配统一信封
- **参数校验增强**：部分请求可能被拒绝（direction 非法值、空白 keyword）
- **认证新增**：破坏性端点需携带 API Key
- **CORS 收紧**：非生产环境不再允许 `*` + credentials

### 不受影响

- 核心追溯算法逻辑不变 (BFS 框架、层级检测、索引构建)
- 数据模型字段不变 (CaliberInfo, FieldMapping 等结构不变)
- 前端渲染逻辑不变 (仅修复 XSS，不改交互)
- 存储层不变 (SQLite schema、缓存机制)
