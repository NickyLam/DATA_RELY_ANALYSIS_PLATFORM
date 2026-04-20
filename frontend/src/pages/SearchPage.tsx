import React, { useCallback, useEffect, useState } from 'react'
import {
  Button,
  Card,
  Col,
  Form,
  Input,
  message,
  Pagination,
  Row,
  Select,
  Space,
  Spin,
  Table,
  Tabs,
  Tag,
  Tooltip,
} from 'antd'
import {
  ArrowDownOutlined,
  ArrowUpOutlined,
  DatabaseOutlined,
  FieldStringOutlined,
  FilterOutlined,
  LinkOutlined,
  SearchOutlined,
  TableOutlined,
} from '@ant-design/icons'
import { useNavigate } from 'react-router-dom'
import type { ColumnsType, TablePaginationConfig } from 'antd/es/table'
import type { TabsProps } from 'antd/es/tabs'

import {
  FieldSearchResult,
  FilterOptions,
  SearchParams,
  SearchResult,
  SearchType,
  SortField,
  SortOrder,
  TableSearchResult,
  searchApi,
} from '../api/search'

const { Option } = Select

interface SearchFormData {
  keyword: string
  exact_name: string
  data_source_id: string
  schema_name: string
  table_type: string
  owner: string
  data_type: string
  table_name: string
}

