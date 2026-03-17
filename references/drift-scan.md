# Automated Drift Scan

Set up a recurring agent task (Claude Code `/loop`, Codex cron, or equivalent) to automatically detect spec drift.

## Setup

Copy the prompt below and configure it as a recurring task. Run frequency depends on team velocity — daily during active development, weekly during slower periods.

## The Prompt

```
Read all active specs in osis/{product}-v{n}/phase-{N}-{slug}/.

For each implementation spec, compare:
  - Data model claims against schema files
  - API surface claims against actual route/procedure definitions
  - Dependency claims against package.json / imports
  - Engineering Notes against recent git log (last 2 weeks)

For each system product spec, compare:
  - Documented states/transitions against state management code
  - Edge cases listed against error handling in the codebase

For each design spec, verify:
  - Links are still valid
  - Status reflects current state

For the phase game plan, check:
  - Systems listed have corresponding spec files
  - Deferred items haven't leaked into the codebase

Do NOT scan osis/{product}-v{n}/vision.md or product-spec.md — these are human-owned
documents of intent that can't be validated against code.

Log all findings to osis/{product}-v{n}/changelog.md with:
  - Date
  - Spec file path
  - Finding type: [Drift] (spec says X, code does Y),
    [Missing] (code with no spec), or [Stale] (spec references dead code)
  - Description

Propose spec updates where the code is clearly authoritative.
Do not modify specs without confirmation — log findings only.
```

## Finding Categories

- **Drift** — spec says X, code does Y. Spec needs updating.
- **Missing** — code implements something with no spec coverage. Spec needs creating or expanding.
- **Stale** — spec references code/patterns that no longer exist. Spec needs cleanup.
- **Misaligned** — built correctly but doesn't match product intent. The code works, but it's not what the product spec intended.
