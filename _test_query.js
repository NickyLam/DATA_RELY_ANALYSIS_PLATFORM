const fs = require('fs');
const html = fs.readFileSync('output/lineage_graph_query.html', 'utf8');
const js = html.match(/<script>([\s\S]*?)<\/script>/)[1];

function extractConst(name, pattern) {
  const m = js.match(pattern);
  if (!m) return null;
  try { return JSON.parse(m[1]); } catch(e) { return null; }
}

const LAYER_INFO = extractConst('LAYER_INFO', /const LAYER_INFO\s*=\s*(\{[\s\S]*?\});/);
const tablesData = extractConst('tablesData', /const tablesData\s*=\s*(\[[\s\S]*?\]);/);
const allLineages = extractConst('allLineages', /const allLineages\s*=\s*(\[[\s\S]*?\]);/);
const allFieldMappings = extractConst('allFieldMappings', /const allFieldMappings\s*=\s*(\[[\s\S]*?\]);/);
const tableLayerMap = extractConst('tableLayerMap', /const tableLayerMap\s*=\s*(\{[\s\S]*?\});/);
const tableColumnsMap = extractConst('tableColumnsMap', /const tableColumnsMap\s*=\s*(\{[\s\S]*?\});/);

console.log('=== Data Check ===');
console.log('Tables: ' + tablesData.length + ', Lineages: ' + allLineages.length + ', FieldMaps: ' + allFieldMappings.length);

// Test 1: Table Search
console.log('\n=== Test 1: Table Search ===');
function searchTable(kw) {
  const k = kw.toUpperCase(), r = [];
  for (const t of tablesData) {
    const fn = t.full_name.toUpperCase(), tn = fn.split('.').pop();
    if (fn.indexOf(k)!==-1 || tn.indexOf(k)!==-1) r.push(t.full_name);
  }
  return r;
}
[['EAST5',318], ['903',4], ['JYB',5], ['M_',982], ['ODS',0], ['X',0]].forEach(function(kv) {
  const r = searchTable(kv[0]);
  const ok = r.length === kv[1] ? 'OK' : 'MISMATCH(expected '+kv[1]+')';
  console.log('  "'+kv[0]+'" => ' + r.length + ' results ... ' + ok);
});

// Test 2: Find tables WITH field mappings AND columns
console.log('\n=== Test 2: Tables With Both Columns & Field Mappings ===');
const fmTargetTables = {};
for (const fm of allFieldMappings) {
  fmTargetTables[fm.target_table] = (fmTargetTables[fm.target_table]||0) + 1;
}
const richTables = [];
for (const tbl in tableColumnsMap) {
  const c = (tableColumnsMap[tbl]||[]).length, f = fmTargetTables[tbl]||0;
  if (c > 3 && f > 5) richTables.push({tbl, cols:c, fms:f});
}
richTables.sort((a,b) => b.fms - a.fms);
richTables.slice(0,8).forEach(function(t) {
  console.log('  ' + t.tbl.split('.').pop().padEnd(45) + ' cols=' + t.cols + ' fmaps=' + t.fms);
});

// Test 3: Field search on a real table
console.log('\n=== Test 3: Field Search on Real Table ===');
if (richTables.length > 0) {
  const targetTbl = richTables[0].tbl;
  const structCols = tableColumnsMap[targetTbl] || [];

  // Simulate cleanColumnName
  function cleanCol(col) {
    if (!col) return '';
    let lastLine = '';
    for (const line of col.split('\n')) {
      const trimmed = line.replace(/^\s+|\s+$/g,'');
      if (trimmed && !trimmed.startsWith('--')) lastLine = trimmed;
    }
    return lastLine || col.replace(/^\s+|\s+$/g,'');
  }

  // Collect unique fields
  const seen = {}, fields = [];
  structCols.forEach(function(c) { if (c && !seen[c]) { seen[c]=true; fields.push(c); } });
  allFieldMappings.forEach(function(fm) {
    if (fm.target_table === targetTbl) {
      const cn = cleanCol(fm.target_column);
      if (cn && !seen[cn]) { seen[cn]=true; fields.push(cn); }
    }
  });

  console.log('  Target: ' + targetTbl.split('.').pop());
  console.log('  Struct columns: ' + structCols.length + ', Total searchable fields: ' + fields.length);
  console.log('  Sample fields: ' + fields.slice(0,12).join(', '));

  // Test searching specific keywords
  [['ID',0], ['',0]].forEach(function(kv) {
    const matches = fields.filter(f => f.toUpperCase().indexOf(kv[0])!==-1);
    console.log('  Search "'+kv[0]+'": ' + matches.length + ' matches' + (matches.length>0 ? ' ('+matches.slice(0,3).join(',')+')' : ''));
  });
}

