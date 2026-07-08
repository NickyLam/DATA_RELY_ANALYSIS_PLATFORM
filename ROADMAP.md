# Roadmap

This roadmap is intentionally practical: it focuses on making the project easier to evaluate, run, extend, and trust as an open-source data lineage analyzer.

## Now: v2.2.x

- Improve English onboarding for open-source reviewers.
- Keep demo screenshots/GIFs current with the UI.
- Expand safe synthetic SQL examples for Oracle, stored procedures, and warehouse exchange-table workflows.
- Keep issue templates and security guidance aligned with sensitive-data handling.

## Next: v2.3

- Add a small public sample dataset that can be parsed end-to-end without private enterprise data.
- Add a one-command demo mode that loads only safe bundled sample SQL.
- Add API response schema examples to Swagger/OpenAPI docs.
- Tighten parser regression tests for CTAS, INSERT SELECT, MERGE, EXCHANGE PARTITION, and stored procedure flows.
- Add export examples for lineage and caliber evidence.

## Later: v2.4+

- Version lineage graph output with an explicit graph schema version.
- Add lineage diff between parse runs.
- Add optional containerized local deployment.
- Add configurable masking/redaction for user-supplied SQL snippets and screenshots.
- Improve frontend accessibility, keyboard navigation, and large-graph performance.

## Non-goals

- Hosting or processing users' private SQL in a public service.
- Committing real enterprise data, local caches, or generated databases.
- Coupling `core/` parsing logic to FastAPI or UI frameworks.
