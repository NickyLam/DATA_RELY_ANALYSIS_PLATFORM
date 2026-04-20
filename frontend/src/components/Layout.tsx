import React from 'react'
import { Outlet, useNavigate, useLocation } from 'react-router-dom'
import { Layout as AntLayout, Menu, Dropdown, Avatar } from 'antd'
import { SearchOutlined, DatabaseOutlined, SettingOutlined, UserOutlined, LogoutOutlined, BranchesOutlined, ApartmentOutlined, BugOutlined } from '@ant-design/icons'

const { Header, Content, Sider } = AntLayout

const Layout: React.FC = () => {
  const navigate = useNavigate()
  const location = useLocation()
  const username = localStorage.getItem('username') || '用户'

  const menuItems = [
    {
      key: '/search',
      icon: <SearchOutlined />,
      label: '资产搜索',
    },
    {
      key: '/troubleshoot',
      icon: <BugOutlined />,
      label: '问题排查',
    },
    {
      key: '/lineage',
      icon: <ApartmentOutlined />,
      label: '表级血缘',
    },
    {
      key: '/field-lineage',
      icon: <BranchesOutlined />,
      label: '字段血缘',
    },
    {
      key: '/data-sources',
      icon: <DatabaseOutlined />,
      label: '数据源管理',
    },
    {
      key: '/settings',
      icon: <SettingOutlined />,
      label: '系统设置',
    },
  ]

  const handleMenuClick = ({ key }: { key: string }) => {
    navigate(key)
  }

  const handleLogout = () => {
    localStorage.removeItem('isAuthenticated')
    localStorage.removeItem('username')
    navigate('/login')
  }

  const userMenuItems = [
    {
      key: 'profile',
      icon: <UserOutlined />,
      label: '个人信息',
    },
    {
      key: 'logout',
      icon: <LogoutOutlined />,
      label: '退出登录',
      danger: true,
    },
  ]

  const handleUserMenuClick = ({ key }: { key: string }) => {
    if (key === 'logout') {
      handleLogout()
    }
  }

  return (
    <AntLayout style={{ minHeight: '100vh' }}>
      <Header style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', background: '#001529', padding: '0 24px' }}>
        <div style={{ color: '#fff', fontSize: '18px', fontWeight: 'bold' }}>
          数据血缘分析平台
        </div>
        <Dropdown
          menu={{
            items: userMenuItems,
            onClick: handleUserMenuClick,
          }}
          placement="bottomRight"
        >
          <div style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 8 }}>
            <Avatar style={{ backgroundColor: '#1890ff' }} icon={<UserOutlined />} />
            <span style={{ color: '#fff' }}>{username}</span>
          </div>
        </Dropdown>
      </Header>
      <AntLayout>
        <Sider width={200} style={{ background: '#fff' }}>
          <Menu
            mode="inline"
            selectedKeys={[location.pathname]}
            items={menuItems}
            onClick={handleMenuClick}
            style={{ height: '100%', borderRight: 0 }}
          />
        </Sider>
        <Content style={{ padding: '24px', background: '#f0f2f5' }}>
          <Outlet />
        </Content>
      </AntLayout>
    </AntLayout>
  )
}

export default Layout