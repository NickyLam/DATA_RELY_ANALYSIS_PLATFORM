## ADDED Requirements

### Requirement: Destructive endpoints require API key
The `POST /api/system/reparse` and `POST /api/cache/rebuild` endpoints SHALL require an `X-Admin-Key` header when the `ADMIN_API_KEY` environment variable is configured. If the environment variable is not set, the endpoints SHALL remain accessible without authentication (backward compatible).

#### Scenario: Valid API key provided
- **WHEN** a request includes `X-Admin-Key: <matching_key>` header
- **THEN** the endpoint SHALL process the request normally

#### Scenario: Invalid API key provided
- **WHEN** a request includes `X-Admin-Key: <wrong_key>` header
- **THEN** the endpoint SHALL return HTTP 403 Forbidden

#### Scenario: API key required but not provided
- **WHEN** `ADMIN_API_KEY` is configured and the request lacks `X-Admin-Key` header
- **THEN** the endpoint SHALL return HTTP 403 Forbidden

#### Scenario: No ADMIN_API_KEY configured
- **WHEN** `ADMIN_API_KEY` environment variable is not set
- **THEN** the endpoint SHALL be accessible without authentication
