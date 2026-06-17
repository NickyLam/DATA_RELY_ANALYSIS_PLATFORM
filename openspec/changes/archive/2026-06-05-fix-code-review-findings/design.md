## Context

数据血缘分析系统经过两轮 QA 修复和一轮完整 Code Review，发现 36 项问题。当前代码库已修复了前两轮的 Critical/High 问题（XSS、线程安全、pickle 安全等），但 Code Review 仍发现 5 个 blocking 级别问题和 12 个 non-blocking issue。系统架构整体合理（Protocol 抽象、Annotated 依赖注入、IIFE 模块化），但存在安全漏洞、性能隐患和大量 DRY 违反。

关键约束：
- Python 3.11+，不向下兼容
- 前端为纯 JS（无构建工具），通过 IIFE + window.* 暴露接口
- 生产环境已有部署，需考虑向后兼容

## Goals / Non-Goals

**Goals:**
- 修复 5 个 blocking 级别安全问题（路径穿越、SSE 阻塞、全局冲突、重复定义、XSS）
- 修复 12 个 non-blocking issue 中影响正确性和可维护性的关键项
- 将重复逻辑提取为共享函数，降低维护成本
- 每个任务原子化、可独立验证、失败后可安全重试

**Non-Goals:**
- 不重构前端为 SPA/框架（React/Vue）
- 不引入新的外部依赖（除认证所需的 passlib/python-multipart）
- 不修改数据库 schema 或存储格式
- 不处理 Low 级别的 nitpick（CSS 重复规则、空存根函数等）
- 不改变 API 路由结构或端点 URL

## Decisions

### D1: SSE 异步化方案 — 改为 async 生成器

**选择**: 将 `generate_sse_events` 从同步生成器改为 async 生成器，使用 `asyncio.Queue` 替代 `queue.Queue`

**替代方案**:
- A) `run_in_executor` 包装同步生成器 — 简单但仍有线程开销，且 `StreamingResponse` 对 async 生成器支持更好
- B) 改用 WebSocket — 过度设计，当前 SSE 模式足够

**理由**: FastAPI 的 `StreamingResponse` 原生支持 async 生成器，无需额外线程。`asyncio.Queue` 的 `await get()` 不会阻塞事件循环。改动范围最小。

### D2: 破坏性端点认证 — API Key Header

**选择**: 使用 `X-Admin-Key` Header + FastAPI `APIKeyHeader` 依赖

**替代方案**:
- A) JWT Token — 过度设计，系统无用户体系
- B) 无认证仅限速 — 无法防止恶意调用
- C) IP 白名单 — 部署环境多变，维护成本高

**理由**: API Key 方案最简单，配置灵活（环境变量 `ADMIN_API_KEY`），与 FastAPI 依赖注入天然集成。未配置 key 时端点仍可访问（向后兼容）。

### D3: display-tab.js 处理 — 整体删除

**选择**: 删除 display-tab.js 文件，从 index.html 移除 script 引用

**替代方案**:
- A) 移至 deprecated/ — 仍可能被误引用
- B) 逐函数合并到模块化文件 — 工作量大且模块化文件已覆盖所有功能

**理由**: display-tab.js 是模块化拆分前的遗留版本，所有功能已被 lineage-graph.js/search-panel.js/detail-panel.js 覆盖。删除最干净。

### D4: core 层共享函数 — 新建 core/utils.py

**选择**: 新建 `core/utils.py`，提取括号匹配、临时表判断等共享逻辑

**替代方案**:
- A) 放入 base_tracer.py — 增加基类职责
- B) 放入 core/models.py — 语义不符

**理由**: 独立模块，无依赖，可被 core 层任何模块导入。符合单一职责原则。

### D5: CaliberTracer 类型化 — 使用 TypedDict 而非 dataclass

**选择**: 为 caliber_infos_raw 的 dict 结构定义 TypedDict

**替代方案**:
- A) 转为 dataclass/dataclass — 需修改所有调用点，改动范围大
- B) 维持现状 — 无类型安全

**理由**: TypedDict 最小侵入，仅添加类型注解，不改变运行时行为。后续可渐进迁移为 dataclass。

### D6: 任务粒度 — 按文件/功能域原子化

**选择**: 每个任务只修改 1-3 个相关文件，可独立测试验证

**理由**: 遵循最小化可重试原则。任务失败后只需回退该任务的改动，不影响其他任务。每个任务有明确的验证条件（测试通过 / 语法检查 / 手动验证）。

## Risks / Trade-offs

- **[SSE 异步化]** → ParseTask 的 subscribers 使用 `queue.Queue`，需同步改为 `asyncio.Queue`。订阅/通知机制需全面适配。缓解：先写测试覆盖现有 SSE 行为，再改实现。
- **[display-tab.js 删除]** → 若有外部代码引用该文件的函数会报错。缓解：全局搜索确认无外部引用后再删除。
- **[API Key 认证]** → 现有客户端未传 key 时，破坏性端点仍可访问（未配置 key 时跳过认证）。缓解：文档中明确说明生产环境必须配置 `ADMIN_API_KEY`。
- **[core/utils.py 提取]** → 改变导入路径，可能影响已有测试。缓解：在原位置保留 re-export 别名过渡期。
