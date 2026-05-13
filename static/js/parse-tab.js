/**
 * 解析层 Tab 逻辑
 * 文件上传、进度监控、结果展示
 */

let selectedFilesArray = [];
let eventSource = null;

// ============================================
// 文件拖拽上传
// ============================================
function handleDragOver(event) {
    event.preventDefault();
    event.stopPropagation();
    event.currentTarget.classList.add('dragover');
}

function handleDragLeave(event) {
    event.preventDefault();
    event.stopPropagation();
    event.currentTarget.classList.remove('dragover');
}

function handleDrop(event) {
    event.preventDefault();
    event.stopPropagation();
    event.currentTarget.classList.remove('dragover');

    const files = Array.from(event.dataTransfer.files);
    addFilesToList(files);
}

function handleFileSelect(event) {
    const files = Array.from(event.target.files);
    addFilesToList(files);
    event.target.value = '';
}

function addFilesToList(files) {
    const validExtensions = ['.tab', '.prc', '.sql'];
    let addedCount = 0;

    files.forEach(file => {
        const ext = '.' + file.name.split('.').pop().toLowerCase();
        
        if (!validExtensions.includes(ext)) {
            showNotification(`不支持的文件类型: ${file.name}`, 'error');
            return;
        }

        if (file.size > 100 * 1024 * 1024) {
            showNotification(`文件过大: ${file.name} (限制100MB)`, 'error');
            return;
        }

        const exists = selectedFilesArray.some(f => f.name === file.name && f.size === file.size);
        if (!exists) {
            selectedFilesArray.push(file);
            addedCount++;
        }
    });

    if (addedCount > 0) {
        updateFileListUI();
        showNotification(`已添加 ${addedCount} 个文件`, 'success');
    }
}

function updateFileListUI() {
    const container = document.getElementById('selectedFiles');
    const list = document.getElementById('fileList');
    const countSpan = document.getElementById('fileCount');
    const startBtn = document.getElementById('startParseBtn');

    if (selectedFilesArray.length === 0) {
        container.style.display = 'none';
        startBtn.disabled = true;
        return;
    }

    container.style.display = 'block';
    countSpan.textContent = selectedFilesArray.length;
    startBtn.disabled = false;

    list.innerHTML = selectedFilesArray.map((file, index) => `
        <li>
            <span class="file-name">${file.name}</span>
            <span class="file-size">${formatFileSize(file.size)}</span>
            <button onclick="removeFile(${index})" style="background:none;border:none;color:#ef4444;cursor:pointer;padding:0 4px;" title="移除">✕</button>
        </li>
    `).join('');
}

function removeFile(index) {
    selectedFilesArray.splice(index, 1);
    updateFileListUI();
}

function clearSelectedFiles() {
    selectedFilesArray = [];
    updateFileListUI();
    showNotification('已清空文件列表', 'info');
}

// ============================================
// 解析任务执行
// ============================================
async function startParsing() {
    if (selectedFilesArray.length === 0) {
        showNotification('请先选择要上传的文件', 'warning');
        return;
    }

    const parseMode = document.getElementById('parseMode').value;
    const startBtn = document.getElementById('startParseBtn');

    try {
        startBtn.disabled = true;
        startBtn.textContent = '⏳ 上传中...';

        const formData = new FormData();
        selectedFilesArray.forEach(file => {
            formData.append('files', file);
        });
        formData.append('parse_mode', parseMode);

        const response = await fetch('/api/parse/upload', {
            method: 'POST',
            body: formData,
        });

        const result = await response.json();

        if (!result.success) {
            throw new Error(result.error || '上传失败');
        }

        AppState.currentTaskId = result.data.task_id;
        
        // 上传成功后清空文件列表
        clearSelectedFiles();
        
        showProgressSection();
        connectToSSE(result.data.task_id);
        
        showNotification(`解析任务已启动 (ID: ${result.data.task_id.slice(0,8)}...)`, 'success');

    } catch (error) {
        console.error('上传失败:', error);
        showNotification('文件上传失败: ' + error.message, 'error');
        startBtn.disabled = false;
        startBtn.textContent = '⚡ 开始解析';
    }
}

