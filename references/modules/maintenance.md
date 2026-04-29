# Maintenance

Post-creation reconciliation. Read this file only when the user triggers Twin, Analyze, or Update.

Three modes live here because they share one purpose: keeping the product, the docs, and the code aligned after creation. They differ in input and output, but the underlying contract (branch discipline, clean-chat writes, changelog logging, `osis.json` sync) is one contract.

```
Twin     → scan codebase        → compress          → write twin.md
Analyze  → scan artifact        → compare vs doc    → log findings
Update   → mid-conversation     → propagate upward  → write affected docs
```

Twin refreshes ground truth. Analyze checks docs against ground truth. Update pushes discoveries from a lower funnel layer to a higher one.

## Shared Contract

Every maintenance mode obeys these rules. They are the cost of keeping the system honest without creating noise.

**Branch guard.** If the current branch is not `main`, warn before scanning or writing. The user can proceed, but they should know. Twin and Analyze perform the guard before the scan. Update performs it before writing. Use `git rev-parse --abbrev-ref HEAD` inside the subagent, not in the main conversation.

**Foreground subagent for scan-based work.** Twin and Analyze run their scan, comparison, and write pass inside a single foreground subagent so the main chat stays clean. Update does not need a subagent unless the write spans many docs. The subagent owns all file reads, all codebase greps, all writes, and returns a structured result. Do not split a scan into multiple subagent calls or narrate intermediate progress.

**Never write files via bash.** No `cat > file`, no `echo ... > file`, no shell redirection. Always use the proper Write or Edit tools. The only shell-driven writes allowed are inside `onboard.sh`.

**File-handling.** `onboard.sh` created placeholder files during onboarding. When a maintenance subagent needs to overwrite any existing file, it must read first, then write, or use Edit for targeted replacements. Calling Write on an unread file fails with "File has not been read yet."

**Session footer.** After any doc write, update the Sessions footer per SKILL.md "Doc Conventions." When a subagent performs the write, the parent resolves the session ID first via `bash {SKILL_PATH}/scripts/session-id.sh` and passes it into the subagent prompt verbatim; the subagent uses it in the footer and does not run the script itself. Skip silently if the script exits non-zero.

**osis.json sync.** Any maintenance mode that creates or deletes docs must update the `files` manifest in `osis.json`. Twin additionally updates `lastTwinUpdate` to the current date.

**Align before writing.** The core Osis principle still applies. In Analyze and Update, surface findings and proposed changes, then confirm before writing. Twin is the one exception: regenerating `twin.md` is the point of the mode, so the write proceeds without per-line alignment once the scan completes. The user can still reject the result.

**Session log.** All three modes are strong-moment sources at both ends. Append a bullet to the current thread in `osis/sessions.md` on mode entry (name the mode and target), and again on scan completion for Twin and Analyze, or write completion for Update (name the outcome: twin refreshed, findings logged, doc propagated). If topic or areas are still `pending`, infer and write them alongside the first append. Skip silently if `bash {SKILL_PATH}/scripts/session-id.sh` returns non-zero or `sessions.md` is missing.

## Twin

Refreshes the digital twin. The twin is an agent-readable operational map: descriptive, not prescriptive. It reflects the system; it does not define product decisions.

### When triggered

The user asks for a twin update, says "rescan the twin," notes that the twin is stale, or runs a cron that invokes Twin mode. Also appropriate before a major Analyze pass, since stale twins make stale comparisons.

### Flow

1. Branch guard.
2. Spawn foreground subagent with description `Refreshing the twin`. The subagent:
   - scans the codebase (routes, schemas, services, dependencies, configs)
   - compresses into the structure below
   - writes `osis/twin.md`
   - updates `osis.json` (`lastTwinUpdate`, `files` manifest if docs shifted)
3. Return a one-line summary to the main chat: what changed vs the previous twin. Do not dump the twin contents into the chat.

### What the twin contains

- **Master diagram.** The product topology in one visual. Follow the diagram geometry rules in `references/docs/engine/twin.md`. The twin's diagram is the product's shape at the code level, drawn from the product's perspective, not a raw repo tree.
- **Systems.** For each significant system: name, capabilities, maturity (shipping / in progress / stub).
- **Canonical entities.** The domain objects that matter, and their relationships.
- **Interfaces.** How systems communicate (HTTP routes, events, shared DB, direct imports).
- **Architecture.** High-level choices (framework, deployment shape, data flow).
- **Dependencies.** External services and critical libraries. Not an exhaustive package list.
- **Known gaps.** Things the twin intentionally cannot capture (WIP surfaces, undocumented edges).

### Altitude

The twin is for agents loading product context, not engineers onboarding. Keep it compressed: readable in 2-3 minutes. If a section reads like code documentation, cut it. If a section reads like a product pitch, cut it. Describe reality.

## Analyze

Compares any artifact against the relevant doc. Broader than drift detection.

