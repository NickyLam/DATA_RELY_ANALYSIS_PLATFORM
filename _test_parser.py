from pathlib import Path
from core.indicator_config_parser import IndicatorConfigParser

data_path = Path("财务集市指标血缘分析/指标")
parser = IndicatorConfigParser(data_path)
result = parser.parse_all()

print(f"Base calcs: {len(result.base_calcs)}")
print(f"GL calcs: {len(result.gl_calcs)}")
print(f"Relations: {len(result.relations)}")
print(f"Procedures: {len(result.procedures)}")
print(f"Parse time: {result.parse_time_sec:.3f} sec")

for name, info in sorted(result.procedures.items()):
    src_preview = info.source_tables[:5]
    print(f"  Proc: {name}, step={info.step_order}, index_type={info.index_type}, config={info.config_table}, target={info.target_table}, sources={src_preview}")

if result.base_calcs:
    bc = result.base_calcs[0]
    print(f"First base calc: index_no={bc.index_no}, algo_type={bc.algo_type}")

if result.gl_calcs:
    gc = result.gl_calcs[0]
    print(f"First GL calc: index_no={gc.index_no}, sign_no={gc.sign_no}, length_val={gc.length_val}")

if result.relations:
    rel = result.relations[0]
    print(f"First relation: index_no={rel.index_no}, depends={rel.depend_index_nos[:5]}")