async function triggerFullParse() {
    try {
        const response = await apiRequest('/api/parse/parse-existing', { method: 'POST' });
        
        AppState.currentTaskId = response.data.task_id;
        
        showProgressSection();
        connectToSSE(response.data.task_id);
        
        showNotification('全量解析任务已启动', 'success');

    } catch (error) {
        console.error('触发全量解析失败:', error);
        showNotification('启动失败: ' + error.message, 'error');
    }
}

// ============================================
// SSE 进度连接
// ============================================
function connectToSSE(taskId) {
    if (eventSource) {
        eventSource.close();
    }

    const statusBadge = document.getElementById('taskStatus');
    statusBadge.textContent = '连接中...';
    statusBadge.className = 'status-badge processing';

    eventSource = new EventSource(`/api/parse/progress/${taskId}`);

    eventSource.onopen = () => {
        console.log('SSE 连接已建立');
        addLogEntry('info', '已连接到进度服务器');
        statusBadge.textContent = '处理中...';
    };

    eventSource.addEventListener('progress', (event) => {
        const data = JSON.parse(event.data);
        updateProgressUI(data);
    });

    eventSource.addEventListener('complete', (event) => {
        const data = JSON.parse(event.data);
        handleTaskComplete(data);
    });

    eventSource.addEventListener('error', (event) => {
        const data = JSON.parse(event.data);
        handleTaskError(data);
    });

    eventSource.onerror = (error) => {
        console.error('SSE 连接错误:', error);
        addLogEntry('error', '连接中断，尝试重连...');
        
        setTimeout(() => {
            if (AppState.currentTaskId) {
                connectToSSE(AppState.currentTaskId);
            }
        }, 3000);
    };
}

// ============================================
// 进度 UI 更新
// ============================================
function showProgressSection() {
    document.getElementById('initialState').style.display = 'none';
    document.getElementById('progressSection').style.display = 'block';
    document.getElementById('resultSection').style.display = 'none';
}

function updateProgressUI(data) {
    const percent = Math.min(Math.max(data.percent, 0), 100);
    
    document.getElementById('progressBarFill').style.width = `${percent}%`;
    document.getElementById('progressPercent').textContent = `${Math.round(percent)}%`;
    document.getElementById('currentFile').textContent = data.current_file || '';
    document.getElementById('progressMessage').textContent = data.message || '';

    if (data.tables_parsed !== undefined) {
        document.getElementById('tablesParsed').textContent = data.tables_parsed;
    }
    if (data.procedures_parsed !== undefined) {
        document.getElementById('proceduresParsed').textContent = data.procedures_parsed;
    }
    if (data.lineages_found !== undefined) {
        document.getElementById('lineagesFound').textContent = data.lineages_found;
    }

    if (data.message) {
        const level = data.level || 'info';
        addLogEntry(level, data.message);
    }
}

