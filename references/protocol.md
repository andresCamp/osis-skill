# Osis Protocol v2.0.0

> Working draft. The shape, principles, and decisions for the next protocol.

---

## What Osis Is

Osis is not a documentation tool. It is a **product clarity system** and a **typed reasoning system for product development**, a system for maintaining clean, evolving product context across abstraction layers.

The docs are not "docs" in the traditional sense. They are definitions of a slice of the product at a specific level of abstraction. Each document has a clear identity, meaning, and role in the system, like types in programming. A `thesis.md` is always a hypothesis. A `brief.md` is always an experiment. A `product.md` is always a definition. Agents can rely on this.

Osis tracks product state at four cuts of abstraction, each with its own doc shape:

1. **Twin**: what the product IS. Code reality compressed into an operational map.
2. **Funnel docs**: what the product is BECOMING. The clarity funnel from manifesto to phase.
3. **Engine docs (crystallized)**: why the product moved. Changelog entries, triaged inbox, iteration signals. Thought that has settled into record.
4. **Engine docs (in motion)**: the thinking itself. The session log captures every osis-activated conversation as a product-thinking thread, whether or not it lands in the other three cuts.

Docs crystallize thought. Sessions capture thought in motion. The unit of the session log is the **thread**, not the session: each activation opens a product-thinking thread that either converges and closes, or stays open, bookmarked for a future session.

Each document is a projection of the same system at a different level of abstraction.

The long-term goal is autonomous product decision-making. The real purpose of the system is to curate clean context for human-agent collaboration, not to create verbose paperwork.

The `osis/` folder IS the digital twin of the company and product. The `twin.md` file is one distillation of the codebase. The whole protocol is the twin.

Osis is also the version control layer for product thinking. Product beliefs, constraints, and bets should be captured in the right doc at the right altitude, even when they are still rough. The goal is not polished prose on day one. The goal is truthful constraints that agents can execute against and future clarity sessions can refine.

**Code is cheap. Product clarity is everything.** Agents can generate millions of lines of code in a day. The bottleneck is knowing what to build and why. Osis is the funnel that turns ethereal product thinking into executable clarity.

---

## Core Principles

1. **Typed reasoning artifacts.** Each doc answers one question only. Fixed purpose, expected semantics, predictable shape. Agents can rely on this.

2. **Product clarity is the job.** Everything in Osis exists to improve product clarity. If a doc, section, or conversation path does not improve clarity, it is noise.

3. **The clarity funnel.** Every layer is a tighter ring. Ethereal → concrete. Shared charter → product → version → system → iteration → phase → plan mode → code. Each layer constrains the one below it.

4. **Capture now, refine later.** Osis should capture current thinking as it exists today, even if rough, and place it at the right altitude from day one. Refinement comes in later clarity sessions.

5. **Protocol spine, adaptive shape.** The set of doc types is fixed; their semantic spine holds whenever they exist. Their altitude is adaptive: a constraint lives at the altitude where its scope is still shared, and branches downward where sharing ends. A manifesto shared across every surface of a product lives at product root; a design-system that differs between surfaces lives at each surface. Not every doc needs to exist on day one, but when a doc exists it keeps its semantic spine and sits at the altitude its sharing demands.

6. **Constraints are leverage.** The docs are the constraint force agents read when doing product thinking or writing code. If ambiguity is degrading output quality, Osis should force the missing constraint into existence through conversation.

7. **The builder is the source of truth.** Only the builder declares what the product is, why it matters, and what constraints govern it. Existing code, README files, landing copy, old docs, decks, and other artifacts are evidence of prior thinking. They sharpen Osis's questions but never become canon on their own. Osis never tells the builder what their product is. It asks, listens, and places aligned thinking at the right altitude.

8. **Shared charter is optional.** The top layer exists only when multiple products truly share one parent set of beliefs and constraints. Repo topology does not create a charter by itself.

9. **Implementation is the handoff boundary.** Osis owns product thinking through tech decisions. Plan mode owns syntax understanding and execution. Clean separation.

10. **Docs are collaboration vessels.** The interaction surface is: talk to agent, agent updates the right docs, human reads them, then the next session starts from a stronger clarity base.

