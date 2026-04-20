import React, { useState, useEffect, useRef, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import { Form, Input, Button, message } from 'antd'
import { UserOutlined, LockOutlined } from '@ant-design/icons'
import './LoginPage.css'

interface LoginFormValues {
  username: string
  password: string
}

interface Particle {
  x: number
  y: number
  vx: number
  vy: number
  radius: number
  opacity: number
}

interface Connection {
  from: number
  to: number
  opacity: number
}

const LoginPage: React.FC = () => {
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()
  const canvasRef = useRef<HTMLCanvasElement>(null)
  const animationRef = useRef<number>()
  const particlesRef = useRef<Particle[]>([])
  const mouseRef = useRef({ x: 0, y: 0 })

  const initParticles = useCallback((width: number, height: number) => {
    const particles: Particle[] = []
    const particleCount = Math.floor((width * height) / 15000)
    
    for (let i = 0; i < particleCount; i++) {
      particles.push({
        x: Math.random() * width,
        y: Math.random() * height,
        vx: (Math.random() - 0.5) * 0.5,
        vy: (Math.random() - 0.5) * 0.5,
        radius: Math.random() * 2 + 1,
        opacity: Math.random() * 0.5 + 0.2,
      })
    }
    particlesRef.current = particles
  }, [])

  useEffect(() => {
    const canvas = canvasRef.current
    if (!canvas) return

    const ctx = canvas.getContext('2d')
    if (!ctx) return

    const resizeCanvas = () => {
      const container = canvas.parentElement
      if (container) {
        canvas.width = container.clientWidth
        canvas.height = container.clientHeight
        initParticles(canvas.width, canvas.height)
      }
    }

    resizeCanvas()
    window.addEventListener('resize', resizeCanvas)

    const handleMouseMove = (e: MouseEvent) => {
      const rect = canvas.getBoundingClientRect()
      mouseRef.current = {
        x: e.clientX - rect.left,
        y: e.clientY - rect.top,
      }
    }

    canvas.addEventListener('mousemove', handleMouseMove)

    const animate = () => {
      if (!ctx || !canvas) return

      ctx.clearRect(0, 0, canvas.width, canvas.height)

      const particles = particlesRef.current
      const connections: Connection[] = []

      particles.forEach((particle, i) => {
        particle.x += particle.vx
        particle.y += particle.vy

        if (particle.x < 0 || particle.x > canvas.width) particle.vx *= -1
        if (particle.y < 0 || particle.y > canvas.height) particle.vy *= -1

        particle.x = Math.max(0, Math.min(canvas.width, particle.x))
        particle.y = Math.max(0, Math.min(canvas.height, particle.y))

        const dx = mouseRef.current.x - particle.x
        const dy = mouseRef.current.y - particle.y
        const dist = Math.sqrt(dx * dx + dy * dy)
        
        if (dist < 150) {
          particle.vx += dx * 0.00005
          particle.vy += dy * 0.00005
        }

        ctx.beginPath()
        ctx.arc(particle.x, particle.y, particle.radius, 0, Math.PI * 2)
        ctx.fillStyle = `rgba(99, 179, 237, ${particle.opacity})`
        ctx.fill()

        for (let j = i + 1; j < particles.length; j++) {
          const other = particles[j]
          const dx = particle.x - other.x
          const dy = particle.y - other.y
          const distance = Math.sqrt(dx * dx + dy * dy)

          if (distance < 120) {
            connections.push({
              from: i,
              to: j,
              opacity: 1 - distance / 120,
            })
          }
        }
      })

      connections.forEach((conn) => {
        const from = particles[conn.from]
        const to = particles[conn.to]
        ctx.beginPath()
        ctx.moveTo(from.x, from.y)
        ctx.lineTo(to.x, to.y)
        ctx.strokeStyle = `rgba(99, 179, 237, ${conn.opacity * 0.3})`
        ctx.lineWidth = 0.5
        ctx.stroke()
      })

      animationRef.current = requestAnimationFrame(animate)
    }

    animate()

    return () => {
      window.removeEventListener('resize', resizeCanvas)
      canvas.removeEventListener('mousemove', handleMouseMove)
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current)
      }
    }
  }, [initParticles])

  const onFinish = async (values: LoginFormValues) => {
    setLoading(true)
    
    try {
      if (values.username === 'admin' && values.password === 'admin123') {
        localStorage.setItem('isAuthenticated', 'true')
        localStorage.setItem('username', values.username)
        message.success('登录成功')
        navigate('/search')
      } else {
        message.error('用户名或密码错误')
      }
    } catch {
      message.error('登录失败，请重试')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="login-container">
      <div className="login-left">
        <canvas ref={canvasRef} className="particle-canvas" />
        <div className="brand-content">
          <div className="brand-icon">
            <svg viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path
                d="M24 4L42 14V34L24 44L6 34V14L24 4Z"
                stroke="currentColor"
                strokeWidth="2"
                fill="none"
              />
              <path
                d="M24 14L34 20V32L24 38L14 32V20L24 14Z"
                stroke="currentColor"
                strokeWidth="2"
                fill="rgba(99, 179, 237, 0.2)"
              />
              <circle cx="24" cy="24" r="4" fill="currentColor" />
            </svg>
          </div>
          <h1 className="brand-title">数据血缘分析平台</h1>
          <p className="brand-subtitle">Data Lineage Analysis Platform</p>
          <p className="brand-description">
            全链路数据血缘追踪，智能影响分析，助力企业数据治理与合规管理
          </p>
          <div className="feature-list">
            <div className="feature-item">
              <span className="feature-dot" />
              <span>可视化血缘图谱</span>
            </div>
            <div className="feature-item">
              <span className="feature-dot" />
              <span>智能影响分析</span>
            </div>
            <div className="feature-item">
              <span className="feature-dot" />
              <span>多数据源支持</span>
            </div>
          </div>
        </div>
        <div className="tech-grid" />
      </div>
      
      <div className="login-right">
        <div className="login-form-wrapper">
          <div className="login-header">
            <h2 className="login-title">欢迎回来</h2>
            <p className="login-subtitle">请登录您的账户以继续</p>
          </div>

          <Form
            name="login"
            onFinish={onFinish}
            autoComplete="off"
            layout="vertical"
            size="large"
            className="login-form"
          >
            <Form.Item
              name="username"
              rules={[{ required: true, message: '请输入用户名' }]}
            >
              <Input
                prefix={<UserOutlined style={{ color: '#9ca3af' }} />}
                placeholder="用户名"
                className="login-input"
              />
            </Form.Item>

            <Form.Item
              name="password"
              rules={[{ required: true, message: '请输入密码' }]}
            >
              <Input.Password
                prefix={<LockOutlined style={{ color: '#9ca3af' }} />}
                placeholder="密码"
                className="login-input"
              />
            </Form.Item>

            <Form.Item>
              <Button
                type="primary"
                htmlType="submit"
                loading={loading}
                block
                className="login-button"
              >
                登录
              </Button>
            </Form.Item>
          </Form>

          <div className="login-footer">
            <p className="demo-hint">
              演示账号: <code>admin</code> / <code>admin123</code>
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default LoginPage