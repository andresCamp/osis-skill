# product.md

Dual-altitude. Covers both `core/product.md` (top-level system, whole product or meta-product) and `{system}/product.md` (subsystem).

Reasoning principles the agent runs silently before engaging each section. Not surfaced to the user. Principles are truths, not criteria.

---

## Core (top-level system)

Type: Definition (whole product or meta-product)
Question: What is this product?
Path: `osis/{version}/core/product.md`

In single-system products, this IS the whole product. In multi-system products, this is the meta-product (composition, macro flows, how systems connect).

### Section scaffolds

#### Definition
Principles:
- A product is defined by the job it is hired to do, not the features it carries.
- Definition precedes solution; the problem statement is the highest-leverage artifact in any product.
- A product that cannot be named in a single sentence is not yet one product.
- Definition must address four risks together: value, usability, feasibility, viability; omitting any collapses the product into a wish.

⚠️ tension: canonical treats the product as a fixed artifact; greenfield (Cagan's operating model, Torres' discovery) treats it as a living hypothesis under continuous validation.

#### The Analogy
Principles:
- Analogy compresses understanding by binding the unfamiliar to something the audience already operates fluently.
- A good analogy constrains as much as it invites; the parts it breaks on are part of its signal.
- Analogy is a tool of alignment, not explanation; its job is shared mental model, not marketing.
- One load-bearing analogy outperforms several decorative ones.

#### Core Concepts
Principles:
- The set of core concepts is the ubiquitous language; if the team uses different words for the same thing, the product is not yet one product.
- Every concept resolves to a noun, a verb, or a relationship; anything else is decoration.
- Concept count is load-bearing: the fewer primitives a product exposes, the more the user can compose.
- A concept that does not appear in the UI, the data model, and the conversation is not a core concept.
- A core concept must survive contact with both user language and system behavior; concepts that live in one but not the other fracture the product into two.

#### Structure
Principles:
- Structure follows decomposability: a product is a hierarchy of near-independent parts whose interactions are weaker than their internal cohesion.
- The shape of the data model is the shape of the product; users feel the schema before they read the docs.
- Structural choices lock in later velocity; the cost of a structural mistake compounds with every feature added on top.
- Every component has one reason to exist; components with two reasons are two components wearing one name.

⚠️ tension: canonical (Simon, Brooks) frames structure as stable architecture; greenfield (Notion's block model, Linear's opinionated primitives) frames structure as the product's unique leverage, the thing competitors cannot copy cheaply.

#### Flow
Principles:
- Flow is the path a user takes from intent to outcome; every step that is not on that path is friction.
- A product has one dominant flow; everything else is a branch off it.
- Flows reveal whether the structure is correct; if the happy path requires explanation, the structure is wrong.
- The flow is described from the user's vantage, not the system's.

#### UX / Surfaces
Principles:
- A surface is where a concept becomes touchable; if a concept has no surface, it does not exist to the user.
- Surfaces should expose the smallest set of affordances that make the dominant flow obvious.
- The surface teaches the model; what is shown and what is hidden is a claim about what matters.
- The same concept rendered on different surfaces must preserve identity; a block is a block whether in a page, a database row, or a mention.

#### Behavioral Rules
Principles:
- Behavioral rules are the invariants the product refuses to violate regardless of feature pressure.
- Defaults are decisions; a product with no opinion in the default path has no point of view.
- Rules are stated as what the product will not do as often as what it will.
- A rule that bends under a good-enough reason was never a rule.

#### Boundaries
Principles:
- A product is defined as much by its non-goals as by its goals; the edge is the artifact.
- Stating what the product is not is the cheapest way to prevent wasted work downstream.
- Boundaries are versioned: they move with intention, not with drift.
- A boundary that has never been tested by a tempting request has not yet been drawn.

⚠️ tension: canonical strategy (Rumelt) treats boundaries as strategic focus; greenfield (Shape Up, founder writing) treats them as an execution guardrail against scope creep within a fixed appetite.

