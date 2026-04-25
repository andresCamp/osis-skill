# thesis.md

Type: Hypothesis
Question: What bet is this version making?
Path: `osis/{version}/thesis.md`

---

## Section scaffolds

Reasoning principles the agent runs silently before engaging each section. Not surfaced to the user. Principles are truths, not criteria.

### Conviction

Principles:
- A thesis must be falsifiable or it is a wish; a bet that cannot be disagreed with is not a bet.
- A conviction names a contrarian secret: what you believe that consensus does not yet price in.
- A version commits to one dominant bet; hedging across every direction is the absence of strategy.
- A conviction is stated plainly enough that a competent outsider can reject it on first read.
- A thesis asserts a change in the world, not a feature you intend to ship.

### Why Now

Principles:
- Timing rests on an enabling condition that was false last cycle and is true this one.
- "Why now" must point to a specific unlock (capability, cost, behavior, regulation), not to generalized momentum.
- A window that has been open for years is not a window; if the answer to "why not two years ago" is weak, the bet is late or premature.
- Market readiness and technical readiness are separate gates; both must clear in the same version.

⚠️ tension: canonical framing favors patient timing against consensus; current AI-cycle writing pressures teams to ship into open windows before the frame closes. Resolve by naming the unlock, not the trend.

### Assumptions

Principles:
- Every thesis rests on a small set of leap-of-faith assumptions; naming them is the work, not a preamble to it.
- Assumptions split into value (users will derive worth) and growth (users will arrive and stay); both must be stated before either is tested.
- An unnamed assumption is an unpriced risk; the riskiest assumption is the one currently treated as obvious.
- Assumptions are ranked by how much of the thesis collapses if the assumption is false.
- Assumptions belong to a version; when a version ships, assumptions graduate to evidence or to corrections in the next thesis.

### Falsifiability

Principles:
- Falsifiability requires a signal, a threshold, and a deadline stated in advance; without all three, the thesis cannot lose.
- Kill criteria are written before the work begins, while the team is still able to disagree with itself.
- A pre-mortem surfaces the failure modes that success-framing hides; the thesis incorporates them as watch conditions.
- Evidence counts against the thesis only if it was specified as disconfirming before it arrived; post-hoc reinterpretation is not learning.
- A thesis that survives its version without encountering its own kill conditions was tested against the wrong conditions.
- Disconfirming evidence is strategically high-value early; the more you invest before testing, the more expensive each reversal becomes.

---

## Template

````markdown
# [Product] [Version] Thesis

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
````

---

## Notes

- Optional section: Alternatives Rejected, Constraints.
- The first version thesis can start rough. Its job is to capture the current strategic bet, not to sound final.
