# Osis Skill Changelog

Each release is documented here in a consistent heuristic so the migration agent can parse structural changes and apply them automatically.

## Heuristic

Every release entry follows this shape:

```markdown
## v{version}: {title} ({YYYY-MM-DD})

One paragraph (or more) describing what shipped, in warm user-facing
language. The narrative carries synthesis and behavior detail.

### Log
(Only present when files are added, renamed, removed, or reshaped in
the skill source or in user repos. Past-tense, comprehensive: every
file-level change in the release.)

- Added: `{path}`
- Renamed: `{old_path}` → `{new_path}`
- Reshaped: `{path}`
- Removed: `{path}`

### Migration
(Only present when user repos are affected. Imperative, tiny: the
subset of Log that the migration agent applies to user `osis/`
folders.)

- Add: `{path}`
- Rename: `{old_path}` → `{new_path}`
- Reshape: `{path}`
- Remove: `{path}`
```

Two voices on purpose. Log records what happened in past-tense; Migration tells the existing user what to do in imperative.

**Migration agent contract** (what the agent does per `### Migration` line):

| Operation | Action | Notes |
|---|---|---|
| `Rename: A → B` | `mv A B`, byte-faithful content | Pure path move. Works for files and folders (folder paths end with `/`). If the template also changed, pair with a separate `Reshape: B`. Wildcard folder patterns (`phase-*/` → `iteration-*/`) enumerate matches and pick reasonable new names. |
| `Reshape: P` | Read current content at `P`, rewrite in the current template shape from the matching file in `references/docs/funnel/` or `references/docs/engine/`, preserve product decisions. | Osis rewrites osis's own output. Never deletes information. |
| `Add: P` | Write an empty shell at `P` using the current template from the matching file in `references/docs/funnel/` or `references/docs/engine/`. Try to seed from existing product decisions elsewhere in `osis/` if obvious. | Empty only as fallback. |
| `Remove: P` | `rm P`. Git preserves history. | Content is not migrated anywhere unless a concurrent `Reshape` or `Add` indicates otherwise. |

Paths use backticks. `{placeholders}` are literal markers the agent resolves against the user's `osis.json` (`{version}` → `v0`, `{iteration}` → actual iteration slug, `{system}` → actual system name, `{phase}` → actual phase name).

**Legacy formats.** Releases up through v1.8.1 used `### Structural Changes` as the section heading with imperative verbs `New`, `Rename`, `Reshape`, `Folder`, `Deprecate`. v1.8.2 briefly used `### Shape` with past-tense verbs `Added`, `Renamed`, `Reshaped`, `Removed`. The migration parser recognizes legacy formats so older entries still upgrade correctly.

`references/protocol.md` and the per-doc files under `references/docs/` carry the doc semantics. The changelog names what changed; those files explain what each doc is.

---

## v1.8.3: Log and Migration (2026-04-26)

The changelog format settles on two voices. `### Log` records what happened in past-tense (every file-level change in the release, comprehensive). `### Migration` tells existing users what to do in imperative (the tiny subset that affects their `osis/` folder). v1.8.2's `### Shape` section is dropped. The previous `### Skill Changes` section is dropped because the top paragraph now carries synthesis and Log carries the file-level detail. v1.8.0 is restated under the new format. The migration parser recognizes `### Migration` as canonical, plus legacy `### Structural Changes` so older releases still upgrade correctly.

---

## v1.8.2: Changelog reads as a record (2026-04-26)

The changelog's `### Structural Changes` section read as imperative instructions to the migration agent: `New:`, `Rename:`, `Deprecate:`. This release reframes it as a record of what changed in the release. Heading becomes `### Shape`; verbs go past-tense: `Added:`, `Renamed:`, `Reshaped:`, `Removed:`. Same machine-readable data, declarative voice. The migration parser supports both new and legacy formats, so older entries still upgrade cleanly. v1.8.0's section is restated in the new shape so the changelog reads consistently end-to-end. (Superseded by v1.8.3.)

---

## v1.8.1: Quieter session log (2026-04-26)

