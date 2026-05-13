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
- What Doesn't Change names world-facing exclusions: surfaces, behaviors, and code paths the iteration deliberately leaves untouched. Intra-iteration build conventions belong in Shared Decisions, not here.

### Shared Decisions

Principles:
- Shared Decisions are cross-cutting commitments scoped to how this iteration is built: stack picks, transport choices, naming conventions, third-party library locks, integration patterns that bind across sibling specs.
- Distinguish by altitude. What Doesn't Change names world-facing exclusions; Shared Decisions name intra-iteration build commitments; per-spec Decisions in impl.md name single-spec local choices.
- One-liner per entry; rationale follows only when load-bearing. The brief is the wrong altitude for full ADR triples.
- Append-only within an iteration. A decision that flips mid-iteration rides upward propagation, it does not get overwritten silently.
- Atomic specs read Shared Decisions to inherit iteration-wide context without repeating it or hunting across siblings.

### Phases

Principles:
- A phase is a slice that can be merged, observed, and reasoned about on its own.
- Sibling phases are ordered by what they teach, not by what is easiest to build first.
- Each phase carries its own smallest viable test of the bet; a phase that cannot fail teaches nothing.
- Phase boundaries are cut-lines: unmerged phases must be droppable without invalidating what already merged.
- A bet may have multiple surfaces. Multiple roles, surfaces, or sub-systems on shared infrastructure (auth, schema, product identity) are phases of one iteration, not separate iterations. The bet is unitary when both halves are needed to validate it; splitting iterations on surface count fragments the test.
- A phase is a unit composing into the iteration: atomic, reviewable in isolation, landed in one focused pass. The trunk stays green at the phase boundary; nothing inside the phase depends on a future phase to function. The iteration is what ships; the phase is what merges.
- Phases form a DAG composing into the iteration. The `## Phases` section opens with a Phases table that is the single source of truth for the DAG. Columns: `Spec | Name | Depends on | Status`. The `Spec` column carries the kebab-case spec id matching `{spec-id}.impl.md` (`NN-name` for solo, `NNa-name / NNb-name / NNc-name` for grouped sub-specs sharing a phase number). `Depends on` is a comma-separated list of sibling spec ids; root specs use `—`. `Status` tracks `not started / in progress / done` per spec. The agent parses this table to compute execution order, detect cycles, and identify parallelizable siblings.
- One spec per row, one row per spec. The table is canonical; per-spec impl headers cross-reference the table via `**Depends on:**`. Drift between the two is the failure mode the Build mode close ritual prevents.
- Phases with no dependency between them are siblings and may execute concurrently. The iteration lands when every spec row reads `done`.

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

Explicit. World-facing exclusions: surfaces, behaviors, code paths the iteration leaves untouched.

## Shared Decisions

Cross-cutting commitments scoped to how this iteration is built. One line each.

- [Topic]: [decision]. [Rationale clause, only when load-bearing.]

## Phases

| Spec | Name | Depends on | Status |
|---|---|---|---|
| 01-name | Short name | — | not started |
| 02a-name | Short name | 01-name | not started |
| 02b-name | Short name | 01-name | not started |
| 03-name | Short name | 02a-name, 02b-name | not started |

Optional narrative paragraph after the table when framing context matters (cut-line dates, demo cohort, shipped-vs-deferred splits).

## Success Criteria

- [ ] [observable outcome]
````

---

## Notes

- Optional sections: Appetite, Loop changes.
- The first brief is often just the current live bet captured cleanly. It does not need to be novel to be worth writing down.
- The Phases table is the iteration's DAG. Per-spec impl headers cross-reference back to it via `**Depends on:**`. Build mode walks the table on every spec open; the close ritual writes the row Status back in sync with the impl header.
- Atomic spec convention: each spec is one session-executable work unit. Naming `NN-name.impl.md` solo, `NNa/NNb/NNc-name.impl.md` grouped sub-specs sharing a phase number. Spec id matches the table's `Spec` column.