### Template

````markdown
# [Product] [Version] Product

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
````

### Notes

- Analogy near the top, fastest way to communicate what's being built.
- Should not include how it is built.
- Does not define internal system mechanics. Those belong in `{system}/product.md`.
- In multi-system: this is the meta-product. Other systems get their own `{system}/product.md`.
- Optional module: Loop (trigger, action, reward, investment, recurrence). Include when recurrence or compounding engagement matters. Remove when irrelevant.

---

## Subsystem (subordinate)

Type: Definition (subordinate)
Question: What is this system?
Path: `osis/{version}/{system}/product.md`

A system warrants its own folder when it's a different app, deployment, or distinct surface. Most things are features within an existing system, not new systems.

### Section scaffolds

#### Purpose
Principles:
- A subsystem has exactly one reason to exist; if it has two, it is two subsystems sharing a folder.
- Purpose is stated in the parent's language, not the subsystem's internals; it must answer "why does the whole need this part."
- Remove the system and name what breaks; that is its purpose.
- A subsystem without a purpose distinguishable from its neighbors is a naming accident.

#### The Analogy
Principles:
- The subsystem's analogy is subordinate to the product's analogy; it must compose, not compete.
- Analogy at the subsystem level clarifies the contract, not the implementation.
- A subsystem that needs a foreign metaphor is mis-scoped.

#### Inputs
Principles:
- Inputs are the full contract a subsystem accepts; anything the subsystem assumes but does not name becomes a bug.
- Inputs should be the smallest set that makes the output computable; extra inputs leak the caller's world into the subsystem.
- The shape of inputs encodes the bounded context; crossing the boundary requires translation, not passing references through.

#### Flow
Principles:
- Flow inside a subsystem is invisible by design; callers depend on behavior, not on steps.
- A subsystem's flow should be reconstructable from its inputs and outputs alone; if it is not, state is leaking.
- Branching is named; an unnamed branch is a hidden second system.
- The flow terminates; every path leads to an output or an explicit, handled failure.

#### Outputs
Principles:
- Outputs are a promise; once named, they are owed to every caller indefinitely.
- The output shape is the real API; documentation lags, the shape does not.
- A subsystem that produces side effects without naming them as outputs is lying about its contract.
- A system produces the minimum output that serves its purpose; extra output is coupling in disguise.

#### Interaction Model
Principles:
- Interaction is the protocol between subsystem and caller (synchronous, asynchronous, streaming, event) and the choice is load-bearing.
- The interaction model is a boundary, not a convenience; changing it is a breaking change even when the data is unchanged.
- Affordances match the user's next legal action; every shown control implies the system is ready to accept it.

#### Behavioral Rules
Principles:
- A subsystem enforces its own invariants; it does not trust the caller to have enforced them.
- Rules inside the boundary are hidden; rules at the boundary are documented.
- Information hiding is the source of long-term velocity; the less a caller knows, the more the subsystem can change.
- Always/never at the subsystem level protects the seam, not the feature.

#### Connections
Principles:
- Every connection is a dependency; every dependency is a coupling the system must pay for.
- Connections should be explicit, directional, and few; implicit connections become load-bearing silently.
- Coupling follows the direction of purpose; a system depends on what it needs, not on what is convenient.
- A connection without a contract is a dependency pretending not to be one.

⚠️ tension: canonical (Parnas, Alexander) minimizes connections; greenfield (microservice practice, observability) accepts more connections but demands they be observable and typed at the boundary.

#### Success Signals
Principles:
- A subsystem that cannot be observed cannot be maintained; signals are part of the contract.
- Success signals describe the subsystem's job in measurable terms; absence of errors is not success.
- The signals a subsystem emits shape which failures are visible; unobserved failure modes compound.
- The absence of an expected signal is itself a signal.

### Template

````markdown
# [System Name] Product

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
````

### Notes

- Does not redefine cross-system flows. Expands only within its boundary.
