# The Osis Protocol

## Why This Exists

Every product development system has the same failure mode: knowledge escapes the architecture. Decisions get made in PRs, chat logs, and conversations. Specs drift from reality. New team members — human or AI — read outdated specs and build the wrong thing.

This protocol prevents that. Layered specs, each owning decisions at a specific altitude. Specs flow down as constraints. Discoveries flow up as updates. Nothing important lives outside the spec system.

## The Hierarchy

```
┌─────────────────────────────────────────────────────────────┐
│                        CANON (durable)                      │
│                                                             │
│   ┌──────────────┐         ┌──────────────────────────┐     │
│   │ Vision Spec  │────────▶│ Product Spec + Roadmap   │     │
│   │ (why)        │         │ (what + phased plan)     │     │
│   └──────────────┘         └────────────┬─────────────┘     │
└─────────────────────────────────────────┼───────────────────┘
                                          │
                          specs flow DOWN  │  discoveries flow UP
                                          │
┌─────────────────────────────────────────┼───────────────────┐
│              PHASE (Initiative)         │                   │
│                                         ▼                   │
│              ┌─────────────────────────────┐                │
│              │     Phase Game Plan         │                │
│              └──────────────┬──────────────┘                │
└─────────────────────────────┼───────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
┌───────────────────────────┐ ┌───────────────────────────┐
│  SYSTEM A (Project)       │ │  SYSTEM B (Project)       │
│                           │ │                           │
│  System Product Spec      │ │  System Product Spec      │
│         ↓                 │ │         ↓                 │
│  Design Spec              │ │  Design Spec              │
│         ↓                 │ │         ↓                 │
│  Implementation Spec      │ │  Implementation Spec      │
└─────────────┬─────────────┘ └─────────────┬─────────────┘
              │                              │
              ▼                              ▼
┌─────────────────────────────────────────────────────────────┐
│              FEATURES (Issues)                              │
│                                                             │
│  Feature Plan → PR / Code → QA                              │
└─────────────────────────────────────────────────────────────┘
```

## Project Management Mapping

| Spec Layer | Entity | Scope |
|---|---|---|
| Phase Game Plan | Initiative | Scoped slice of the product roadmap |
| System Specs | Project | One system within the phase |
| Feature Plan → QA | Issue | One discrete feature |

## Propagation Rules

### Down (constraints)

```
Canon
  ↓ defines phases
Phase Game Plan
  ↓ scopes systems
System Product Spec
  ↓ defines UX / behavior
Design Spec
  ↓ links to what to build
Implementation Spec
  ↓ defines how to build
Feature Plans
  ↓ constrains code
```

### Up (discoveries)

```
Code discovery
  ↑ updates Implementation Spec (eng notes)
Impl discovery that changes UX
  ↑ updates System Product Spec
Behavior change that changes phase scope
  ↑ updates Phase Game Plan
Scope conflict with product direction
  ↑ escalates to Canon
```

Updates propagate recursively. A code discovery that affects UX flows up through every layer it touches.

## Drift Prevention

### The Contract

1. A PR is not done until the relevant spec reflects any architectural or behavioral discovery.
2. Implementation Specs maintain an `### Engineering Notes` section for tactical discoveries.
3. No important decision lives only in PRs, issue comments, or chat logs.
4. Canon specs are the ceiling — if a discovery contradicts canon, escalate.

### Changelog

Every version maintains a `changelog.md` at the version root. This logs all spec changes — human-initiated and scan-detected.

Format:

```markdown
# Changelog

## [Date]

### Drift Scan
- **[Drift]** `{file}` — description of mismatch
- **[Missing]** `{file}` — code exists with no spec coverage
- **[Stale]** `{file}` — spec references dead code

### Manual Updates
- `{file}` — what changed and why
```

## Phase Lifecycle

When a phase completes:
1. Archive phase specs into `archive/`
2. Scope the next Phase Game Plan from the Product Roadmap
3. Create fresh system specs for the new phase

When canon is updated (rare):
1. Cascade changes to all active phase and system specs
2. Validate in-flight work still aligns

## File Structure

```
osis/
  osis.json                                      ← machine state + config
  README.md                                      ← static, explains osis protocol
  twin.md                                        ← what the product IS (code compression)
  {product}-v{n}/
    vision.md                                    ← canon
    product-spec.md                              ← canon
    changelog.md                                 ← drift log
    phase-{N}-{slug}/
      game-plan.md
      {system}--product-spec.md
      {system}--design-spec.md
      {system}--implementation-spec.md
      signals/                                   ← raw inputs stored here
        {date}--{slug}.md
    archive/
      phase-{N}-{slug}/
        ...
```

**Conventions:**
- **`osis/`** at the project root — branded, discoverable, signals the protocol is in use
- **`osis.json`** — machine state and config. Read first on every interaction. Contains product name, active phase, timestamps for last twin update and drift scan. Fields start null and get populated during bootstrap and ongoing use.
- **README.md** — static file explaining the osis protocol. Same in every repo.
- **`twin.md`** — single file, product-level compression of the codebase. Updated from main only (with override).
- **Version folder** as the next level — new product version gets new folder with fresh canon docs
- **Canon** at the version root — always two files, always findable
- **Phase folders** named `phase-{N}-{slug}/`
- **System files** named `{system}--{spec-type}.md` — the `--` groups files by system alphabetically
- **`signals/`** in each phase folder — raw inputs (transcripts, notes, feedback, observations) that informed spec decisions. Each signal is a markdown file with frontmatter (`type`, `date`, `source`, `affected`, `summary`) followed by raw content. Signals archive with their phase.
- **Not every system needs every spec** — backend systems skip design specs. No empty templates.
- **Archive** completed phases into `archive/`

## Using with Project Management (Linear, etc.)

### Setting Up a Phase

1. Create the **Initiative**. Link the game plan in the description.
2. Create a **Project** for each system. Link all specs in the project description.
3. Create **Issues** within each project as features are scoped from the implementation spec.

### Where Conversations Happen

| Type | Where |
|------|-------|
| Task-level (blockers, progress) | Issue comments |
| Design feedback, annotations | Design tool comments |
| Architectural or behavioral decisions | Specs (linked from issues) |
| Status and priority | PM tool |

**Rule:** If a decision in a comment affects architecture or product behavior, pull it into the relevant spec. Comments are ephemeral. Specs are durable.
