import React, { useEffect, useState, useCallback, useMemo } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import {
  Card,
  Input,
  Button,
  Table,
  Modal,
  Descriptions,
  Tag,
  Space,
  Spin,
  Empty,
  message,
  Tooltip,
  Dropdown,
  Select,
  Typography,
  Divider,
  Collapse,
  Badge,
} from 'antd'
import type { MenuProps } from 'antd'
import {
  SearchOutlined,
  ExportOutlined,
  DownloadOutlined,
  InfoCircleOutlined,
  BranchesOutlined,
  DatabaseOutlined,
  CodeOutlined,
  MergeCellsOutlined,
  ArrowRightOutlined,
  ReloadOutlined,
  ZoomInOutlined,
  ZoomOutOutlined,
  FullscreenOutlined,
} from '@ant-design/icons'
import { fieldLineageApi, FieldNode, FieldEdge, ExpressionDetail, FieldSearchResult } from '../api/fieldLineage'

const { Text } = Typography
const { Panel } = Collapse

interface GraphNode {
  id: string
  label: string
  table: string
  type: 'source' | 'intermediate' | 'target'
  dataType?: string
  x: number
  y: number
}

interface GraphEdge {
  source: string
  target: string
  label: string
  transformationType: string
  expression?: string
  confidence: number
}

const TRANSFORMATION_TYPE_COLORS: Record<string, string> = {
  direct_map: '#52c41a',
  expression: '#1890ff',
  aggregation: '#722ed1',
  join: '#fa8c16',
  filter: '#eb2f96',
  case_when: '#13c2c2',
  function: '#2f54eb',
}

const TRANSFORMATION_TYPE_LABELS: Record<string, string> = {
  direct_map: '直接映射',
  expression: '表达式计算',
  aggregation: '聚合计算',
  join: '多表关联',
  filter: '条件过滤',
  case_when: '条件判断',
  function: '函数转换',
}

