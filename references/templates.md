# Osis Protocol v1.0.0 — Templates

> Working draft. Minimal canonical shapes for each doc type.
> A repo does not need every doc on day one. When a doc is instantiated, keep its spine. Sections removable. Modules optional.

---

## Org Level

### charter.md

Type: **Operating constraints**
Question: *Who are we and how do we work?*

```markdown
# [Org Name] — Charter

## Mission

One sentence. Why this organization exists.

## Values

| Value | In Practice |
|---|---|
| [value] | [How this shows up in decisions] |

## Non-Negotiables

What we will never compromise on, regardless of circumstance.

- [non-negotiable]

## Decision Principles

How we make decisions when values conflict or the path is unclear.

- [principle]
```

---

## Product Level

### manifesto.md

Type: **Declaration**
Question: *What's wrong with the world and what are we going to do about it?*

```markdown
# [Product Name]

## [The declaration in one line]

---

## The Problem

What is broken. Not a feature gap — a human problem.
Be specific. Be visceral.

## The Deeper Structure

Why has this persisted? What structural forces keep it unsolved?
One level deeper than the obvious.

## What Changed

What is different now — technology, culture, cost —
that makes solving this possible today?

## The Declaration

What we are going to do about it.
One paragraph. Quotable. Bold.

## What We Refuse

What we will not do, even if it would be easier or more profitable.

---

*[Organization] — [Date]*
```

Notes:
- Mostly native writing. Should not feel framework-generated.
- Optional section: Impact, Long Horizon.
- Capture the builder's current declaration, not polished launch copy. Rough but true beats smooth but stale.

---

### brand.md

Type: **Expression**
Question: *How does this product express itself?*

```markdown
# [Product Name] — Brand

## Identity

What this product IS in one sentence.

## Voice

| We are | We are not |
|---|---|
| [trait] | [anti-trait] |

## Positioning

For [audience]
who [situation/pain],
[Product] is a [category]
that [key benefit].
Unlike [alternative],
we [key differentiator].

## Naming & Language

| Use | Don't Use | Why |
|---|---|---|
| [term] | [term] | [reason] |
```

Notes:
- Mostly native writing.
- Optional section: Personality.
- Materialize when language, positioning, or taste are already acting as real constraints, or when downstream output keeps drifting.

---

### design-system.md

Type: **Interface rules**
Question: *How does it look and feel?*

```markdown
# [Product Name] — Design System

## Interface Principles

First-principles for every visual and interaction decision.

### [Principle 1]
What it means. How it applies.

### [Principle 2]
...

## Visual Language

### Color
Primary, secondary, semantic. When to use each.

### Typography
Families, scale, hierarchy.

### Spacing & Layout
Grid, spacing scale, layout patterns.

## Interaction Patterns

### Navigation
How users move through the product.

### Feedback
How the product responds to actions.

### States
Loading, empty, error, success.

## Shared Primitives

Reusable interface patterns and their rules.

| Primitive | Usage | Behavior |
|---|---|---|
| [primitive] | [when] | [how] |
```

Notes:
- Not a coded component inventory. Shared interface primitives, not an exhaustive catalog.
- Actual coded components belong closer to implementation.
- Materialize when the product already has a strong visual language, or when agent output needs interface constraints to stay consistent.

---

## Version Level

### thesis.md

Type: **Hypothesis**
Question: *What bet is this version making?*

```markdown
# [Product] [Version] — Thesis

## Conviction

What we believe about how to attack the problem.
This is the bet. Clear enough that someone can disagree.

## Why Now

What makes this the right moment for this particular approach.

## Assumptions

What must be true for this to work.

- [assumption]

## Falsifiability

How we'll know if we're wrong.

| Signal | Indicates |
|---|---|
| [observation] | [right / wrong] |
```

Notes:
- Optional section: Alternatives Rejected, Constraints.
- Framework modules: JTBD, PR/FAQ.
- The first version thesis can start rough. Its job is to capture the current strategic bet, not to sound final.

---

### core/product.md (top-level system)

Type: **Definition**
Question: *What is this product?*
Path: `{version}/core/product.md`

