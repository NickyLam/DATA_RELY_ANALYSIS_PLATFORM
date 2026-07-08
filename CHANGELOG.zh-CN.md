# 变更日志

语言版本：中文 | [English](CHANGELOG.md)

本文记录项目的重要变更。公开发布说明按语义化版本组织。

## [v2.2.0] - 2026-07-08

### 新增

- 将 README 整理为中文/英文两个独立版本，方便中文用户和海外审核人员阅读。
- 补充正式发布说明，包含安装命令、演示截图、示例 SQL 和输出示例。
- 在 `docs/assets/` 增加公开安全的血缘图截图、GIF 演示和架构图。
- 增加开源维护文档：`CONTRIBUTING.md`、`SECURITY.md`、`ROADMAP.md`、GitHub Issue 模板和 PR 模板。
- 在 `docs/examples/` 增加安全示例 SQL 和 API 响应样例。

### 修复

- 修复 Type5 ICL 共性加工模式中 `_ex` 交换表被误判为临时表导致的血缘丢失问题。
- 保留 `INSERT INTO ..._ex` 与 `ALTER TABLE ... EXCHANGE PARTITION ... WITH TABLE ..._ex` 场景下的字段血缘。
- 修复上游图转换中的边方向问题。

### 能力增强

- 数仓层级检测扩展到 17 种层级，包括 SRC、MSL、ITL、IOL、ICL、IML、IDL、IEL、DQC。
- 前端同步更新分层颜色、标签和样式。
- 支持面向系统的数据血缘导出和治理复核材料整理。

### 审核说明

- `SOURCE_DATA/` 中的真实业务数据不得提交到公开仓库，也不得附加到公开 Issue。
- 当前演示素材均为可公开展示的安全截图。

## [v2.1.0] - 2026-05-14

### 新增

- 指标血缘分析模式。
- 解析层与展示层双 Tab 前端结构。
- 口径追溯和治理证据导出流程。

[v2.2.0]: ./docs/releases/v2.2.0.zh-CN.md
[v2.1.0]: ./docs/indicator-lineage-dual-mode-design.md
