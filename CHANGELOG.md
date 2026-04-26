# Osis Skill Changelog

Each release is documented here in a consistent heuristic so the migration agent can parse structural changes and apply them automatically.

## Heuristic

Every release entry follows this shape:

```markdown
## v{version}: {title} ({YYYY-MM-DD})

One paragraph describing what shipped, in warm user-facing language.

### Shape
(Only present when the protocol shape changes. If absent, migration is a no-op for this release. Reads as a record of what changed in this release, not as instructions to the migration agent.)

- Added: `{path}`
- Renamed: `{old_path}` → `{new_path}`
- Reshaped: `{path}`
- Removed: `{path}`

### Skill Changes

- Non-structural: new modes, features, fixes, behavior changes.
```

**Operation contract** (what the migration agent does per line):

| Operation | Action | Notes |
|---|---|---|
| `Renamed: A → B` | `mv A B`, byte-faithful content | Pure path move. Works for files and folders (folder paths end with `/`). If the template also changed, pair with a separate `Reshaped: B`. Wildcard folder patterns (`phase-*/` → `iteration-*/`) enumerate matches and pick reasonable new names. |
| `Reshaped: P` | Read current content at `P`, rewrite in the current template shape from the matching file in `references/docs/funnel/` or `references/docs/engine/`, preserve product decisions. | Osis rewrites osis's own output. Never deletes information. |
| `Added: P` | `Write` an empty shell at `P` using the current template from the matching file in `references/docs/funnel/` or `references/docs/engine/`. Try to seed from existing product decisions elsewhere in `osis/` if obvious. | Empty only as fallback. |
| `Removed: P` | `rm P`. Git preserves history. | Content is not migrated anywhere unless a concurrent `Reshaped` or `Added` indicates otherwise. |

Paths use backticks. `{placeholders}` are literal markers the agent resolves against the user's `osis.json` (`{version}` → `v0`, `{iteration}` → actual iteration slug, `{system}` → actual system name, `{phase}` → actual phase name).

**Legacy format.** Releases up through v1.8.1 used `### Structural Changes` as the section heading and operation verbs `New`, `Rename`, `Reshape`, `Folder`, `Deprecate`. The migration parser recognizes both formats so older entries still upgrade correctly.

`references/protocol.md` and the per-doc files under `references/docs/` carry the doc semantics. The changelog names what changed; those files explain what each doc is.

---

## v1.8.2: Changelog reads as a record (2026-04-26)

The changelog's `### Structural Changes` section read as imperative instructions to the migration agent: `New:`, `Rename:`, `Deprecate:`. This release reframes it as a record of what changed in the release. Heading becomes `### Shape`; verbs go past-tense: `Added:`, `Renamed:`, `Reshaped:`, `Removed:`. Same machine-readable data, declarative voice. The migration parser supports both new and legacy formats, so older entries still upgrade cleanly. v1.8.0's section is restated in the new shape so the changelog reads consistently end-to-end.

### Skill Changes

- **`### Shape` replaces `### Structural Changes`** as the canonical section heading. The Heuristic at the top of CHANGELOG.md is rewritten to document the new format, with a Legacy callout naming the old heading and verbs.
- **Past-tense verbs replace imperative verbs.** `Added`, `Renamed`, `Reshaped`, `Removed`. The legacy `Folder:` op collapses into `Renamed:` (folder paths end with `/`, wildcard patterns still work). The operation contract table is restated in past tense.
- **Migration parser updated.** `references/migration.md` recognizes both `### Shape` (new) and `### Structural Changes` (legacy), and both verb sets. New names are canonical; each Operations subsection notes its legacy alias.
- **v1.8.0 entry restated.** Same byte-equivalent meaning per bullet, new verbs and heading. No semantic change; the rewrite is for internal consistency only.
- No protocol shape change in v1.8.2 itself.

---

## v1.8.1: Quieter session log (2026-04-26)

Session-log writes were leaking into chat one tool call at a time: a Session Preflight on the first substantive turn, plus a small Edit at every strong moment after that. In a dense conversation that's three or four visible writes a session, all of which look identical to the user (a tiny bullet appended to a file). This release replaces that with a buffered model. Strong moments are tracked silently in working context and flushed in one Edit at a natural lull (a major doc write landing, a topic pivot, conversational acks like "ok / nice / thanks") or on explicit capture cues ("log this," "save this," "checkpoint," "wrap this up"). Sessions without a lull and no cue produce no entry at all. Missing beats empty.

### Skill Changes

- **Session Preflight removed.** SKILL.md no longer pre-creates an entry on the first substantive turn. Conversation Initialization step 4 is gone.
- **Session Log Buffering added.** New SKILL.md section describes the buffer-and-flush model: track moments silently, flush on lull or cue, one flush is one Edit, never narrate. Lull and cue lists are explicit so behavior is consistent across agent calls.
- **Per-mode strong-moment language updated.** Triage, Consult, Update, Analyze, and Twin sections now describe their moments as candidate bullets that feed the buffer, not as immediate appends.
- **Doc Conventions Session Log cross-reference** updated to point at the new buffering section.
- No protocol shape change. No template changes, no doc renames, no scaffold changes. Existing repos see no migration.

---

## v1.8.0: Research-backed reasoning + modules (2026-04-23)