11. **Archive over mutate.** Previous iterations and versions are the archive. The folder structure preserves the paper trail.

12. **Upward propagation.** Discoveries at lower layers that invalidate higher-layer assumptions must be pushed up immediately (phase → iteration → version → product). Prevents silent drift and closes the loop structurally.

13. **Local clarity.** Each doc should be understandable in isolation, but more powerful in context.

---

## The Clarity Funnel

```
[Shared Charter]: "We believe X about the world" [philosophical, optional]
  Product: "This problem matters"                [philosophical]
    Version: "Here's how we're manifesting it"   [strategic]
      System: "Here's a distinct surface"        [strategic/tactical]
        Iteration: "Here's the bet right now"    [tactical]
          Phase: "Here's how we're building it"  [executable]
            → plan mode → code
```

| Level | Nature | What it captures |
|---|---|---|
| **Shared Charter** | Philosophical | Who we are, what we believe, how we work across multiple products |
| **Product** | Philosophical | Why this problem matters, our enduring declaration |
| **Version** | Strategic | What we're building, for whom, how it works, how we win |
| **System** | Strategic/Tactical | A distinct, encapsulated product surface with its own inputs, outputs, and behavior |
| **Iteration** | Tactical | A falsifiable product bet informed by signal |
| **Phase** | Executable | Tech decisions in logical, testable chunks → plan mode |

---

## Funnel as a Branching Tree

The altitude ladder is the conceptual spine. The instantiated funnel in any repo is a tree. Each node carries the levels whose scope is shared across all branches below it; branching happens at the altitude where shared scope ends.

```
                              [product]
                  ──────────────────────────────
                  manifesto.md
                  charter.md
                  (brand, design-system here if shared across surfaces)
                                  │
              ┌───────────────────┼───────────────────┐
              │                   │                   │
            {surface}           {surface}            {surface}
           ──────────          ──────────           ──────────
            {version}/          {version}/           {version}/
             thesis.md           thesis.md            thesis.md
             strategy.md         strategy.md          strategy.md
             changelog.md        changelog.md         changelog.md
             product.md          product.md           product.md
             iteration-{n}--{slug}/   iteration-{n}--{slug}/    iteration-{n}--{slug}/
               brief.md            brief.md             brief.md
               signals/            signals/             signals/
               {phase-name}.impl.md {phase-name}.impl.md {phase-name}.impl.md
```

For a single-surface product there is no branch; the tree collapses to one line from manifesto down to phase.

For a monorepo of unrelated products, branching happens at the charter altitude. Each product is a subtree carrying its own manifesto and its own funnel below it.

The right shape is not chosen in advance. It is discovered by asking where each constraint actually stops being shared. The answer determines the altitude.

---

## Observed vs Committed Shape

On first contact, Osis can reliably observe only some things:

- repo and system topology
- current product behavior in code
- existing docs, copy, and artifacts
- recurring language, tensions, and visible constraints

This is the **observed shape**.

The **committed shape** is what the builder actually stands behind after conversation: the current manifesto framing, the current thesis, the current design constraints, the current shared charter, and so on.

The first session moves observed shape into committed shape. Existing artifacts are imported as signal, never promoted directly into truth. The builder is the only source of committed truth. The goal is to leave the session with the builder's current product thinking captured in the protocol at the right altitude, even if the docs are still rough.

Onboarding is the first clarity session. It does not end at the CTA; the CTA starts it. The session continues until current thinking is captured at the right altitudes, then settles naturally into normal Consult mode.

## Funnel Navigation

The funnel defines the default motion of product work: downward, from ambiguity toward execution.

But the funnel is **directional guidance, not a rigid workflow**.

- A passive user will usually move down the funnel over time.
- A user can enter at any layer, jump layers, revisit earlier docs, or force cross-layer updates.
- The unit of work is **one aligned decision**, not one doc.
- After alignment, identify every implicated typed doc and update them together.
- Preserve each doc's semantic boundary. Do not collapse multiple doc types into one artifact.
- Leave untouched docs alone. Do not manufacture work for untouched layers.
- Propagate consequences up or down the funnel as needed.

