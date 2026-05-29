## 1. 修复缺失导入

- [x] 1.1 在 `core/caliber_metadata.py` 第10行的 `from core.models import SubqueryInfo, SelectColumnMapping` 中补充 `SQLCondition`，改为 `from core.models import SQLCondition, SubqueryInfo, SelectColumnMapping`

## 2. 验证修复

- [x] 2.1 运行 `python -c "from core.caliber_metadata import MetadataExtractor; print('import OK')"` 确认导入无报错
- [x] 2.2 运行 `python -m pytest tests/ -v -k "caliber"` 确认现有测试通过
- [x] 2.3 运行 `python -m pytest tests/ -v` 确认全量测试通过