const FieldLineagePage: React.FC = () => {
  const { fieldId } = useParams<{ fieldId: string }>()
  const navigate = useNavigate()

  const [loading, setLoading] = useState(false)
  const [searchLoading, setSearchLoading] = useState(false)
  const [nodes, setNodes] = useState<FieldNode[]>([])
  const [edges, setEdges] = useState<FieldEdge[]>([])
  const [sourceNodes, setSourceNodes] = useState<FieldNode[]>([])
  const [isMultiSource, setIsMultiSource] = useState(false)
  const [pathLength, setPathLength] = useState(0)
  const [selectedNode, setSelectedNode] = useState<FieldNode | null>(null)
  const [selectedEdge, setSelectedEdge] = useState<FieldEdge | null>(null)
  const [detailModalVisible, setDetailModalVisible] = useState(false)
  const [expressionModalVisible, setExpressionModalVisible] = useState(false)
  const [searchModalVisible, setSearchModalVisible] = useState(false)
  const [searchResults, setSearchResults] = useState<FieldSearchResult[]>([])
  const [searchKeyword, setSearchKeyword] = useState('')
  const [maxDepth, setMaxDepth] = useState(10)
  const [scale, setScale] = useState(1)
  const [graphOffset, setGraphOffset] = useState({ x: 0, y: 0 })

  const loadLineage = useCallback(async () => {
    if (!fieldId) return

    setLoading(true)
    try {
      const response = await fieldLineageApi.getShortestPath(fieldId, maxDepth, true)
      setNodes(response.nodes)
      setEdges(response.edges)
      setSourceNodes(response.source_nodes)
      setIsMultiSource(response.is_multi_source)
      setPathLength(response.path_length)
      message.success('血缘链路加载成功')
    } catch (error) {
      message.error('加载血缘链路失败')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }, [fieldId, maxDepth])

  useEffect(() => {
    loadLineage()
  }, [loadLineage])

  const handleSearch = useCallback(async () => {
    if (!searchKeyword.trim()) {
      message.warning('请输入搜索关键词')
      return
    }

    setSearchLoading(true)
    try {
      const results = await fieldLineageApi.searchFields({ field_name: searchKeyword, limit: 50 })
      setSearchResults(results)
    } catch (error) {
      message.error('搜索失败')
      console.error(error)
    } finally {
      setSearchLoading(false)
    }
  }, [searchKeyword])

  const handleSelectField = useCallback((result: FieldSearchResult) => {
    navigate(`/field-lineage/${result.id}`)
    setSearchModalVisible(false)
  }, [navigate])

  const handleExport = useCallback(async (formatType: string) => {
    if (!fieldId) return

    try {
      const response = await fieldLineageApi.exportLineage(fieldId, formatType, maxDepth)
      const blob = new Blob([response.content], { type: 'text/plain;charset=utf-8' })
      const url = URL.createObjectURL(blob)
      const link = document.createElement('a')
      link.href = url
      link.download = response.filename
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      URL.revokeObjectURL(url)
      message.success('导出成功')
    } catch (error) {
      message.error('导出失败')
      console.error(error)
    }
  }, [fieldId, maxDepth])

  const exportMenuItems: MenuProps['items'] = [
    {
      key: 'json',
      label: 'JSON 格式',
      icon: <CodeOutlined />,
      onClick: () => handleExport('json'),
    },
    {
      key: 'csv',
      label: 'CSV 格式',
      icon: <DatabaseOutlined />,
      onClick: () => handleExport('csv'),
    },
    {
      key: 'markdown',
      label: 'Markdown 格式',
      onClick: () => handleExport('markdown'),
    },
  ]

  const graphNodes = useMemo(() => {
    const nodeWidth = 180
    const nodeHeight = 60
    const horizontalGap = 80
    const verticalGap = 100

    const levels: Record<string, number> = {}
    const nodeMap: Record<string, FieldNode> = {}
    
    nodes.forEach(node => {
      nodeMap[node.id] = node
    })

    const targetNode = nodes.find(n => !edges.some(e => e.target_id === n.id))
    if (targetNode) {
      levels[targetNode.id] = 0
    }

    let currentLevel = 0
    let processed = new Set<string>()
    if (targetNode) {
      processed.add(targetNode.id)
    }

    while (processed.size < nodes.length) {
      const nextLevel = currentLevel + 1
      const nodesAtCurrentLevel = nodes.filter(n => levels[n.id] === currentLevel)
      
      nodesAtCurrentLevel.forEach(node => {
        edges.forEach(edge => {
          if (edge.target_id === node.id && !processed.has(edge.source_id)) {
            levels[edge.source_id] = nextLevel
            processed.add(edge.source_id)
          }
        })
      })
      
      currentLevel = nextLevel
    }

    const levelGroups: Record<number, FieldNode[]> = {}
    nodes.forEach(node => {
      const level = levels[node.id] || 0
      if (!levelGroups[level]) {
        levelGroups[level] = []
      }
      levelGroups[level].push(node)
    })

    // maxLevel and canvasWidth used for layout calculation
    const canvasHeight = Math.max(...Object.values(levelGroups).map(g => g.length)) * (nodeHeight + verticalGap) + 100

    return nodes.map((node) => {
      const level = levels[node.id] || 0
      const levelNodes = levelGroups[level] || []
      const indexInLevel = levelNodes.indexOf(node)
      const totalInLevel = levelNodes.length

      const x = level * (nodeWidth + horizontalGap) + 50
      const y = (indexInLevel - totalInLevel / 2 + 0.5) * (nodeHeight + verticalGap) + canvasHeight / 2

      const isSource = sourceNodes.some(s => s.id === node.id)
      const isTarget = !edges.some(e => e.target_id === node.id)

      return {
        id: node.id,
        label: node.name,
        table: node.table_name,
        type: (isSource ? 'source' : isTarget ? 'target' : 'intermediate') as 'source' | 'target' | 'intermediate',
        dataType: node.data_type,
        x,
        y,
      }
    })
  }, [nodes, edges, sourceNodes])

  const graphEdges = useMemo(() => {
    return edges.map(edge => ({
      source: edge.source_id,
      target: edge.target_id,
      label: TRANSFORMATION_TYPE_LABELS[edge.transformation_type] || edge.transformation_type,
      transformationType: edge.transformation_type,
      expression: edge.expression,
      confidence: edge.confidence_score,
    }))
  }, [edges])

  const handleNodeClick = useCallback((node: GraphNode) => {
    const fieldNode = nodes.find(n => n.id === node.id)
    if (fieldNode) {
      setSelectedNode(fieldNode)
      setDetailModalVisible(true)
    }
  }, [nodes])

  const handleEdgeClick = useCallback((edge: GraphEdge) => {
    const fieldEdge = edges.find(e => e.source_id === edge.source && e.target_id === edge.target)
    if (fieldEdge) {
      setSelectedEdge(fieldEdge)
      setExpressionModalVisible(true)
    }
  }, [edges])

  const handleZoomIn = useCallback(() => {
    setScale(prev => Math.min(prev + 0.2, 2))
  }, [])

  const handleZoomOut = useCallback(() => {
    setScale(prev => Math.max(prev - 0.2, 0.5))
  }, [])

  const handleResetZoom = useCallback(() => {
    setScale(1)
    setGraphOffset({ x: 0, y: 0 })
  }, [])

  const renderExpressionDetail = (detail?: ExpressionDetail) => {
    if (!detail) return null

    return (
      <div style={{ padding: '16px 0' }}>
        <Descriptions column={1} bordered size="small">
          <Descriptions.Item label="转换类型">
            <Tag color={TRANSFORMATION_TYPE_COLORS[detail.transformation_type] || '#default'}>
              {TRANSFORMATION_TYPE_LABELS[detail.transformation_type] || detail.transformation_type}
            </Tag>
          </Descriptions.Item>
          <Descriptions.Item label="原始表达式">
            <Text code>{detail.raw_expression}</Text>
          </Descriptions.Item>
          <Descriptions.Item label="解析表达式">
            <Text>{detail.parsed_expression}</Text>
          </Descriptions.Item>
          <Descriptions.Item label="源字段">
            <Space>
              {detail.source_fields.map(field => (
                <Tag key={field} color="blue">{field}</Tag>
              ))}
            </Space>
          </Descriptions.Item>
          {detail.aggregation_type && (
            <Descriptions.Item label="聚合类型">
              <Tag color="purple">{detail.aggregation_type.toUpperCase()}</Tag>
            </Descriptions.Item>
          )}
          {detail.join_condition && (
            <Descriptions.Item label="JOIN 条件">
              <Text code>{detail.join_condition}</Text>
            </Descriptions.Item>
          )}
          {detail.filter_condition && (
            <Descriptions.Item label="过滤条件">
              <Text code>{detail.filter_condition}</Text>
            </Descriptions.Item>
          )}
          {detail.description && (
            <Descriptions.Item label="描述">
              <Text>{detail.description}</Text>
            </Descriptions.Item>
          )}
        </Descriptions>
      </div>
    )
  }

  const renderGraph = () => {
    if (nodes.length === 0) {
      return (
        <Empty
          description="暂无血缘数据"
          style={{ height: 500, display: 'flex', flexDirection: 'column', justifyContent: 'center' }}
        />
      )
    }

    const nodeWidth = 180
    const nodeHeight = 60

    const maxX = Math.max(...graphNodes.map(n => n.x)) + nodeWidth + 50
    const maxY = Math.max(...graphNodes.map(n => n.y)) + nodeHeight + 50
    const minX = Math.min(...graphNodes.map(n => n.x)) - 50
    const minY = Math.min(...graphNodes.map(n => n.y)) - nodeHeight - 50

    const viewBoxWidth = maxX - minX
    const viewBoxHeight = maxY - minY

    return (
      <svg
        width="100%"
        height="100%"
        viewBox={`${minX} ${minY} ${viewBoxWidth} ${viewBoxHeight}`}
        style={{ transform: `scale(${scale}) translate(${graphOffset.x}px, ${graphOffset.y}px)`, transformOrigin: 'center' }}
      >
        {graphEdges.map((edge, index) => {
          const sourceNode = graphNodes.find(n => n.id === edge.source)
          const targetNode = graphNodes.find(n => n.id === edge.target)
          
          if (!sourceNode || !targetNode) return null

          const startX = sourceNode.x + nodeWidth
          const startY = sourceNode.y + nodeHeight / 2
          const endX = targetNode.x
          const endY = targetNode.y + nodeHeight / 2

          const midX = (startX + endX) / 2

          const pathD = `M ${startX} ${startY} L ${midX} ${startY} L ${midX} ${endY} L ${endX} ${endY}`

          return (
            <g key={`edge-${index}`} onClick={() => handleEdgeClick(edge)} style={{ cursor: 'pointer' }}>
              <path
                d={pathD}
                fill="none"
                stroke={TRANSFORMATION_TYPE_COLORS[edge.transformationType] || '#d9d9d9'}
                strokeWidth={2}
                strokeOpacity={0.8}
                markerEnd="url(#arrowhead)"
              />
              <rect
                x={midX - 40}
                y={(startY + endY) / 2 - 12}
                width={80}
                height={24}
                fill="white"
                stroke={TRANSFORMATION_TYPE_COLORS[edge.transformationType] || '#d9d9d9'}
                strokeWidth={1}
                rx={4}
              />
              <text
                x={midX}
                y={(startY + endY) / 2}
                textAnchor="middle"
                dominantBaseline="middle"
                fontSize={12}
                fill="#333"
              >
                {edge.label}
              </text>
              {edge.confidence < 1 && (
                <text
                  x={midX}
                  y={(startY + endY) / 2 + 20}
                  textAnchor="middle"
                  fontSize={10}
                  fill="#999"
                >
                  置信度: {(edge.confidence * 100).toFixed(0)}%
                </text>
              )}
            </g>
          )
        })}
        
        <defs>
          <marker
            id="arrowhead"
            markerWidth="10"
            markerHeight="7"
            refX="9"
            refY="3.5"
            orient="auto"
          >
            <polygon points="0 0, 10 3.5, 0 7" fill="#d9d9d9" />
          </marker>
        </defs>

        {graphNodes.map((node) => {
          const bgColor = node.type === 'source' ? '#f6ffed' : node.type === 'target' ? '#e6f7ff' : '#fff'
          const borderColor = node.type === 'source' ? '#52c41a' : node.type === 'target' ? '#1890ff' : '#d9d9d9'

          return (
            <g
              key={node.id}
              onClick={() => handleNodeClick(node)}
              style={{ cursor: 'pointer' }}
            >
              <rect
                x={node.x}
                y={node.y}
                width={nodeWidth}
                height={nodeHeight}
                fill={bgColor}
                stroke={borderColor}
                strokeWidth={2}
                rx={8}
              />
              <text
                x={node.x + nodeWidth / 2}
                y={node.y + 20}
                textAnchor="middle"
                fontSize={14}
                fontWeight="bold"
                fill="#333"
              >
                {node.label}
              </text>
              <text
                x={node.x + nodeWidth / 2}
                y={node.y + 40}
                textAnchor="middle"
                fontSize={12}
                fill="#666"
              >
                {node.table}
              </text>
              {node.type === 'source' && (
                <circle
                  cx={node.x + nodeWidth - 15}
                  cy={node.y + 15}
                  r={8}
                  fill="#52c41a"
                />
              )}
              {node.type === 'target' && (
                <circle
                  cx={node.x + nodeWidth - 15}
                  cy={node.y + 15}
                  r={8}
                  fill="#1890ff"
                />
              )}
            </g>
          )
        })}
      </svg>
    )
  }

  const searchColumns = [
    {
      title: '字段名',
      dataIndex: 'name',
      key: 'name',
      render: (text: string) => <Text strong>{text}</Text>,
    },
    {
      title: '完整名称',
      dataIndex: 'full_name',
      key: 'full_name',
      ellipsis: true,
    },
    {
      title: '所属表',
      dataIndex: 'table_name',
      key: 'table_name',
    },
    {
      title: '数据类型',
      dataIndex: 'data_type',
      key: 'data_type',
      render: (text?: string) => text ? <Tag>{text}</Tag> : '-',
    },
    {
      title: '操作',
      key: 'action',
      render: (_: unknown, record: FieldSearchResult) => (
        <Button type="link" onClick={() => handleSelectField(record)}>
          查看血缘
        </Button>
      ),
    },
  ]

  return (
    <div style={{ padding: '24px', background: '#f0f2f5', minHeight: '100vh' }}>
      <Card
        title={
          <Space>
            <BranchesOutlined />
            <span>字段级最小血缘链路</span>
            {isMultiSource && (
              <Tag color="orange" icon={<MergeCellsOutlined />}>
                多源汇聚
              </Tag>
            )}
          </Space>
        }
        extra={
          <Space>
            <Tooltip title="搜索字段">
              <Button icon={<SearchOutlined />} onClick={() => setSearchModalVisible(true)}>
                搜索
              </Button>
            </Tooltip>
            <Tooltip title="刷新">
              <Button icon={<ReloadOutlined />} onClick={loadLineage} loading={loading}>
                刷新
              </Button>
            </Tooltip>
            <Dropdown menu={{ items: exportMenuItems }} placement="bottomRight">
              <Button icon={<ExportOutlined />}>
                导出 <DownloadOutlined />
              </Button>
            </Dropdown>
          </Space>
        }
        style={{ marginBottom: '16px' }}
      >
        <Space style={{ marginBottom: '16px' }}>
          <Text>最大深度:</Text>
          <Select
            value={maxDepth}
            onChange={setMaxDepth}
            style={{ width: 120 }}
            options={[
              { value: 5, label: '5 层' },
              { value: 10, label: '10 层' },
              { value: 15, label: '15 层' },
              { value: 20, label: '20 层' },
            ]}
          />
          <Divider type="vertical" />
          <Text>路径长度: <Badge count={pathLength} style={{ backgroundColor: '#52c41a' }} /></Text>
          <Divider type="vertical" />
          <Text>源字段数: <Badge count={sourceNodes.length} style={{ backgroundColor: '#1890ff' }} /></Text>
        </Space>

        <div style={{ position: 'relative', height: 600, background: '#fafafa', border: '1px solid #d9d9d9', borderRadius: 8, overflow: 'hidden' }}>
          <div style={{ position: 'absolute', top: 16, right: 16, zIndex: 10 }}>
            <Space>
              <Tooltip title="放大">
                <Button size="small" icon={<ZoomInOutlined />} onClick={handleZoomIn} />
              </Tooltip>
              <Tooltip title="缩小">
                <Button size="small" icon={<ZoomOutOutlined />} onClick={handleZoomOut} />
              </Tooltip>
              <Tooltip title="重置">
                <Button size="small" icon={<FullscreenOutlined />} onClick={handleResetZoom} />
              </Tooltip>
            </Space>
          </div>

          {loading ? (
            <div style={{ height: '100%', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
              <Spin size="large" tip="加载血缘链路..." />
            </div>
          ) : renderGraph()}
        </div>

        {nodes.length > 0 && (
          <Collapse style={{ marginTop: '16px' }} defaultActiveKey={['nodes', 'edges']}>
            <Panel header="节点列表" key="nodes">
              <Table
                dataSource={nodes}
                rowKey="id"
                size="small"
                pagination={false}
                columns={[
                  {
                    title: '字段名',
                    dataIndex: 'name',
                    key: 'name',
                    render: (text: string, record: FieldNode) => (
                      <Space>
                        <Text strong>{text}</Text>
                        {record.is_source && <Tag color="green">源字段</Tag>}
                      </Space>
                    ),
                  },
                  {
                    title: '所属表',
                    dataIndex: 'table_name',
                    key: 'table_name',
                  },
                  {
                    title: '完整名称',
                    dataIndex: 'full_name',
                    key: 'full_name',
                    ellipsis: true,
                  },
                  {
                    title: '数据类型',
                    dataIndex: 'data_type',
                    key: 'data_type',
                    render: (text?: string) => text ? <Tag>{text}</Tag> : '-',
                  },
                  {
                    title: '操作',
                    key: 'action',
                    render: (_: unknown, record: FieldNode) => (
                      <Button type="link" onClick={() => { setSelectedNode(record); setDetailModalVisible(true); }}>
                        详情
                      </Button>
                    ),
                  },
                ]}
              />
            </Panel>
            <Panel header="转换路径" key="edges">
              <Table
                dataSource={edges}
                rowKey={(edge) => `${edge.source_id}-${edge.target_id}`}
                size="small"
                pagination={false}
                columns={[
                  {
                    title: '源字段',
                    dataIndex: 'source_id',
                    key: 'source_id',
                    render: (id: string) => {
                      const node = nodes.find(n => n.id === id)
                      return node ? <Text>{node.name}</Text> : id
                    },
                  },
                  {
                    title: '',
                    key: 'arrow',
                    width: 40,
                    render: () => <ArrowRightOutlined style={{ color: '#d9d9d9' }} />,
                  },
                  {
                    title: '目标字段',
                    dataIndex: 'target_id',
                    key: 'target_id',
                    render: (id: string) => {
                      const node = nodes.find(n => n.id === id)
                      return node ? <Text>{node.name}</Text> : id
                    },
                  },
                  {
                    title: '转换类型',
                    dataIndex: 'transformation_type',
                    key: 'transformation_type',
                    render: (type: string) => (
                      <Tag color={TRANSFORMATION_TYPE_COLORS[type] || '#default'}>
                        {TRANSFORMATION_TYPE_LABELS[type] || type}
                      </Tag>
                    ),
                  },
                  {
                    title: '表达式',
                    dataIndex: 'expression',
                    key: 'expression',
                    ellipsis: true,
                    render: (text?: string) => text ? <Text code>{text}</Text> : '-',
                  },
                  {
                    title: '置信度',
                    dataIndex: 'confidence_score',
                    key: 'confidence_score',
                    render: (score: number) => (
                      <Tag color={score >= 0.9 ? 'green' : score >= 0.7 ? 'blue' : 'orange'}>
                        {(score * 100).toFixed(0)}%
                      </Tag>
                    ),
                  },
                  {
                    title: '操作',
                    key: 'action',
                    render: (_: unknown, record: FieldEdge) => (
                      <Button type="link" onClick={() => { setSelectedEdge(record); setExpressionModalVisible(true); }}>
                        详情
                      </Button>
                    ),
                  },
                ]}
              />
            </Panel>
          </Collapse>
        )}
      </Card>

      <Modal
        title={
          <Space>
            <InfoCircleOutlined />
            <span>字段详情</span>
          </Space>
        }
        open={detailModalVisible}
        onCancel={() => setDetailModalVisible(false)}
        footer={<Button onClick={() => setDetailModalVisible(false)}>关闭</Button>}
        width={600}
      >
        {selectedNode && (
          <Descriptions column={1} bordered>
            <Descriptions.Item label="字段名">{selectedNode.name}</Descriptions.Item>
            <Descriptions.Item label="完整名称">{selectedNode.full_name}</Descriptions.Item>
            <Descriptions.Item label="所属表">{selectedNode.table_name}</Descriptions.Item>
            <Descriptions.Item label="数据类型">{selectedNode.data_type || '-'}</Descriptions.Item>
            <Descriptions.Item label="表达式">{selectedNode.expression || '-'}</Descriptions.Item>
            <Descriptions.Item label="是否源字段">
              {selectedNode.is_source ? <Tag color="green">是</Tag> : <Tag>否</Tag>}
            </Descriptions.Item>
          </Descriptions>
        )}
      </Modal>

      <Modal
        title={
          <Space>
            <CodeOutlined />
            <span>转换表达式详情</span>
          </Space>
        }
        open={expressionModalVisible}
        onCancel={() => setExpressionModalVisible(false)}
        footer={<Button onClick={() => setExpressionModalVisible(false)}>关闭</Button>}
        width={700}
      >
        {selectedEdge && (
          <div>
            <Descriptions column={2} bordered size="small" style={{ marginBottom: '16px' }}>
              <Descriptions.Item label="源字段">
                {nodes.find(n => n.id === selectedEdge.source_id)?.name || selectedEdge.source_id}
              </Descriptions.Item>
              <Descriptions.Item label="目标字段">
                {nodes.find(n => n.id === selectedEdge.target_id)?.name || selectedEdge.target_id}
              </Descriptions.Item>
              <Descriptions.Item label="置信度">
                <Tag color={selectedEdge.confidence_score >= 0.9 ? 'green' : selectedEdge.confidence_score >= 0.7 ? 'blue' : 'orange'}>
                  {(selectedEdge.confidence_score * 100).toFixed(0)}%
                </Tag>
              </Descriptions.Item>
              <Descriptions.Item label="作业 ID">{selectedEdge.job_id || '-'}</Descriptions.Item>
            </Descriptions>
            {renderExpressionDetail(selectedEdge.expression_detail)}
          </div>
        )}
      </Modal>

      <Modal
        title={
          <Space>
            <SearchOutlined />
            <span>搜索字段</span>
          </Space>
        }
        open={searchModalVisible}
        onCancel={() => setSearchModalVisible(false)}
        footer={null}
        width={800}
      >
        <Space.Compact style={{ width: '100%', marginBottom: '16px' }}>
          <Input
            placeholder="输入字段名搜索..."
            value={searchKeyword}
            onChange={(e) => setSearchKeyword(e.target.value)}
            onPressEnter={handleSearch}
            style={{ width: 'calc(100% - 100px)' }}
          />
          <Button type="primary" icon={<SearchOutlined />} onClick={handleSearch} loading={searchLoading}>
            搜索
          </Button>
        </Space.Compact>
        <Table
          dataSource={searchResults}
          columns={searchColumns}
          rowKey="id"
          size="small"
          pagination={{ pageSize: 10 }}
          loading={searchLoading}
        />
      </Modal>
    </div>
  )
}

export default FieldLineagePage