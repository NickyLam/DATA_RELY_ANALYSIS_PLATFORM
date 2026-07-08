# Contributing

Thanks for helping improve the data lineage analyzer. This project handles SQL and metadata that may come from sensitive enterprise environments, so contributions must be careful about test data, logs, and reproducibility.

## Development setup

```bash
python3.11 -m venv .venv
source .venv/bin/activate
python3.11 -m pip install -r requirements.txt
```

Run the app:

```bash
python3.11 run_app.py
```

Run checks:

```bash
python3.11 -m pytest tests/
ruff check app/ core/ tests/
mypy app/ core/
```

If local hooks are enabled:

```bash
bash scripts/install-git-hooks.sh
scripts/agent-verify.sh quick
scripts/agent-verify.sh full
```

## Contribution workflow

1. Open an issue for non-trivial changes.
2. Keep API routes thin; put business logic in `app/services/`.
3. Keep `core/` framework-agnostic. Do not import FastAPI from `core/`.
4. Add or update tests for parser, lineage, API, or frontend behavior.
5. Update docs when changing user-facing behavior, setup, APIs, or exported formats.
6. Use conventional commit messages, for example `fix: 修复字段血缘方向`.

## Sensitive data policy

Do not commit:

- Real `SOURCE_DATA/` content.
- Local cache files from `output/`.
- Database files such as `.db` or `.sqlite`.
- Logs, credentials, API keys, screenshots containing customer names, or proprietary SQL.
- Compressed archives with unknown contents.

Use synthetic SQL samples like `examples/oracle_warehouse_lineage.sql` when filing issues or tests.

## Coding standards

- Python 3.11+ compatible syntax only.
- Use type hints for new code.
- Use `snake_case` for functions and variables.
- Use `PascalCase` for Pydantic models and dataclasses.
- Do not use PEP 604 unions as the second argument to `isinstance()`. Use tuples such as `isinstance(value, (A, B))`.
- New parsers should implement the parser protocol by duck typing and register through `ParserRegistry`.

## Testing guidance

- Parser changes: add narrow unit tests under `tests/`.
- API changes: add API tests with mocked services.
- Graph/UI behavior: update frontend E2E coverage when applicable.
- Storage/cache changes: include migration or compatibility tests.

## Pull request checklist

- [ ] Tests added or updated.
- [ ] `python3.11 -m pytest tests/` passes, or the PR explains why it cannot be run.
- [ ] `ruff check app/ core/ tests/` passes for touched files.
- [ ] Documentation updated when user-facing behavior changes.
- [ ] No sensitive data, local cache, logs, or generated archives are included.
