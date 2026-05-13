# Build

Brackets plan mode. Read this file only when the user invokes Build mode (says "build {spec}", "let's work on {spec-id}", "start {phase}", "open {NN-name}", or equivalent intent).

Build is the mode that opens and closes the loop around a single atomic spec. Plan mode owns the code authoring in the middle; Build owns the orientation in and the bookkeeping out.

```
User: "let's build {spec-id}"
  ↓
Build open: resolve spec → DAG check → load context → hand back
  ↓
Plan mode: code authoring, file diffs, test runs (user invokes; Build does not enter)
  ↓
User: "done with {spec}" / "{spec} landed"
  ↓
Build close: status update → changelog → propagation sweep → session footers
```

## What Build is

Build is the protocol-aware wrapper around plan mode. It does not author code, does not run tests, does not enter plan mode for the user. The user crosses into plan mode themselves at the moment of their choosing; Build does the work that plan mode does not know how to do.

The orient-load-execute-close loop is what coordinates parallel sessions. The DAG (in the parent brief's Phases table) tells the next agent what is ready to build. The changelog tells them what has shipped. Build is the mode that reads the first and writes the second.

## When triggered

User intent: "build {spec-id}", "let's work on {spec-id}", "start the {phase} phase", "open {NN-name}", "ship {spec-id}", "kick off {spec-id}", or equivalent.

The user always names a target spec by id from a brief's Phases table. If no spec id is named, ask which one. Multi-spec coordination ("which should I do first?") is a Consult, not a Build.

## Open ritual

1. **Resolve the target spec.** Find the matching row in the parent brief's Phases table. The `Spec` column carries the id; the row carries `Depends on` and `Status`. If the spec id has no row, surface the mismatch and stop. Do not invent or guess.
2. **DAG check.** Walk the `Depends on` column. For every upstream spec, verify its row Status is `done`. If any upstream is not `done`, surface the blocker by name and offer three branches:
   - (a) switch to the blocker and build it first
   - (b) build anyway, accepting that the dependency is unmet and risk is on the user
   - (c) stop
   Do not silently allow Build to proceed past an unmet dependency.
3. **Load context silently.** Read in this order:
   - The target spec's `{spec-id}.impl.md` in full
   - The parent brief's `## Shared Decisions` section
   - The parent brief's Bet + Insight (one-paragraph framing)
   - Any sibling spec the target's Decisions section explicitly cites
   Do not narrate the loads. Come informed.
4. **Surface one summary line and hand back.** Format: "Loaded {spec-id} + brief context. {dependency status}. Ready when you are." Build does NOT enter plan mode for the user. The user enters plan mode themselves; that boundary is sovereign.
5. **Session log candidate.** Build entry is a strong-moment candidate for the session-log buffer (name the spec id, the iteration, and whether the DAG check cleared or surfaced a blocker).

## Close ritual

Triggered when the user signals the spec landed: "done with {spec}", "{spec} landed", "merged the {spec} branch", or an explicit close cue.

1. **Confirm the spec landed.** If the work is partial or in progress, stop. Build does not manage in-progress state beyond what the brief's Status column shows.
2. **Update the brief's Phases table.** Set the spec's row Status to `done`. Edit the brief.md file directly.
3. **Update the impl header.** Set the spec's `**Status:**` header to `done`.
4. **Append a changelog entry** to the active version's `changelog.md`:
   ```
   - {YYYY-MM-DD} [Build] {iteration-slug}/{spec-id} — {one-line outcome}
   ```
5. **Upward propagation sweep.** If the spec surfaced anything in its Engineering Notes that invalidates assumptions above (the brief's Bet, the parent product.md, the thesis, the manifesto), route into Update mode and run the propagation. Build close is a propagation trigger.
6. **Session footer** on every doc touched in steps 2-5 (the brief, the impl, the changelog, and any docs Update mode touched). Resolve the session ID with `bash {SKILL_PATH}/scripts/session-id.sh`; if non-zero, skip the footers silently.
7. **Session log candidate.** Build close is a strong-moment candidate for the session-log buffer (name the spec id, the outcome, and whether propagation fired).

## Bracket boundary: Build vs plan mode

Build owns:
- DAG check on the way in
- Context load (spec + brief + dep specs) on the way in
- Status update across brief + impl on the way out
- Changelog entry on the way out
- Upward propagation sweep on the way out
- Session footers on all touched docs

Plan mode owns:
- Code authoring
- File diffs and edits
- Test runs
- Internal sequencing within the spec

Build does NOT enter plan mode, does not author code, does not edit source, does not run tests. It is a wrapper, not a replacement. The user is sovereign over the middle of the bracket; Build does not intervene mid-execution.

## Transitional format support

User repos can carry briefs in two shapes during the v1.10.0 → v1.11.0 transition:
- **v1.11.0 (canonical):** Phases table with `Spec | Name | Depends on | Status` columns
- **v1.10.0 (legacy):** Per-phase `### {phase-slug}` headings followed by `depends_on:` YAML codeblocks

The Open ritual's DAG parser tries the table first. If the brief carries no Phases table, fall back to parsing the YAML codeblocks under per-phase headings. On first encountering a legacy brief during Build open, surface a soft prompt:

> "This iteration's brief is in the v1.10.0 phase-codeblock format. Migrate it to the v1.11.0 Phases table now (one edit, no spec-level changes), or proceed with the legacy parse?"

If the user accepts migration, run the brief reshape from the v1.11.0 changelog Migration block and continue. If the user defers, proceed with the legacy parse and re-offer on the next Build open against this iteration.

## Session Log

Build is a strong-moment source on both ends. Append a bullet to the current thread in `osis/sessions.md` when Build mode is entered (name the spec id, the iteration, and whether the DAG cleared) and again on close (name the spec id, the outcome, propagation status). If topic or areas are still `pending`, infer and write them alongside the first append. If `bash {SKILL_PATH}/scripts/session-id.sh` returns non-zero or `sessions.md` is missing, skip the append silently.

## When NOT to trigger Build

- Pure code work without a target spec in mind — that's plan mode standalone.
- Mid-spec micro-questions ("how should I structure this function?") — Consult or plan mode, not Build.
- Multi-spec coordination ("which one should I do first?") — Consult with the brief loaded.
- A spec already at `done` Status — re-opening is a propagation event (Update mode), not a Build re-entry.
- The user has not named a spec id — ask which spec they mean before triggering.

## Edge cases

- **Dependency not done.** Surface by name and offer the three branches (switch / proceed with risk / stop). Do not silently allow Build to proceed.
- **Spec id not in any brief.** Either the brief is stale or the user named the wrong id. Surface the mismatch and ask the user to clarify.
- **No active iteration.** No brief loaded means no DAG. Ask the user which iteration they're building against and load that brief first.
- **Grouped specs (`NNa/NNb/NNc`).** Each is independently buildable. Their `Depends on` can include other grouped siblings under the same number; the DAG check applies the same way.
- **Plan-mode handoff timing.** Open ritual ends *before* plan mode. If the user starts coding without explicitly entering plan mode, Build does not intervene; the user is sovereign over the middle of the bracket.
- **Multiple specs in one session.** Build can run more than once in a session: open spec A, finish, close, open spec B, repeat. Each open/close pair is independent.
- **Aborted build.** If the user signals "stop" or "abandon" mid-spec, Build does nothing to the brief or impl. Status stays where it was; the spec remains in progress for the next attempt.
