# Project Design Cleanup

The project boundary is a single FastAPI application entry. `run_app.py` and `app.main:app` are the authoritative server entry points for the current codebase, while legacy helper scripts such as `api_server.py` and `analyze_lineage.py` remain in the repository for compatibility and operational reference.

Generated runtime data is not source. Output directories, temporary uploads, logs, pid files, Python caches, virtual environments, local build products, archives, and OS/editor metadata are ignored through `.gitignore` so cleanup can happen without deleting local files.

Legacy scripts are retained but should not define new architecture. New development should keep request handling, domain logic, and generated artifacts separated so source review focuses on application code rather than runtime byproducts.