const SearchPage: React.FC = () => {
  const navigate = useNavigate()
  const [form] = Form.useForm<SearchFormData>()

  const [loading, setLoading] = useState<boolean>(false)
  const [filterOptions, setFilterOptions] = useState<FilterOptions>({
    data_sources: [],
    schemas: [],
    table_types: [],
    data_types: [],
  })
  const [searchResult, setSearchResult] = useState<SearchResult>({
    tables: [],
    fields: [],
    total_tables: 0,
    total_fields: 0,
    page: 1,
    page_size: 20,
    total_pages: 0,
  })
  const [searchType, setSearchType] = useState<SearchType>('all')
  const [currentPage, setCurrentPage] = useState<number>(1)
  const [pageSize, setPageSize] = useState<number>(20)
  const [sortBy, setSortBy] = useState<SortField>('name')
  const [sortOrder, setSortOrder] = useState<SortOrder>('asc')
  const [showFilters, setShowFilters] = useState<boolean>(false)
  const [hasSearched, setHasSearched] = useState<boolean>(false)

  useEffect(() => {
    loadFilterOptions()
  }, [])

  const loadFilterOptions = useCallback(async () => {
    try {
      const options = await searchApi.getFilterOptions()
      setFilterOptions(options)
    } catch {
      message.error('加载筛选选项失败')
    }
  }, [])

  const handleSearch = useCallback(async () => {
    try {
      setLoading(true)
      const formData = form.getFieldsValue()

      const params: SearchParams = {
        keyword: formData.keyword || undefined,
        exact_name: formData.exact_name || undefined,
        data_source_id: formData.data_source_id || undefined,
        schema_name: formData.schema_name || undefined,
        table_type: formData.table_type || undefined,
        owner: formData.owner || undefined,
        data_type: formData.data_type || undefined,
        table_name: formData.table_name || undefined,
        search_type: searchType,
        sort_by: sortBy,
        sort_order: sortOrder,
        page: currentPage,
        page_size: pageSize,
      }

      const result = await searchApi.searchAll(params)
      setSearchResult(result)
      setHasSearched(true)
    } catch {
      message.error('搜索失败，请重试')
    } finally {
      setLoading(false)
    }
  }, [form, searchType, sortBy, sortOrder, currentPage, pageSize])

  const handleTableChange = useCallback(
    (pagination: TablePaginationConfig) => {
      setCurrentPage(pagination.current || 1)
      setPageSize(pagination.pageSize || 20)
    },
    []
  )

  const handleSortChange = useCallback((field: SortField) => {
    if (sortBy === field) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc')
    } else {
      setSortBy(field)
      setSortOrder('asc')
    }
  }, [sortBy, sortOrder])

  const handleDataSourceChange = useCallback(async (dataSourceId: string) => {
    form.setFieldValue('schema_name', undefined)
    if (dataSourceId) {
      try {
        const schemas = await searchApi.getSchemas(dataSourceId)
        setFilterOptions(prev => ({ ...prev, schemas }))
      } catch {
        message.error('加载Schema列表失败')
      }
    } else {
      loadFilterOptions()
    }
  }, [form, loadFilterOptions])

  const handleViewLineage = useCallback((tableId: string) => {
    navigate(`/lineage/${tableId}`)
  }, [navigate])

  const handleViewFieldLineage = useCallback((fieldId: string) => {
    navigate(`/field-lineage/${fieldId}`)
  }, [navigate])

  const handleViewImpact = useCallback((tableId: string) => {
    navigate(`/impact/${tableId}`)
  }, [navigate])

  const handleTabChange = useCallback((key: string) => {
    setSearchType(key as SearchType)
    setCurrentPage(1)
  }, [])

  const handleReset = useCallback(() => {
    form.resetFields()
    setSearchType('all')
    setCurrentPage(1)
    setSortBy('name')
    setSortOrder('asc')
    loadFilterOptions()
  }, [form, loadFilterOptions])

  const tableColumns: ColumnsType<TableSearchResult> = [
    {
      title: '表名',
      dataIndex: 'name',
      key: 'name',
      width: 200,
      ellipsis: true,
      render: (text: string, _record: TableSearchResult) => (
        <Tooltip title={text}>
          <Space>
            <TableOutlined style={{ color: '#1890ff' }} />
            <span style={{ fontWeight: 500 }}>{text}</span>
          </Space>
        </Tooltip>
      ),
    },
    {
      title: 'Schema',
      dataIndex: 'schema_name',
      key: 'schema_name',
      width: 120,
      ellipsis: true,
    },
    {
      title: '数据库',
      dataIndex: 'database_name',
      key: 'database_name',
      width: 120,
      ellipsis: true,
    },
    {
      title: '数据源',
      dataIndex: 'data_source_name',
      key: 'data_source_name',
      width: 120,
      ellipsis: true,
      render: (text: string) => (
        <Tooltip title={text}>
          <Space>
            <DatabaseOutlined style={{ color: '#52c41a' }} />
            <span>{text}</span>
          </Space>
        </Tooltip>
      ),
    },
    {
      title: '类型',
      dataIndex: 'table_type',
      key: 'table_type',
      width: 100,
      render: (text: string) => {
        const colorMap: Record<string, string> = {
          table: 'blue',
          view: 'green',
          materialized_view: 'orange',
        }
        return <Tag color={colorMap[text] || 'default'}>{text}</Tag>
      },
    },
    {
      title: '字段数',
      dataIndex: 'column_count',
      key: 'column_count',
      width: 80,
      align: 'center',
      sorter: true,
      sortOrder: sortBy === 'column_count' ? (sortOrder === 'asc' ? 'ascend' : 'descend') : null,
      render: (count: number) => <Tag color="purple">{count}</Tag>,
    },
    {
      title: '血缘关系',
      dataIndex: 'lineage_count',
      key: 'lineage_count',
      width: 120,
      align: 'center',
      sorter: true,
      sortOrder: sortBy === 'lineage_count' ? (sortOrder === 'asc' ? 'ascend' : 'descend') : null,
      render: (_: number, record: TableSearchResult) => (
        <Space direction="vertical" size={0}>
          <Tooltip title="上游血缘">
            <Tag color="cyan">
              <ArrowUpOutlined /> {record.upstream_count}
            </Tag>
          </Tooltip>
          <Tooltip title="下游血缘">
            <Tag color="magenta">
              <ArrowDownOutlined /> {record.downstream_count}
            </Tag>
          </Tooltip>
        </Space>
      ),
    },
    {
      title: '所有者',
      dataIndex: 'owner',
      key: 'owner',
      width: 100,
      ellipsis: true,
      render: (text: string) => text || '-',
    },
    {
      title: '操作',
      key: 'action',
      width: 180,
      fixed: 'right',
      render: (_: unknown, record: TableSearchResult) => (
        <Space size="small">
          <Button
            type="link"
            size="small"
            icon={<LinkOutlined />}
            onClick={() => handleViewLineage(record.id)}
          >
            血缘
          </Button>
          <Button
            type="link"
            size="small"
            onClick={() => handleViewImpact(record.id)}
          >
            影响分析
          </Button>
        </Space>
      ),
    },
  ]

  const fieldColumns: ColumnsType<FieldSearchResult> = [
    {
      title: '字段名',
      dataIndex: 'name',
      key: 'name',
      width: 180,
      ellipsis: true,
      render: (text: string, record: FieldSearchResult) => (
        <Tooltip title={text}>
          <Space>
            <FieldStringOutlined style={{ color: '#faad14' }} />
            <span style={{ fontWeight: 500 }}>{text}</span>
            {record.is_primary_key && <Tag color="red">PK</Tag>}
            {record.is_foreign_key && <Tag color="orange">FK</Tag>}
          </Space>
        </Tooltip>
      ),
    },
    {
      title: '所属表',
      dataIndex: 'table_name',
      key: 'table_name',
      width: 180,
      ellipsis: true,
      render: (text: string) => (
        <Tooltip title={text}>
          <Space>
            <TableOutlined style={{ color: '#1890ff' }} />
            <span>{text}</span>
          </Space>
        </Tooltip>
      ),
    },
    {
      title: 'Schema',
      dataIndex: 'schema_name',
      key: 'schema_name',
      width: 100,
      ellipsis: true,
    },
    {
      title: '数据源',
      dataIndex: 'data_source_name',
      key: 'data_source_name',
      width: 120,
      ellipsis: true,
    },
    {
      title: '数据类型',
      dataIndex: 'data_type',
      key: 'data_type',
      width: 120,
      ellipsis: true,
      render: (text: string) => text || '-',
    },
    {
      title: '可空',
      dataIndex: 'is_nullable',
      key: 'is_nullable',
      width: 60,
      align: 'center',
      render: (nullable: boolean) => (
        <Tag color={nullable ? 'default' : 'red'}>{nullable ? 'YES' : 'NO'}</Tag>
      ),
    },
    {
      title: '血缘数',
      dataIndex: 'lineage_count',
      key: 'lineage_count',
      width: 80,
      align: 'center',
      render: (count: number) => <Tag color="purple">{count}</Tag>,
    },
    {
      title: '操作',
      key: 'action',
      width: 100,
      fixed: 'right',
      render: (_: unknown, record: FieldSearchResult) => (
        <Button
          type="link"
          size="small"
          icon={<LinkOutlined />}
          onClick={() => handleViewFieldLineage(record.id)}
        >
          字段血缘
        </Button>
      ),
    },
  ]

  const tabItems: TabsProps['items'] = [
    {
      key: 'all',
      label: (
        <Space>
          <SearchOutlined />
          全部 ({searchResult.total_tables + searchResult.total_fields})
        </Space>
      ),
    },
    {
      key: 'tables',
      label: (
        <Space>
          <TableOutlined />
          表 ({searchResult.total_tables})
        </Space>
      ),
    },
    {
      key: 'fields',
      label: (
        <Space>
          <FieldStringOutlined />
          字段 ({searchResult.total_fields})
        </Space>
      ),
    },
  ]

  useEffect(() => {
    if (hasSearched) {
      handleSearch()
    }
  }, [currentPage, pageSize, sortBy, sortOrder, searchType, handleSearch, hasSearched])

  return (
    <div style={{ padding: '24px' }}>
      <Card
        title={
          <Space>
            <SearchOutlined style={{ fontSize: '20px', color: '#1890ff' }} />
            <span style={{ fontSize: '18px', fontWeight: 600 }}>资产搜索</span>
          </Space>
        }
        extra={
          <Space>
            <Button
              icon={<FilterOutlined />}
              onClick={() => setShowFilters(!showFilters)}
            >
              {showFilters ? '隐藏筛选' : '高级筛选'}
            </Button>
            <Button onClick={handleReset}>重置</Button>
            <Button type="primary" icon={<SearchOutlined />} onClick={handleSearch} loading={loading}>
              搜索
            </Button>
          </Space>
        }
        style={{ marginBottom: '16px' }}
      >
        <Form form={form} layout="vertical">
          <Row gutter={16}>
            <Col xs={24} sm={12} md={8} lg={6}>
              <Form.Item name="keyword" label="关键词（模糊查询）">
                <Input
                  placeholder="输入表名或字段名关键词"
                  prefix={<SearchOutlined />}
                  allowClear
                  onPressEnter={handleSearch}
                />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12} md={8} lg={6}>
              <Form.Item name="exact_name" label="名称（精确查询）">
                <Input
                  placeholder="输入完整名称"
                  allowClear
                  onPressEnter={handleSearch}
                />
              </Form.Item>
            </Col>
          </Row>

          {showFilters && (
            <Row gutter={16}>
              <Col xs={24} sm={12} md={8} lg={6}>
                <Form.Item name="data_source_id" label="数据源">
                  <Select
                    placeholder="选择数据源"
                    allowClear
                    showSearch
                    onChange={handleDataSourceChange}
                  >
                    {filterOptions.data_sources.map(ds => (
                      <Option key={ds.id} value={ds.id}>
                        <Space>
                          <DatabaseOutlined />
                          {ds.name}
                        </Space>
                      </Option>
                    ))}
                  </Select>
                </Form.Item>
              </Col>
              <Col xs={24} sm={12} md={8} lg={6}>
                <Form.Item name="schema_name" label="Schema">
                  <Select placeholder="选择Schema" allowClear showSearch>
                    {filterOptions.schemas.map(schema => (
                      <Option key={schema} value={schema}>
                        {schema}
                      </Option>
                    ))}
                  </Select>
                </Form.Item>
              </Col>
              <Col xs={24} sm={12} md={8} lg={6}>
                <Form.Item name="table_type" label="表类型">
                  <Select placeholder="选择表类型" allowClear>
                    {filterOptions.table_types.map(type => (
                      <Option key={type} value={type}>
                        {type}
                      </Option>
                    ))}
                  </Select>
                </Form.Item>
              </Col>
              <Col xs={24} sm={12} md={8} lg={6}>
                <Form.Item name="owner" label="所有者">
                  <Input placeholder="输入所有者名称" allowClear />
                </Form.Item>
              </Col>
              <Col xs={24} sm={12} md={8} lg={6}>
                <Form.Item name="data_type" label="数据类型">
                  <Select placeholder="选择数据类型" allowClear showSearch>
                    {filterOptions.data_types.map(type => (
                      <Option key={type} value={type}>
                        {type}
                      </Option>
                    ))}
                  </Select>
                </Form.Item>
              </Col>
              <Col xs={24} sm={12} md={8} lg={6}>
                <Form.Item name="table_name" label="所属表名">
                  <Input placeholder="输入表名（字段搜索）" allowClear />
                </Form.Item>
              </Col>
            </Row>
          )}
        </Form>
      </Card>

      <Card>
        <Tabs activeKey={searchType} items={tabItems} onChange={handleTabChange} />

        <Spin spinning={loading}>
          {searchType === 'all' && (
            <div>
              {searchResult.tables.length > 0 && (
                <div style={{ marginBottom: '24px' }}>
                  <div style={{ marginBottom: '12px', fontWeight: 500 }}>
                    <TableOutlined style={{ marginRight: '8px', color: '#1890ff' }} />
                    表搜索结果 ({searchResult.total_tables})
                  </div>
                  <Table
                    columns={tableColumns}
                    dataSource={searchResult.tables}
                    rowKey="id"
                    pagination={false}
                    scroll={{ x: 1200 }}
                    size="middle"
                    onChange={(pagination, _filters, sorter) => {
                      if (!Array.isArray(sorter) && sorter.field) {
                        handleSortChange(sorter.field as SortField)
                      }
                      handleTableChange(pagination)
                    }}
                  />
                </div>
              )}

              {searchResult.fields.length > 0 && (
                <div>
                  <div style={{ marginBottom: '12px', fontWeight: 500 }}>
                    <FieldStringOutlined style={{ marginRight: '8px', color: '#faad14' }} />
                    字段搜索结果 ({searchResult.total_fields})
                  </div>
                  <Table
                    columns={fieldColumns}
                    dataSource={searchResult.fields}
                    rowKey="id"
                    pagination={false}
                    scroll={{ x: 1000 }}
                    size="middle"
                  />
                </div>
              )}

              {!loading && hasSearched && searchResult.tables.length === 0 && searchResult.fields.length === 0 && (
                <div style={{ textAlign: 'center', padding: '48px', color: '#999' }}>
                  <SearchOutlined style={{ fontSize: '48px', marginBottom: '16px' }} />
                  <div>未找到匹配的资产</div>
                </div>
              )}
            </div>
          )}

          {searchType === 'tables' && (
            <Table
              columns={tableColumns}
              dataSource={searchResult.tables}
              rowKey="id"
              pagination={{
                current: currentPage,
                pageSize: pageSize,
                total: searchResult.total_tables,
                showSizeChanger: true,
                showQuickJumper: true,
                showTotal: (total) => `共 ${total} 条`,
                pageSizeOptions: ['10', '20', '50', '100'],
              }}
              scroll={{ x: 1200 }}
              size="middle"
              loading={loading}
              onChange={(pagination, _filters, sorter) => {
                if (!Array.isArray(sorter) && sorter.field) {
                  handleSortChange(sorter.field as SortField)
                }
                handleTableChange(pagination)
              }}
            />
          )}

          {searchType === 'fields' && (
            <Table
              columns={fieldColumns}
              dataSource={searchResult.fields}
              rowKey="id"
              pagination={{
                current: currentPage,
                pageSize: pageSize,
                total: searchResult.total_fields,
                showSizeChanger: true,
                showQuickJumper: true,
                showTotal: (total) => `共 ${total} 条`,
                pageSizeOptions: ['10', '20', '50', '100'],
              }}
              scroll={{ x: 1000 }}
              size="middle"
              loading={loading}
              onChange={handleTableChange}
            />
          )}

          {searchType === 'all' && hasSearched && (searchResult.total_tables > 0 || searchResult.total_fields > 0) && (
            <div style={{ marginTop: '16px', textAlign: 'center' }}>
              <Pagination
                current={currentPage}
                pageSize={pageSize}
                total={searchResult.total_tables + searchResult.total_fields}
                showSizeChanger
                showQuickJumper
                showTotal={(total) => `共 ${total} 条`}
                pageSizeOptions={['10', '20', '50', '100']}
                onChange={(page, newPageSize) => {
                  setCurrentPage(page)
                  setPageSize(newPageSize)
                }}
              />
            </div>
          )}
        </Spin>
      </Card>
    </div>
  )
}

export default SearchPage