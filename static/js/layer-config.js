/**
 * 层级配置加载器
 * 从 /api/system/layers 动态加载各系统的层级配色和标签配置，
 * 消除前端硬编码的 LAYER_CONFIG，修复 dws/ads vs base/app 不一致问题。
 *
 * 提供：
 *   - getLayerColor(layer, system)   层级主色
 *   - getLayerLabel(layer, system)   层级标签
 *   - getLayerOrder(system)          层级顺序
 *   - getLayerConfig(layer, system)  完整配置 {color, bg, border, label, order}
 *   - getNodeTypeConfig(nodeType)    指标节点类型配置
 *   - getEdgeTypeConfig(edgeType)    边类型配置
 */

let LAYER_CONFIGS = {};
let CONFIGS_LOADED = false;
let _loadPromise = null;
let _currentSystem = 'rrp';

const _FALLBACK_LAYER_CONFIG = {
    ods:    { label: 'ODS源系统层',   color: '#4ade80', order: 0 },
    src:    { label: 'SRC原始数据层',  color: '#34d399', order: 1 },
    msl:    { label: 'MSL源系统层',   color: '#2dd4bf', order: 2 },
    itl:    { label: 'ITL接口层',     color: '#22d3ee', order: 3 },
    iol:    { label: 'IOL操作层',     color: '#38bdf8', order: 4 },
    icl:    { label: 'ICL共性加工层', color: '#818cf8', order: 5 },
    iml:    { label: 'IML模型层',     color: '#a78bfa', order: 6 },
    idl:    { label: 'IDL接口层',     color: '#c084fc', order: 7 },
    iel:    { label: 'IEL外部层',     color: '#e879f9', order: 8 },
    dqc:    { label: 'DQC数据质量层', color: '#f472b6', order: 9 },
    diis:  { label: 'DIIS明细层',     color: '#fb923c', order: 10 },
    base:  { label: 'B基础层',       color: '#818cf8', order: 11 },
    mdl:   { label: 'M模型层',       color: '#c084fc', order: 12 },
    app:   { label: 'A/S应用汇总层', color: '#fb923c', order: 13 },
    east:  { label: 'EAST报送层',     color: '#f87171', order: 14 },
    config: { label: '配置/临时表',   color: '#6b7280', order: 15 },
    other:  { label: '其他',          color: '#6b7280', order: 16 },
};

const NODE_TYPE_CONFIG = {
    indicator: { label: '指标', color: '#3b82f6', bg: '#dbeafe', border: '#2563eb', shape: 'circle' },
    measure:   { label: '度量', color: '#8b5cf6', bg: '#ede9fe', border: '#7c3aed', shape: 'circle' },
    table:     { label: '源表', color: '#10b981', bg: '#d1fae5', border: '#059669', shape: 'rect' },
    field:     { label: '科目', color: '#f59e0b', bg: '#fef3c7', border: '#d97706', shape: 'diamond' },
    procedure: { label: '过程', color: '#64748b', bg: '#f1f5f9', border: '#475569', shape: 'hexagon' },
};

const EDGE_TYPE_CONFIG = {
    data_flow:       { label: '数据流',   style: 'solid',  color: '#3b82f6' },
    calc_dependency: { label: '计算依赖', style: 'solid',  color: '#8b5cf6' },
    gl_mapping:      { label: '科目映射', style: 'dashed', color: '#f59e0b' },
};

function _hexToRgb(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    if (!result) return null;
    return {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16),
    };
}

function _rgbToHex(r, g, b) {
    return '#' + [r, g, b].map(function(v) {
        var hex = Math.max(0, Math.min(255, Math.round(v))).toString(16);
        return hex.length === 1 ? '0' + hex : hex;
    }).join('');
}

function _lightenColor(hex, amount) {
    var rgb = _hexToRgb(hex);
    if (!rgb) return hex;
    return _rgbToHex(
        rgb.r + (255 - rgb.r) * amount,
        rgb.g + (255 - rgb.g) * amount,
        rgb.b + (255 - rgb.b) * amount
    );
}

function _darkenColor(hex, amount) {
    var rgb = _hexToRgb(hex);
    if (!rgb) return hex;
    return _rgbToHex(
        rgb.r * (1 - amount),
        rgb.g * (1 - amount),
        rgb.b * (1 - amount)
    );
}

const DEPTH_CONFIGS = [
    { color: '#ef4444', border: '#dc2626', bg: '#fef2f2', label: '目标层' },
    { color: '#f59e0b', border: '#d97706', bg: '#fffbeb', label: '第1层来源' },
    { color: '#3b82f6', border: '#2563eb', bg: '#eff6ff', label: '第2层来源' },
    { color: '#8b5cf6', border: '#7c3aed', bg: '#f5f3ff', label: '第3层来源' },
    { color: '#10b981', border: '#059669', bg: '#ecfdf5', label: '第4层来源' },
    { color: '#6b7280', border: '#4b5563', bg: '#f9fafb', label: '更深层来源' },
];

function getDepthLayerConfig(depth) {
    var absDepth = Math.abs(depth);
    var config = DEPTH_CONFIGS[Math.min(absDepth, DEPTH_CONFIGS.length - 1)];
    return {
        color: config.color,
        border: config.border,
        bg: config.bg,
        label: absDepth === 0 ? '目标表' : '第' + absDepth + '层来源',
    };
}

