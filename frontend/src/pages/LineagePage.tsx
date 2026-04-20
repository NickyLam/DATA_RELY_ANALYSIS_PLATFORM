import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { useParams } from 'react-router-dom'
import ReactFlow, {
  Background,
  Controls,
  Edge,
  MarkerType,
  MiniMap,
  Node,
  NodeTypes,
  Panel,
  Position,
  useNodesState,
  useEdgesState,
  useReactFlow,
} from 'reactflow'
import 'reactflow/dist/style.css'
import {
  Button,
  Card,
  Descriptions,
  Drawer,
  Empty,
  message,
  Radio,
  Select,
  Skeleton,
  Spin,
  Tag,
  Tooltip,
  Typography,
} from 'antd'
import {
  ApiOutlined,
  BranchesOutlined,
  CameraOutlined,
  CodeOutlined,
  DownloadOutlined,
  ExpandOutlined,
  FileTextOutlined,
  FullscreenOutlined,
  ShrinkOutlined,
  TableOutlined,
} from '@ant-design/icons'
import { toPng } from 'html-to-image'

import { lineageApi } from '../api/lineage'
import type { DirectionType, LineageEdge, LineageGraph, LineageNode } from '../api/lineage'

const { Text } = Typography

interface TableNodeData {
  label: string
  type: string
  database?: string
  schema?: string
  rowCount?: number
  level?: number
  isExpanded?: boolean
  hasChildren?: boolean
  isLoading?: boolean
  onExpand?: () => void
  onCollapse?: () => void
}

const NODE_COLORS: Record<string, { bg: string; border: string; text: string }> = {
  Table: { bg: '#E8F4FD', border: '#1890FF', text: '#1890FF' },
  View: { bg: '#FFF7E6', border: '#FA8C16', text: '#FA8C16' },
  StoredProcedure: { bg: '#F6FFED', border: '#52C41A', text: '#52C41A' },
  Job: { bg: '#F9F0FF', border: '#722ED1', text: '#722ED1' },
}

const TableNode: React.FC<{ data: TableNodeData }> = ({ data }) => {
  const colors = NODE_COLORS[data.type] || NODE_COLORS.Table
  const icon = data.type === 'View' ? <FileTextOutlined /> : <TableOutlined />

  return (
    <div
      style={{
        padding: '12px 16px',
        borderRadius: '8px',
        background: colors.bg,
        border: `2px solid ${colors.border}`,
        minWidth: '160px',
        maxWidth: '240px',
        boxShadow: '0 2px 8px rgba(0, 0, 0, 0.08)',
        transition: 'all 0.2s ease',
        opacity: data.isLoading ? 0.6 : 1,
      }}
    >
      {data.isLoading ? (
        <div style={{ textAlign: 'center' }}>
          <Spin size="small" />
          <Text type="secondary" style={{ marginLeft: '8px', fontSize: '12px' }}>
            加载中...
          </Text>
        </div>
      ) : (
        <>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '4px' }}>
            <span style={{ color: colors.text, fontSize: '16px' }}>{icon}</span>
            <Text strong style={{ color: colors.text, fontSize: '14px' }}>
              {data.label}
            </Text>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
            <Tag
              color={colors.border}
              style={{
                margin: 0,
                fontSize: '12px',
                padding: '0 4px',
                borderRadius: '4px',
              }}
            >
              {data.type}
            </Tag>
            {data.database && (
              <Text type="secondary" style={{ fontSize: '12px' }}>
                {data.database}
              </Text>
            )}
          </div>
          {data.hasChildren && (
            <div style={{ marginTop: '8px', textAlign: 'center' }}>
              <Button
                size="small"
                type="link"
                icon={data.isExpanded ? <ShrinkOutlined /> : <ExpandOutlined />}
                onClick={data.isExpanded ? data.onCollapse : data.onExpand}
                style={{ fontSize: '12px' }}
              >
                {data.isExpanded ? '收缩' : '展开'}
              </Button>
            </div>
          )}
        </>
      )}
    </div>
  )
}

const nodeTypes: NodeTypes = {
  tableNode: TableNode,
}

const centerY = 300