This keeps Osis opinionated in structure without turning it into a serial ritual.

In practice:

- A product repo usually starts sparse.
- The first session captures the builder's current thinking into the right docs.
- Future sessions refine and expand the shape as new constraints become real.
- If a constraint is already clearly present in the product, Osis should codify it instead of waiting for perfect prose.

---

## Doc Types

Each doc is a typed node in a reasoning graph. Edges are the structural relationships (version → iteration → phase). This enables propagation, consistency checks, and eventually autonomous decisions.

### Funnel Docs

| Doc | Type Signature | Level | Purpose |
|---|---|---|---|
| `charter.md` | Operating constraints | Shared Charter / Org | Mission, values, non-negotiables, decision principles |
| `manifesto.md` | Declaration | Product | Why the problem matters, what's broken, what we refuse |
| `brand.md` | Expression | Product | Voice, tone, personality, positioning, language |
| `design-system.md` | Interface rules | Product | Visual language, interaction patterns, shared primitives |
| `thesis.md` | Hypothesis | Version | The strategic bet this version makes |
| `strategy.md` | Allocation | Version | Where we focus and how we win |
| `core/product.md` | Definition | System (top-level) | What the whole product is — composition, macro flows |
| `{system}/product.md` | Definition | System | What this subsystem is — internal flow, inputs/outputs |
| `brief.md` | Experiment | Iteration | Signal, insight, the tactical bet |
| `{phase}.impl.md` | Execution plan | Phase | Tech decisions → handoff to plan mode |

### Engine Docs

| Doc | Level | Purpose |
|---|---|---|
| `twin.md` | Product | Agent-readable operational map. Descriptive, not prescriptive, reflects the system, does not define product decisions |
| `sessions.md` | Root | Session log. One entry per osis-activated conversation, tracked as a product-thinking thread (open or closed). Captures thinking in motion, not just what crystallized into docs |
| `changelog.md` | Version | Chronological record of decisions and spec changes |
| `inbox/{signal}.md` | Root | Pre-triage signal. Imported artifacts, pasted notes, and unresolved observations land here before routing |
| `{signal}.md` | Iteration (`signals/`) | Raw intel that informed the brief |
| `osis.json` | Root | Machine state, routing, file graph |
| `README.md` | Root | Static protocol explainer |

### Sessions Log

`sessions.md` is a root-level engine doc that sits alongside `twin.md`, `inbox/`, and `osis.json`. It is append-only, most-recent-first, and owns a different altitude from the per-doc Sessions footer: the footer records per-doc provenance (which session touched which doc), while `sessions.md` records the thread itself (what the conversation was about, whether it closed, which areas it touched).

Entry shape:

- Heading: `## {YYYY-MM-DD} · claude -r {session-id}`
- `**Topic:**` one-line subject, or `pending` until it can be inferred
- `**Areas:**` comma-separated tags (docs touched, product areas discussed), or `pending`
- Append-only bullets for strong moments within the thread
- Divider `---` between entries
- Most recent entry at the top

Preflight behavior: on the first substantive user turn after the greeting (never during silent activation), the skill resolves the current session ID, checks `sessions.md` for a matching entry, and prepends a stub with `topic/areas: pending` if none exists. The skill never modifies other entries; sibling-session entries are independent threads.

Strong-moment triggers append bullets to the current thread's entry: after a doc write or aligned decision in Consult, on mode entry and completion summary in Triage, on mode entry and scan completion in Twin, Analyze, and Update, and when the user says "log this" or "note this." When a strong moment fires and topic or areas are still `pending`, the skill infers and writes them from current context.

Preexisting docs, marketing copy, decks, and notes should be loaded into `osis/inbox/` as signal when they are relevant to onboarding or a clarity session. They inform the conversation, but they do not become canon automatically.

---

## Key Boundaries

**Product vs Strategy**
- Product = what the product is, how it behaves, core concepts, UX, structure
- Strategy = market, wedge, focus, success criteria, non-goals
- Product should not include how it is built