Osis becomes a research-backed reasoning architecture. The monolithic `references/templates.md` is replaced by per-doc files under `references/docs/funnel/` and `references/docs/engine/`, each carrying reasoning principles distilled from deep research into canonical product frameworks (JTBD, PR/FAQ, Loop, North Star, and more). Modules wrap activities like customer discovery as typed surfaces in `osis.json` alongside products, with their own entry behavior and phase playbooks. The funnel becomes a branching tree where constraints live at the altitude their scope is shared. A new `osis/sessions.md` captures every osis-activated conversation as a logged product-thinking thread. The progressive-disclosure playbooks (onboarding, triage, maintenance) consolidate into `references/modules/`. Protocol shape bumps to v2.0.0.

### Shape

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

### Skill Changes

- **Sessions log as a fourth cut.** Protocol now names four cuts of abstraction: Twin (what the product IS), Funnel docs (what it's BECOMING), crystallized Engine docs (why it moved), and in-motion Engine docs (the thinking itself). `sessions.md` is the in-motion doc: append-only, most-recent-first, one entry per osis-activated conversation. Sibling-session entries are independent threads; the log respects the parallel-session reality of Claude Code use.
- **Session Preflight.** Runs exactly once per session, on the first substantive user turn after the greeting. Resolves the current session ID, scans `sessions.md` for a matching heading, and prepends a fresh stub with `Topic: pending` and `Areas: pending` if none exists. Preflight never modifies entries from other sessions. It is silent, never narrates, and is suppressed entirely during onboarding (the onboarding subagent owns `sessions.md` scaffolding).
- **Strong-moment hooks per mode.** Consult appends a bullet after each doc write, each aligned inline decision, and explicit capture cues ("log this", "note this"). Triage, Twin, Analyze, and Update append at both mode entry and completion. When topic or areas are still `pending`, the first strong moment infers both from context and writes them in place. All writes are silent.
- **Per-doc reasoning layer.** `references/templates.md` is replaced by a folder of per-doc files under `references/docs/funnel/` (charter, manifesto, brand, design-system, thesis, strategy, product, brief) and `references/docs/engine/` (impl, signals, changelog, twin). Each file carries per-section reasoning principles stated as truths, not criteria, distilled from canonical product thinking. Drafting docs carry principles; `references/docs/engine/twin.md` is the deliberate exception: template-only, because Twin mode regenerates from code instead of drafting section by section.- **Drafting discipline baked into principles.** The protocol's Frameworks section is rewritten around the per-doc files. Observation and inference must stay distinct; a concrete scene can open a claim but doesn't prove the category; never invent motives, incentives, failed fixes, or certainty; prefer mechanism over villain; "why now" needs a concrete unlock. The agent pushes back once when a draft violates a principle, then defers to the builder. The old "Core Framework Set" table (JTBD, PR/FAQ, North Star, Loop, etc.) is retired as a user-facing surface and lives inside the per-doc principles instead.- **References restructure.** The three progressive-disclosure playbooks move to `references/modules/onboarding.md`, `references/modules/triage.md`, and `references/modules/maintenance.md`. SKILL.md, README.md, and the SKILL.md Conversation Initialization pointer all now read from the new paths.
- **Funnel as a branching tree.** The protocol adds a "Funnel as a Branching Tree" section with a worked tree diagram. The altitude ladder remains the conceptual spine; the instantiated funnel branches at the altitude where shared scope ends. Principle 5 (Protocol spine, adaptive shape) now explicitly names adaptive altitude: a constraint lives at the altitude where its scope is still shared, and branches downward where sharing ends.
- **Monorepo modules routing.** Mode Detection for `type: "org"` now reads both the `products` and `modules` maps. Products route to a product's `osis/` tree; modules route to `osis/{module-slug}/` and the skill reads the module's `README.md` for entry behavior and phase playbooks before engaging. Product context loading gains the same split.- **`modules` map in `osis.json`.** Both org and product `osis.json` scaffolds now include `"modules": {}` at the top level, and the product template also registers `sessions` in the `files` manifest. `onboard.sh` writes both on first scaffold.- **Always-scaffolded set expands.** `onboard.sh` now writes `osis/sessions.md` with an intro line and a trailing divider alongside `osis.json`, `README.md`, `twin.md`, `inbox/`, `{version}/changelog.md`, and `{version}/core/`. The scaffold summary printed at end of run lists `sessions.md` in the tree.
- **Sessions footer carve-out.** The per-doc Sessions footer convention now excludes `sessions.md` (in addition to `osis.json` and `README.md`). `sessions.md` embeds session IDs in every entry heading, so a separate footer would double the record.
- **Migration agent reads per-doc files.** `references/migration.md` is updated: `Reshape` and `New` operations now pull the current template from the matching file in `references/docs/funnel/` or `references/docs/engine/`, not from `references/templates.md`. The operation contract in the changelog Heuristic header is updated to match.
- **Onboarding playbook carries sessions + twin geometry.** `references/modules/onboarding.md` adds `sessions.md` to the always-created set, documents preflight suppression during onboarding, and points at `references/docs/engine/twin.md` for monorepo repo-map diagram geometry.- **Protocol version bumps to v2.0.0.** `references/protocol.md` header is now `# Osis Protocol v2.0.0`. Shape-bearing changes across the release (new `sessions.md` doc type, per-doc reasoning layer, branching-tree shape, `modules` routing) warrant a major protocol bump.

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
