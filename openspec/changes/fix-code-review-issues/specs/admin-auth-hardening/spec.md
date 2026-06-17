## ADDED Requirements

### Requirement: Admin API key must be configured for management endpoints
系统 SHALL 要求配置 `ADMIN_API_KEY` 环境变量才能访问管理端点。未配置时，所有依赖 `admin_required` 的端点 SHALL 返回 HTTP 403 状态码和明确的配置提示信息。

#### Scenario: 未配置 ADMIN_API_KEY 时访问管理端点
- **WHEN** `ADMIN_API_KEY` 环境变量未设置或为空
- **AND** 用户请求 `/api/cache/rebuild` 或 `/api/system/reparse` 等管理端点
- **THEN** 系统 SHALL 返回 HTTP 403
- **AND** 响应 body SHALL 包含 `{"detail": "Admin API key not configured"}` 格式的错误消息

#### Scenario: 配置了 ADMIN_API_KEY 但未提供正确密钥
- **WHEN** `ADMIN_API_KEY` 环境变量已设置为 `my-secret-key`
- **AND** 用户请求管理端点但未提供 `X-Admin-Key` header 或提供了错误值
- **THEN** 系统 SHALL 返回 HTTP 403
- **AND** 响应 body SHALL 包含 `{"detail": "Invalid admin API key"}` 格式的错误消息

#### Scenario: 提供正确的 admin key 访问管理端点
- **WHEN** `ADMIN_API_KEY` 环境变量已设置
- **AND** 用户在请求头中提供匹配的 `X-Admin-Key`
- **THEN** 系统 SHALL 正常处理该管理端点请求

### Requirement: Error responses must not expose user input
系统 SHALL 在所有 HTTP 错误响应中避免直接嵌入用户提供的原始输入值（如表名、字段名等），防止信息探测攻击。

#### Scenario: 查询不存在的表时错误消息不含原始输入
- **WHEN** 用户查询表名为 `<script>alert(1)</script>` 的不存在的表
- **THEN** 错误响应中的 detail 字段 SHALL 不包含原始表名字符串
- **AND** 可使用通用描述如 "未找到指定的表"