// Test 4: Upstream BFS
console.log('\n=== Test 4: Upstream BFS Trace ===');
function bfsUpstream(tgt) {
  const upMap={};
  for (const l of allLineages) {
    if (l.source_table===l.target_table) continue;
    if (!upMap[l.target_table]) upMap[l.target_table]=[];
    upMap[l.target_table].push(l);
  }
  const visited={}, nodes=[], links={}, depths={};
  const queue=[tgt]; visited[tgt]=true; depths[tgt]=0; nodes.push(tgt);
  while(queue.length>0){
    const cur=queue.shift(), cd=depths[cur]||0;
    if(cd>15)continue;
    for(const up of(upMap[cur]||[])){
      if(visited[up.source_table])continue;
      visited[up.source_table]=true;
      depths[up.source_table]=cd+1;
      queue.push(up.source_table); nodes.push(up.source_table);
      links[up.source_table+'->'+cur]={src:up.source_table,tgt:cur,proc:up.procedure};
    }
  }
  return {nodes, links:Object.keys(links), maxD:Math.max(...Object.values(depths),0), depths};
}

// Pick 3 representative tables
const testTargets = [
  tablesData.find(t => t.full_name.includes('EAST5_903_JYBJXXB'))?.full_name,
  tablesData.find(t => t.full_name.match(/M_GL_BAL[^_]/))?.full_name,
  tablesData.find(t => t.full_name.startsWith('A_') && allFieldMappings.some(f=>f.target_table===t.full_name))?.full_name,
].filter(Boolean);

testTargets.forEach(function(tgt) {
  const r = bfsUpstream(tgt);
  console.log('  ' + tgt.split('.').pop().padEnd(40) + ' => nodes=' + r.nodes.length + ' edges=' + r.links.length + ' depth=' + r.maxD);
  // Show first 3 levels
  const byDepth = {};
  for (const n of Object.keys(r.depths)) {
    const d=r.depths[n]; if(!byDepth[d])byDepth[d]=[]; byDepth[d].push(n.split('.').pop());
  }
  for (let d=0; d<=Math.min(r.maxD,3); d++) {
    if(byDepth[d]) console.log('    Depth '+d+': '+byDepth[d].slice(0,5).join(', ') + (byDepth[d].length>5?' ...('+byDepth[d].length+' total)':''));
  }
});

// Test 5: Field mapping detail for target edge
console.log('\n=== Test 5: Field Detail on Target Edge ===');
if (testTargets[0]) {
  const tgt = testTargets[0];
  const ups = allLineages.filter(l => l.target_table === tgt && l.source_table !== tgt);
  console.log('  Target: ' + tgt.split('.').pop() + ', direct upstream tables: ' + ups.length);
  if (ups.length > 0) {
    const proc = ups[0].procedure || '';
    const edgeFMs = allFieldMappings.filter(f =>
      f.target_table === tgt && (f.procedure||'') === proc
    );
    console.log('  First upstream via procedure: ' + proc.split('.').pop());
    console.log('  Field mappings on this edge: ' + edgeFMs.length);
    edgeFMs.slice(0,3).forEach(function(fm) {
      console.log('    src='+(fm.source_table||'?')+'.'+(fm.source_column||'').replace(/\n/g,' ').substring(0,20) +
                  ' -> tgt_col='+(fm.target_column||'').replace(/\n/g,' ').substring(0,25));
    });
  }
}

console.log('\n=== ALL TESTS DONE ===');