Session-log writes were leaking into chat one tool call at a time: a Session Preflight on the first substantive turn, plus a small Edit at every strong moment after that. In a dense conversation that's three or four visible writes a session, all of which look identical to the user (a tiny bullet appended to a file). This release replaces that with a buffered model. Strong moments are tracked silently in working context and flushed in one Edit at a natural lull (a major doc write landing, a topic pivot, conversational acks like "ok / nice / thanks") or on explicit capture cues ("log this," "save this," "checkpoint," "wrap this up"). Sessions without a lull and no cue produce no entry at all. Missing beats empty. SKILL.md drops the Session Preflight section, adds a new Session Log Buffering section, and updates per-mode strong-moment language to describe candidate bullets that feed the buffer rather than immediate appends. No protocol shape change.

---

## v1.8.0: Research-backed reasoning + modules (2026-04-23)

Osis becomes a research-backed reasoning architecture. The monolithic `references/templates.md` is replaced by per-doc files under `references/docs/funnel/` and `references/docs/engine/`, each carrying reasoning principles distilled from deep research into canonical product frameworks (JTBD, PR/FAQ, Loop, North Star, and more). Modules wrap activities like customer discovery as typed surfaces in `osis.json` alongside products, with their own entry behavior and phase playbooks. The funnel becomes a branching tree where constraints live at the altitude their scope is shared. A new `osis/sessions.md` captures every osis-activated conversation as a logged product-thinking thread. The progressive-disclosure playbooks (onboarding, triage, maintenance) consolidate into `references/modules/`. Protocol shape bumps to v2.0.0.

### Log

- Added: `osis/sessions.md`
- Reshaped: `references/protocol.md`
- Renamed: `references/onboarding.md` → `references/modules/onboarding.md`
- Renamed: `references/triage.md` → `references/modules/triage.md`
- Renamed: `references/maintenance.md` → `references/modules/maintenance.md`
- Added: `references/docs/funnel/charter.md`
- Added: `references/docs/funnel/manifesto.md`
- Added: `references/docs/funnel/brand.md`
- Added: `references/docs/funnel/design-system.md`
- Added: `references/docs/funnel/thesis.md`
- Added: `references/docs/funnel/strategy.md`
- Added: `references/docs/funnel/product.md`
- Added: `references/docs/funnel/brief.md`
- Added: `references/docs/engine/impl.md`
- Added: `references/docs/engine/signals.md`
- Added: `references/docs/engine/changelog.md`
- Added: `references/docs/engine/twin.md`
- Removed: `references/templates.md`

### Migration

- Add: `osis/sessions.md`

---

## v1.5.2: Repo name in the activation header (2026-04-18)

The activation header now renders during fresh onboarding (not just after scaffolding), and its product slot resolves to the repo directory basename when no product name is set yet. The generic "Osis" placeholder no longer appears in projects that have a clear repo name to use.

### Skill Changes

- `render-header.sh` always falls back to the repo directory basename for the product slot when `osis.json`'s `product` or `org` field is null or missing, including the fresh-onboarding case where `osis.json` does not yet exist.
- Bootstrap greeting now substitutes the same name: *"Welcome to Osis 👋 Let's set up {name}."* Before the fix, the greeting said "your product" generically.
- `osis.json` info-column line drops the legacy `${PRODUCT:-Osis}` fallback; `PRODUCT` is now guaranteed to be set whenever the header renders.
- `SKILL.md` Mode Detection for the no-`osis.json` branch explicitly outputs the pre-loaded Activation header block before following the onboarding playbook. The old minimal "👋 Welcome to Osis" welcome line is replaced by the full header.
- `onboarding.md` Flow section updated to reflect the new welcome shape (Activation header rendered verbatim, followed by the scan announcement).

(No structural changes. Protocol shape stays at 1.0.)

---

## v1.5.1: Anon-key stability (2026-04-18)

Fixes two stability edges in the pseudonymous identity layer: multi-line JSON formatting of `~/.claude/osis-telemetry.json` or `osis/osis.json` no longer regenerates the anonId, and both files are now written atomically via tempfile + rename so a partial write cannot corrupt the key.

### Skill Changes

- `track.sh`'s `read_json_string` flattens files with `tr` before the sed match. A reformatted JSON file (prettier, editor format-on-save, manual edit) keeps the same anonId instead of being treated as missing.
- `track.sh`'s user-file creation writes to a same-directory tempfile and renames into place. A killed process mid-write no longer leaves a corrupt file that forces the next activation to mint a new UUID.
- `onboard.sh`'s `osis/osis.json` scaffold (both org and product modes) now uses the same tempfile + rename pattern, so a crashed scaffold cannot leave a half-written osis.json with an unreadable anonId.

