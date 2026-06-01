# Spec Delta: 安全修复

---

## MODIFIED Requirements

### Requirement: CORS Configuration
WHEN the application starts,
the system SHALL configure CORS with explicit origin allowlisting.

#### Scenario: Production mode
GIVEN the `PRODUCTION` environment variable is set
WHEN CORS middleware is configured
THEN only the explicitly listed origins are allowed
AND `allow_credentials=True` is set

#### Scenario: Development mode
GIVEN the `PRODUCTION` environment variable is not set
WHEN CORS middleware is configured
THEN localhost origins (http://localhost:*, http://127.0.0.1:*) are allowed
AND `allow_credentials=True` is set
AND wildcard `["*"]` with credentials is NEVER used

---

### Requirement: XSS Prevention in Frontend
WHEN server-controlled data (table names, field names, procedure names, indicator data) is rendered in the UI,
the system SHALL escape HTML special characters before inserting into the DOM.

#### Scenario: Table name contains HTML
GIVEN a table named `<script>alert(1)</script>`
WHEN the table name is rendered in the search panel
THEN the name is displayed as literal text `<script>alert(1)</script>`
AND no JavaScript is executed

#### Scenario: Field name contains quote character
GIVEN a field named `'; alert(1);//`
WHEN the field name is used in an onclick attribute
THEN the attribute does not break out of its quotes
AND no JavaScript is executed

---

## ADDED Requirements

### Requirement: Security Response Headers
WHEN the application serves any HTTP response,
the system SHALL include the following security headers:
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'`

#### Scenario: Any API response
GIVEN any HTTP response from the application
WHEN the response is sent to the client
THEN the headers include X-Content-Type-Options, X-Frame-Options, and Content-Security-Policy

---

### Requirement: Temporary Upload Cleanup
WHEN a file upload parse task completes,
the system SHALL clean up the uploaded files from the temp_uploads directory.

#### Scenario: Parse completes successfully
GIVEN a parse task has completed successfully
WHEN the result is returned to the client
THEN the uploaded files in `temp_uploads/{task_id}/` are deleted

#### Scenario: Parse fails
GIVEN a parse task has failed with an exception
WHEN the error is returned to the client
THEN the uploaded files are still deleted (best-effort cleanup)

#### Scenario: Stale files on startup
GIVEN temp_uploads contains files older than 24 hours
WHEN the application starts up
THEN those stale files are cleaned up automatically
