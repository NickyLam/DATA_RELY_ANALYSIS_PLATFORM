# 数据血缘分析平台 - 前端应用

## 技术栈

- **框架**: React 18+
- **语言**: TypeScript 5.0+
- **构建工具**: Vite 5.0+
- **UI 组件库**: Ant Design 5+
- **可视化**: React Flow / D3.js / Cytoscape.js
- **状态管理**: Zustand
- **路由**: React Router 6+

## 项目结构

```
frontend/
├── src/
│   ├── components/
│   │   └── Layout.tsx           # 布局组件
│   ├── pages/
│   │   ├── SearchPage.tsx       # 资产搜索页
│   │   ├── LineagePage.tsx      # 表级血缘页
│   │   ├── FieldLineagePage.tsx # 字段血缘页
│   │   ├── ImpactPage.tsx       # 影响分析页
│   │   └── DataSourcePage.tsx   # 数据源管理页
│   ├── App.tsx                  # 应用入口
│   ├── main.tsx                 # React 入口
│   └── index.css                # 全局样式
├── package.json                 # 项目配置
├── tsconfig.json                # TypeScript 配置
├── vite.config.ts               # Vite 配置
├── Dockerfile                   # Docker 配置
└── README.md                    # 本文件
```

## 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 启动开发服务器

```bash
npm run dev
```

### 3. 访问应用

http://localhost:5173

## 页面功能

### 资产搜索页
- 搜索表和字段
- 查看表的基本信息
- 快速跳转到血缘查询

### 表级血缘页
- 展示表的完整血缘链路
- 支持层级展开和收缩
- 支持导出血缘图

### 字段血缘页
- 展示字段的最小血缘链路
- 显示转换表达式
- 支持多源汇聚展示

### 影响分析页
- 分析表的下游影响
- 标记受影响的监管报送表
- 支持导出影响清单

### 数据源管理页
- 管理数据源配置
- 触发采集任务
- 查看采集状态

## 开发指南

### 代码质量

```bash
# 代码检查
npm run lint

# 代码格式化
npm run format
```

### 单元测试

```bash
npm run test
```

## Docker 部署

```bash
docker build -t lineage-frontend .
docker run -p 5173:5173 lineage-frontend
```

## 许可证

MIT