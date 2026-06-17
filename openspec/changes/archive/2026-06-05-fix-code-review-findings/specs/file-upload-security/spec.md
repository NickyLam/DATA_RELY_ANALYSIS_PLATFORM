## ADDED Requirements

### Requirement: File upload path traversal prevention
The system SHALL sanitize uploaded file names to prevent path traversal attacks. The `save_upload` function MUST extract only the base filename (stripping directory components) and replace all non-alphanumeric characters (except dots and hyphens) with underscores before constructing the save path.

#### Scenario: Malicious filename with directory traversal
- **WHEN** a file is uploaded with filename `../../etc/cron.d/malicious`
- **THEN** the system saves the file using a sanitized name like `<uuid>_etc_cron_d_malicious`, preventing directory traversal

#### Scenario: Normal filename preserved
- **WHEN** a file is uploaded with filename `my_table.tab`
- **THEN** the system saves the file using `<uuid>_my_table.tab`

### Requirement: Filename character sanitization
The system SHALL apply `Path(filename).name` to strip directory components, then `re.sub(r'[^\w.\-]', '_', name)` to replace unsafe characters. The sanitized name MUST be combined with a UUID prefix for uniqueness.

#### Scenario: Filename with special characters
- **WHEN** a file is uploaded with filename `table (1).tab`
- **THEN** the system saves the file using `<uuid>_table__1_.tab`