In single-system products, this IS the whole product. In multi-system products, this is the meta-product (composition, macro flows, how systems connect).

```markdown
# [Product] [Version] — Product

## Definition

What the product does and who it's for. Plain language.

## The Analogy

"Think of what [known thing] does, but [key difference]."

## Core Concepts

| Concept | Definition |
|---|---|
| [term] | [meaning] |

## Structure

How the product is organized. Systems, surfaces, layers.

[Diagram or description]

## Flow

The core user flow. What the user does, what the product does.

[Step-by-step or flow diagram]

## UX / Surfaces

| Surface | Purpose | Key Elements |
|---|---|---|
| [surface] | [what] | [what's on it] |

## Behavioral Rules

What the product always does. What it never does.

**Always:**
- [rule]

**Never:**
- [rule]

## Boundaries

What the product is NOT. Explicit scope.

---

*[Date]*
```

Notes:
- Analogy near the top — fastest way to communicate what's being built.
- Should not include how it is built.
- Does not define internal system mechanics. Those belong in `{system}/product.md`.
- In multi-system: this is the meta-product. Other systems get their own `{system}/product.md`.
- Optional module: Loop (trigger → action → reward → investment → recurrence). Include when recurrence or compounding engagement matters. Remove when irrelevant.
- Framework modules: JTBD, Loop, Non-goals.

---

### strategy.md

Type: **Allocation**
Question: *Where do we focus and how do we win?*

```markdown
# [Product] [Version] — Strategy

## Target

Who this is for. Be specific.

## Wedge

Where exactly we enter the market. The initial foothold.

## Why Us

Why we are uniquely positioned to win this wedge.

## GTM / Distribution

How users find and adopt the product.

## Success Criteria

| Metric | Target | Timeframe |
|---|---|---|
| [metric] | [number] | [by when] |

## Non-Goals

What we are explicitly NOT doing and why.

- [non-goal] — [reason]

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| [risk] | [what breaks] | [what we do] |
```

Notes:
- Framework modules: North Star / KPI, Non-goals, Opportunity Solution Tree.
- Optional sections: Segments, Activation, Growth, Resources & Constraints.

---

## System Level

### {system}/product.md

Type: **Definition** (subordinate)
Question: *What is this system?*
Path: `{version}/{system}/product.md`

A system warrants its own folder when it's a different app, deployment, or distinct surface. Most things are features within an existing system, not new systems.

```markdown
# [System Name] — Product

## Purpose

One paragraph. What this system does for the user.

## The Analogy

What real-world role or process does this system mirror?

Where it sits:
  [Previous] → [THIS SYSTEM] → [Next]

## Inputs

What this system receives. What must exist before it runs.

## Flow

Step-by-step behavior. Happy path, then adaptation.

### [Step 1]
What happens. What the rules are.

### [Step 2]
...

## Outputs

What this system produces. What downstream systems receive.

## Interaction Model

What the system shows. What the user does. The rhythm.

## Behavioral Rules

**Always:**
- [rule]

**Never:**
- [rule]

## Connections

| System | Direction | What Flows |
|---|---|---|
| [system] | → / ← / ↔ | [data] |

## Success Signals

How we know this system is working.

- [signal]
```

Notes:
- Does not redefine cross-system flows. Expands only within its boundary.

---

## Iteration Level

### brief.md

Type: **Experiment**
Question: *What bet are we making and why?*
Path: `{version}/{system}/{iteration-slug}/brief.md`

The iteration lives in the system that owns the product direction. Phases inside the iteration may touch other systems' code; the brief captures that. Cross-cutting refactors (no product direction change) go to the version-level changelog, not a brief.

```markdown
# [Iteration Name] — Brief

**Version:** [version]
**Date:** [date]
**Status:** [active / shipped / superseded]

## Signals

What we observed. The raw intel.

- [signal]

## Insight

What the signals mean. The pattern.

## Bet

What we're doing about it and why we expect it to work.

## What Changes

| Area | Before | After |
|---|---|---|
| [what] | [current] | [new] |

## What Doesn't Change

Explicit. What we're leaving alone.

## Phases

| Phase | Scope | Depends On |
|---|---|---|
| [name] | [what ships] | [prereq] |

## Success Criteria

- [ ] [observable outcome]
```

