# Osis Protocol v1.0.0

> Working draft. The shape, principles, and decisions for the next protocol.

---

## What Osis Is

Osis is not a documentation tool. It is a **typed reasoning system for product development** — a system for maintaining clean, evolving product context across abstraction layers.

The docs are not "docs" in the traditional sense. They are definitions of a slice of the product at a specific level of abstraction. Each document has a clear identity, meaning, and role in the system — like types in programming. A `thesis.md` is always a hypothesis. A `brief.md` is always an experiment. A `product.md` is always a definition. Agents can rely on this.

Each document is a projection of the same system at a different level of abstraction.

The long-term goal is autonomous product decision-making. The real purpose of the system is to curate clean context for human-agent collaboration, not to create verbose paperwork.

The `osis/` folder IS the digital twin of the company and product. The `twin.md` file is one distillation of the codebase. The whole protocol is the twin.

**Code is cheap. Product clarity is everything.** Agents can generate millions of lines of code in a day. The bottleneck is knowing what to build and why. Osis is the funnel that turns ethereal product thinking into executable clarity.

---

## Core Principles

1. **Typed reasoning artifacts.** Each doc answers one question only. Fixed purpose, expected semantics, predictable shape. Not rigid templates — recognizable kinds of thinking. Agents know how to interpret each doc, can connect them together, can reason across layers.

2. **The clarity funnel.** Every layer is a tighter ring. Ethereal → concrete. Org → product → version → system → iteration → phase → plan mode → code. Each layer constrains the one below it.

3. **Top-down compliance.** The product complies with the org. The version complies with the product. The iteration complies with the version. The pattern repeats down the funnel.

4. **Dense seeds beat exhaustive text.** LLMs are good at expanding from dense seeds. Docs should be minimal, expandable, modular, easy to keep fresh. A short doc that's accurate beats a long one that's stale.

5. **Modular structure.** The protocol applies the right structure to the situation. Same protocol, adaptive shape.

6. **Org and system are the same abstraction.** Organizational routing layers — added when complexity warrants it, skipped when there's only one thing.

7. **Implementation is the handoff boundary.** Osis owns product thinking through tech decisions. Plan mode owns syntax understanding and execution. Clean separation.

8. **Docs are collaboration vessels** between user and agent. The interaction surface is: talk to agent, agent modifies doc, human reads docs, makes changes or talks to agent again. The conversation is where the value lives.

9. **Archive over mutate.** Previous iterations and versions are the archive. The folder structure preserves the paper trail.

10. **Non-goals matter as much as goals.** Explicit exclusions prevent scope creep and misaligned execution.

11. **Don't be eager.** Code bugs don't touch osis unless they reveal a product/UX decision. Engage when there's a real product decision to make.

12. **Osis is opinionated.** The structure IS the value. Modular ≠ shapeless.

13. **The flywheel.** Docs capture product and technical decisions → single source of truth → better informed future decisions → faster building. Every rotation compounds.

14. **Upward propagation.** Discoveries at lower layers that invalidate higher-layer assumptions must be pushed up immediately (phase → iteration → version). Prevents silent drift and closes the loop structurally.

15. **Local clarity.** Each doc should be understandable in isolation, but more powerful in context.

---

## The Clarity Funnel

```
Org: "We believe X about the world"              [philosophical]
  Product: "This problem matters"                 [philosophical]
    Version: "Here's how we're manifesting it"    [strategic]
      System: "Here's a distinct surface"         [strategic/tactical]
        Iteration: "Here's the bet right now"     [tactical]
          Phase: "Here's how we're building it"   [executable]
            → plan mode → code
```

| Level | Nature | What it captures |
|---|---|---|
| **Org** | Philosophical | Who we are, what we believe, how we work |
| **Product** | Philosophical | Why this problem matters, our enduring declaration |
| **Version** | Strategic | What we're building, for whom, how it works, how we win |
| **System** | Strategic/Tactical | A distinct, encapsulated product surface with its own inputs, outputs, and behavior |
| **Iteration** | Tactical | A falsifiable product bet informed by signal |
| **Phase** | Executable | Tech decisions in logical, testable chunks → plan mode |

