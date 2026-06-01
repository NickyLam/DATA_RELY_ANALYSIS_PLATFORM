# Spec Delta: API 接口标准化

---

## MODIFIED Requirements

### Requirement: Unified Response Envelope
WHEN any API endpoint returns a response,
the system SHALL wrap the response body in a unified envelope with the following structure:
```json
{
  "code": 0,
  "message": "",
  "data": <payload>
}
```
WHERE `code` = 0 indicates success, non-zero indicates error.
The HTTP status code SHALL reflect the actual outcome (200 for success, 4xx/5xx for errors).

#### Scenario: Successful query
GIVEN a valid lineage query request
WHEN the server processes the request successfully
THEN the response has HTTP status 200
AND the body is `{"code": 0, "message": "", "data": <result>}`

#### Scenario: Resource not found
GIVEN a query for a non-existent table
WHEN the server cannot find the table
THEN the response has HTTP status 404
AND the body is `{"code": 404, "message": "表不存在", "data": null}`

#### Scenario: Internal server error
GIVEN an unexpected exception during processing
WHEN the server fails to complete the request
THEN the response has HTTP status 500
AND the body is `{"code": 500, "message": "服务内部错误", "data": null}`
AND the exception details are logged server-side but NOT exposed to the client

---

### Requirement: Enum Parameter Validation
WHEN an API endpoint accepts an enumerated parameter (direction, data_source, etc.),
the system SHALL validate the parameter against the defined enum values
and return HTTP 422 with a descriptive message for invalid values.

#### Scenario: Invalid direction value
GIVEN a request with `direction=sideways`
WHEN the server validates the parameter
THEN the response has HTTP status 422
AND the message indicates the valid values are "upstream", "downstream", "both"

#### Scenario: Valid direction value
GIVEN a request with `direction=upstream`
WHEN the server validates the parameter
THEN the request proceeds normally

---

### Requirement: API Key Authentication for Destructive Endpoints
WHEN a destructive endpoint is called (reparse, cache rebuild, file upload),
the system SHALL require a valid API key in the `X-API-Key` header.

#### Scenario: Request without API key
GIVEN a request to `POST /api/system/reparse` without `X-API-Key` header
WHEN the server processes the request
THEN the response has HTTP status 401
AND the message is "API Key required"

#### Scenario: Request with valid API key
GIVEN a request to `POST /api/system/reparse` with the correct `X-API-Key` header
WHEN the server processes the request
THEN the request proceeds normally

#### Scenario: API key not configured
GIVEN the `API_KEY` environment variable is not set
WHEN destructive endpoints are called
THEN the system skips authentication (backward compatible)

---

## ADDED Requirements

### Requirement: Rate Limiting
WHEN an API endpoint is called,
the system SHALL enforce rate limiting to prevent abuse.

#### Scenario: Normal usage
GIVEN a client making fewer than 60 requests per minute
WHEN the client calls any endpoint
THEN all requests are processed normally

#### Scenario: Rate limit exceeded
GIVEN a client making more than 60 requests per minute
WHEN the client exceeds the limit
THEN the response has HTTP status 429
AND the response includes a `Retry-After` header

#### Scenario: Parse endpoint rate limit
GIVEN a client calling parse endpoints
WHEN the client exceeds 5 requests per minute
THEN the response has HTTP status 429