Notes:
- Framework modules: Hypothesis/experiment, Non-goals, Kill criteria.
- Optional sections: Appetite, Loop changes.
- The first brief is often just the current live bet captured cleanly. It does not need to be novel to be worth writing down.

---

## Phase Level

### {phase-name}.impl.md

Type: **Execution plan**
Question: *How do we build this?*
Path: `{version}/{system}/{iteration-slug}/{phase-name}.impl.md`

```markdown
# [Phase Name] — Implementation

**Iteration:** [parent iteration]
**Status:** [not started / in progress / done]

## Scope

What this phase accomplishes. What ships.
What is out of scope.

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| [what] | [approach] | [why] |

## Architecture

How the pieces fit together.

```
[ASCII diagram]
```

## Key Flows

### [Flow Name]

```
[Sequence diagram or step-by-step]
```

## Interfaces

APIs, events, schemas, and component contracts.

```typescript
type Example = {
  field: string
}
```

## Build Order

Each step independently testable.

### 1. [Name]
**Scope:** What gets built.
**Validates:** What question this answers.

### 2. [Name]
**Depends on:** 1
**Scope:** ...
**Validates:** ...

## Rollout / Migration

How this gets deployed. Migration path if applicable.

## Engineering Notes

Discoveries during build. Propagate up if they change product direction.

- [Date] — [Discovery]
```

Notes:
- Framework-light. Technical and executable.
- Framework modules: Non-goals (scope section).
- Optional sections: Performance budget, Rollback plan.

---

## Engine Docs

### twin.md

Type: **Operational map**

```markdown
# [Product Name] — Twin

Agent-readable operational map of the product.
Not a source of truth for product decisions.

Last updated: [Date]

## Master Diagram

[ASCII — the whole product in one visual]

## Systems

### [System Name]
**What it does:** One line.
**Capabilities:** What it can do today.
**Maturity:** [mature / solid / basic / thin / minimal]

## Canonical Entities

Key data objects and their relationships.

## Interfaces

How systems communicate. APIs, events, shared state.

## Architecture

[ASCII — services, data stores, deployment]

## Dependencies

External services the product relies on.

## Known Gaps

What's missing, broken, or incomplete.
```

---

### changelog.md

Type: **Decision record**

```markdown
# Changelog

## [Date] — [Change Name]

### Changes
- `[file]` — what changed and why

### Drift
- **[Drift]** `[file]` — spec says X, code does Y
- **[Missing]** `[file]` — code with no spec
- **[Stale]** `[file]` — spec references dead code

### Follow-up
- [ ] [action needed]
```

---

### signals/{date}--{slug}.md

Type: **Raw intel**

```markdown
---
type: [observation | feedback | research | transcript | metric]
date: [YYYY-MM-DD]
source: [where this came from]
summary: [one-line key insight]
---

[Raw content. However messy. The brief extracts the insight.
Do not interpret here. Raw only.]
```

---

### osis.json

Type: **Machine state**

```json
{
  "protocolShape": "1.0",
  "type": "product",
  "product": null,
  "activeVersion": null,
  "anonId": "uuid-v4",
  "createdAt": "ISO-8601",
  "lastTwinUpdate": null,
  "files": {}
}
```

Org variant:
```json
{
  "protocolShape": "1.0",
  "type": "org",
  "org": null,
  "anonId": "uuid-v4",
  "createdAt": "ISO-8601",
  "products": {}
}
```

---

## Design Principles

1. **These are typed reasoning artifacts, not generic docs.** Each doc answers one question only.
2. **Dense seeds beat exhaustive text.** Minimal default, modular expansion.
3. **Non-goals matter as much as goals.** Explicit exclusions everywhere.
4. **Structure must serve both humans and agents.** Human-readable markdown, agent-navigable semantics.
5. **The system should feel alive, not ceremonial.** If a doc isn't being used to make decisions, it shouldn't exist.
6. **Dates on everything.** Context decays.
7. **Frameworks are invisible.** Applied automatically at the right moment. Max 1-2 per doc.