(No structural changes. Protocol shape stays at 1.0.)

---

## v1.5.0: Onboarding as a conversation (2026-04-18)

Osis now onboards by having a real conversation instead of scaffolding empty docs. It loads your repo as context, asks one sharp question tuned to your product, and captures your current product thinking at the right altitude as you talk. The builder is the only source of truth; existing artifacts become signal, never canon.

### Skill Changes

- **Onboarding is the first clarity session.** Not a one-shot scaffolder. The CTA starts the session, it does not end it. The session runs until current thinking is captured at the right altitudes, then settles into normal Consult mode.
- **Bootstrap vs import.** Replaces the old template-vs-product terminology. Bootstrap (blank repo, starter template, no meaningful product signal) opens with `What are you building?`. Import (real product surfaces and artifacts) opens with a product-aware invitation (see below).
- **Import opener carries the product name.** The import question is `Walk me through {product_name}. I've got the repo loaded, skip the basics.` Name substitutes from the subagent's inferred value in `osis.json`, falling back to the repo directory basename.
- **Monorepo silent scaffold.** Removed the pre-scaffold confirmation gate. Monorepos now silently scaffold the root org `osis/` plus the primary product's `osis/` at its product-local path based on scan evidence. Topology corrections happen through conversation mid-session. No diagram-in-opener, no reflection quiz, no "does that match how you see X?" prompt.
- **Minimum scaffold.** `onboard.sh` no longer creates stubs for `manifesto.md`, `brand.md`, `design-system.md`, `thesis.md`, `strategy.md`, or `core/product.md`. Always-created: `osis.json`, `README.md`, `twin.md`, `inbox/`, `{version}/changelog.md`, `{version}/core/`. Earned docs materialize in-session when the builder articulates them.
- **Header product slot uses your project name.** `render-header.sh` resolves via `osis.json`'s `product` or `org` field, then the repo directory basename. Projects without an inferred product name show the repo name instead of the stale `Osis` placeholder.
- **Builder as source of truth.** Principle 7 of the protocol is explicit: only the builder declares what the product is. Code, README, landing copy, decks, and other artifacts sharpen Osis's questions but never become canon on their own.
- **Follow-up pattern.** Altitude-check, dot-connect, gap-fill, tension-force, and altitude-capture moves in the session contract, plus an anti-rabbit-hole rule: placement beats polish. First session aims for current thinking at every relevant altitude, not perfect prose at one.
- **What-to-materialize policy.** Explicit split of always-created, earned-in-session, and not-forced docs in the first session contract.
- **CLAUDE.md wiring.** Product Knowledge pointers mark earned docs with "(if present)" instead of assuming they exist. New pointer for `core/{iteration}/brief.md` active bet.
- **osis.json `version` → `protocolShape`.** Field renamed to separate protocol-shape versioning from skill versioning. Existing projects keep working; migration agent leaves the old field in place.

(No structural changes. Protocol shape stays at 1.0.)

---

## v1.1.0: Pseudonymous traction metrics (2026-04-13)

Fire-and-forget telemetry for skill activation, onboarding, and update events. Two-tier pseudonymous identity: user UUID in `~/.claude/osis-telemetry.json`, repo UUID as `anonId` in each project's `osis/osis.json`. Silent opt-out via `OSIS_TELEMETRY=0`.

### Skill Changes

- New `scripts/track.sh` fires background telemetry on activation, onboarding, and update.
- `onboard.sh` now mints `anonId` and `createdAt` in `osis.json` on first scaffold.
- Landing route at `apps/landing/src/pages/api/t.ts` validates and forwards events to PostHog.
- `Bash(bash ${SKILL_DIR}/scripts/track.sh *)` added to allow lists.

(No structural changes. Existing folders migrate as no-op.)

---

## v1.0.0: The clarity funnel (2026-04-11)

Osis becomes a typed reasoning system. Every document is now a projection of the same product at a different level of abstraction. The clarity funnel replaces the phase-centric model: Org → Product → Version → System → Iteration → Phase, each layer constraining the one below.

### Structural Changes

