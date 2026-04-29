# Triage

Pre-decision sorting. Read this file only when the user invokes Triage mode (says "triage," asks to process the inbox, or equivalent intent).

Triage is the mode that turns chaos into clarity. The inbox is the drop zone. Triage is the pass that processes it.

```
Anything (thought, screenshot, transcript, voice note, user quote)
  ↓ drop
Inbox (osis/inbox/ — flat, pre-triage)
  ↓ triage mode
Outcome per item: discard, distill, or move
  ↓
Docs (funnel) / iteration signals / trash
```

## The Inbox

Location: `osis/inbox/` at the product root. Flat directory. No subfolders (would bloat on daily use).

### What lives here

- **Agent-written drops** — when Osis is in a consult and a signal surfaces that doesn't fit the current thread, it drops to inbox for later. Agent-written items carry signal frontmatter and a dated slug filename.
- **User drops** — anything the user pastes, drags, or describes: voice memos, screenshots, raw thoughts, interview quotes, competitor links. No required shape. Keep as raw as the user gave it.
- **Mixed media** — screenshots (`.png`), text (`.md`), transcripts, whatever. They live as siblings in the flat directory. Filename is the grouping key, not folder structure.

### Filename conventions

Agent-written:
```
osis/inbox/{YYYY-MM-DD}--{slug}.md
```

User-written: whatever the user gives. Don't rename their files. If they paste raw text with no filename, save as `osis/inbox/{YYYY-MM-DD}--{user-slug}.md` with no frontmatter, just the content.

### Signal frontmatter (agent-written only)

```markdown
---
type: observation | feedback | research | transcript | metric
date: 2026-04-16
source: consult | voice memo | slack | manual
summary: One-line key insight.
---
[Raw content. Do not interpret here.]
```

This is the same shape as iteration signals. Inbox items ARE signals — they just haven't been routed to an iteration yet.

### osis.json manifest

The inbox is listed in `osis.json` as a top-level signals collection:

```json
{
  "files": {
    "inbox": [
      "osis/inbox/2026-04-16--landing-copy-feedback.md",
      "osis/inbox/2026-04-16--screenshot-onboarding.png"
    ],
    ...
  }
}
```

Keep it synced: every inbox write, triage move, or discard updates this array.

## Triage Mode

Triggered by user intent: "triage," "let's go through the inbox," "what's in the inbox," or equivalent.

### Flow

1. **Load the inbox.** Read `osis.json` inbox array. If empty, tell the user there's nothing to triage and stop.
2. **Spawn foreground subagent** with description `Triaging the inbox`. Before spawning, the main conversation runs `bash {SKILL_PATH}/scripts/session-id.sh` and passes the result into the subagent prompt as the parent session ID; the subagent uses it verbatim in any Sessions footer it writes and must not run `session-id.sh` itself. If the script exits non-zero, omit the value and the subagent skips footer writes for this pass. The subagent:
   - reads every inbox item
   - reads the relevant product docs via the `osis.json` files manifest for context
   - analyzes holistically, not FIFO
   - **looks for convergence** — multiple items pointing at the same underlying essence
   - proposes groupings and a routing outcome per group
   - returns a structured triage proposal
3. **Present the proposal** to the user. Groupings, proposed outcomes, and the reasoning per group. Do not write yet.
4. **Align.** User confirms, edits, or rejects. Approval is per group, not all-or-nothing.
5. **Execute approved outcomes.** Writes happen in the subagent to keep the chat clean. Update `osis.json` inbox array and any affected doc manifests. Log to the relevant `{version}/changelog.md`.
6. **Session footer** on every touched doc.

### Session Log

Triage is a strong-moment source on both ends. Append a bullet to the current thread in `osis/sessions.md` when Triage mode is entered (name it as Triage entry, note inbox size) and again on the completion summary (name the outcomes by count: discards, distills, moves). If topic or areas are still `pending`, infer and write them alongside the first append. If `bash {SKILL_PATH}/scripts/session-id.sh` returns non-zero or `sessions.md` is missing, skip the append silently.

