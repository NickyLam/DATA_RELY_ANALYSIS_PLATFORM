## ADDED Requirements

### Requirement: Remove display-tab.js
The `static/js/display-tab.js` file SHALL be deleted. Its `<script>` tag SHALL be removed from `index.html`. All functionality is already provided by `lineage-graph.js`, `search-panel.js`, and `detail-panel.js`.

#### Scenario: No display-tab.js script tag in HTML
- **WHEN** index.html is loaded
- **THEN** no `<script src="js/display-tab.js">` tag SHALL exist

### Requirement: Wrap parse-tab.js in IIFE
The `static/js/parse-tab.js` file SHALL be wrapped in an IIFE to prevent global namespace pollution. Only necessary public interfaces SHALL be exposed via `window.*` assignments.

#### Scenario: No leaked global variables
- **WHEN** parse-tab.js is loaded
- **THEN** `selectedFilesArray`, `eventSource`, `sseRetryCount` SHALL NOT be global variables

### Requirement: Event delegation for spec-toggle in detail-panel.js
The `_bindSpecToggle` function SHALL use event delegation on `#infoPanel` instead of adding individual click listeners to each `.spec-toggle` element. This prevents listener accumulation when rendering multiple node details.

#### Scenario: Multiple node detail renders
- **WHEN** a user clicks on 5 different nodes in succession
- **THEN** each `.spec-toggle` element SHALL have exactly one click handler, not 5

### Requirement: innerHTML XSS protection in app.js
The `showSystemStats` function SHALL use `escapeHtml()` for all dynamic values before inserting into HTML. The `overlay.innerHTML = html` pattern MUST ensure all interpolated values are escaped.

#### Scenario: Malicious API response
- **WHEN** the stats API returns `<script>alert(1)</script>` as a field value
- **THEN** the overlay SHALL display the escaped text, not execute the script

### Requirement: Remove debug console.log from production code
All `console.log` statements in `indicator-tab.js` SHALL be removed or replaced with `console.debug` wrapped in a development-mode check.

#### Scenario: Production browser console
- **WHEN** the application is running in production
- **THEN** no debug log messages from indicator-tab.js SHALL appear in the browser console
