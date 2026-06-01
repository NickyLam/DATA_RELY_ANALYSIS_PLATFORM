# Python Backend Development Rules

## Architecture

- **Four-layer architecture**: API → Service → Repository → Model. Dependencies flow downward only; reverse dependencies are forbidden.
- **API layer**: Request validation (Pydantic), call Service, return response. No business logic, no direct DB access.
- **Service layer**: Sole owner of business logic and transaction boundaries. Returns Pydantic Schema or primitives, never ORM Model.
- **Repository layer**: Data access only. Returns ORM Model. No business logic.
- **Model layer**: Field mappings and table constraints only. No business methods.

## API Design

- RESTful: plural nouns (`/users`), HTTP methods for CRUD, kebab-case URLs, snake_case query params.
- API versioning in URL prefix: `/api/v1/users`.
- Unified response: `ApiResponse[T]` with `code`, `message`, `data`.
- All endpoints must have `summary`, `description`, `response_model`.
- Schema fields must have `description` and `examples`.

## Type Safety

- **NEVER use `Any`**. Use `unknown` + type narrowing instead.
- All functions must have explicit return type annotations.
- Use Python 3.10+ union syntax `X | None` instead of `Optional[X]`.
- Use `collections.abc` instead of `typing` for generic types (e.g., `Sequence` not `List`).
- Run `mypy --strict` before committing.

## Naming

- Functions/variables: `snake_case`
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Boolean variables: `is_`/`has_`/`can_`/`should_` prefix
- Pydantic Schemas: `PascalCase` + suffix (`UserCreateRequest`, `UserResponse`)
- Private methods/attributes: `_` prefix

## Variables

- **No magic numbers**. Use named constants.
- **Never shadow builtins** (`list`, `id`, `type`, `dict`, etc.).
- Prefer `const` (no reassignment). Use `list[User]` not `List[User]`.
- Constants must be `UPPER_SNAKE_CASE` at module level or use `Enum`.

## Functions

- Single responsibility. Max 50 lines; if longer, split.
- Max 5 parameters; if more, use Pydantic Model or `dataclass`.
- Required params before optional params.
- Boolean-returning functions: `is_`/`has_`/`can_`/`should_` prefix.

## Exceptions

- Use `BusinessError(ErrorCode)` for business errors. Never raise raw `ValueError`/`RuntimeError` in business logic.
- **Never use empty `except`**. Always catch specific exceptions.
- **Never swallow exceptions**. Who catches, who logs.
- Use `raise NewError(...) from e` to preserve exception chain.
- Log with `exc_info=e` to include stack trace.

## Logging

- Use `%` formatting: `logger.info("User %s logged in", user_id)`. **Never f-strings in log calls**.
- **Never log sensitive data** (passwords, tokens, secrets).
- Use `logging.getLogger(__name__)` per module.

## Database

- Use SQLAlchemy 2.0 async style only. **Never** use `session.query()` legacy API.
- **Never** concatenate SQL strings. Always use parameterized queries.
- Use `selectinload`/`joinedload` to prevent N+1 queries.
- Always add `.limit()` to list queries.

## Security

- **Never hardcode secrets** in source code. Use environment variables.
- All external input must pass Pydantic validation.
- Passwords: use `bcrypt` via `passlib`. Never store plaintext.
- File uploads: validate type and size, use random filenames.

## Code Quality

- Run `ruff check` and `ruff format` before committing.
- Run `mypy --strict` before committing.
- No wildcard imports (`from module import *`).
- No circular imports.
- No `__all__` without explicit export list in `__init__.py`.

## Testing

- Test naming: `test_{method}_{scenario}_{expected_result}`.
- Use AAA pattern: Arrange → Act → Assert.
- Line coverage ≥ 80%. Core business logic ≥ 90%.

## Async

- Use `async/await` in async context. **Never** use blocking calls (`requests`, `time.sleep`) in async functions.
- Use `httpx` instead of `requests` for async HTTP.
- Use `asyncio.gather` for parallel independent tasks.
