## Summary

-

## Validation

- [ ] `python3.11 -m pytest tests/`
- [ ] `ruff check app/ core/ tests/`
- [ ] `mypy app/ core/`

## Safety checklist

- [ ] No real `SOURCE_DATA/`, local cache, database, log, archive, or secret files are included.
- [ ] User-facing behavior changes are documented.
- [ ] Parser/API changes include synthetic examples or tests.
