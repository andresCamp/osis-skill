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

## Monorepo Support

Osis works in monorepos with multiple products. The root `osis/` becomes an org-level router that directs agents to the right product context.

### Org vs Product

| Scope | osis.json type | Twin | Versions | Protocol |
|-------|---------------|------|----------|----------|
| Product (default) | `"product"` or absent | Describes one product | `{product}-v{n}/` with full spec hierarchy | Full protocol |
| Org | `"org"` | Describes the org — products, shared systems, relationships | None — org docs are flat | No spec hierarchy |

The product layer is unchanged. A product `osis/` in a monorepo is identical to a standalone `osis/`. The org layer is purely additive.

### Org osis.json

```json
{
  "type": "org",
  "org": "cloudnine",
  "products": {
    "serdna": "apps/serdna/osis",
    "onc9": "apps/onc9/osis"
  }
}
```

The `products` map is the source of truth for routing. Keys are product names, values are relative paths to product `osis/` directories.

**Not every app needs osis.** The test is whether the thing requires product thinking — decisions, tradeoffs, iteration. A design system with consumers who depend on its APIs? That needs osis. A shared API where interface changes ripple across products? That needs osis. A stateless auth wrapper around a third-party SDK? Probably not. Osis is the thinking layer. If you need to think about it, it belongs in the products map. If it's static plumbing, it shows up in the org twin as context but doesn't need its own protocol.

### Org File Structure

```
osis/                          ← org root (flat, no versions)
  osis.json                    ← type: "org", products map
  twin.md                      ← org twin (products, shared systems, relationships)
  vision.md                    ← org mission (durable, not versioned)
  {product-a}/                 ← symlink → apps/product-a/osis
  {product-b}/                 ← symlink → apps/product-b/osis
```

Org docs are flat. No version folders, no phases, no changelog. The org doesn't ship — products ship. Org-level docs (mission, culture, etc.) are added as needed.

Symlinks at the org root point to each product's `osis/` directory. These serve two purposes:
- **Human convenience** — browse all product docs from one place
- **Agent fallback** — an agent at the repo root can traverse into any product

### Monorepo File Structure (Full)

```
monorepo/
├── osis/                              ← org-level osis
│   ├── osis.json                      ← type: "org", products map
│   ├── twin.md                        ← org twin
│   ├── vision.md                      ← org mission
│   ├── product-a/                     ← symlink → apps/product-a/osis
│   └── product-b/                     ← symlink → apps/product-b/osis
│
├── apps/product-a/osis/               ← product-level osis (real files)
│   ├── osis.json                      ← type: "product"
│   ├── twin.md                        ← product twin
│   └── product-a-v1/
│       ├── vision.md
│       ├── product-spec.md
│       ├── changelog.md
│       └── phase-1-ship/
│
├── apps/product-b/osis/               ← product-level osis (real files)
│   ├── osis.json                      ← type: "product"
│   ├── twin.md                        ← product twin
│   └── product-b-v1/
│       ├── vision.md
│       ├── product-spec.md
│       ├── changelog.md
│       └── ...
```

### Agent Routing

1. Agent finds the nearest `osis.json`
2. Read the `type` field:
   - **`"product"` (or absent)** — product scope. Behave as normal.
   - **`"org"`** — org scope. Read the products map. If the agent can determine which product it's working on from context, route there. Otherwise, ask: *"You're in the [org] org. Working on [product list] today?"*
3. Once routed to a product, the agent operates on the product `osis/` exactly as in a standalone repo.

The org `osis.json` is the agent's routing table. The symlinks are the human's routing table. Both get you to the same product.

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
