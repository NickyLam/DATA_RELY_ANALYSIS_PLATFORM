(function () {
  "use strict";

  /* ============================================================
     全局状态管理
     ============================================================ */
  var state = {
    tables: [],
    fields: {},
    currentResult: null,
    isLoading: false,
    selectedNodeId: null,
  };

  /* ============================================================
     DOM 引用缓存（页面加载后一次性获取）
     ============================================================ */
  var dom = {};

  /* ============================================================
     常量定义
     ============================================================ */
  var DEBOUNCE_MS = 300;
  var LAYER_NAMES = {
    0: "源系统",
    1: "ODS",
    2: "DII",
    3: "BASE",
    4: "MDL",
    5: "APP",
    6: "EAST",
  };

  var LAYER_TYPE_MAP = {
    ods: { label: "ODS", color: "#4ade80" },
    diis: { label: "DII", color: "#38bdf8" },
    base: { label: "BASE", color: "#818cf8" },
    mdl: { label: "MDL", color: "#c084fc" },
    app: { label: "APP", color: "#fb923c" },
    east: { label: "EAST", color: "#f87171" },
    config: { label: "CONFIG", color: "#6b7280" },
    temp: { label: "TMP", color: "#6b7280" },
    other: { label: "OTHER", color: "#64748b" },
  };

  /* ============================================================
     工具函数
     ============================================================ */

  function escapeHtml(str) {
    if (typeof str !== "string") return "";
    var div = document.createElement("div");
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  }

  function getLayerColor(layerType) {
    var info = LAYER_TYPE_MAP[layerType] || LAYER_TYPE_MAP.other;
    return info.color;
  }

  function getLayerLabel(layerType) {
    var info = LAYER_TYPE_MAP[layerType] || LAYER_TYPE_MAP.other;
    return info.label;
  }

  function debounce(fn, delay) {
    var timer = null;
    return function () {
      var context = this;
      var args = arguments;
      if (timer) clearTimeout(timer);
      timer = setTimeout(function () {
        fn.apply(context, args);
        timer = null;
      }, delay);
    };
  }

  /* ============================================================
     API 封装层
     ============================================================ */

  function apiGet(url) {
    return fetch(url, {
      method: "GET",
      headers: { Accept: "application/json" },
    }).then(function (res) {
      if (!res.ok) {
        throw new Error("HTTP " + res.status + ": " + res.statusText);
      }
      return res.json();
    });
  }

  function apiPost(url, body) {
    return fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify(body),
    }).then(function (res) {
      if (!res.ok) {
        throw new Error("HTTP " + res.status + ": " + res.statusText);
      }
      return res.json();
    });
  }

  /* ============================================================
     系统统计初始化（页面加载时调用）
     ============================================================ */

  function initStats() {
    apiGet("/api/stats")
      .then(function (data) {
        renderStats(data);
      })
      .catch(function (err) {
        console.warn("加载系统统计失败:", err.message);
        var container = document.getElementById("stats-container");
        if (container) {
          container.innerHTML =
            '<span class="stat-badge"><span class="stat-label">统计加载失败</span></span>';
        }
      });
  }

  function renderStats(data) {
    var container = document.getElementById("stats-container");
    if (!container || !data) return;

    var html =
      '<span class="stat-badge">' +
      '<span class="stat-label">表总数</span>' +
      '<span class="stat-value">' + escapeHtml(String(data.total_tables || 0)) + "</span>" +
      "</span>" +
      '<span class="stat-badge">' +
      '<span class="stat-label">字段数</span>' +
      '<span class="stat-value">' + escapeHtml(String(data.total_fields || 0)) + "</span>" +
      "</span>" +
      '<span class="stat-badge">' +
      '<span class="stat-label">过程数</span>' +
      '<span class="stat-value">' + escapeHtml(String(data.total_procedures || 0)) + "</span>" +
      "</span>";
    container.innerHTML = html;
  }

  /* ============================================================
     表名搜索与自动补全（防抖 300ms）
     ============================================================ */

  var doSearchTables = debounce(function (keyword) {
    keyword = (keyword || "").trim();
    if (keyword.length === 0) {
      hideAutocomplete(dom.autocompleteDropdown);
      state.tables = [];
      return;
    }

    apiGet("/api/tables?keyword=" + encodeURIComponent(keyword))
      .then(function (data) {
        // API 返回 {success: true, data: [...]}
        var list = Array.isArray(data) ? data : (data.data && Array.isArray(data.data) ? data.data : []);
        state.tables = list;
        renderTableAutocomplete(list, keyword);
      })
      .catch(function (err) {
        console.warn("表名搜索失败:", err.message);
        showAutocompleteEmpty(dom.autocompleteDropdown, "搜索失败，请重试");
      });
  }, DEBOUNCE_MS);

  function renderTableAutocomplete(list, keyword) {
    var dropdown = dom.autocompleteDropdown;
    if (!dropdown) return;

    if (!list || list.length === 0) {
      showAutocompleteEmpty(dropdown, '未找到匹配的表 "' + escapeHtml(keyword) + '"');
      return;
    }

    var frag = document.createDocumentFragment();
    for (var i = 0; i < list.length; i++) {
      var item = list[i];
      // API 返回 {full_name, short_name}，优先使用 short_name
      var name = typeof item === "string" ? item : item.short_name || item.full_name || item.table_name || item.name || "";
      var div = document.createElement("div");
      div.className = "autocomplete-item";
      div.textContent = name;
      div.setAttribute("data-table-name", name);
      div.addEventListener("click", onTableItemClick);
      frag.appendChild(div);
    }
    dropdown.innerHTML = "";
    dropdown.appendChild(frag);
    showAutocomplete(dropdown);
  }

  function onTableItemClick(e) {
    var name = e.target.getAttribute("data-table-name") || "";
    if (dom.tableInput) {
      dom.tableInput.value = name;
    }
    hideAutocomplete(dom.autocompleteDropdown);

    if (name && dom.fieldInput) {
      dom.fieldInput.focus();
      loadFields(name);
    }
  }

  /* ============================================================
     字段列表加载（可选，辅助补全）
     ============================================================ */

  function loadFields(tableName) {
    tableName = (tableName || "").trim();
    if (!tableName) return;

    apiGet("/api/tables/" + encodeURIComponent(tableName) + "/fields")
      .then(function (data) {
        var list = Array.isArray(data) ? data : data.fields || [];
        state.fields[tableName] = list;
      })
      .catch(function (err) {
        console.warn("字段列表加载失败:", err.message);
        state.fields[tableName] = [];
      });
  }

  /* ============================================================
     字段输入自动补全（基于已缓存的字段列表）
     ============================================================ */

  var doSearchFields = debounce(function (keyword) {
    var tableName = dom.tableInput ? (dom.tableInput.value || "").trim() : "";
    keyword = (keyword || "").trim();

    if (!tableName || keyword.length === 0) {
      hideAutocomplete(dom.fieldAutocompleteDropdown);
      return;
    }

    var cached = state.fields[tableName];
    if (!cached || cached.length === 0) {
      hideAutocomplete(dom.fieldAutocompleteDropdown);
      return;
    }

    var lowerKw = keyword.toLowerCase();
    var matched = [];
    for (var i = 0; i < cached.length; i++) {
      var fname = typeof cached[i] === "string" ? cached[i] : (cached[i].field_name || cached[i].name || "");
      if (fname.toLowerCase().indexOf(lowerKw) >= 0) {
        matched.push(fname);
      }
    }

    renderFieldAutocomplete(matched);
  }, DEBOUNCE_MS);

  function renderFieldAutocomplete(list) {
    var dropdown = dom.fieldAutocompleteDropdown;
    if (!dropdown) return;

    if (!list || list.length === 0) {
      hideAutocomplete(dropdown);
      return;
    }

    var frag = document.createDocumentFragment();
    for (var i = 0; i < list.length; i++) {
      var div = document.createElement("div");
      div.className = "autocomplete-item";
      div.textContent = list[i];
      div.setAttribute("data-field-name", list[i]);
      div.addEventListener("click", onFieldItemClick);
      frag.appendChild(div);
    }
    dropdown.innerHTML = "";
    dropdown.appendChild(frag);
    showAutocomplete(dropdown);
  }

  function onFieldItemClick(e) {
    var name = e.target.getAttribute("data-field-name") || "";
    if (dom.fieldInput) {
      dom.fieldInput.value = name;
    }
    hideAutocomplete(dom.fieldAutocompleteDropdown);
  }

  /* ============================================================
     自动补全下拉框通用操作
     ============================================================ */

  function showAutocomplete(dropdown) {
    if (!dropdown) return;
    dropdown.classList.add("active");
    dropdown.style.display = "block";
  }

  function hideAutocomplete(dropdown) {
    if (!dropdown) return;
    dropdown.classList.remove("active");
    dropdown.style.display = "none";
  }

  function showAutocompleteEmpty(dropdown, message) {
    if (!dropdown) return;
    dropdown.innerHTML =
      '<div class="autocomplete-empty">' + escapeHtml(message) + "</div>";
    showAutocomplete(dropdown);
  }

  function hideAllAutocompletes() {
    hideAutocomplete(dom.autocompleteDropdown);
    hideAutocomplete(dom.fieldAutocompleteDropdown);
  }

  /* ============================================================
     血缘查询核心逻辑 ★
     ============================================================ */

  function queryLineage() {
    if (state.isLoading) return;

    var tableName = dom.tableInput ? (dom.tableInput.value || "").trim() : "";
    var fieldName = dom.fieldInput ? (dom.fieldInput.value || "").trim() : "";

    if (!tableName) {
      showErrorState("请输入目标表名");
      dom.tableInput && dom.tableInput.focus();
      return;
    }
    if (!fieldName) {
      showErrorState("请输入目标字段名");
      dom.fieldInput && dom.fieldInput.focus();
      return;
    }

    hideAllAutocompletes();
    showLoading();

    var payload = {
      table: tableName,
      field: fieldName,
      max_depth: 10,
    };

    apiPost("/api/lineage/query", payload)
      .then(function (res) {
        hideLoading();
        if (res.success && res.data) {
          state.currentResult = res.data;
          renderLineageSwimmer(res.data);
        } else {
          var msg = res.message || res.error || "查询返回空结果";
          showEmptyState(tableName, fieldName);
        }
      })
      .catch(function (err) {
        hideLoading();
        console.error("血缘查询失败:", err);
        showErrorState("查询失败: " + err.message);
      });
  }

  /* ============================================================
     渲染泳道图 ★ 核心可视化
     ============================================================ */

  function renderLineageSwimmer(data) {
    if (!data || !data.chains || data.chains.length === 0) {
      showEmptyState(data.target_table || "", data.target_field || "");
      return;
    }

    var lineageContainer = document.getElementById("lineage-container");
    var canvasWrap = document.getElementById("lineage-canvas-wrap");
    var svgLayer = dom.svgLayer;
    var nodesLayer = dom.nodesLayer;
    var resultSummary = dom.resultSummary;
    var legendBar = dom.legendBar;

    if (!canvasWrap || !nodesLayer || !svgLayer) return;

    lineageContainer && lineageContainer.classList.remove("hidden");

    renderResultSummary(data);
    renderLegendBar(legendBar);

    // 统一清理：清除 skeleton / state-view，保留 svg-layer 和 nodes-layer
    clearCanvasContent(canvasWrap);

    // 恢复 svg-layer 和 nodes-layer 的显示（loading 时被隐藏）
    svgLayer.style.display = "";
    nodesLayer.style.display = "";

    var allNodesByLayer = groupNodesByLayer(data.chains);
    var layerKeys = Object.keys(allNodesByLayer).sort(function (a, b) {
      return Number(a) - Number(b);
    });

    var layerElements = [];

    for (var li = 0; li < layerKeys.length; li++) {
      var layerKey = layerKeys[li];
      var nodes = allNodesByLayer[layerKey];
      var rowEl = createLayerRow(layerKey, nodes);
      // 将层级行追加到 nodes-layer（不是 canvas-wrap！）
      nodesLayer.appendChild(rowEl.row);
      layerElements.push({
        key: layerKey,
        rowEl: rowEl.row,
        nodeEls: rowEl.nodeEls,
      });
    }

    requestAnimationFrame(function () {
      drawConnections(svgLayer, layerElements, data.chains);
    });

    hideDetailPanel();
  }

  function groupNodesByLayer(chains) {
    var groups = {};
    var seenKeys = {};

    for (var ci = 0; ci < chains.length; ci++) {
      var chain = chains[ci];
      if (!chain.chain) continue;
      for (var ni = 0; ni < chain.chain.length; ni++) {
        var node = chain.chain[ni];
        var uniqueKey = node.table_name + "::" + node.field_name + "::" + node.layer;
        if (seenKeys[uniqueKey]) continue;
        seenKeys[uniqueKey] = true;

        var layerNum = String(node.layer != null ? node.layer : ni);
        if (!groups[layerNum]) {
          groups[layerNum] = [];
        }
        groups[layerNum].push(node);
      }
    }
    return groups;
  }

  function createLayerRow(layerKey, nodes) {
    var row = document.createElement("div");
    row.className = "layer-row";

    var layerLabel = document.createElement("div");
    layerLabel.className = "layer-label";
    var displayName = LAYER_NAMES[layerKey] || ("L" + layerKey);
    layerLabel.textContent = displayName;
    row.appendChild(layerLabel);

    var nodesContainer = document.createElement("div");
    nodesContainer.className = "layer-nodes";

    var nodeEls = [];
    for (var i = 0; i < nodes.length; i++) {
      var card = createNodeCard(nodes[i], layerKey);
      nodesContainer.appendChild(card.el);
      nodeEls.push(card);
    }

    row.appendChild(nodesContainer);
    return { row: row, nodeEls: nodeEls };
  }

  function createNodeCard(node, layerKey) {
    var card = document.createElement("div");
    var layerType = node.layer_type || "other";
    var color = getLayerColor(layerType);
    var isTarget = node.layer_type === "other" && node.transform_logic === "(目标字段)";
    var isSource = node.layer === 0;
    var isTemp = !!node.is_temp;

    card.className = "node-card fade-in";
    card.style.setProperty("--node-color", color);
    card.setAttribute("data-node-id", node.table_name + "::" + node.field_name + "::" + node.layer);

    if (isTarget) card.classList.add("is-target");
    if (isSource) card.classList.add("is-source");
    if (isTemp) card.classList.add("is-temp");

    var targetMarker = isTarget ? '<span class="target-marker">\uD83D\uDD17</span>' : "";

    var procedureHtml = "";
    if (node.procedure) {
      procedureHtml =
        '<div class="node-procedure">' +
        '<span class="proc-label">PROC:</span> ' +
        escapeHtml(node.procedure) +
        "</div>";
    }

    var transformHtml = "";
    if (node.transform_logic) {
      transformHtml =
        '<div class="node-transform">' + escapeHtml(node.transform_logic) + "</div>";
    }

    var tagsHtml =
      '<span class="node-tag layer-tag" style="--node-color:' +
      color +
      '">' +
      getLayerLabel(layerType) +
      "</span>";

    if (isTemp) {
      tagsHtml +=
        ' <span class="node-tag" style="color:#6b7280;border-color:#4b5563;">TMP</span>';
    }

    card.innerHTML =
      targetMarker +
      '<div class="node-table-name">' +
      escapeHtml(node.table_name) +
      "</div>" +
      '<div class="node-field-name" style="color:' +
      color +
      '">' +
      escapeHtml(node.field_name) +
      "</div>" +
      '<div class="node-meta">' +
      tagsHtml +
      "</div>" +
      procedureHtml +
      transformHtml;

    card.addEventListener("click", function () {
      onNodeClick(node, card);
    });

    return { el: card, node: node };
  }

  /* ============================================================
     SVG 连接线绘制
     ============================================================ */

  function drawConnections(svgLayer, layerElements, chains) {
    if (!svgLayer || !svgLayer.parentElement) return;
    var canvasWrap = svgLayer.parentElement;
    var wrapRect = canvasWrap.getBoundingClientRect();
    if (!wrapRect || wrapRect.width === 0 || wrapRect.height === 0) return;

    // 关键：动态设置 SVG 的宽高属性，确保坐标系与容器一致
    svgLayer.setAttribute("width", String(wrapRect.width));
    svgLayer.setAttribute("height", String(wrapRect.height));

    setupSvgDefs(svgLayer);

    var pathCount = 0;

    for (var ci = 0; ci < chains.length; ci++) {
      var chain = chains[ci];
      if (!chain.chain || chain.chain.length < 2) continue;

      for (var ni = 0; ni < chain.chain.length - 1; ni++) {
        var fromNode = chain.chain[ni];
        var toNode = chain.chain[ni + 1];

        var fromEl = findNodeElement(fromNode);
        var toEl = findNodeElement(toNode);
        if (!fromEl || !toEl) continue;

        try {
          var fromRect = fromEl.getBoundingClientRect();
          var toRect = toEl.getBoundingClientRect();
          if (!fromRect || !toRect) continue;

          // 坐标计算：相对于 canvas-wrap（SVG 父容器）
          var x1 = fromRect.left + fromRect.width / 2 - wrapRect.left;
          var y1 = fromRect.bottom - wrapRect.top;
          var x2 = toRect.left + toRect.width / 2 - wrapRect.left;
          var y2 = toRect.top - wrapRect.top;

          drawCurvedArrow(svgLayer, x1, y1, x2, y2);
          pathCount++;
        } catch (e) {
          /* 跳过无法绘制连接线的节点对 */
        }
      }
    }

    console.log("[Lineage] 已绘制 " + pathCount + " 条连接线");
  }

  function findNodeElement(node) {
    var id = node.table_name + "::" + node.field_name + "::" + node.layer;
    return document.querySelector('[data-node-id="' + id + '"]');
  }

  function setupSvgDefs(svgLayer) {
    var defs = document.createElementNS("http://www.w3.org/2000/svg", "defs");

    var marker = document.createElementNS(
      "http://www.w3.org/2000/svg",
      "marker"
    );
    marker.setAttribute("id", "arrowhead");
    marker.setAttribute("markerWidth", "10");
    marker.setAttribute("markerHeight", "7");
    marker.setAttribute("refX", "9");
    marker.setAttribute("refY", "3.5");
    marker.setAttribute("orient", "auto");

    var polygon = document.createElementNS(
      "http://www.w3.org/2000/svg",
      "polygon"
    );
    polygon.setAttribute("points", "0 0, 10 3.5, 0 7");
    polygon.setAttribute("class", "arrow-head");

    marker.appendChild(polygon);
    defs.appendChild(marker);
    svgLayer.appendChild(defs);
  }

  function drawCurvedArrow(svgLayer, x1, y1, x2, y2) {
    var midY = (y1 + y2) / 2;
    var pathData =
      "M" + x1 + "," + y1 + " C" + x1 + "," + midY + " " + x2 + "," + midY + " " + x2 + "," + y2;

    var path = document.createElementNS("http://www.w3.org/2000/svg", "path");
    path.setAttribute("d", pathData);
    path.setAttribute("class", "connection-path");
    path.setAttribute("marker-end", "url(#arrowhead)");
    path.setAttribute("fill", "none");
    svgLayer.appendChild(path);
  }

  /* ============================================================
     结果摘要栏渲染
     ============================================================ */

  function renderResultSummary(data) {
    var el = dom.resultSummary;
    if (!el || !data) return;

    el.classList.remove("hidden");
    el.innerHTML =
      '<div class="summary-item">' +
      '<span class="summary-num">' +
      escapeHtml(String(data.total_nodes || 0)) +
      '</span><span class="summary-text">个节点</span></div>' +
      '<div class="summary-divider"></div>' +
      '<div class="summary-item">' +
      '<span class="summary-num">' +
      escapeHtml(String(data.total_tables || 0)) +
      '</span><span class="summary-text">张表</span></div>' +
      '<div class="summary-divider"></div>' +
      '<div class="summary-item">' +
      '<span class="summary-num">' +
      escapeHtml(String(data.total_procedures || 0)) +
      '</span><span class="summary-text">个过程</span></div>' +
      '<div class="summary-divider"></div>' +
      '<div class="summary-item">' +
      '<span class="summary-num">' +
      escapeHtml(String(data.max_depth || 0)) +
      '</span><span class="summary-text">最大深度</span></div>' +
      '<span class="summary-time">查询耗时 ' +
      (data.query_time_ms ? data.query_time_ms.toFixed(2) : "-") +
      " ms</span>";
  }

  /* ============================================================
     图例栏渲染
     ============================================================ */

  function renderLegendBar(legendBar) {
    if (!legendBar) return;
    legendBar.classList.remove("hidden");

    var itemsContainer = legendBar.querySelector(".legend-items");
    if (!itemsContainer) return;
    itemsContainer.innerHTML = "";

    var types = ["ods", "diis", "base", "mdl", "app", "east", "temp", "other"];
    var frag = document.createDocumentFragment();

    for (var i = 0; i < types.length; i++) {
      var type = types[i];
      var info = LAYER_TYPE_MAP[type];
      if (!info) continue;

      var item = document.createElement("div");
      item.className = "legend-item";
      item.innerHTML =
        '<span class="legend-dot" style="background:' +
        info.color +
        '"></span>' +
        "<span>" +
        info.label +
        "</span>";
      frag.appendChild(item);
    }
    itemsContainer.appendChild(frag);
  }

  /* ============================================================
     详情面板
     ============================================================ */

  function onNodeClick(node, cardEl) {
    if (state.selectedNodeId) {
      var prev = document.querySelector('[data-node-id="' + state.selectedNodeId + '"].selected');
      if (prev) prev.classList.remove("selected");
    }

    state.selectedNodeId = cardEl.getAttribute("data-node-id");
    cardEl.classList.add("selected");
    showDetailPanel(node);
  }

  function showDetailPanel(node) {
    var panel = dom.detailPanel;
    var body = document.getElementById("detail-body");
    if (!panel || !body || !node) return;

    panel.classList.add("visible");
    panel.style.display = "block";

    var layerType = node.layer_type || "other";
    var color = getLayerColor(layerType);

    var sourceFieldsHtml = "";
    if (node.source_fields && node.source_fields.length > 0) {
      var chips = "";
      for (var i = 0; i < node.source_fields.length; i++) {
        chips +=
          '<span class="source-field-chip">' +
          escapeHtml(node.source_fields[i]) +
          "</span>";
      }
      sourceFieldsHtml =
        '<div class="detail-section">' +
        '<div class="detail-section-title">\u{1F4CB} 上游字段</div>' +
        '<div class="source-fields-list">' +
        chips +
        "</div></div>";
    }

    body.innerHTML =
      '<div class="detail-grid">' +
      '<div class="detail-field"><div class="detail-field-label">表名</div>' +
      '<div class="detail-field-value">' +
      escapeHtml(node.table_name) +
      "</div></div>" +
      '<div class="detail-field"><div class="detail-field-label">字段</div>' +
      '<div class="detail-field-value value-highlight" style="color:' +
      color +
      '">' +
      escapeHtml(node.field_name) +
      "</div></div>" +
      '<div class="detail-field"><div class="detail-field-label">层级</div>' +
      '<div class="detail-field-value">' +
      escapeHtml(String(node.layer)) +
      " (" +
      getLayerLabel(layerType) +
      ")</div></div>" +
      '<div class="detail-field"><div class="detail-field-label">过程</div>' +
      '<div class="detail-field-value">' +
      (node.procedure ? escapeHtml(node.procedure) : '<span style="color:var(--text-muted)">\u65E0</span>') +
      "</div></div>" +
      '<div class="detail-field"><div class="detail-field-label">转换逻辑</div>' +
      '<div class="detail-field-value">' +
      (node.transform_logic ? escapeHtml(node.transform_logic) : '<span style="color:var(--text-muted)">\u65E0</span>') +
      "</div></div>" +
      '<div class="detail-field"><div class="detail-field-label">临时表</div>' +
      '<div class="detail-field-value">' +
      (node.is_temp ? '\u662F' : '\u5426') +
      "</div></div></div>" +
      sourceFieldsHtml;
  }

  function hideDetailPanel() {
    var panel = dom.detailPanel;
    if (!panel) return;
    panel.classList.remove("visible");
    panel.style.display = "none";

    var body = document.getElementById("detail-body");
    if (body) body.innerHTML = "";

    state.selectedNodeId = null;

    var prev = document.querySelector(".node-card.selected");
    if (prev) prev.classList.remove("selected");
  }

  /* ============================================================
     状态视图：Loading / Empty / Error
     ============================================================ */

  function clearCanvasContent(canvasWrap) {
    if (!canvasWrap) return;
    // 安全清除：只删除 skeleton 和 state-view，保留 svg-layer 和 nodes-layer
    var skeleton = canvasWrap.querySelector(".skeleton-container");
    if (skeleton) skeleton.remove();
    var stateView = canvasWrap.querySelector("#state-view-el");
    if (stateView) stateView.remove();
    // 清空 svg-layer 内部内容（保留元素本身）
    var svgLayer = dom.svgLayer;
    if (svgLayer) svgLayer.innerHTML = "";
    // 清空 nodes-layer 内部内容
    var nodesLayer = dom.nodesLayer;
    if (nodesLayer) nodesLayer.innerHTML = "";
  }

  function showLoading() {
    state.isLoading = true;

    var btn = dom.btnQuery;
    if (btn) {
      btn.disabled = true;
      btn.innerHTML = '<span class="btn-spinner"></span>\u67E5\u8BE2\u4E2D...';
    }

    var lineageContainer = document.getElementById("lineage-container");
    if (lineageContainer) {
      lineageContainer.classList.remove("hidden");
    }

    var canvasWrap = document.getElementById("lineage-canvas-wrap");
    if (canvasWrap) {
      // 保留 svg-layer 和 nodes-layer，只插入 skeleton 到最前面
      var existingSkeleton = canvasWrap.querySelector(".skeleton-container");
      if (!existingSkeleton) {
        var skeletonEl = document.createElement("div");
        skeletonEl.className = "skeleton-container";
        skeletonEl.innerHTML =
          '<div class="skeleton-row">' +
          '<div class="skeleton-node"></div><div class="skeleton-node"></div><div class="skeleton-node"></div>' +
          "</div>" +
          '<div class="skeleton-line-h"></div>' +
          '<div class="skeleton-row">' +
          '<div class="skeleton-node"></div><div class="skeleton-node"></div>' +
          "</div>" +
          '<div class="skeleton-line-h"></div>' +
          '<div class="skeleton-row"><div class="skeleton-node"></div></div>';
        canvasWrap.insertBefore(skeletonEl, canvasWrap.firstChild);
      }

      // 隐藏已有的节点和连接线（不删除DOM元素）
      var svgLayer = dom.svgLayer;
      var nodesLayer = dom.nodesLayer;
      if (svgLayer) svgLayer.style.display = "none";
      if (nodesLayer) nodesLayer.style.display = "none";
    }

    var summaryEl = dom.resultSummary;
    if (summaryEl) summaryEl.classList.add("hidden");

    var legendEl = dom.legendBar;
    if (legendEl) legendEl.classList.add("hidden");

    hideDetailPanel();
  }

  function hideLoading() {
    state.isLoading = false;
    var btn = dom.btnQuery;
    if (btn) {
      btn.disabled = false;
      btn.innerHTML = "\uD83D\uDD0D \u67E5\u8BE2\u8840\u7F18";
    }
  }

  function showEmptyState(table, field) {
    var lineageContainer = document.getElementById("lineage-container");
    if (lineageContainer) lineageContainer.classList.remove("hidden");

    var canvasWrap = document.getElementById("lineage-canvas-wrap");
    if (canvasWrap) {
      // 不用 innerHTML 避免销毁 svg-layer / nodes-layer
      clearCanvasContent(canvasWrap);

      var stateEl = document.createElement("div");
      stateEl.className = "state-view";
      stateEl.id = "state-view-el";
      stateEl.innerHTML =
        '<div class="state-icon">\uD83D\uDCDD</div>' +
        '<div class="state-title">\u672A\u67E5\u5230\u8840\u7F18\u6570\u636E</div>' +
        '<div class="state-desc">\u8868 <strong>' +
        escapeHtml(table || "-") +
        "</strong> \u7684\u5B57\u6BB5 <strong>" +
        escapeHtml(field || "-") +
        "</strong> \u672A\u627E\u5230\u4E0A\u6E38\u8840\u7F18\u94FE\u8DEF\uFF0C\u8BF7\u68C0\u67E5\u8868\u540D/\u5B57\u6BB5\u540D\u662F\u5426\u6B63\u786E\u3002</div>";
      canvasWrap.appendChild(stateEl);
    }

    var summaryEl = dom.resultSummary;
    if (summaryEl) summaryEl.classList.add("hidden");

    var legendEl = dom.legendBar;
    if (legendEl) legendEl.classList.add("hidden");

    hideDetailPanel();
  }

  function showErrorState(message) {
    var lineageContainer = document.getElementById("lineage-container");
    if (lineageContainer) lineageContainer.classList.remove("hidden");

    var canvasWrap = document.getElementById("lineage-canvas-wrap");
    if (canvasWrap) {
      clearCanvasContent(canvasWrap);

      var stateEl = document.createElement("div");
      stateEl.className = "state-view error-state";
      stateEl.id = "state-view-el";
      stateEl.innerHTML =
        '<div class="state-icon">\u274C</div>' +
        '<div class="state-title">\u67E5\u8BE2\u51FA\u9519</div>' +
        '<div class="state-desc">' +
        escapeHtml(message || "\u672A\u77E5\u9519\u8BEF") +
        "</div>" +
        '<button class="error-action" onclick="location.reload()">\u91CD\u8BD5</button>';
      canvasWrap.appendChild(stateEl);
    }

    var summaryEl = dom.resultSummary;
    if (summaryEl) summaryEl.classList.add("hidden");

    var legendEl = dom.legendBar;
    if (legendEl) legendEl.classList.add("hidden");

    hideDetailPanel();
  }

  /* ============================================================
     事件绑定
     ============================================================ */

  function bindEvents() {
    if (dom.tableInput) {
      dom.tableInput.addEventListener("input", function () {
        doSearchTables(dom.tableInput.value);
      });

      dom.tableInput.addEventListener("keydown", function (e) {
        if (e.key === "Enter") {
          e.preventDefault();
          hideAutocomplete(dom.autocompleteDropdown);
          if (dom.fieldInput) {
            dom.fieldInput.focus();
          }
        }
      });

      dom.tableInput.addEventListener("blur", function () {
        setTimeout(function () {
          hideAutocomplete(dom.autocompleteDropdown);
        }, 150);
      });
    }

    if (dom.fieldInput) {
      dom.fieldInput.addEventListener("input", function () {
        doSearchFields(dom.fieldInput.value);
      });

      dom.fieldInput.addEventListener("keydown", function (e) {
        if (e.key === "Enter") {
          e.preventDefault();
          hideAutocomplete(dom.fieldAutocompleteDropdown);
          queryLineage();
        }
      });

      dom.fieldInput.addEventListener("blur", function () {
        setTimeout(function () {
          hideAutocomplete(dom.fieldAutocompleteDropdown);
        }, 150);
      });
    }

    if (dom.btnQuery) {
      dom.btnQuery.addEventListener("click", function (e) {
        e.preventDefault();
        queryLineage();
      });
    }

    if (dom.detailCloseBtn) {
      dom.detailCloseBtn.addEventListener("click", function () {
        hideDetailPanel();
      });
    }

    document.addEventListener("click", function (e) {
      var target = e.target;
      if (
        dom.autocompleteDropdown &&
        !dom.autocompleteDropdown.contains(target) &&
        dom.tableInput &&
        target !== dom.tableInput
      ) {
        hideAutocomplete(dom.autocompleteDropdown);
      }
      if (
        dom.fieldAutocompleteDropdown &&
        !dom.fieldAutocompleteDropdown.contains(target) &&
        dom.fieldInput &&
        target !== dom.fieldInput
      ) {
        hideAutocomplete(dom.fieldAutocompleteDropdown);
      }
    });
  }

  /* ============================================================
     初始化入口
     ============================================================ */

  function init() {
    dom.headerTitle = document.getElementById("header-title");
    dom.statCards = document.querySelectorAll(".stat-card");
    dom.tableInput = document.getElementById("table-input");
    dom.fieldInput = document.getElementById("field-input");
    dom.btnQuery = document.getElementById("btn-query");
    dom.autocompleteDropdown = document.getElementById("autocomplete-dropdown");
    dom.fieldAutocompleteDropdown = document.getElementById("field-autocomplete-dropdown");
    dom.canvasWrap = document.getElementById("lineage-canvas-wrap");
    dom.svgLayer = document.getElementById("svg-layer");
    dom.nodesLayer = document.getElementById("nodes-layer");
    dom.resultSummary = document.getElementById("result-summary");
    dom.legendBar = document.getElementById("legend-bar");
    dom.detailPanel = document.getElementById("detail-panel");
    dom.detailCloseBtn = document.getElementById("detail-close-btn");

    bindEvents();
    initStats();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