### Use cases

- **Drift check:** docs vs code, flag mismatches.
- **Feature QA:** "I just built this, does it match the product doc?"
- **Agent QA:** "Here's an agent transcript, does the behavior align with the product?"
- **Output QA:** compare any output against behavioral rules or product intent.

### Flow

1. Branch guard (for code-based checks).
2. Load the relevant doc(s) via the `osis.json` files manifest.
3. Spawn foreground subagent with description `Analyzing {target}`. The subagent:
   - scans the artifact (code, transcript, output)
   - compares against the loaded doc(s)
   - categorizes each finding
   - returns a structured report
4. Present findings to the user. Propose doc updates where code is clearly authoritative. Do not modify docs without confirmation.
5. On approval, write updates and log to the relevant `{version}/changelog.md`.

### Finding categories

- **Drift** — doc says X, reality does Y. Doc needs updating, or code needs fixing, or product intent needs reconsidering.
- **Missing** — reality implements something with no doc coverage. Doc needs creating or expanding.
- **Stale** — doc references something that no longer exists. Doc needs cleanup.
- **Misaligned** — built correctly against code, but does not match product intent. The subtle one: flag and discuss, do not auto-resolve.

### What NOT to scan

`manifesto.md`, `thesis.md`, `strategy.md`, `brand.md`, and `design-system.md` are human-owned reasoning docs. They cannot be validated against code. Analyze leaves them alone unless the user explicitly asks for a consistency check across them.

### Changelog entry format

```markdown
- {YYYY-MM-DD} [Drift|Missing|Stale|Misaligned] {doc/path.md} — {one-line description}
```

Group multiple findings from a single Analyze pass under one date heading.

### Cron variant

For automated recurring drift scans (Claude Code `/loop`, Codex cron, or equivalent), use this prompt as the recurring task:

```
Read osis/osis.json to identify the active version and file manifest.

For each implementation doc ({phase}.impl.md), compare:
  - Data model claims against schema files
  - API surface claims against actual route/procedure definitions
  - Dependency claims against package.json / imports
  - Engineering Notes against recent git log (last 2 weeks)

For each product doc (core/product.md or {system}/product.md), compare:
  - Documented flows against actual user-facing behavior
  - Behavioral rules against code implementation
  - Core concepts against actual naming in the codebase

For each iteration brief (brief.md), check:
  - Phases listed have corresponding impl docs
  - "What Changes" items are reflected in the codebase

Do NOT scan manifesto.md, thesis.md, strategy.md, brand.md, or
design-system.md. These are human-owned reasoning docs that
can't be validated against code.

Log all findings to osis/{version}/changelog.md with date, doc path,
finding category, and description.

Propose doc updates where the code is clearly authoritative.
Do not modify docs without confirmation. Log findings only.
```

Run frequency: daily during active development, weekly during slower periods.

## Update

Upward propagation. Triggered mid-conversation when a discovery at a lower funnel layer invalidates an assumption at a higher one.

This is the lightest maintenance mode. No scan, no subagent by default, no branch guard unless the write crosses many docs.

### When triggered

The user discovers during implementation (or during a Consult) that a brief, a product doc, a strategy, or even a thesis no longer holds. The realization usually comes from doing the work, not from reading the docs.

Examples:
- Building a phase reveals the brief's bet was wrong.
- A feature behavior conflicts with the product definition.
- Strategy priorities are contradicted by what the team is actually doing.

### Flow

1. Understand what was discovered. Get specific. "We're not doing X anymore" is the starting point, not the end.
2. Identify which doc owns it. Route by type, not by folder:
   - product behavior → `core/product.md` or `{system}/product.md`
   - market/wedge/focus → `strategy.md`
   - version hypothesis → `thesis.md`
   - iteration bet → `brief.md`
   - enduring declaration → `manifesto.md`
3. Check propagation. If the discovery invalidates an assumption at a higher layer, that layer must be updated too. Do not silently patch a lower layer while a higher layer contradicts it.
4. Align with the user on every affected doc before writing.
5. Write via subagent if the change spans multiple docs, directly via Edit for a single-doc change. Log to `{version}/changelog.md`.
6. Session footer on every touched doc.


### The propagation rule

Update exists because implementation reveals truth that specification could not anticipate. When that happens, push the truth up, not just across. A brief that learns something the thesis assumed away must change the thesis, or the brief is lying to itself.

---

## Sessions

- 2026-04-29 — Extended the shared-contract Session footer rule: when a subagent performs the write, the parent resolves the session ID and passes it into the prompt verbatim, so the footer binds to the conversation that initiated the work. · `claude -r f8a091a2-bca2-4185-8bea-9cef943ce3dc`
- 2026-04-23 — Added shared-contract session-log rule; Twin, Analyze, Update as strong-moment sources on entry and completion · `claude -r 14bd6251-f95c-4256-a184-3b259e64906b`
