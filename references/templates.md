# Spec Templates

Templates for every artifact in the osis protocol. Each template defines the structure and purpose of each section. These serve two audiences: **humans** making decisions and **AI agents** needing written context to act correctly.

---

## 0. Digital Twin (twin.md)

Code compression. A mechanical description of what the codebase produces. Present tense. No vision, no personas, no strategy. One file. The first thing an agent reads. Readable in 2-3 minutes.

```markdown
# Digital Twin — [Product Name]

Last updated: [Date]

## Master Diagram

The whole codebase in one visual. Every system, every
connection, every service.

[ASCII diagram]

## Systems

### Product-Specific Systems

#### [System Name]
**Capabilities:** What it can do today.
**Features:** What users can do with it.
**Key Flows:** [Step-by-step or flow diagram]
**Maturity:** [mature / solid / basic / thin / minimal]
**Connections:** What other systems it talks to.

#### [System Name]
...

### Standard Systems

- **Auth:** [One-liner + product-specific quirks]
- **Email:** [One-liner + quirks]

## Routes / Endpoints

| Route | Method | What It Does |
|---|---|---|
| ...   | ...    | ...          |

## Architecture

Services, data stores, external dependencies, deployment.

[ASCII diagram]

## Dependencies

External services the product relies on.
```

---

## 0b. Org Twin (twin.md — monorepo)

Org-level twin. Describes the org's products, shared systems, and how they relate. Not a product twin — no routes, no endpoints, no architecture details.

```markdown
# Org Twin — [Org Name]

Last updated: [Date]

## Products

| Product | Description | Status |
|---------|-------------|--------|
| [product-a] | One-line description | Active / Planning / Maintenance |
| [product-b] | ... | ... |

## Shared Systems

Systems, services, or infrastructure shared across products.

### [Shared System Name]
**Used by:** [product-a], [product-b]
**What it does:** One-liner.

## Product Relationships

How products connect, share data, or depend on each other.

[ASCII diagram or description]

## Dependencies

External services shared across the org.

| Service | Used By | Purpose |
|---------|---------|---------|
| ...     | ...     | ...     |
```

---

## 1. Vision Spec

Canon. Durable. The manifesto. Answers: **why does this thing need to exist?**

Not a product description. Not features. The argument for why this problem matters, why now, and what success looks like. Write it like a manifesto.

```markdown
# [Project Name]

## [Subtitle framing the scope and ambition]

*A Manifesto*

---

*[Organization] — [Date]*

---

## I. The Problem

What problem has existed forever? Why has it persisted? What have
people been doing about it with whatever tools they had?

Don't start with technology. Start with the human condition.

---

## II. The Deeper Structure

Go one level deeper. Why does this problem exist the way it does?
What are the underlying mechanics that make it hard?

---

## III. The History of Attempts

How has every generation tried to solve this? What did each attempt
capture, and what was its structural limitation?

| Era | Approach | What It Captured | Structural Limitation |
|-----|----------|------------------|-----------------------|
| ... | ...      | ...              | ...                   |

---

## IV. What Changed

What is different now? What combination of technology, cost, or
cultural shift makes solving this possible today?

---

## V. The Vision

Define the core concept. Give it a name if it deserves one.
This should be quotable.

---

## VI. How It Works (Conceptual)

Not the product. The conceptual architecture. Atomic units,
structural innovation, how pieces relate. What you'd draw
on a whiteboard.

---

## VII. The Impact

What changes for individuals? Communities? Society?
Be concrete. Use scenarios.

---

## VIII. The Long Horizon

Where does this go in 10-20 years? Not a roadmap — the logical
terminus of the idea.

---

*[Organization]*
```

---

## 2. Product Spec + Roadmap

Canon. Durable. The product bible. Answers: **what are we building, how does it work, when does each piece ship?**

```markdown
# [Project Name] — Product Spec

Last updated: [Date]

> Pointer to Vision Spec for the "why." This is the "what" and "when."

---

## 1. What We're Building

Explain the product in plain language.

### The Analogy

Every product has a real-world analog — something people already
understand. Find it. This is the most important paragraph in the
spec. It grounds the team in reality.

"Think of what [known thing] does, but [key difference]."

The gap between the analog and what you're building IS the product.

**The test:** [One sentence — how do you know it's working?]

**The constraint:** [Team size, burn, runway, timeline.]

---

## 2. Core Concepts

Define the vocabulary. Key nouns, coined terms, precise definitions.
This becomes the shared language for every human and agent.

---

## 3. The Pipeline

How does raw input become finished output? Stages, flows, diagrams.

### 3.1 [Stage Name]
What happens. Who/what does it. What it produces.

---

## 4. The Data Model (Conceptual)

Not a schema. Entities, relationships, what grows, what's static.

---

## 5. The Actors

| Actor | Role | Faces User? | The Job |
|-------|------|-------------|---------|
| ...   | ...  | ...         | ...     |

### What Flows Between Them
Data/artifact flow between actors.

---

## 6. The Product Loop

What makes users come back.

### [Primary Loop]
Trigger → Action → Reward → Investment → Next Trigger

### [Secondary Loop] (if applicable)
Same structure.

### The Crossover
How loops feed each other.

---

## 7. Screens

| Screen | Stage | Key Elements |
|--------|-------|--------------|
| ...    | ...   | ...          |

---

## 8. Editorial / Design Philosophy

Principles that shape every UI decision.

---

## 9. Roadmap

### Phase 1 — [Name] ([Date])

**Goal:** One sentence.

| Component | Tier | Notes |
|-----------|------|-------|
| ...       | T1/T2/T3 | ... |

**T1** = Must ship. **T2** = Ship if possible. **T3** = Nice to have.

**Does not ship:** [Explicit list]
**Success looks like:** [Measurable outcomes]

### Phase 2 — [Name]
...

### Phase 3 — [Name]
...

### The Long Horizon
The reason the roadmap exists.

---

*[Organization] — [Date]*
```

