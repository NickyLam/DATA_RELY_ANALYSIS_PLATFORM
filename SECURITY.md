# Security Policy

Language: [中文](SECURITY.zh-CN.md) | English

## Supported versions

The active supported line is the current `v2.x` release series. Security fixes should target the latest `main` branch unless a maintainer explicitly requests a backport.

## Reporting a vulnerability

Please do not open a public issue for vulnerabilities that include exploit details, private data paths, credentials, or proprietary SQL.

Report privately through one of these channels:

1. GitHub private vulnerability reporting, if enabled for this repository.
2. A direct maintainer contact channel listed in the repository profile.

If neither is available, open a public issue with only a minimal statement such as "Potential security issue in upload handling" and ask maintainers for a private contact path. Do not include secrets, real business SQL, customer names, screenshots with sensitive metadata, or cache/database files.

## What to include

- Affected version or commit.
- Component: parser, upload API, cache/storage, frontend, export, or dependency.
- Minimal synthetic reproduction steps.
- Expected vs actual behavior.
- Whether sensitive data exposure is possible.

## Data handling expectations

This project is designed for local analysis of enterprise SQL and metadata. Treat the following as sensitive by default:

- `SOURCE_DATA/`
- `output/`
- `temp_uploads/`
- `.db`, `.sqlite`, `.log`, `.zip`, `.7z`, `.tar`, and screenshot files containing real data
- Environment variables and admin API keys

## Maintainer response target

- Initial acknowledgement: within 5 business days.
- Triage decision: within 10 business days when a synthetic reproduction is available.
- Fix timeline: depends on severity and exploitability.

## Dependency security

Before release, run:

```bash
python3.11 -m pip install -r requirements.txt
python3.11 -m pip list --outdated
```

If this project is packaged with npm-based frontend tooling in the future, add `npm audit` to release verification.