**core/product.md vs {system}/product.md**
- `core/product.md` defines the product as a whole: composition, macro flows, and how systems connect. In single-system products, it is literally the whole product.
- `{system}/product.md` defines a subsystem: internal flow, inputs/outputs, and local behavior.
- Core product does not define internal system mechanics. System products do not redefine cross-system flows.

**System bar (high)**
- A system is significant: a different app, a different deployment, or a distinct surface that interfaces with the main product.
- Most things are features within an existing system, not new systems. When in doubt, it's a feature.

**Brand vs Design System**
- Brand = identity, voice, positioning, language, emotional expression
- Design System = interface principles, visual language, shared primitives, interaction rules

**Brief vs Implementation**
- Brief = what changes and why (product decisions)
- Implementation = how that change is built (tech decisions)

---

## Single vs Multi System

Every system is the same shape: a folder with `product.md` and iteration folders inside. The system layer is recursive — `core/` always exists as the top-level system; satellites get added when complexity warrants it.

| Scenario | Version layout | System folders |
|---|---|---|
| **Single system** | `thesis.md` + `strategy.md` + `changelog.md` + `core/` | `core/` only — its `product.md` IS the whole product |
| **Multi system** | `thesis.md` + `strategy.md` + `changelog.md` + `core/` + `{system}/` | `core/product.md` is the meta-product; each `{system}/product.md` defines its own scope |

The same `core/product.md` doc evolves naturally as systems get added: it scales from "the whole product" (single-system) to "the meta-product describing composition and how systems connect" (multi-system) without restructuring.

---

## Folder Structure

Canonical shape for the common case. Actual layouts follow the branching tree above: any doc may live at a higher or lower altitude depending on where its scope is shared. Many projects start sparse and materialize more docs over time.

```
osis/
  osis.json                           ← machine state, file graph
  README.md                           ← static
  charter.md                          ← shared charter (only when multiple products share it)
  manifesto.md                        ← product
  brand.md                            ← product
  design-system.md                    ← product
  twin.md                             ← product (engine)
  sessions.md                         ← root (engine: product-thinking thread log, one entry per session)
  inbox/                              ← root (engine: imported and pre-triage signals)
    {date}--{slug}.md
  {version}/                          ← e.g. mvp/, v1/, v2/
    thesis.md
    strategy.md
    changelog.md                      ← single source of truth for all iterations
    core/                             ← always exists; the top-level system
      product.md
      iteration-{n}--{slug}/               ← e.g. iteration-1--launch/
        brief.md
        signals/
          {date}--{slug}.md
        {phase-name}.impl.md          ← e.g. core-ux.impl.md
    {system}/                         ← only when complexity warrants
      product.md
      iteration-{n}--{slug}/
        brief.md
        signals/
        {phase-name}.impl.md
```

For monorepos: the root `osis/` acts as a routing map. It holds `osis.json` (type: `"org"`, products map), `twin.md` as the repo/product map, and optional `charter.md` when multiple products truly share one. Product-local `osis/` directories remain canonical.

---

## osis.json Schema

Machine state for the osis folder. Consumed by the skill at load time (mode detection, file manifest) and by the migration agent (protocol shape comparison).

### Product osis.json

```json
{
  "protocolShape": "1.0",
  "product": "Product Name",
  "activeVersion": "mvp",
  "lastTwinUpdate": "YYYY-MM-DD",
  "anonId": "uuid",
  "createdAt": "ISO timestamp",
  "color": "blue",
  "files": {
    "twin": "osis/twin.md",
    "sessions": "osis/sessions.md",
    "inbox": [],
    "manifesto": "osis/manifesto.md",
    "brand": "osis/brand.md",
    "design-system": "osis/design-system.md",
    "mvp": {
      "thesis": "osis/mvp/thesis.md",
      "strategy": "osis/mvp/strategy.md",
      "changelog": "osis/mvp/changelog.md",
      "systems": {
        "core": {
          "product": "osis/mvp/core/product.md"
        }
      }
    }
  }
}
```

### Org osis.json (monorepo)