### The Three Outcomes

Every inbox item (or group of converged items) resolves to exactly one of these:

**Discard.** Not useful, already covered, or not signal. Delete the file. Log to changelog with a one-line reason. The discard is the decision; history doesn't need to keep the noise.

**Distill.** The insight rolls up into an existing doc — manifesto, thesis, strategy, product.md, brand, design-system, brief. The decision gets written into the funnel layer that owns it. The raw inbox file is deleted after distillation; provenance lives in the changelog entry and the target doc's session footer.

**Move.** The item is an iteration signal. Relocate the file from `osis/inbox/{name}` to `osis/{version}/{iteration}/signals/{name}` verbatim. Frontmatter and content unchanged. Update both manifests (remove from inbox, add to iteration signals).

### Convergence

This is the whole reason triage is holistic instead of FIFO. Multiple signals can distill into a single essence.

Examples:
- Three inbox items about onboarding friction at different steps → one insight ("onboarding assumes prior context the user doesn't have") → one distillation into `core/product.md` onboarding section.
- A screenshot + a transcript quote + a voice memo all naming the same missing feature → one move into a new iteration signal, all three items referenced in the signal body, all three inbox files deleted.

The subagent's job is to find the pattern, not to process items individually. If five items are really one insight, the proposal groups them and proposes one outcome. The user sees the essence, not the chaos.

When grouping, name the essence in one sentence. That sentence is what the user reviews. The raw items are supporting evidence.

### What "distill" looks like in practice

Distillation is not summarization. It is the moment a raw signal becomes a product decision captured in the right typed doc.

- An interview quote about pricing confusion → a paragraph in `strategy.md` about positioning, not a bullet in a notes file.
- A screenshot of a confusing empty state → a behavioral rule update in `core/product.md`, not a TODO.
- Three competitor screenshots showing the same pattern → a decision in `thesis.md` about what we're doing differently, or a `non-goals` entry saying we're explicitly not copying it.

If the distillation produces a "we should think about this later" — that's not distilled, that's parked. Either the insight is sharp enough to change a doc, or it stays in the inbox until it is.

### Changelog entry format

```markdown
## 2026-04-16 — Triage

- [Discard] osis/inbox/2026-04-15--random-thought.md — unclear signal, asked user to resurface if relevant
- [Distill → manifesto.md] osis/inbox/2026-04-14--core-promise.md, osis/inbox/2026-04-15--user-quote.md — clarified product promise to emphasize speed of iteration
- [Move → v1/iteration-2/signals/] osis/inbox/2026-04-15--onboarding-friction.md — becomes iteration signal for in-flight onboarding work
```

Group entries by triage session, not by individual item. One triage pass = one dated heading.

## When NOT to Trigger Triage

- Inbox is empty.
- User is bringing a fresh signal in-thread — that's Consult, not Triage. Consult processes one signal in context; Triage processes the accumulated batch holistically.
- The user is mid-decision on a different doc. Triage is a dedicated pass, not a sidebar.

## Writing to the Inbox

Both Osis and the user can write to the inbox.

**Osis writes** when, during a consult, a signal surfaces that doesn't belong to the current thread. Rather than derail or force-route, Osis says "that's worth parking — dropping it to inbox" and writes a signal-shaped file. The current consult continues uninterrupted.

**User writes** when they drop anything manually: pasted content, screenshots, a single sentence. No format required. Osis does not reformat user drops on arrival — that's triage's job.

Either way, update the `osis.json` inbox array on write.

---

## Sessions

- 2026-04-29 — Triage subagent spawn now requires the parent to resolve the session ID first and pass it into the prompt, so footers from triage writes bind to the conversation that initiated the work. · `claude -r f8a091a2-bca2-4185-8bea-9cef943ce3dc`
- 2026-04-23 — Added Session Log section, triage as strong-moment source on mode entry and completion · `claude -r 14bd6251-f95c-4256-a184-3b259e64906b`
