## Why

Code Review 发现 36 项问题（5 blocking、12 non-blocking issue、10 suggestion、6 nitpick、3 praise），其中 5 个 blocking 级别问题（文件上传路径穿越、SSE 阻塞事件循环、display-tab.js 全局冲突、正则常量重复定义、innerHTML 未转义）需在合并前修复。其余 DRY 违反、封装破坏、死代码等问题是中长期架构债务，需分批清理。所有任务遵循最小化可重试原则——每个任务原子化、可独立验证、失败后可安全重试。

## What Changes

- **安全修复**: 文件上传路径穿越防护、innerHTML XSS 转义、破坏性端点认证保护
- **性能修复**: SSE 生成器从同步改为 async、get_downstream_tables 使用已有索引
- **功能修复**: 删除 display-tab.js 消除全局函数冲突、正则常量重复定义清理
- **封装改善**: 消除 getattr 访问私有属性、暴露公共方法替代直接访问
- **DRY 重构**: 括号匹配/临时表判断/字段名规范化/表信息转换等重复逻辑提取为共享函数
- **代码清理**: 死代码删除、console.log 清理、CSS 重复规则合并、IIFE 封装
- **可维护性**: 超长方法拆分、响应模型统一、依赖版本锁定、事件委托统一

## Capabilities

### New Capabilities
- `file-upload-security`: 文件上传路径穿越防护与文件名清洗
- `async-sse`: SSE 生成器异步化，避免阻塞事件循环
- `admin-auth`: 破坏性端点的 API Key 认证保护
- `core-utils`: core 层共享工具函数（括号匹配、临时表判断等）
- `frontend-cleanup`: 前端死代码删除、IIFE 封装、事件监听去重、调试日志清理

### Modified Capabilities
- `lineage-service`: 封装改善（消除私有属性访问）、超长方法拆分、索引优化
- `caliber-tracer`: 内部存储类型化、fallback 层拆分、上下游方法合并
- `api-responses`: 响应模型统一、异常处理规范化

## Impact

- **后端 API**: parse.py SSE 端点签名变更、system.py/lineage.py 破坏性端点新增认证依赖
- **前端**: display-tab.js 删除、index.html 移除 script 引用、parse-tab.js IIFE 封装
- **Core**: 新增 `core/utils.py` 共享模块、dml_parser.py 删除重复常量
- **依赖**: requirements.txt 版本范围收窄、可能新增 passlib/python-multipart
- **测试**: SSE 测试需适配 async 生成器、认证端点测试需 mock API key
