import React from 'react'
import { Input, Button, Table, Card } from 'antd'
import { SearchOutlined } from '@ant-design/icons'

const SearchPage: React.FC = () => {
  const columns = [
    {
      title: '表名',
      dataIndex: 'name',
      key: 'name',
    },
    {
      title: '数据库',
      dataIndex: 'database',
      key: 'database',
    },
    {
      title: '类型',
      dataIndex: 'type',
      key: 'type',
    },
    {
      title: '字段数',
      dataIndex: 'columnCount',
      key: 'columnCount',
    },
    {
      title: '操作',
      key: 'action',
      render: () => <Button type="link">查看血缘</Button>,
    },
  ]

  return (
    <Card title="资产搜索">
      <div style={{ marginBottom: 16 }}>
        <Input.Search
          placeholder="输入表名或字段名"
          enterButton={<SearchOutlined />}
          size="large"
          style={{ width: 400 }}
        />
      </div>
      <Table columns={columns} dataSource={[]} />
    </Card>
  )
}

export default SearchPage