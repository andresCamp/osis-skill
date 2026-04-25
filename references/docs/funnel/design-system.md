# design-system.md

Type: Interface rules
Question: How does it look and feel?
Path: `osis/design-system.md`

---

## Section scaffolds

Reasoning principles the agent runs silently before engaging each section. Not surfaced to the user. Principles are truths, not criteria.

### Interface Principles

Principles:
- Every interface teaches a mental model; the surface must match the thing beneath it, or users learn the wrong system.
- Affordance precedes aesthetic; if the user cannot tell what is actionable, no amount of polish rescues it.
- Consistency compounds; every exception taxes memory and forces re-learning at the worst moment.
- Reduce before you add: the strongest interface decision is the element you removed without loss.
- In agentic surfaces, the model is part of the UI; intent capture, context, and reversibility are interface concerns, not chrome.

⚠️ tension: canonical heuristics assume a deterministic surface the user drives; AI-native work assumes a probabilistic surface the user steers.

### Visual Language

Principles:
- Color, type, and space are a token hierarchy: raw values feed semantic roles feed component usage; skipping the semantic layer guarantees future rework.
- Typography carries more signal than color; a single well-tuned type scale resolves most hierarchy problems before color is invoked.
- Space is structural, not decorative; rhythm on a shared unit grid is what makes unrelated screens feel like one product.
- Contrast is a functional requirement, not a stylistic one; accessibility floors are design constraints, not adornments.
- Restraint scales: monochrome by default, saturation reserved for meaning, keeps attention routable as the surface grows.

### Interaction Patterns

Principles:
- State must be legible at a glance; loading, empty, error, and success are first-class screens, not afterthoughts bolted to the happy path.
- Every action needs a reversal path; undo is cheaper than confirmation and respects the user's tempo.
- Feedback latency shapes perceived quality more than visual fidelity; respond in under 100ms even if the work takes longer.
- Navigation should expose location, not hide it; users who cannot name where they are cannot predict where they will go.
- For AI-driven flows, show the model's next move before it happens and leave a seam for the human to intervene.

⚠️ tension: classical interaction assumes a linear flow; agentic flows are conversational and must remain interruptible mid-step.

### Shared Primitives

Principles:
- Primitives own behavior and accessibility; styling is a separate layer composed on top, so teams can restyle without re-auditing correctness.
- Composition beats configuration; small parts that combine outlast large components with twenty props.
- Ownership over dependency: primitives the product can read, fork, and modify in-repo age better than black-box imports.
- A primitive earns its place only when used in three unrelated contexts; premature abstraction is the main source of design-system debt.
- Every primitive ships with its states, tokens, and a11y contract as one unit; a component without those is a liability, not a primitive.

---

## Template

````markdown
# [Product Name] Design System

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

### Spacing and Layout
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
````

---

## Notes

- Not a coded component inventory. Shared interface primitives, not an exhaustive catalog.
- Actual coded components belong closer to implementation.
- Materialize when the product already has a strong visual language, or when agent output needs interface constraints to stay consistent.
