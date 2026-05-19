# Deprecated Code

This directory contains deprecated code that is no longer actively maintained.
It is kept for historical reference only.

## api_server.py

**Status**: Deprecated — replaced by FastAPI architecture (`app/main.py`)

| Item | Old (api_server.py) | New (app/main.py) |
|------|---------------------|---------------------|
| Framework | Python stdlib `http.server` | FastAPI + Uvicorn |
| Architecture | Monolithic (1500+ lines) | Modular (5 router modules) |
| Port | 8080 | 8899 |
| Async Support | No | Yes (SSE progress streaming) |
| API Routes | 16 | 37+ |

### Migration Notes

- All functionality from `api_server.py` has been migrated to the FastAPI app
- The missing `GET /api/tables/{table_name}/fields` endpoint was added to `app/api/lineage.py`
- No Python code imports `api_server` — zero runtime dependencies
- All startup scripts (`start.sh`, `start.bat`, `run_app.py`) use the FastAPI app
- Build config (`build.spec`, `pyproject.toml`) points to FastAPI

### No Guarantees

This code is provided as-is. It may not work with current dependencies and will not receive bug fixes or updates.
