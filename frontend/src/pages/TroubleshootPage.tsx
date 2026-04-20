import React, { useState, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  Card,
  Input,
  Button,
  Tabs,
  Table,
  Tag,
  Timeline,
  Empty,
  Spin,
  Alert,
  Statistic,
  Row,
  Col,
  Tooltip,
  Space,
  Badge,
  Progress,
  Typography,
  message,
} from 'antd'
import {
  SearchOutlined,
  BugOutlined,
  LinkOutlined,
  ClockCircleOutlined,
  WarningOutlined,
  CheckCircleOutlined,
  ExclamationCircleOutlined,
  HistoryOutlined,
  DatabaseOutlined,
  RightOutlined,
} from '@ant-design/icons'
import type { ColumnsType } from 'antd/es/table'

import {
  troubleshootApi,
  QuickSearchResult,
  TroubleshootResult,
  LineageRelation,
  BatchExecution,
  ChangeRecord,
} from '../api/troubleshoot'

const { Title, Text } = Typography

const TroubleshootPage: React.FC = () => {
  const navigate = useNavigate()
  const [searchKeyword, setSearchKeyword] = useState('')
  const [searchResults, setSearchResults] = useState<QuickSearchResult[]>([])
  const [selectedObject, setSelectedObject] = useState<QuickSearchResult | null>(null)
  const [troubleshootResult, setTroubleshootResult] = useState<TroubleshootResult | null>(null)
  const [loading, setLoading] = useState(false)
  const [searching, setSearching] = useState(false)

  const handleSearch = useCallback(async () => {
    if (!searchKeyword.trim()) {
      message.warning('请输入搜索关键词')
      return
    }

    setSearching(true)
    try {
      const response = await troubleshootApi.quickSearch(searchKeyword, 'all', 10)
      setSearchResults(response.results)
      if (response.results.length === 0) {
        message.info('未找到匹配的对象')
      }
    } catch (error) {
      message.error('搜索失败，请稍后重试')
      console.error('Search error:', error)
    } finally {
      setSearching(false)
    }
  }, [searchKeyword])

  const handleSelectObject = useCallback(async (result: QuickSearchResult) => {
    setSelectedObject(result)
    setLoading(true)
    try {
      const data = await troubleshootApi.analyzeObjectByName(
        result.object_name,
        result.object_type,
        true,
        true,
        7
      )
      setTroubleshootResult(data)
    } catch (error) {
      message.error('分析失败，请稍后重试')
      console.error('Analyze error:', error)
    } finally {
      setLoading(false)
    }
  }, [])

  const handleAnalyze = useCallback(async () => {
    if (!searchKeyword.trim()) {
      message.warning('请输入对象名称')
      return
    }

    setLoading(true)
    try {
      const data = await troubleshootApi.analyzeObjectByName(searchKeyword, 'table', true, true, 7)
      setTroubleshootResult(data)
      setSelectedObject({
        object_id: data.object_id,
        object_name: data.object_name,
        object_type: data.object_type,
        has_lineage: data.upstream_lineages.length > 0 || data.downstream_lineages.length > 0,
        lineage_count: data.upstream_lineages.length + data.downstream_lineages.length,
      })
    } catch (error) {
      message.error('分析失败，请稍后重试')
      console.error('Analyze error:', error)
    } finally {
      setLoading(false)
    }
  }, [searchKeyword])

  const handleViewLineage = useCallback((objectId: string) => {
    navigate(`/lineage/${objectId}`)
  }, [navigate])

  const getStatusColor = (status: string): string => {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
        return 'green'
      case 'running':
      case 'pending':
        return 'blue'
      case 'failed':
      case 'error':
        return 'red'
      default:
        return 'default'
    }
  }

  const getImpactColor = (level: string): string => {
    switch (level.toLowerCase()) {
      case 'critical':
        return 'red'
      case 'high':
        return 'orange'
      case 'medium':
        return 'yellow'
      case 'low':
        return 'green'
      default:
        return 'default'
    }
  }

  const searchColumns: ColumnsType<QuickSearchResult> = [
    {
      title: '对象名称',
      dataIndex: 'object_name',
      key: 'object_name',
      render: (text: string, _record: QuickSearchResult) => (
        <Space>
          <DatabaseOutlined />
          <Text strong>{text}</Text>
        </Space>
      ),
    },
    {
      title: '类型',
      dataIndex: 'object_type',
      key: 'object_type',
      render: (type: string) => (
        <Tag color={type === 'Table' ? 'blue' : 'purple'}>{type}</Tag>
      ),
    },
    {
      title: '数据库',
      dataIndex: 'database',
      key: 'database',
    },
    {
      title: '模式',
      dataIndex: 'schema',
      key: 'schema',
    },
    {
      title: '血缘',
      dataIndex: 'has_lineage',
      key: 'has_lineage',
      render: (hasLineage: boolean, record: QuickSearchResult) => (
        <Badge
          count={record.lineage_count}
          showZero
          color={hasLineage ? 'green' : 'default'}
          style={{ marginLeft: 8 }}
        />
      ),
    },
    {
      title: '操作',
      key: 'action',
      render: (_: unknown, record: QuickSearchResult) => (
        <Button
          type="link"
          icon={<BugOutlined />}
          onClick={() => handleSelectObject(record)}
        >
          排查
        </Button>
      ),
    },
  ]

  const lineageColumns: ColumnsType<LineageRelation> = [
    {
      title: '源对象',
      dataIndex: 'source_name',
      key: 'source_name',
      render: (text: string, record: LineageRelation) => (
        <Tooltip title={`ID: ${record.source_id}`}>
          <Button
            type="link"
            onClick={() => handleViewLineage(record.source_id)}
          >
            {text}
          </Button>
        </Tooltip>
      ),
    },
    {
      title: '目标对象',
      dataIndex: 'target_name',
      key: 'target_name',
      render: (text: string, record: LineageRelation) => (
        <Tooltip title={`ID: ${record.target_id}`}>
          <Button
            type="link"
            onClick={() => handleViewLineage(record.target_id)}
          >
            {text}
          </Button>
        </Tooltip>
      ),
    },
    {
      title: '血缘类型',
      dataIndex: 'lineage_type',
      key: 'lineage_type',
      render: (type: string) => <Tag>{type}</Tag>,
    },
    {
      title: '来源',
      dataIndex: 'sources',
      key: 'sources',
      render: (sources: string[]) => (
        <Space>
          {sources.map((s) => (
            <Tag key={s} color={s === 'static' ? 'blue' : 'green'}>
              {s}
            </Tag>
          ))}
        </Space>
      ),
    },
    {
      title: '置信度',
      dataIndex: 'confidence_score',
      key: 'confidence_score',
      render: (score: number) => (
        <Progress
          percent={Math.round(score * 100)}
          size="small"
          status={score >= 0.7 ? 'success' : score >= 0.5 ? 'normal' : 'exception'}
        />
      ),
    },
    {
      title: '执行次数',
      dataIndex: 'execution_count',
      key: 'execution_count',
      render: (count: number) => <Badge count={count} showZero color="blue" />,
    },
    {
      title: '最后执行',
      dataIndex: 'last_seen',
      key: 'last_seen',
      render: (time?: string) =>
        time ? new Date(time).toLocaleString('zh-CN') : '-',
    },
  ]

  const batchColumns: ColumnsType<BatchExecution> = [
    {
      title: '批次 ID',
      dataIndex: 'batch_id',
      key: 'batch_id',
      width: 150,
      ellipsis: true,
    },
    {
      title: '作业名称',
      dataIndex: 'job_name',
      key: 'job_name',
      render: (text: string) => <Text strong>{text}</Text>,
    },
    {
      title: '类型',
      dataIndex: 'job_type',
      key: 'job_type',
      render: (type: string) => <Tag>{type}</Tag>,
    },
    {
      title: '状态',
      dataIndex: 'status',
      key: 'status',
      render: (status: string) => (
        <Tag color={getStatusColor(status)}>
          {status.toUpperCase()}
        </Tag>
      ),
    },
    {
      title: '开始时间',
      dataIndex: 'start_time',
      key: 'start_time',
      render: (time: string) => new Date(time).toLocaleString('zh-CN'),
    },
    {
      title: '耗时',
      dataIndex: 'duration_seconds',
      key: 'duration_seconds',
      render: (seconds: number) => {
        if (seconds < 60) return `${seconds.toFixed(1)}秒`
        if (seconds < 3600) return `${(seconds / 60).toFixed(1)}分钟`
        return `${(seconds / 3600).toFixed(1)}小时`
      },
    },
    {
      title: '处理记录',
      dataIndex: 'records_processed',
      key: 'records_processed',
      render: (count: number, record: BatchExecution) => (
        <Space>
          <Text>{count}</Text>
          {record.records_failed > 0 && (
            <Tag color="red">失败 {record.records_failed}</Tag>
          )}
        </Space>
      ),
    },
    {
      title: '错误信息',
      dataIndex: 'error_message',
      key: 'error_message',
      ellipsis: true,
      render: (msg?: string) =>
        msg ? (
          <Tooltip title={msg}>
            <ExclamationCircleOutlined style={{ color: 'red' }} />
          </Tooltip>
        ) : null,
    },
  ]

  const renderChangeTimeline = (changes: ChangeRecord[]) => {
    if (changes.length === 0) {
      return <Empty description="暂无变更历史" />
    }

    return (
      <Timeline
        items={changes.map((change) => ({
          color: getImpactColor(change.impact_level),
          dot:
            change.impact_level === 'critical' || change.impact_level === 'high'
              ? <WarningOutlined />
              : <ClockCircleOutlined />,
          children: (
            <div>
              <Space>
                <Tag color={getImpactColor(change.impact_level)}>
                  {change.impact_level.toUpperCase()}
                </Tag>
                <Tag>{change.change_type}</Tag>
                <Text type="secondary">
                  {new Date(change.change_time).toLocaleString('zh-CN')}
                </Text>
              </Space>
              <br />
              <Text strong>{change.object_name}</Text>
              {change.change_description && (
                <Text type="secondary"> - {change.change_description}</Text>
              )}
              {change.change_user && (
                <Text type="secondary"> (操作人: {change.change_user})</Text>
              )}
              {change.before_value && change.after_value && (
                <div style={{ marginTop: 8 }}>
                  <Text code>变更前: {change.before_value}</Text>
                  <RightOutlined style={{ margin: '0 8px', color: '#999' }} />
                  <Text code>变更后: {change.after_value}</Text>
                </div>
              )}
            </div>
          ),
        }))}
      />
    )
  }

  const renderIssues = (issues: string[]) => {
    if (issues.length === 0) {
      return (
        <Alert
          type="success"
          message="未发现潜在问题"
          icon={<CheckCircleOutlined />}
          showIcon
        />
      )
    }

    return (
      <Space direction="vertical" style={{ width: '100%' }}>
        {issues.map((issue, index) => (
          <Alert
            key={index}
            type="warning"
            message={issue}
            icon={<WarningOutlined />}
            showIcon
          />
        ))}
      </Space>
    )
  }

  const renderRecommendations = (recommendations: string[]) => {
    if (recommendations.length === 0) {
      return <Empty description="暂无排查建议" />
    }

    return (
      <Space direction="vertical" style={{ width: '100%' }}>
        {recommendations.map((rec, index) => (
          <Alert
            key={index}
            type="info"
            message={rec}
            icon={<CheckCircleOutlined />}
            showIcon
          />
        ))}
      </Space>
    )
  }

  return (
    <div style={{ padding: '0 24px' }}>
      <Card style={{ marginBottom: 24 }}>
        <Title level={4}>
          <BugOutlined style={{ marginRight: 8 }} />
          问题排查
        </Title>
        <Text type="secondary">
          输入表名或字段名，快速定位数据问题，查看血缘关系、运行批次和变更历史
        </Text>
        <div style={{ marginTop: 16 }}>
          <Space.Compact style={{ width: '100%' }}>
            <Input
              placeholder="输入表名或字段名进行搜索..."
              size="large"
              value={searchKeyword}
              onChange={(e) => setSearchKeyword(e.target.value)}
              onPressEnter={handleSearch}
              prefix={<SearchOutlined />}
            />
            <Button
              type="default"
              size="large"
              icon={<SearchOutlined />}
              loading={searching}
              onClick={handleSearch}
            >
              搜索
            </Button>
            <Button
              type="primary"
              size="large"
              icon={<BugOutlined />}
              loading={loading}
              onClick={handleAnalyze}
            >
              直接分析
            </Button>
          </Space.Compact>
        </div>
      </Card>

      {searchResults.length > 0 && !selectedObject && (
        <Card style={{ marginBottom: 24 }}>
          <Table
            columns={searchColumns}
            dataSource={searchResults}
            rowKey="object_id"
            pagination={false}
            size="small"
          />
        </Card>
      )}

      {loading && (
        <Card>
          <Spin size="large" style={{ display: 'block', margin: '100px auto' }}>
            <Text type="secondary">正在分析...</Text>
          </Spin>
        </Card>
      )}

      {troubleshootResult && !loading && (
        <>
          <Card style={{ marginBottom: 24 }}>
            <Row gutter={16}>
              <Col span={4}>
                <Statistic
                  title="上游血缘"
                  value={troubleshootResult.statistics.upstream_count as number}
                  prefix={<LinkOutlined />}
                />
              </Col>
              <Col span={4}>
                <Statistic
                  title="下游血缘"
                  value={troubleshootResult.statistics.downstream_count as number}
                  prefix={<LinkOutlined />}
                />
              </Col>
              <Col span={4}>
                <Statistic
                  title="执行批次"
                  value={troubleshootResult.statistics.batch_count as number}
                  prefix={<ClockCircleOutlined />}
                />
              </Col>
              <Col span={4}>
                <Statistic
                  title="失败批次"
                  value={troubleshootResult.statistics.failed_batch_count as number}
                  valueStyle={{
                    color:
                      (troubleshootResult.statistics.failed_batch_count as number) > 0
                        ? '#cf1322'
                        : '#3f8600',
                  }}
                  prefix={<ExclamationCircleOutlined />}
                />
              </Col>
              <Col span={4}>
                <Statistic
                  title="变更次数"
                  value={troubleshootResult.statistics.change_count as number}
                  prefix={<HistoryOutlined />}
                />
              </Col>
              <Col span={4}>
                <Statistic
                  title="平均置信度"
                  value={Math.round(
                    (troubleshootResult.statistics.avg_confidence as number) * 100
                  )}
                  suffix="%"
                  prefix={<CheckCircleOutlined />}
                />
              </Col>
            </Row>
          </Card>

          <Card style={{ marginBottom: 24 }}>
            <Tabs
              defaultActiveKey="upstream"
              items={[
                {
                  key: 'upstream',
                  label: (
                    <span>
                      <LinkOutlined />
                      上游血缘 ({troubleshootResult.upstream_lineages.length})
                    </span>
                  ),
                  children: (
                    <Table
                      columns={lineageColumns}
                      dataSource={troubleshootResult.upstream_lineages}
                      rowKey="source_id"
                      pagination={{ pageSize: 10 }}
                      size="small"
                    />
                  ),
                },
                {
                  key: 'downstream',
                  label: (
                    <span>
                      <LinkOutlined />
                      下游血缘 ({troubleshootResult.downstream_lineages.length})
                    </span>
                  ),
                  children: (
                    <Table
                      columns={lineageColumns}
                      dataSource={troubleshootResult.downstream_lineages}
                      rowKey="target_id"
                      pagination={{ pageSize: 10 }}
                      size="small"
                    />
                  ),
                },
                {
                  key: 'batches',
                  label: (
                    <span>
                      <ClockCircleOutlined />
                      最近批次 ({troubleshootResult.recent_batches.length})
                    </span>
                  ),
                  children: (
                    <Table
                      columns={batchColumns}
                      dataSource={troubleshootResult.recent_batches}
                      rowKey="batch_id"
                      pagination={{ pageSize: 10 }}
                      size="small"
                    />
                  ),
                },
                {
                  key: 'changes',
                  label: (
                    <span>
                      <HistoryOutlined />
                      变更历史 ({troubleshootResult.change_history.length})
                    </span>
                  ),
                  children: renderChangeTimeline(troubleshootResult.change_history),
                },
              ]}
            />
          </Card>

          <Row gutter={16}>
            <Col span={12}>
              <Card
                title={
                  <span>
                    <WarningOutlined style={{ marginRight: 8 }} />
                    潜在问题
                  </span>
                }
                style={{ marginBottom: 24 }}
              >
                {renderIssues(troubleshootResult.potential_issues)}
              </Card>
            </Col>
            <Col span={12}>
              <Card
                title={
                  <span>
                    <CheckCircleOutlined style={{ marginRight: 8 }} />
                    排查建议
                  </span>
                }
                style={{ marginBottom: 24 }}
              >
                {renderRecommendations(troubleshootResult.recommendations)}
              </Card>
            </Col>
          </Row>

          <Card>
            <Space>
              <Button
                type="primary"
                icon={<LinkOutlined />}
                onClick={() => handleViewLineage(troubleshootResult.object_id)}
              >
                查看完整血缘
              </Button>
              <Button
                icon={<SearchOutlined />}
                onClick={() => {
                  setSearchKeyword('')
                  setSearchResults([])
                  setSelectedObject(null)
                  setTroubleshootResult(null)
                }}
              >
                重新搜索
              </Button>
            </Space>
          </Card>
        </>
      )}

      {!troubleshootResult && !loading && searchResults.length === 0 && (
        <Card>
          <Empty
            description="输入表名或字段名开始排查"
            image={Empty.PRESENTED_IMAGE_SIMPLE}
          />
        </Card>
      )}
    </div>
  )
}

export default TroubleshootPage