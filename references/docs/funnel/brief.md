# brief.md

Type: Experiment
Question: What bet are we making and why?
Path: `osis/{version}/{system}/{iteration-slug}/brief.md`

The iteration lives in the system that owns the product direction. Phases inside the iteration may touch other systems' code; the brief captures that. Cross-cutting refactors with no product direction change go to the version-level changelog, not a brief.

---

## Section scaffolds

Reasoning principles the agent runs silently before engaging each section. Not surfaced to the user. Principles are truths, not criteria.

### Signals

Principles:
- A signal is a specific observation with a traceable source; without a source it is an assertion.
- Raw observation and interpretation belong in different layers; merging them destroys the ability to reinterpret later.
- Signals only earn weight through repetition, recency, or proximity to the user actually doing the job.
- One vivid signal can carry more weight than a dozen weak ones, but only if it is load-bearing for the decision that follows.
- Absence is a signal: what users did not do, did not ask for, did not return to.

### Insight

Principles:
- An insight names a pattern across signals that was not obvious from any single one.
- An insight is only useful if it reframes what to do next; a restatement of signals is not an insight.
- The sharpness of an insight is the sharpness of the problem it implies.
- An insight survives the question "what else could explain these signals?"; if the first reading is the only reading, the pattern is not yet understood.
- Insight lives above solution; naming a solution here collapses the reasoning and hides the bet.

### Bet

Principles:
- A bet is only a bet if a reasonable person could disagree with it.
- A bet names what is believed, what would make it wrong, and what would make it right.
- The cost of the bet must fit the confidence behind it; appetite is set before scope, not discovered through it.
- A bet rests on one load-bearing assumption; if that assumption fails, the rest is irrelevant.
- Expecting a bet to work is not the same as knowing why; the mechanism is the bet, not the outcome.
- A brief specifies what evidence counts as learning, not merely shipping; intent is fixed while scope is variable, and treating them as one collapses the bet into a feature list.

### What Changes

Principles:
- Change is stated as the observable difference in the world, not as the work performed to produce it.
- What changes is named for whom; change with no subject is motion, not progress.
- The change must be the smallest one that tests the bet; anything larger is scope leaking in.
- If the change cannot be described without listing tasks, the bet is not yet shaped.

### What Doesn't Change

Principles:
- Naming what is left alone is an act of commitment, not omission.
- Adjacent surfaces will pull scope toward themselves; stating their exclusion is what holds the line.
- What doesn't change marks the edges of the bet; without edges, success and failure blur.
- Preserving something on purpose is different from ignoring it; the distinction must be explicit.

### Phases

Principles:
- A phase is a slice that can be merged, observed, and reasoned about on its own.
- Sibling phases are ordered by what they teach, not by what is easiest to build first.
- Each phase carries its own smallest viable test of the bet; a phase that cannot fail teaches nothing.
- Phase boundaries are cut-lines: unmerged phases must be droppable without invalidating what already merged.
- A bet may have multiple surfaces. Multiple roles, surfaces, or sub-systems on shared infrastructure (auth, schema, product identity) are phases of one iteration, not separate iterations. The bet is unitary when both halves are needed to validate it; splitting iterations on surface count fragments the test.
- A phase is a unit composing into the iteration: atomic, reviewable in isolation, landed in one focused pass. The trunk stays green at the phase boundary; nothing inside the phase depends on a future phase to function. The iteration is what ships; the phase is what merges.
- Phases form a DAG composing into the iteration. Each phase entry begins with a heading carrying the phase slug (kebab-case, matching `{slug}.impl.md`) followed by a YAML codeblock declaring `depends_on: [<sibling-slug>, ...]`. Root phases declare `depends_on: []`. These blocks are the canonical DAG; the agent parses them to compute execution order, detect cycles, and identify parallelizable siblings.
- Phases with no dependency between them are siblings and may execute concurrently. The iteration lands when every phase node has merged.

### Success Criteria

Principles:
- A success criterion is observable from outside the team; internal confidence is not a criterion.
- Each criterion must be able to come back negative; a criterion that cannot fail is decoration.
- Leading criteria show the bet's mechanism is working; lagging criteria show the bet mattered; both are needed, and they are not interchangeable.
- The threshold is set before the result is seen, or it becomes a narrative instead of a test.
- Fewer, sharper criteria beat a dashboard; if everything matters, nothing decides.

---

## Template

````markdown
# [Iteration Name] Brief

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

### [phase-slug]

```yaml
depends_on: []
```

[what this phase ships and how it tests the bet]

## Success Criteria

- [ ] [observable outcome]
````

---

## Notes

- Optional sections: Appetite, Loop changes.
- The first brief is often just the current live bet captured cleanly. It does not need to be novel to be worth writing down.


---

## Sessions

- 2026-04-28 — Added "Phases form a DAG, not a sequence" Key Decision and YAML-codeblock `depends_on` declaration format; surgically reworded surrounding Phases principles to align (shipped to merged, ordering scoped to siblings, cut-lines reframed to merged subsets) · `claude -r f8a091a2-bca2-4185-8bea-9cef943ce3dc`
- 2026-04-28 — Reworded phase rules from "narrow working product on its own" to "atomic, reviewable in isolation, trunk-green at merge"; SWE-canonical framing per trunk-based-development and stacked-diff doctrine · `claude -r 7e8770e6-5469-40df-977e-0cacf4de1864`
- 2026-04-28 — Added bet-divergence principle (multiple surfaces on shared infrastructure are phases, not iterations) and vertical-slice principle (phases ship as narrow working products, not horizontal layers) to the Phases section · `claude -r 3d474847-90d6-4b05-9200-795b96b6f325`