---

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

---

## Doc Types

Each doc is a typed node in a reasoning graph. Edges are the structural relationships (version → iteration → phase). This enables propagation, consistency checks, and eventually autonomous decisions.

### Funnel Docs

| Doc | Type Signature | Level | Purpose |
|---|---|---|---|
| `charter.md` | Operating constraints | Org | Mission, values, non-negotiables, decision principles |
| `manifesto.md` | Declaration | Product | Why the problem matters, what's broken, what we refuse |
| `brand.md` | Expression | Product | Voice, tone, personality, positioning, language |
| `design-system.md` | Interface rules | Product | Visual language, interaction patterns, shared primitives |
| `thesis.md` | Hypothesis | Version | The strategic bet this version makes |
| `product.md` | Definition | Version / System | What the product (or system) is |
| `strategy.md` | Allocation | Version | Where we focus and how we win |
| `brief.md` | Experiment | Iteration | Signal, insight, the tactical bet |
| `{phase}.impl.md` | Execution plan | Phase | Tech decisions → handoff to plan mode |

### Engine Docs

| Doc | Level | Purpose |
|---|---|---|
| `twin.md` | Product | Agent-readable operational map. Descriptive, not prescriptive — reflects the system, does not define product decisions |
| `changelog.md` | Version | Chronological record of decisions and spec changes |
| `{signal}.md` | Iteration (`signals/`) | Raw intel that informed the brief |
| `osis.json` | Root | Machine state, routing, file graph |
| `README.md` | Root | Static protocol explainer |

---

## Key Boundaries

**Product vs Strategy**
- Product = what the product is, how it behaves, core concepts, UX, structure
- Strategy = market, wedge, focus, success criteria, non-goals
- Product should not include how it is built

**Version product.md vs {system}-product.md**
- Version `product.md` defines the product as a whole: composition, macro flows, and how systems connect.
- `{system}-product.md` defines a subsystem: internal flow, inputs/outputs, and local behavior.
- Version product does not define internal system mechanics. System products do not redefine cross-system flows.

**Brand vs Design System**
- Brand = identity, voice, positioning, language, emotional expression
- Design System = interface principles, visual language, shared primitives, interaction rules

**Brief vs Implementation**
- Brief = what changes and why (product decisions)
- Implementation = how that change is built (tech decisions)

---

## Single vs Multi System

| Scenario | Version docs | System docs |
|---|---|---|
| **Single system** | `thesis.md` + `product.md` + `strategy.md` | — |
| **Multi system** | `thesis.md` + `product.md` + `strategy.md` | `{system}-product.md` per system |

In multi-system: `product.md` stays at the version level as the meta-product definition. Each system gets a subordinate product doc (`interview-product.md`, `story-graph-product.md`, etc.).

---

## Folder Structure

```
osis/
  osis.json                           ← machine state, file graph
  README.md                           ← static
  charter.md                          ← org
  manifesto.md                        ← product
  brand.md                            ← product
  design-system.md                    ← product
  twin.md                             ← product (engine)
  {version}/                          ← e.g. v0/, v1/
    thesis.md
    product.md                        ← the product definition
    strategy.md
    changelog.md
    {system}-product.md               ← only if multi-system
    {iteration-slug}/                 ← e.g. iteration-1--activation/
      brief.md
      signals/
        {date}--{slug}.md
      {phase-name}.impl.md            ← e.g. core-ux.impl.md
```

For monorepos: org-level `osis/` holds `charter.md`, `osis.json` (type: "org", products map), and symlinks to product `osis/` directories.

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

- Core spine required
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

**product.md exists at version level in both single and multi system.** In multi-system, it's the meta-product; systems get `{system}-product.md`.

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