- Rename: `vision.md` → `manifesto.md`
- Rename: `{version}/vision.md` → `{version}/thesis.md`
- Rename: `{version}/product-spec.md` → `{version}/core/product.md`
- Rename: `{version}/{system}--product-spec.md` → `{version}/{system}/product.md`
- Rename: `{version}/{system}--implementation-spec.md` → `{version}/{iteration}/{phase}.impl.md`
- Folder: `{version}/phase-*/` → `{version}/iteration-*/`
- Rename: `{version}/{iteration}/implementation-spec.md` → `{version}/{iteration}/{phase}.impl.md`
- Reshape: `manifesto.md`
- Reshape: `{version}/thesis.md`
- Reshape: `{version}/core/product.md`
- New: `charter.md`
- New: `brand.md`
- New: `design-system.md`
- New: `{version}/strategy.md`
- New: `{version}/{iteration}/brief.md`
- Deprecate: `{version}/{system}--design-spec.md`
- Deprecate: `{version}/iteration-*/game-plan.md`
- Deprecate: `archive/`

### Skill Changes

- 15 core principles: typed reasoning, upward propagation, local clarity, dense seeds, and more.
- 7-framework system: JTBD, PR/FAQ, North Star, Loop, Non-goals, Experiment/Hypothesis, Opportunity Solution Tree.
- Modular templates: minimal canonical shape plus optional framework modules.
- `osis.json` schema refresh: new `activeVersion` field, simplified `files` manifest. Removed `activePhase`, `lastDriftScan`.

---

## v0.5.3: Self-healing permissions + header polish (2026-04-10)

Skill now works in any project on first activation without a pre-bootstrap step. Header typography refreshed.

### Skill Changes

- New `scripts/ensure-global-perms.sh` writes global permissions to `~/.claude/settings.json` instead of per-project.
- SKILL.md preprocessing fallbacks so the skill degrades gracefully when permissions aren't configured.
- Header rows rewritten: `▲ **Osis** v{version} · osis.dev`, `*Build products people love, faster*`, `**{product}** · {phase}`.
- `color` field added to `osis.json` for future use.

(No structural changes.)

---

## v0.5.2: Skill-scoped permissions (2026-04-10)

Five permission patterns in `SKILL.md` frontmatter auto-approve tool calls while osis is active.

### Skill Changes

- `allowed-tools` added: `Bash(bash */.claude/skills/osis/*)`, `Bash(mkdir *)`, `Bash(curl *)`, `Edit(/osis/**)`, `Write(/osis/**)`.

(No structural changes.)

---

## v0.5.1: Fresh-bootstrap welcome (2026-04-09)

Fresh bootstraps now show a welcome greeting instead of the "keep building" variant.

### Skill Changes

- `render-header.sh` branches on whether `$PRODUCT` is set.
- Fresh projects get `"Welcome to Osis 👋 Let's set up your product."`.

(No structural changes.)

---

## v0.5.0: New look + yes/no updates (2026-04-09)

Silent skill load, time-aware greeting, activation header with `▲` glyph, one-tap update flow.

### Skill Changes

- SKILL.md bash injection eliminates tool calls on activation.
- `additionalDirectories` unlocks silent lazy reference reads.
- Activation header via `assets/logo.txt` + `scripts/render-header.sh`.
- Time-of-day greeting with 14 rotating opening-phrase variants.
- Warmer release banner with `▲` glyph and rich title + description.
- One-tap update flow via new `scripts/update-skill.sh`.

(No structural changes.)

---

## v0.3.1: Silent skill load (2026-04-09)

Permission prompts on conversation load eliminated.

### Skill Changes

- New Conversation Initialization section in SKILL.md pinning the load sequence.
- Deterministic curl for auto-update with matching allow rule.
- Local version moved into SKILL.md so `version.json` no longer needs reading at load.

(No structural changes.)

---

## v0.3.0: Session footers (2026-04-09)

Every osis doc appends per-session entries with date, summary, and a resume command.

### Skill Changes

- Doc Conventions section added to SKILL.md.
- New `scripts/session-id.sh` helper.
- Behavioral rule: update session footer on every doc write.

(No structural changes.)

---

## Pre-v0.3.0

Earlier versions predate the structured changelog. See `osis/v0/changelog.md` for the full product-decision history.
