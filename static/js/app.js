/**
 * 数据血缘分析系统 v2.0 - 主应用逻辑
 * 全局状态管理、TAB 切换、工具函数
 */

const API_BASE = '';

// ============================================
// 全局应用状态
// ============================================
const AppState = {
    currentTab: 'display',
    selectedFiles: [],
    currentTaskId: null,
    searchTimeout: null,
    queryDepth: 5,
    queryMode: 'upstream',
    caliberMode: 'upstream',
    systemStats: null,
};

// ============================================
// TAB 切换功能
// ============================================
function switchTab(tabName) {
    AppState.currentTab = tabName;

    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.tab === tabName);
    });

    document.querySelectorAll('.tab-content').forEach(content => {
        content.classList.toggle('active', content.id === `${tabName}-tab`);
    });

    if (tabName === 'display') {
        initDisplayTab();
    }
}

function setCaliberMode(mode) {
    AppState.caliberMode = mode;
    document.querySelectorAll('[data-caliber-mode]').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.caliberMode === mode);
    });
}

// ============================================
// 工具函数
// ============================================
function formatFileSize(bytes) {
    if (bytes < 1024) return bytes + ' B';
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
    return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
}

function formatTime(date) {
    return new Date(date).toLocaleTimeString('zh-CN', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
    });
}

function debounce(func, delay = 300) {
    let timeoutId;
    return function (...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func.apply(this, args), delay);
    };
}

async function apiRequest(url, options = {}) {
    const defaultOptions = {
        headers: {
            'Content-Type': 'application/json',
            ...options.headers,
        },
    };

    const response = await fetch(API_BASE + url, { ...defaultOptions, ...options });

    if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `HTTP ${response.status}: ${response.statusText}`);
    }

    return response.json();
}

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 80px;
        right: 24px;
        padding: 12px 24px;
        background: ${type === 'error' ? '#ef4444' : type === 'success' ? '#22c55e' : '#6366f1'};
        color: white;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 9999;
        animation: slideIn 0.3s ease;
        font-size: 14px;
    `;

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease forwards';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// 注入动画样式
const styleSheet = document.createElement('style');
styleSheet.textContent = `
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
`;
document.head.appendChild(styleSheet);

// ============================================
// 系统统计
// ============================================
async function showSystemStats() {
    try {
        const response = await apiRequest('/api/stats');
        const stats = response.data;

        let html = `
            <div style="max-width:500px;margin:auto;padding:32px;background:white;border-radius:12px;box-shadow:0 8px 32px rgba(0,0,0,0.1);">
                <h2 style="margin-bottom:20px;color:#1e293b;">📊 系统统计信息</h2>
                <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:16px;">
                    <div style="padding:16px;background:#f8fafc;border-radius:8px;text-align:center;">
                        <div style="font-size:28px;font-weight:700;color:#6366f1;">${stats.total_tables || 0}</div>
                        <div style="font-size:12px;color:#64748b;margin-top:4px;">表数量</div>
                    </div>
                    <div style="padding:16px;background:#f8fafc;border-radius:8px;text-align:center;">
                        <div style="font-size:28px;font-weight:700;color:#6366f1;">${stats.total_procedures || 0}</div>
                        <div style="font-size:12px;color:#64748b;margin-top:4px;">存储过程</div>
                    </div>
                    <div style="padding:16px;background:#f8fafc;border-radius:8px;text-align:center;">
                        <div style="font-size:28px;font-weight:700;color:#6366f1;">${stats.total_table_lineages || 0}</div>
                        <div style="font-size:12px;color:#64748b;margin-top:4px;">表级血缘</div>
                    </div>
                    <div style="padding:16px;background:#f8fafc;border-radius:8px;text-align:center;">
                        <div style="font-size:28px;font-weight:700;color:#6366f1;">${stats.total_field_mappings || 0}</div>
                        <div style="font-size:12px;color:#64748b;margin-top:4px;">字段映射</div>
                    </div>
                </div>
                ${stats.cache_size !== undefined ? `
                <div style="margin-top:20px;padding:16px;background:#f0fdf4;border:1px solid #bbf7d0;border-radius:8px;">
                    <div style="font-size:13px;color:#166534;">✅ 缓存已启用 | 缓存条目: ${stats.cache_size}</div>
                </div>` : ''}
                <button onclick="this.closest('div').remove()" 
                    style="margin-top:20px;width:100%;padding:10px;background:#f1f5f9;border:none;border-radius:6px;cursor:pointer;font-size:13px;">
                    关闭
                </button>
            </div>
        `;

        const overlay = document.createElement('div');
        overlay.innerHTML = html;
        overlay.style.cssText = `
            position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);z-index:9999;display:flex;align-items:center;justify-content:center;padding:20px;
        `;
        overlay.onclick = (e) => { if(e.target===overlay) overlay.remove(); };
        document.body.appendChild(overlay);

    } catch (error) {
        console.error('获取系统统计失败:', error);
        showNotification('获取统计信息失败: ' + error.message, 'error');
    }
}

// ============================================
// 初始化
// ============================================
document.addEventListener('DOMContentLoaded', () => {
    console.log('%c🔗 数据血缘分析系统 v2.0 已启动', 'color:#6366f1;font-size:14px;font-weight:bold;');
    
    checkSystemHealth();

    // 默认激活展示层，确保初始化
    initDisplayTab();
});

async function checkSystemHealth() {
    try {
        const health = await apiRequest('/health');
        document.getElementById('systemStatus').textContent = `● 系统就绪 (运行 ${Math.floor(health.uptime_seconds/60)} 分钟)`;
        document.getElementById('systemStatus').style.color = '#22c55e';
    } catch (error) {
        document.getElementById('systemStatus').textContent = '● 系统异常';
        document.getElementById('systemStatus').style.color = '#ef4444';
    }
}

// ============================================
// 强制重新解析
// ============================================
async function forceReparse() {
    if (!confirm('⚠️ 确定要重新全量解析吗？\n\n这将清除缓存并重新解析所有数据文件，耗时约6-10分钟。\n期间服务仍可用（使用旧数据），解析完成后自动刷新。')) {
        return;
    }

    showNotification('🔄 开始全量重新解析，请耐心等待...', 'info');

    try {
        const response = await apiRequest('/api/system/reparse', { method: 'POST' });

        if (response.success) {
            const data = response.data;
            showNotification(
                `✅ 重新解析完成！${data.tables} 张表, ${data.procedures} 个过程, 耗时 ${data.parse_time_sec}s`,
                'success'
            );
        } else {
            showNotification('❌ 重新解析失败: ' + (response.error || '未知错误'), 'error');
        }
    } catch (error) {
        showNotification('❌ 重新解析请求失败: ' + error.message, 'error');
    }
}