const getLayoutedElements = (
  nodes: Node[],
  edges: Edge[],
  direction: DirectionType = 'upstream'
): { nodes: Node[]; edges: Edge[] } => {
  const levels: Map<string, number> = new Map()
  const visited: Set<string> = new Set()

  const calculateLevels = (nodeId: string, level: number) => {
    if (visited.has(nodeId)) return
    visited.add(nodeId)
    levels.set(nodeId, level)

    const connectedEdges = edges.filter(
      (e) =>
        (direction === 'upstream' && e.target === nodeId) ||
        (direction === 'downstream' && e.source === nodeId) ||
        (direction === 'both' && (e.source === nodeId || e.target === nodeId))
    )

    connectedEdges.forEach((edge) => {
      if (direction === 'both') {
        const nextNodeId = edge.source === nodeId ? edge.target : edge.source
        const nextLevel = edge.source === nodeId ? level + 1 : level - 1
        calculateLevels(nextNodeId, nextLevel)
      } else {
        const nextNodeId = direction === 'upstream' ? edge.source : edge.target
        calculateLevels(nextNodeId, direction === 'upstream' ? level + 1 : level - 1)
      }
    })
  }

  const rootNodes = nodes.filter((n) => {
    if (direction === 'upstream') {
      return !edges.some((e) => e.target === n.id)
    } else if (direction === 'downstream') {
      return !edges.some((e) => e.source === n.id)
    }
    return true
  })

  rootNodes.forEach((node) => calculateLevels(node.id, 0))

  const minLevel = Math.min(...Array.from(levels.values()), 0)

  const nodesByLevel: Map<number, Node[]> = new Map()
  nodes.forEach((node) => {
    const level = levels.get(node.id) || 0
    if (!nodesByLevel.has(level)) {
      nodesByLevel.set(level, [])
    }
    nodesByLevel.get(level)?.push(node)
  })

  const HORIZONTAL_SPACING = 280
  const VERTICAL_SPACING = 80
  const centerX = 400

  const layoutedNodes: Node[] = []

  nodesByLevel.forEach((levelNodes, level) => {
    const normalizedLevel = level - minLevel
    const x = centerX + normalizedLevel * HORIZONTAL_SPACING
    const totalHeight = (levelNodes.length - 1) * VERTICAL_SPACING
    const startY = centerY - totalHeight / 2

    levelNodes.forEach((node, index) => {
      layoutedNodes.push({
        ...node,
        position: { x, y: startY + index * VERTICAL_SPACING },
      })
    })
  })

  return {
    nodes: layoutedNodes,
    edges,
  }
}

const GraphSkeleton: React.FC = () => (
  <div
    style={{
      height: '100%',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '24px',
    }}
  >
    <Skeleton.Node
      active
      style={{
        width: '200px',
        height: '60px',
        marginBottom: '16px',
        borderRadius: '8px',
      }}
    />
    <div style={{ display: 'flex', gap: '16px', marginBottom: '16px' }}>
      <Skeleton.Node
        active
        style={{ width: '160px', height: '50px', borderRadius: '8px' }}
      />
      <Skeleton.Node
        active
        style={{ width: '160px', height: '50px', borderRadius: '8px' }}
      />
    </div>
    <div style={{ display: 'flex', gap: '16px' }}>
      <Skeleton.Node
        active
        style={{ width: '140px', height: '45px', borderRadius: '8px' }}
      />
      <Skeleton.Node
        active
        style={{ width: '140px', height: '45px', borderRadius: '8px' }}
      />
      <Skeleton.Node
        active
        style={{ width: '140px', height: '45px', borderRadius: '8px' }}
      />
    </div>
    <Skeleton.Input
      active
      size="small"
      style={{ width: '300px', marginTop: '24px' }}
    />
  </div>
)