---

## 3. Phase Game Plan

Rotates per phase. Maps to Initiative. Answers: **what are we doing in this phase?**

```markdown
# Phase [N] Game Plan — [Name]

**Goal:** [One sentence from Product Spec roadmap]
**Target date:** [Date]
**Status:** [Not started | In progress | Complete | Archived]

---

## 1. What This Phase Accomplishes

Expand the goal. What can users do after this phase that they
couldn't before?

---

## 2. Constraints

- **Timeline:** [Hard/soft]
- **Resources:** [Team size, roles]
- **Budget:** [Relevant costs]
- **Dependencies:** [What must exist first]

---

## 3. Systems

| System | Type | Description |
|--------|------|-------------|
| ...    | New / Changed | One-line |

---

## 4. What Ships

| Component | Tier | System | Notes |
|-----------|------|--------|-------|
| ...       | T1   | ...    | ...   |

---

## 5. What Does NOT Ship

| Deferred Item | Reason | Revisit In |
|---------------|--------|------------|
| ...           | ...    | Phase N+1  |

---

## 6. Success Criteria

- [ ] [Observable outcome]

---

## 7. Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| ...  | ...    | ...        |

---

## 8. Open Questions

- [ ] [Question] — *Unresolved*
- [x] [Question] — *Resolved: [answer]. Updated in [spec].*
```

---

## 4. System Product Spec

Rotates per phase. Maps to Project. Answers: **what does this system do for the user?**

Product-level only. No architecture. No code. A UX person should write and read this.

```markdown
# [System Name] — Product Spec

## Purpose

One paragraph. What is this system? What does it do for the user?

### The Analogy

What real-world role or process does this system mirror?
Each system spec needs its own analog grounded in the
product's top-level metaphor.

Where it sits in the pipeline:

  [Previous Step] → [THIS SYSTEM] → [Next Step]

## Inputs

What does this system receive? What must exist before it runs?

## Interaction Model

How does the user interact?
- What does the system say/show?
- What does the user do?
- What's the rhythm?

For backend systems, replace with **Trigger & Execution Model**.

## The Flow

Step-by-step behavior. Concrete, not abstract.
Happy path + how the system adapts.

### [Phase/Stage 1]
What happens. What the rules are.

### [Phase/Stage 2]
...

## Behavioral Rules

Dos and don'ts. Use specific examples.

Anti-patterns — what the system should NOT do and why.

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| ...      | ...               |

## Connections

| System | Relationship | What Flows |
|--------|--------------|------------|
| ...    | Feeds into / Receives from | ... |

## Open Questions

- [ ] [Question] — *Unresolved*
- [x] [Question] — *Resolved: [answer]*
```

---

## 5. Design Spec

Rotates per phase. A lightweight index. The real work lives in the design tool.

```markdown
# [System Name] — Design Spec

**Designs:** [Link to Figma / Pencil / design tool]
**PM Project:** [Link]
**Status:** [Exploring | Ready for Dev | Implemented]

## Notes

Anything worth capturing that doesn't belong in a design tool
comment or PM issue. Keep this short.
```

---

## 6. Implementation Spec

Rotates per phase. Maps to Project. Answers: **how are we building this?**

This is what an AI agent reads before entering plan mode. Must be accurate.

```markdown
# [System Name] — Implementation Spec

## Status

| Phase | Status | Notes |
|-------|--------|-------|
| 1. [Name] | Not started / In progress / Done | |
| 2. [Name] | ... | |

---

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| ...      | ...    | ...       |

---

## System Architecture

ASCII diagram showing all pieces — client, server, external
services, and how they communicate.

```
[ASCII system diagram]
```

---

## [Critical Flow Name]

Sequence diagram or step-by-step of the most important flow.
Show timing, parallelism, critical path.

```
[ASCII sequence diagram]
```

---

## Wire Contracts

Exact types, payloads, constraints.

### [Contract Name]

```typescript
type ExamplePayload = {
  field: string
  field2: number
}
```

| Field | Max Size | Notes |
|-------|----------|-------|
| ...   | ...      | ...   |

---

## Directory Structure

```
path/to/system/
├── index.ts
├── module-a/
└── module-b/
```

---

## Build Phases

Each phase independently testable.

### Phase 1: [Name]
**Scope:** What gets built.
**Validates:** What question this answers.

### Phase 2: [Name]
**Depends on:** Phase 1
**Scope:** ...
**Validates:** ...

---

## Latency / Performance Budget

If performance-sensitive, document the budget.

---

## Engineering Notes

Short bullets capturing discoveries from implementation.

- [Date] — [Discovery]

If a discovery changes UX or behavior, propagate up.

---

## Open Questions

- [ ] [Question] — *Unresolved*
- [x] [Question] — *Resolved: [answer]*
```
