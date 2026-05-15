from pathlib import Path
from core.indicator_config_parser import IndicatorConfigParser
from core.indicator_graph_builder import IndicatorGraphBuilder

result = IndicatorConfigParser(Path('财务集市指标血缘分析/指标')).parse_all()
builder = IndicatorGraphBuilder(result)
graph = builder.build_full_graph()

print(f'Graph: {graph.node_count} nodes, {graph.edge_count} edges')
print(f'Stats: {graph.stats}')

r = builder.trace_indicator('FM0100011', '001', 'upstream', 5)
print(f'Trace FM0100011: {r.graph.node_count} nodes, {r.chain_count} chains, {r.query_time_ms:.1f}ms')

steps = builder.get_pipeline_steps('FM0100011')
for s in steps:
    print(f'  Step{s["step_order"]}: {s["proc_name"]} involved={s["involved"]}')

detail = builder.get_indicator_detail('FM0100011')
print(f'Detail: {len(detail["measures"])} measures, {len(detail["gl_mappings"])} gl, up={detail["upstream_indices"][:3]}, is_gl={detail["is_gl"]}')

r2 = builder.trace_indicator('FM0100002', '', 'upstream', 5)
print(f'Trace FM0100002 (derived): {r2.graph.node_count} nodes, {r2.chain_count} chains')

print('ALL OK')