```json
{
  "protocolShape": "1.0",
  "type": "org",
  "org": "Org Name",
  "anonId": "uuid",
  "createdAt": "ISO timestamp",
  "products": {
    "product-a": "apps/product-a/osis",
    "product-b": "apps/product-b/osis"
  }
}
```

### Fields

| Field | Purpose |
|---|---|
| `protocolShape` | Which protocol shape the folder follows (e.g. `"1.0"`). Migration compares this against the skill's current protocol version. |
| `product` / `org` | Human-readable name, shown in the activation header. |
| `type` | `"product"` (default) or `"org"` (monorepo root). |
| `activeVersion` | Which version folder (`mvp`, `v1`, `v2`) is the active build target. The convention is `mvp` for the first version, then numbered (`v1`, `v2`...) after. |
| `anonId` | Stable repo UUID for pseudonymous telemetry. Minted once during onboarding; never modified. |
| `createdAt` | ISO timestamp from first onboarding. Never modified. |
| `files` | Flat manifest of the docs that are currently materialized. Missing docs are simply absent until created. Regenerated by onboarding, migration, and maintenance modes. |

### Protocol Shape

`protocolShape` tracks what protocol version the folder is in, independent of the skill version. The skill declares its current protocol version at the top of `references/protocol.md` (`# Osis Protocol v{X}`). When `osis.json.protocolShape` is behind the skill's declared protocol version, migration runs as part of the update sequence (see `references/migration.md`).

Skill releases that do not change folder structure (new modes, fixes, internal features) do not bump the protocol version, so no migration runs. Only releases that add, rename, reshape, or remove docs in the protocol bump the protocol version.

---

## The Lifecycle Flow

```
version → system → iteration → phase → build → ship
                      ↑                            |
                      +────── signal ──────────────+
```

1. **Version** sets the paradigm.
2. **System** organizes work surfaces (when warranted).
3. **Iteration** captures product direction — a bet informed by signal.
4. **Phase** scopes execution — a logical, testable chunk.
5. **Build** happens in plan mode. Osis steps back.
6. **Signal** comes back. New iteration. Loop continues.

Sometimes you iterate again before you build because new signal arrives mid-direction.

---

## Roadmap Decision

No separate roadmap doc. The structure itself is the roadmap:
- Version = current direction
- Briefs = sequence of bets
- Implementation docs = execution path

---

## Frameworks

Osis applies first principles from proven product frameworks at the right altitude, automatically. Frameworks are a hidden reasoning layer, not the product itself.

Each typed doc has a per-doc reference file at `references/docs/funnel/{doc}.md` or `references/docs/engine/{doc}.md`. The drafting docs carry per-section principles distilled from proven thinkers. `references/docs/engine/twin.md` is the deliberate exception: template-only, because Twin mode regenerates from code instead of drafting section by section. The agent loads the relevant doc silently when helping a builder draft, reasons from it, and never narrates it. The builder never thinks "I should use JTBD here."

**Constraints:**
- Principles are stated as truths, not criteria. They shape reasoning, not grading.
- Not every section needs 5 principles. 2 or 3 load-bearing truths is often enough.
- When canonical sources disagree, the per-doc file flags the tension. Surface it as a decision for the builder, never silently pick.
- Reasoning is contextual via Pareto (80/20 for this case). The agent pushes back once when a draft violates a principle, then defers to the builder.
- Observation and inference must stay distinct. If the draft crosses beyond what was observed, either ask for more signal or label the move as inference.
- A concrete scene can open a claim, but it does not prove the category. Repeated signal earns generalization.
- Never invent motives, incentives, failed fixes, or certainty to make a paragraph land.
- Prefer mechanism over villain. Reach for structure, defaults, incentives, and missing apprenticeship before bad actors.
- "Why now" needs a concrete unlock or cost shift. If the unlock is weak, say so.
- The agent never performs the scaffold back to the builder. Use the references to think, then speak plainly.

---

## Template Philosophy

```
minimal canonical shape + optional modules
```

These are typed reasoning artifacts, not generic docs. Each doc answers one question only.