function addLogEntry(level, message) {
    const logOutput = document.getElementById('logOutput');
    const time = formatTime(new Date());
    
    const entry = document.createElement('div');
    entry.className = `log-entry ${level}`;
    entry.innerHTML = `<span class="log-time">[${time}]</span>${escapeHtml(message)}`;
    
    logOutput.appendChild(entry);
    logOutput.scrollTop = logOutput.scrollHeight;
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// ============================================
// 任务完成处理
// ============================================
function handleTaskComplete(data) {
    if (eventSource) {
        eventSource.close();
        eventSource = null;
    }

    const statusBadge = document.getElementById('taskStatus');
    statusBadge.textContent = '完成';
    statusBadge.className = 'status-badge success';

    document.getElementById('progressBarFill').style.width = '100%';
    document.getElementById('progressPercent').textContent = '100%';
    document.getElementById('progressMessage').textContent = '✅ 解析完成！';

    addLogEntry('success', `解析完成！共发现 ${data.tables_parsed || 0} 张表，${data.procedures_parsed || 0} 个过程`);

    setTimeout(() => {
        showResultSection(data);
    }, 1500);
}

function handleTaskError(data) {
    if (eventSource) {
        eventSource.close();
        eventSource = null;
    }

    const statusBadge = document.getElementById('taskStatus');
    statusBadge.textContent = '失败';
    statusBadge.className = 'status-badge error';

    const errorMessage = data.message || data.errors?.[0] || '未知错误';
    document.getElementById('progressMessage').textContent = `❌ 解析失败: ${errorMessage}`;

    addLogEntry('error', `解析失败: ${errorMessage}`);

    if (data.errors && data.errors.length > 0) {
        data.errors.forEach(err => addLogEntry('error', err));
    }

    showNotification('解析任务失败: ' + errorMessage, 'error');
    
    document.getElementById('startParseBtn').disabled = false;
    document.getElementById('startParseBtn').textContent = '⚡ 开始解析';
}

// ============================================
// 结果展示
// ============================================
function showResultSection(data) {
    document.getElementById('progressSection').style.display = 'none';
    document.getElementById('resultSection').style.display = 'block';

    const summaryHtml = `
        <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:12px;text-align:center;">
            <div>
                <div style="font-size:24px;font-weight:700;color:#22c55e;">${data.tables_parsed || 0}</div>
                <div style="font-size:12px;color:#64748b;">表</div>
            </div>
            <div>
                <div style="font-size:24px;font-weight:700;color:#6366f1;">${data.procedures_parsed || 0}</div>
                <div style="font-size:12px;color:#64748b;">存储过程</div>
            </div>
            <div>
                <div style="font-size:24px;font-weight:700;color:#f59e0b;">${data.lineages_found || 0}</div>
                <div style="font-size:12px;color:#64748b;">血缘关系</div>
            </div>
        </div>
    `;
    document.getElementById('resultSummary').innerHTML = summaryHtml;

    loadParsedObjects();

    showNotification('解析完成！可以切换到展示层查看血缘图谱', 'success');
}

async function loadParsedObjects() {
    try {
        const [tablesResponse, procsResponse] = await Promise.all([
            apiRequest('/api/tables?keyword=&limit=10000'),
            apiRequest('/api/procedures?keyword=&limit=10000'),
        ]);

        const tables = tablesResponse.data || [];
        const procedures = procsResponse.data || [];

        document.getElementById('tableCount').textContent = tables.length;
        document.getElementById('procCount').textContent = procedures.length;

        const tablesHtml = tables.slice(0, 200).map(table => `
            <div class="object-item" onclick="queryTableFromParse('${table.full_name}')">
                <span class="object-name">${table.short_name || table.full_name}</span>
                <span class="object-meta">${table.layer || ''} | ${(table.field_count || 0)} 字段</span>
            </div>
        `).join('');

        const procsHtml = procedures.slice(0, 200).map(proc => `
            <div class="object-item">
                <span class="object-name">${proc.short_name || proc.full_name}</span>
                <span class="object-meta">存储过程</span>
            </div>
        `).join('');

        document.getElementById('parsedTablesList').innerHTML = tablesHtml || '<p style="padding:20px;text-align:center;color:#94a3b8;">暂无数据</p>';
        document.getElementById('parsedProcsList').innerHTML = procsHtml || '<p style="padding:20px;text-align:center;color:#94a3b8;">暂无数据</p>';

    } catch (error) {
        console.error('加载解析对象失败:', error);
    }
}

function showParsedList(type) {
    document.querySelectorAll('.list-tab').forEach((tab, idx) => {
        tab.classList.toggle('active', (type === 'tables' && idx === 0) || (type === 'procedures' && idx === 1));
    });

    document.getElementById('parsedTablesList').style.display = type === 'tables' ? 'block' : 'none';
    document.getElementById('parsedProcsList').style.display = type === 'procedures' ? 'block' : 'none';
}

function queryTableFromParse(tableName) {
    switchTab('display');
    setTimeout(() => {
        document.getElementById('searchInput').value = tableName;
        executeQuery(tableName, 'table');
    }, 300);
}