function setCurrentSystem(system) {
    if (system) _currentSystem = system;
}

function getCurrentSystem() {
    return _currentSystem;
}

async function loadLayerConfigs() {
    if (CONFIGS_LOADED) return LAYER_CONFIGS;
    if (_loadPromise) return _loadPromise;

    _loadPromise = (async function() {
        try {
            var resp = await fetch('/api/system/layers');
            if (!resp.ok) {
                throw new Error('HTTP ' + resp.status);
            }
            var json = await resp.json();
            if (json.success && json.data) {
                LAYER_CONFIGS = json.data;
                CONFIGS_LOADED = true;
            } else {
                throw new Error('Invalid response format');
            }
        } catch (e) {
            console.warn('Failed to load layer configs, using defaults:', e);
            LAYER_CONFIGS = {
                _default: {
                    layer_order: ['ods', 'src', 'msl', 'itl', 'iol', 'icl', 'iml', 'idl', 'iel', 'dqc', 'diis', 'base', 'mdl', 'app', 'east', 'config'],
                    layer_colors: Object.fromEntries(
                        Object.entries(_FALLBACK_LAYER_CONFIG).map(function(e) { return [e[0], e[1].color]; })
                    ),
                    layer_labels: Object.fromEntries(
                        Object.entries(_FALLBACK_LAYER_CONFIG).map(function(e) { return [e[0], e[1].label]; })
                    ),
                },
            };
        }
        _loadPromise = null;
        return LAYER_CONFIGS;
    })();

    return _loadPromise;
}

function getLayerColor(layer, system) {
    system = system || _currentSystem;
    var sysConfig = LAYER_CONFIGS[system];
    if (sysConfig && sysConfig.layer_colors && sysConfig.layer_colors[layer]) {
        return sysConfig.layer_colors[layer];
    }
    var defaultConfig = LAYER_CONFIGS._default;
    if (defaultConfig && defaultConfig.layer_colors && defaultConfig.layer_colors[layer]) {
        return defaultConfig.layer_colors[layer];
    }
    if (_FALLBACK_LAYER_CONFIG[layer]) {
        return _FALLBACK_LAYER_CONFIG[layer].color;
    }
    return '#6b7280';
}

function getLayerLabel(layer, system) {
    system = system || _currentSystem;
    var sysConfig = LAYER_CONFIGS[system];
    if (sysConfig && sysConfig.rules) {
        var rule = sysConfig.rules.find(function(r) { return r.layer === layer; });
        if (rule && rule.label) return rule.label;
    }
    var defaultConfig = LAYER_CONFIGS._default;
    if (defaultConfig && defaultConfig.layer_labels && defaultConfig.layer_labels[layer]) {
        return defaultConfig.layer_labels[layer];
    }
    if (_FALLBACK_LAYER_CONFIG[layer]) {
        return _FALLBACK_LAYER_CONFIG[layer].label;
    }
    return layer.toUpperCase();
}

function getLayerOrder(system) {
    system = system || _currentSystem;
    var sysConfig = LAYER_CONFIGS[system];
    if (sysConfig && sysConfig.layer_order) {
        return sysConfig.layer_order;
    }
    var defaultConfig = LAYER_CONFIGS._default;
    if (defaultConfig && defaultConfig.layer_order) {
        return defaultConfig.layer_order;
    }
    return ['ods', 'src', 'msl', 'itl', 'iol', 'icl', 'iml', 'idl', 'iel', 'dqc', 'diis', 'base', 'mdl', 'app', 'east', 'config'];
}

function getLayerConfig(layer, system) {
    system = system || _currentSystem;
    var color = getLayerColor(layer, system);
    var label = getLayerLabel(layer, system);
    var orderList = getLayerOrder(system);
    var idx = orderList.indexOf(layer);
    return {
        color: color,
        bg: _lightenColor(color, 0.82),
        border: _darkenColor(color, 0.28),
        label: label,
        order: idx >= 0 ? idx : 99,
    };
}

function getNodeTypeConfig(nodeType) {
    return NODE_TYPE_CONFIG[nodeType] || NODE_TYPE_CONFIG.procedure;
}

function getEdgeTypeConfig(edgeType) {
    return EDGE_TYPE_CONFIG[edgeType] || { label: edgeType || '', style: 'solid', color: '#94a3b8' };
}

function getLayerShortLabel(layer, system) {
    var shortMap = {
        ods: 'ODS', src: 'SRC', msl: 'MSL', itl: 'ITL', iol: 'IOL',
        icl: 'ICL', iml: 'IML', idl: 'IDL', iel: 'IEL', dqc: 'DQC',
        diis: 'DIIS', base: 'BASE', mdl: 'MDL',
        app: 'APP', east: 'EAST', config: 'CFG', other: 'OTH',
    };
    if (shortMap[layer]) return shortMap[layer];
    var label = getLayerLabel(layer, system);
    var match = label.match(/^([A-Z/]+)/);
    if (match) return match[1];
    if (label.length <= 3) return label.toUpperCase();
    return label.substring(0, 3).toUpperCase();
}

function getDepthLayerConfigShared(depth) {
    return getDepthLayerConfig(depth);
}

document.addEventListener('DOMContentLoaded', function() {
    loadLayerConfigs();
});