- Dense seeds beat exhaustive text. Minimal default, modular expansion.
- Non-goals matter as much as goals. Explicit exclusions everywhere.
- Structure must serve both humans and agents. Human-readable markdown, agent-navigable semantics.
- The system should feel alive, not ceremonial. If a doc isn't being used to make decisions, it shouldn't exist.
- Dates on everything. Context decays.
- Frameworks are invisible. Distilled into per-section principles for drafting docs in `references/docs/`, with `references/docs/engine/twin.md` as the regeneration-only exception.
- Doc spine required when the doc exists. The project does not need every doc on day one.
- Sections removable. Modules optional. Humans need flexibility, agents need predictable semantics.

**Rule:** Every section earns its place. If empty, remove it. No blank templates.

---

## Key Decisions

**Phase and iteration are not the same.**
Iteration = the release (the bet that ships). Phase = a unit composing into the iteration. Iteration boundaries split when the bet itself diverges, not when surface count grows: multiple roles, surfaces, or sub-systems sharing auth, schema, or product identity are phases of one iteration. A phase is atomic and reviewable in isolation: an agent lands it in a single focused pass, the trunk stays green at the merge point, and nothing inside the phase depends on a future phase to function.

**Phases form a DAG, not a sequence.**
Each phase entry declares its dependencies in a YAML codeblock under its heading. The agent parses these declarations to compute execution order, detect cycles, and identify parallelizable siblings. The iteration lands when every phase node has merged.

**No separate roadmap.** The structure is the roadmap.

**No design spec.** Killed. Link to designs from the impl doc.

**No game plan.** Killed. Absorbed by brief (direction) and impl (execution).

**Phase is a flat doc, not a folder.** `{name}.impl.md` with dot separator.

**Product identity lives at the product level.** Manifesto → Brand → Design System. A funnel within the funnel.

**Thesis lives at version level.** The manifesto persists across versions; the thesis for how to attack it changes.

**Every system is a folder with `product.md`.** `core/` always exists. In single-system, `core/product.md` IS the whole product. In multi-system, `core/product.md` is the meta-product and satellites get their own `{system}/product.md`.

---

## What Changes from Protocol v0.1.0

- Reframed: documentation tool → typed reasoning system
- New layers: org (formalized), product (formalized), iteration (new), system (clarified)
- New docs: `charter.md`, `manifesto.md`, `brand.md`, `design-system.md`, `thesis.md`, `strategy.md`, `brief.md`
- Removed: design spec, game plan, vision.md (replaced by product.md at version level)
- Renamed: `product-spec.md` → `product.md`, `{system}--implementation-spec.md` → `{phase}.impl.md`
- Restructured: iteration is the folder, phases are flat impl docs inside it
- Roadmap removed as standalone artifact
- Framework system: core set of 7, mapped to doc types, max 1-2 per doc
- Modular templates: minimal spine + optional framework modules

---

## Open Items

- Template refinement and finalization
- Migration path for existing osis projects on v0.1.0
- `osis.json` schema for the new structure
- Bootstrap flow for the new doc set
- Skill mode definitions for the new protocol shape
- Framework module implementation details

---

## Sessions

- 2026-04-28 — Added "Phases form a DAG, not a sequence" Key Decision and YAML-codeblock `depends_on` declaration format to brief drafting docs and template; SWE-canonical pattern matching Docker Compose / GHA / Bazel · `claude -r f8a091a2-bca2-4185-8bea-9cef943ce3dc`
- 2026-04-28 — Reworded phase rules from "narrow working product on its own" to "atomic, reviewable in isolation, trunk-green at merge"; SWE-canonical framing per trunk-based-development and stacked-diff doctrine · `claude -r 7e8770e6-5469-40df-977e-0cacf4de1864`
- 2026-04-28 — Sharpened the `Phase and iteration are not the same` Key Decision: iteration boundaries split on bet divergence (not surface count); phases are vertical slices, not horizontal layers · `claude -r 3d474847-90d6-4b05-9200-795b96b6f325`
- 2026-04-23 — Added sessions.md as root-level engine doc, introduced fourth cut (thinking in motion), bumped protocol to v2.0.0 · `claude -r 14bd6251-f95c-4256-a184-3b259e64906b`
