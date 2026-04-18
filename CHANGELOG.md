# Osis Skill Changelog

Each release is documented here in a consistent heuristic so the migration agent can parse structural changes and apply them automatically.

## Heuristic

Every release entry follows this shape:

```markdown
## v{version}: {title} ({YYYY-MM-DD})

One paragraph describing what shipped, in warm user-facing language.

### Structural Changes
(Only present when the protocol shape changes. If absent, migration is a no-op for this release.)

- Rename: `{old_path}` → `{new_path}`
- Reshape: `{path}`
- New: `{path}`
- Folder: `{old_pattern}/` → `{new_pattern}/`
- Deprecate: `{path}`

### Skill Changes

- Non-structural: new modes, features, fixes, behavior changes.
```

**Operation contract** (what the migration agent does per line):

| Operation | Action | Notes |
|---|---|---|
| `Rename: A → B` | `mv A B`, byte-faithful content | Pure path move. If the template also changed, pair with a separate `Reshape: B`. |
| `Reshape: P` | Read current content at `P`, rewrite in the current template shape (from `references/templates.md`), preserve product decisions. | Osis rewrites osis's own output. Never deletes information. |
| `New: P` | `Write` an empty shell at `P` using the current template. Try to seed from existing product decisions elsewhere in `osis/` if obvious. | Empty only as fallback. |
| `Folder: A/ → B/` | `mv A/ B/`, all contents preserved. | Wildcards in the pattern (`phase-*/` → `iteration-*/`) indicate a naming convention change; the agent matches old names and picks reasonable new names. |
| `Deprecate: P` | `rm P`. Git preserves history. | Content is not migrated anywhere unless a concurrent `Reshape` or `New` indicates otherwise. |

Paths use backticks. `{placeholders}` are literal markers the agent resolves against the user's `osis.json` (`{version}` → `v0`, `{iteration}` → actual iteration slug, `{system}` → actual system name, `{phase}` → actual phase name).

`references/protocol.md` and `references/templates.md` carry the doc semantics. The changelog names what changed; those files explain what each doc is.

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
