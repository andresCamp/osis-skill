# Automated Drift Scan

Set up a recurring agent task (Claude Code `/loop`, Codex cron, or equivalent) to automatically detect doc drift.

## Setup

Copy the prompt below and configure it as a recurring task. Run frequency depends on team velocity: daily during active development, weekly during slower periods.

## The Prompt

```
Read osis/osis.json to identify the active version and file manifest.

For each implementation doc ({phase}.impl.md), compare:
  - Data model claims against schema files
  - API surface claims against actual route/procedure definitions
  - Dependency claims against package.json / imports
  - Engineering Notes against recent git log (last 2 weeks)

For each product doc (product.md or {system}-product.md), compare:
  - Documented flows against actual user-facing behavior
  - Behavioral rules against code implementation
  - Core concepts against actual naming in the codebase

For each iteration brief (brief.md), check:
  - Phases listed have corresponding impl docs
  - "What Changes" items are reflected in the codebase

Do NOT scan manifesto.md, thesis.md, strategy.md, brand.md, or
design-system.md. These are human-owned reasoning docs that
can't be validated against code.

Log all findings to osis/{version}/changelog.md with:
  - Date
  - Doc file path
  - Finding type: [Drift] (doc says X, code does Y),
    [Missing] (code with no doc), or [Stale] (doc references dead code)
  - Description

Propose doc updates where the code is clearly authoritative.
Do not modify docs without confirmation. Log findings only.
```

## Finding Categories

- **Drift** — doc says X, code does Y. Doc needs updating.
- **Missing** — code implements something with no doc coverage. Doc needs creating or expanding.
- **Stale** — doc references code/patterns that no longer exist. Doc needs cleanup.
- **Misaligned** — built correctly but doesn't match product intent. The code works, but it's not what the product doc intended.