const LazyLineageGraph: React.FC<{
  graphData: LineageGraph
  direction: DirectionType
  expandedNodes: Set<string>
  loadingNodes: Set<string>
  onNodeClick: (event: React.MouseEvent, node: Node) => void
  onExpandNode: (nodeId: string) => void
  onCollapseNode: (nodeId: string) => void
}> = ({
  graphData,
  direction,
  expandedNodes,
  loadingNodes,
  onNodeClick,
  onExpandNode,
  onCollapseNode,
}) => {
  const { fitView } = useReactFlow()
  const [nodes, setNodes, onNodesChange] = useNodesState([])
  const [edges, setEdges, onEdgesChange] = useEdgesState([])
  const [visibleNodes, setVisibleNodes] = useState<Set<string>>(new Set())
  const [isInitialLoad, setIsInitialLoad] = useState(true)

  const convertToReactFlowElements = useMemo(() => {
    const initialNodes = graphData.nodes.slice(0, 20)
    const initialNodeIds = new Set(initialNodes.map((n) => n.id))

    const flowNodes: Node[] = initialNodes.map((node) => ({
      id: node.id,
      type: 'tableNode',
      data: {
        label: node.name,
        type: node.type,
        database: node.properties?.database as string | undefined,
        schema: node.properties?.schema as string | undefined,
        rowCount: node.properties?.row_count as number | undefined,
        level: node.properties?.level as number | undefined,
        isExpanded: expandedNodes.has(node.id),
        hasChildren: graphData.nodes.length > 20 && !expandedNodes.has(node.id),
        isLoading: loadingNodes.has(node.id),
        onExpand: () => onExpandNode(node.id),
        onCollapse: () => onCollapseNode(node.id),
      } as TableNodeData,
      position: { x: 0, y: 0 },
      sourcePosition: Position.Right,
      targetPosition: Position.Left,
    }))

    const flowEdges: Edge[] = graphData.edges
      .filter((edge: LineageEdge) => initialNodeIds.has(edge.source_id) && initialNodeIds.has(edge.target_id))
      .map((edge: LineageEdge, index: number) => ({
        id: `edge-${index}`,
        source: edge.source_id,
        target: edge.target_id,
        type: 'smoothstep',
        animated: true,
        style: {
          stroke: '#1890FF',
          strokeWidth: 2,
        },
        markerEnd: {
          type: MarkerType.ArrowClosed,
          color: '#1890FF',
        },
        label: edge.transformation_type || edge.edge_type,
        labelStyle: {
          fill: '#666',
          fontSize: 12,
        },
        labelBgStyle: {
          fill: '#fff',
          fillOpacity: 0.9,
        },
      }))

    return getLayoutedElements(flowNodes, flowEdges, direction)
  }, [graphData, direction, expandedNodes, loadingNodes, onExpandNode, onCollapseNode])

  useEffect(() => {
    if (isInitialLoad) {
      setNodes(convertToReactFlowElements.nodes)
      setEdges(convertToReactFlowElements.edges)
      const initialIds = new Set(convertToReactFlowElements.nodes.map((n) => n.id))
      setVisibleNodes(initialIds)
      setTimeout(() => {
        fitView({ padding: 0.2 })
        setIsInitialLoad(false)
      }, 100)
    }
  }, [convertToReactFlowElements, setNodes, setEdges, fitView, isInitialLoad])

  const loadMoreNodes = useCallback(() => {
    if (visibleNodes.size >= graphData.nodes.length) return

    const currentSize = visibleNodes.size
    const batchSize = 10
    const newNodes = graphData.nodes.slice(currentSize, currentSize + batchSize)

    if (newNodes.length === 0) return

    const newNodeIds = new Set(newNodes.map((n) => n.id))
    const allVisibleIds = new Set([...visibleNodes, ...newNodeIds])

    const flowNodes: Node[] = graphData.nodes
      .filter((n) => allVisibleIds.has(n.id))
      .map((node) => ({
        id: node.id,
        type: 'tableNode',
        data: {
          label: node.name,
          type: node.type,
          database: node.properties?.database as string | undefined,
          schema: node.properties?.schema as string | undefined,
          rowCount: node.properties?.row_count as number | undefined,
          level: node.properties?.level as number | undefined,
          isExpanded: expandedNodes.has(node.id),
          hasChildren: allVisibleIds.size < graphData.nodes.length,
          isLoading: loadingNodes.has(node.id),
          onExpand: () => onExpandNode(node.id),
          onCollapse: () => onCollapseNode(node.id),
        } as TableNodeData,
        position: { x: 0, y: 0 },
        sourcePosition: Position.Right,
        targetPosition: Position.Left,
      }))

    const flowEdges: Edge[] = graphData.edges
      .filter((edge: LineageEdge) => allVisibleIds.has(edge.source_id) && allVisibleIds.has(edge.target_id))
      .map((edge: LineageEdge, index: number) => ({
        id: `edge-${index}`,
        source: edge.source_id,
        target: edge.target_id,
        type: 'smoothstep',
        animated: true,
        style: { stroke: '#1890FF', strokeWidth: 2 },
        markerEnd: { type: MarkerType.ArrowClosed, color: '#1890FF' },
        label: edge.transformation_type || edge.edge_type,
        labelStyle: { fill: '#666', fontSize: 12 },
        labelBgStyle: { fill: '#fff', fillOpacity: 0.9 },
      }))

    const layouted = getLayoutedElements(flowNodes, flowEdges, direction)
    setNodes(layouted.nodes)
    setEdges(layouted.edges)
    setVisibleNodes(allVisibleIds)

    setTimeout(() => fitView({ padding: 0.2 }), 100)
  }, [graphData, direction, visibleNodes, expandedNodes, loadingNodes, setNodes, setEdges, fitView, onExpandNode, onCollapseNode])

  useEffect(() => {
    const handleScroll = (event: WheelEvent) => {
      if (event.deltaY < 0 && visibleNodes.size < graphData.nodes.length) {
        loadMoreNodes()
      }
    }

    window.addEventListener('wheel', handleScroll)
    return () => window.removeEventListener('wheel', handleScroll)
  }, [loadMoreNodes, visibleNodes.size, graphData.nodes.length])

  return (
    <ReactFlow
      nodes={nodes}
      edges={edges}
      onNodesChange={onNodesChange}
      onEdgesChange={onEdgesChange}
      onNodeClick={onNodeClick}
      nodeTypes={nodeTypes}
      fitView
      fitViewOptions={{ padding: 0.2 }}
      minZoom={0.1}
      maxZoom={2}
      defaultEdgeOptions={{
        type: 'smoothstep',
        animated: true,
      }}
      proOptions={{ hideAttribution: true }}
    >
      <Background color="#aaa" gap={16} />
      <Controls showInteractive={false} />
      <MiniMap
        nodeColor={(node: Node) => {
          const colors = NODE_COLORS[node.data?.type as string] || NODE_COLORS.Table
          return colors.border
        }}
        maskColor="rgba(0, 0, 0, 0.1)"
        style={{ background: '#fff' }}
      />
      <Panel position="top-right">
        <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
          {visibleNodes.size < graphData.nodes.length && (
            <Tag color="orange">
              已加载 {visibleNodes.size}/{graphData.nodes.length} 个节点
            </Tag>
          )}
          <Button
            size="small"
            onClick={loadMoreNodes}
            disabled={visibleNodes.size >= graphData.nodes.length}
          >
            加载更多
          </Button>
        </div>
      </Panel>
    </ReactFlow>
  )
}

