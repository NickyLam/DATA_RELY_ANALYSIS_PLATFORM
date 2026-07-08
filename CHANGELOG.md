# Changelog

Language: [中文](CHANGELOG.zh-CN.md) | English

All notable changes to this project are documented here. The project uses semantic versioning for public release notes.

## [v2.2.0] - 2026-07-08

### Added

- English README summary for open-source reviewers.
- Formal release notes with install commands, demo screenshots, example SQL, and sample API output.
- Demo assets under `docs/assets/`, including a lineage graph screenshot and short GIF walkthrough.
- Open-source maintenance documents: `CONTRIBUTING.md`, `SECURITY.md`, `ROADMAP.md`, and GitHub issue templates.
- Example SQL and API response fixtures under `docs/examples/`.

### Fixed

- Corrected lineage loss in Type5 ICL common processing patterns where `_ex` exchange tables were previously treated like temporary tables.
- Preserved lineage through `INSERT INTO ..._ex` and `ALTER TABLE ... EXCHANGE PARTITION ... WITH TABLE ..._ex` flows.
- Fixed upstream graph edge direction in graph conversion.

### Added

- Expanded warehouse layer detection to 17 layer types, including SRC, MSL, ITL, IOL, ICL, IML, IDL, IEL, and DQC.
- Updated frontend layer colors and labels for the expanded warehouse model.

### Highlighted capabilities

- Oracle and enterprise warehouse SQL parsing for DDL, DML, stored procedures, and indicator sources.
- Field-level lineage graph construction across layered warehouse schemas.
- D3.js visualization for upstream/downstream lineage review.
- SQLite-backed parse-result cache with in-memory query indexes.

### Notes for reviewers

- Real business data under `SOURCE_DATA/` must not be committed or attached to public issues.
- The included demo assets are safe screenshots intended for public project review.

## [v2.1.0] - 2026-05-14

### Added

- Indicator lineage analysis mode.
- Dual-tab frontend structure for parsing and visualization workflows.
- Caliber tracing and export workflow for governance evidence.

[v2.2.0]: ./docs/releases/v2.2.0.md
[v2.1.0]: ./docs/indicator-lineage-dual-mode-design.md
