# impl.md (phase execution plan)

Type: Execution plan
Question: How do we build this?
Path: `osis/{version}/{system}/{iteration-slug}/{phase-name}.impl.md`

Osis owns product thinking through tech decisions. Plan mode owns syntax and execution. The impl doc is the handoff boundary.

---

## Section scaffolds

Reasoning principles the agent runs silently before engaging each section. Not surfaced to the user. Principles are truths, not criteria.

### Scope

Principles:
- A phase without an observable done signal is not a phase; acceptance lives inside scope.
- Non-goals are load-bearing; unstated exclusions leak into the build and deform the timeline.
- Scope is bounded by appetite, not by requirements; when the work outgrows the appetite, cut, never extend.
- What ships must stay in production, revenue-continuous, and observable from day one of the phase.

### Decisions

Principles:
- Every non-obvious choice carries its rejected alternatives; a decision without its context decays into folklore.
- Decisions are immutable once recorded; supersede, never edit. The history of reversals is the architecture.
- Record the decision at the altitude it constrains: product-level choices in product docs, interface-level in the phase, code-level belongs downstream.
- Reversible decisions are made fast and local; irreversible decisions are made slow and explicit.
- Stack familiarity is a first-order input, not a rationalization.
- Decisions are recorded as context, choice, consequences; without the full triple, future readers see the conclusion but not the reasoning.

⚠️ tension: canonical ADR practice records decisions post-commitment; greenfield coding-agent handoff requires them pre-commitment so the agent inherits the constraint.

### Architecture

Principles:
- Pieces are defined by what crosses their boundaries, not what lives inside them.
- A bounded context owns its vocabulary; shared terms across contexts are contracts, not conveniences.
- The facade precedes the replacement; route traffic through a seam before touching either side of it.
- Coupling is a budget: each dependency spent must be named and justified against the phase's appetite.
- The shape of the data outlives the shape of the code.

### Key Flows

Principles:
- A flow is defined by its failure modes, not its happy path; unspecified failure is specified chaos.
- Sequence belongs in flows; state belongs in interfaces. Conflating them hides race conditions.
- Every flow names its actor, its trigger, its invariant, and its terminal state.
- Flows cross boundaries; if a flow never leaves one component, it is an implementation detail, not a flow.

### Interfaces

Principles:
- Additive change is free; removal is expensive; renaming is removal plus addition.
- A contract without a version is a contract that cannot evolve.
- The caller's assumptions are part of the interface whether documented or not; document them or inherit them as bugs.
- Interfaces encode guarantees, not implementations; a schema that leaks internal shape has already broken.
- Errors are part of the interface; unspecified failure is an undocumented API.

### Build Order

Principles:
- Each step is independently testable and independently revertible, or it is not a step.
- Build the seam before the thing on either side of it; routing layers, feature flags, and abstraction boundaries come first.
- Sequence by risk reduction: the step that resolves the most uncertainty ships first, regardless of visible progress.
- Vertical slices over horizontal layers; a thin end-to-end path teaches more than a complete layer in isolation.
- Integration happens continuously or never; deferred integration is rediscovered as rework.

### Rollout / Migration

Principles:
- Rollback is a first-class path, not a contingency; if rollback is untested, the release is untested.
- Traffic shifts gradually and observably; a cutover without a canary is a bet, not a rollout.
- Old and new coexist during migration; the transition window is where the real design lives.
- The facade routes, the migration ratchets; once a slice is migrated, the old path for that slice is removed, not kept warm.
- Users experience the migration, not the plan; their path through it is the design.

### Engineering Notes

Principles:
- Discoveries propagate upward when they invalidate assumptions above, not when they're merely interesting.
- The note is written at the moment of surprise; deferred notes become rationalizations.
- Notes close the loop to the layer that made the assumption: the product doc, the thesis, or the prior phase.
- Silence in engineering notes means the phase revealed nothing new, which is itself a signal worth questioning.
- A workaround without a named root cause is a future incident.

---

## Template

````markdown
# [Phase Name] Implementation

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

- [Date], [Discovery]
````

---

## Notes

- Framework-light. Technical and executable.
- Optional sections: Performance budget, Rollback plan.