const LineagePage: React.FC = () => {
  const { tableId } = useParams<{ tableId: string }>()
  const [loading, setLoading] = useState(false)
  const [initialLoading, setInitialLoading] = useState(true)
  const [graphData, setGraphData] = useState<LineageGraph | null>(null)
  const [direction, setDirection] = useState<DirectionType>('upstream')
  const [depth, setDepth] = useState(5)
  const [selectedNode, setSelectedNode] = useState<LineageNode | null>(null)
  const [drawerVisible, setDrawerVisible] = useState(false)
  const [expandedNodes, setExpandedNodes] = useState<Set<string>>(new Set())
  const [loadingNodes, setLoadingNodes] = useState<Set<string>>(new Set())

  const reactFlowWrapper = useRef<HTMLDivElement>(null)

  const fetchLineageData = useCallback(async () => {
    if (!tableId) {
      message.warning('请选择要查看血缘的表')
      return
    }

    setLoading(true)
    setInitialLoading(true)
    try {
      const data = await lineageApi.getTableLineage(tableId, depth, direction)
      setGraphData(data)
      setExpandedNodes(new Set())
      setLoadingNodes(new Set())
    } catch (error) {
      message.error('获取血缘数据失败')
      console.error(error)
    } finally {
      setLoading(false)
      setInitialLoading(false)
    }
  }, [tableId, depth, direction])

  useEffect(() => {
    fetchLineageData()
  }, [fetchLineageData])

  const onNodeClick = useCallback(
    async (_event: React.MouseEvent, node: Node) => {
      setLoadingNodes((prev) => new Set([...prev, node.id]))
      try {
        const details = await lineageApi.getTableDetails(node.id)
        setSelectedNode(details)
        setDrawerVisible(true)
      } catch {
        const basicNode = graphData?.nodes.find((n) => n.id === node.id)
        if (basicNode) {
          setSelectedNode(basicNode)
          setDrawerVisible(true)
        }
      } finally {
        setLoadingNodes((prev) => {
          const next = new Set(prev)
          next.delete(node.id)
          return next
        })
      }
    },
    [graphData]
  )

  const onExpandNode = useCallback((nodeId: string) => {
    setExpandedNodes((prev) => new Set([...prev, nodeId]))
  }, [])

  const onCollapseNode = useCallback((nodeId: string) => {
    setExpandedNodes((prev) => {
      const next = new Set(prev)
      next.delete(nodeId)
      return next
    })
  }, [])

  const handleExportPNG = useCallback(async () => {
    if (!reactFlowWrapper.current) return

    try {
      const png = await toPng(reactFlowWrapper.current, {
        backgroundColor: '#fff',
        quality: 1,
      })

      const link = document.createElement('a')
      link.download = `lineage-${tableId}-${Date.now()}.png`
      link.href = png
      link.click()

      message.success('导出成功')
    } catch (error) {
      message.error('导出失败')
      console.error(error)
    }
  }, [tableId])

  const handleExportJSON = useCallback(() => {
    if (!graphData) return

    const json = JSON.stringify(graphData, null, 2)
    const blob = new Blob([json], { type: 'application/json' })
    const url = URL.createObjectURL(blob)

    const link = document.createElement('a')
    link.download = `lineage-${tableId}-${Date.now()}.json`
    link.href = url
    link.click()

    URL.revokeObjectURL(url)
    message.success('导出成功')
  }, [graphData, tableId])

  const handleFullscreen = useCallback(() => {
    if (!reactFlowWrapper.current) return

    if (document.fullscreenElement) {
      document.exitFullscreen()
    } else {
      reactFlowWrapper.current.requestFullscreen()
    }
  }, [])

  return (
    <Card
      title={
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <BranchesOutlined style={{ color: '#1890FF' }} />
          <span>表级血缘图谱</span>
          {graphData && (
            <Tag color="blue" style={{ marginLeft: '8px' }}>
              {graphData.total_nodes} 个节点 / {graphData.total_edges} 条边
            </Tag>
          )}
        </div>
      }
      extra={
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <Select
            value={depth}
            onChange={setDepth}
            style={{ width: 100 }}
            options={[
              { value: 1, label: '深度 1' },
              { value: 2, label: '深度 2' },
              { value: 3, label: '深度 3' },
              { value: 5, label: '深度 5' },
              { value: 7, label: '深度 7' },
              { value: 10, label: '深度 10' },
            ]}
          />
          <Radio.Group value={direction} onChange={(e) => setDirection(e.target.value)}>
            <Radio.Button value="upstream">上游</Radio.Button>
            <Radio.Button value="downstream">下游</Radio.Button>
            <Radio.Button value="both">双向</Radio.Button>
          </Radio.Group>
          <Tooltip title="导出 PNG">
            <Button icon={<CameraOutlined />} onClick={handleExportPNG} />
          </Tooltip>
          <Tooltip title="导出 JSON">
            <Button icon={<DownloadOutlined />} onClick={handleExportJSON} />
          </Tooltip>
        </div>
      }
      styles={{
        body: { padding: 0, height: 'calc(100vh - 180px)', overflow: 'hidden' },
      }}
    >
      {initialLoading ? (
        <GraphSkeleton />
      ) : loading ? (
        <div
          style={{
            height: '100%',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          <Spin size="large" tip="加载血缘数据..." />
        </div>
      ) : !graphData || graphData.nodes.length === 0 ? (
        <div
          style={{
            height: '100%',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          <Empty description="暂无血缘数据" />
        </div>
      ) : (
        <div ref={reactFlowWrapper} style={{ width: '100%', height: '100%' }}>
          <LazyLineageGraph
            graphData={graphData}
            direction={direction}
            expandedNodes={expandedNodes}
            loadingNodes={loadingNodes}
            onNodeClick={onNodeClick}
            onExpandNode={onExpandNode}
            onCollapseNode={onCollapseNode}
          />
          <Panel position="bottom-center">
            <Tooltip title="全屏">
              <Button icon={<FullscreenOutlined />} onClick={handleFullscreen} />
            </Tooltip>
          </Panel>
        </div>
      )}

      <Drawer
        title={
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <TableOutlined style={{ color: '#1890FF' }} />
            <span>{selectedNode?.name || '表详情'}</span>
          </div>
        }
        placement="right"
        width={480}
        open={drawerVisible}
        onClose={() => setDrawerVisible(false)}
      >
        {selectedNode && (
          <div>
            <Descriptions column={1} bordered size="small">
              <Descriptions.Item label="表名">{selectedNode.name}</Descriptions.Item>
              <Descriptions.Item label="类型">
                <Tag color={NODE_COLORS[selectedNode.type]?.border || '#1890FF'}>
                  {selectedNode.type}
                </Tag>
              </Descriptions.Item>
              <Descriptions.Item label="数据库">
                {(selectedNode.properties?.database as string) || '-'}
              </Descriptions.Item>
              <Descriptions.Item label="Schema">
                {(selectedNode.properties?.schema as string) || '-'}
              </Descriptions.Item>
              <Descriptions.Item label="行数">
                {(selectedNode.properties?.row_count as number)?.toLocaleString() || '-'}
              </Descriptions.Item>
              <Descriptions.Item label="数据源">
                {(selectedNode.properties?.data_source_name as string) || '-'}
              </Descriptions.Item>
              <Descriptions.Item label="创建时间">
                {(selectedNode.properties?.created_at as string) || '-'}
              </Descriptions.Item>
              <Descriptions.Item label="更新时间">
                {(selectedNode.properties?.updated_at as string) || '-'}
              </Descriptions.Item>
            </Descriptions>

            {(selectedNode.properties?.fields as Array<{ name: string; type: string }>)?.length >
              0 && (
              <Card
                title={
                  <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <CodeOutlined />
                    <span>字段列表</span>
                  </div>
                }
                style={{ marginTop: '16px' }}
                size="small"
              >
                <div style={{ maxHeight: '300px', overflow: 'auto' }}>
                  {(selectedNode.properties?.fields as Array<{ name: string; type: string }>)?.map(
                    (field, index) => (
                      <div
                        key={index}
                        style={{
                          padding: '8px 12px',
                          borderBottom:
                            index <
                            (
                              selectedNode.properties?.fields as Array<{
                                name: string
                                type: string
                              }>
                            ).length -
                              1
                              ? '1px solid #f0f0f0'
                              : 'none',
                          display: 'flex',
                          justifyContent: 'space-between',
                        }}
                      >
                        <Text>{field.name}</Text>
                        <Tag>{field.type}</Tag>
                      </div>
                    )
                  )}
                </div>
              </Card>
            )}

            <Card
              title={
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <ApiOutlined />
                  <span>血缘关系</span>
                </div>
              }
              style={{ marginTop: '16px' }}
              size="small"
            >
              <div>
                <Text type="secondary">上游表数量：</Text>
                <Text strong>
                  {graphData?.edges.filter((e) => e.target_id === selectedNode.id).length || 0}
                </Text>
              </div>
              <div style={{ marginTop: '8px' }}>
                <Text type="secondary">下游表数量：</Text>
                <Text strong>
                  {graphData?.edges.filter((e) => e.source_id === selectedNode.id).length || 0}
                </Text>
              </div>
            </Card>
          </div>
        )}
      </Drawer>
    </Card>
  )
}

export default LineagePage