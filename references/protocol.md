# Osis Protocol v1.0.0

> Working draft. The shape, principles, and decisions for the next protocol.

---

## What Osis Is

Osis is not a documentation tool. It is a **product clarity system** and a **typed reasoning system for product development** — a system for maintaining clean, evolving product context across abstraction layers.

The docs are not "docs" in the traditional sense. They are definitions of a slice of the product at a specific level of abstraction. Each document has a clear identity, meaning, and role in the system — like types in programming. A `thesis.md` is always a hypothesis. A `brief.md` is always an experiment. A `product.md` is always a definition. Agents can rely on this.

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

5. **Protocol spine, adaptive shape.** The set of doc types is fixed. The instantiated shape in a repo is adaptive. Not every doc needs to exist on day one, but when a doc exists it keeps its semantic spine.

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
| `twin.md` | Product | Agent-readable operational map. Descriptive, not prescriptive — reflects the system, does not define product decisions |
| `changelog.md` | Version | Chronological record of decisions and spec changes |
| `inbox/{signal}.md` | Root | Pre-triage signal. Imported artifacts, pasted notes, and unresolved observations land here before routing |
| `{signal}.md` | Iteration (`signals/`) | Raw intel that informed the brief |
| `osis.json` | Root | Machine state, routing, file graph |
| `README.md` | Root | Static protocol explainer |

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

Canonical locations, not a mandatory checklist. Many projects start sparse and materialize more docs over time.

```
osis/
  osis.json                           ← machine state, file graph
  README.md                           ← static
  charter.md                          ← shared charter (only when multiple products share it)
  manifesto.md                        ← product
  brand.md                            ← product
  design-system.md                    ← product
  twin.md                             ← product (engine)
  inbox/                              ← root (engine: imported and pre-triage signals)
    {date}--{slug}.md
  {version}/                          ← e.g. v0/, v1/
    thesis.md
    strategy.md
    changelog.md                      ← single source of truth for all iterations
    core/                             ← always exists; the top-level system
      product.md
      {iteration-slug}/               ← e.g. iteration-1--launch/
        brief.md
        signals/
          {date}--{slug}.md
        {phase-name}.impl.md          ← e.g. core-ux.impl.md
    {system}/                         ← only when complexity warrants
      product.md
      {iteration-slug}/
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
  "activeVersion": "v1",
  "lastTwinUpdate": "YYYY-MM-DD",
  "anonId": "uuid",
  "createdAt": "ISO timestamp",
  "color": "blue",
  "files": {
    "twin": "osis/twin.md",
    "inbox": [],
    "manifesto": "osis/manifesto.md",
    "brand": "osis/brand.md",
    "design-system": "osis/design-system.md",
    "v1": {
      "thesis": "osis/v1/thesis.md",
      "strategy": "osis/v1/strategy.md",
      "changelog": "osis/v1/changelog.md",
      "systems": {
        "core": {
          "product": "osis/v1/core/product.md"
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
| `activeVersion` | Which version folder (`v0`, `v1`) is the active build target. |
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

### Philosophy

Osis applies a small set of proven product frameworks to the right decisions, automatically.

Frameworks are a hidden reasoning layer, not the product itself. They are mini skills with triggers — selected automatically, plugged into the right doc at the right time. The user never thinks "I should use JTBD here."

**Constraints:**
- Each doc uses at most 1–2 frameworks. Otherwise docs become bloated.
- Frameworks should never change the type of a doc — only enhance clarity within it.

### Core Framework Set

| Framework | Trigger | Output | Allowed Docs |
|---|---|---|---|
| **JTBD** | Product is feature-led, unclear on user job | Job statement, desired outcome, alternatives, constraints | Thesis, Product, Brief |
| **PR/FAQ** | Value proposition or future state is fuzzy | Customer-facing value articulation, objections, promise | Thesis, Product |
| **North Star / KPI** | Strategy or iteration needs success definition | Core metric, supporting metrics, rationale | Strategy, Brief |
| **Loop** | Product needs recurrence or compounding engagement clarity | Trigger, action, reward, investment, recurrence path | Product, Brief |
| **Non-goals** | Scope drift, ambiguity, or overreach | Explicit exclusions | Strategy, Product, Brief, Implementation |
| **Experiment / Hypothesis** | Iteration is a bet that needs structure | Hypothesis, method, success/failure criteria | Brief |
| **Opportunity Solution Tree** | Complex product needs structured path from opportunities to solutions | Outcome, major opportunities, solution branches | Product, Strategy |

### Optional (later)

RICE-lite, Tenets, DIBB, Appetite, Kill criteria, 11-star

### Framework-to-Doc Mapping

| Doc | Framework posture |
|---|---|
| Charter | Principles/tenets only. Not framework-heavy. |
| Manifesto | Mostly native writing. Should not feel framework-generated. |
| Brand | Mostly native writing. |
| Design System | Mostly native system rules. |
| Thesis | Best place for: JTBD, PR/FAQ, assumptions, falsifiability |
| Strategy | Best place for: North Star / KPI, non-goals, wedge, risk |
| Product | Best place for: JTBD, analogy, loops, structure, boundaries |
| Brief | Best place for: signals, hypothesis, success/kill criteria, appetite |
| Implementation | Framework-light. Technical and executable. |

---

## Template Philosophy

```
minimal canonical shape + optional modules
```

- Doc spine required when the doc exists
- The project does not need every doc on day one
- Sections removable
- Modules optional
- Every section must materially improve the quality, speed, or correctness of a decision
- Humans need flexibility, agents need predictable semantics

**Rule:** Every section earns its place. If empty, remove it. No blank templates.

---

## Key Decisions

**Phase and iteration are not the same.**
Iteration = product direction (the bet). Phase = unit of work (the execution slice).

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
