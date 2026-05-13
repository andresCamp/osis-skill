# impl.md (atomic spec)

Type: Execution plan
Question: How do we build this?
Path: `osis/{version}/{system}/{iteration-slug}/{spec-id}.impl.md`

Osis owns product thinking through tech decisions. Plan mode owns syntax and execution. The impl is the handoff boundary, and it is the only file the executing agent reads alongside the parent brief and dep specs. The impl translates product into technology: UX first (how it looks and feels), then Technology (how it gets built).

---

## Foundational principles

Gates the entire doc. Apply to every section.

- **One spec = one atomic work unit (scope, not length).** Atomic refers to what's bounded inside the spec, not how briefly it's described. A dense capture of one work unit can run 150-300 lines and that is correct. Sparse single-unit specs are the failure mode this convention prevents.
- **The impl is the only file the executing agent reads.** Plan mode loads the impl, the parent brief, and the dep specs. Anything not captured in those files is invisible at build time. The conversation log is not a source.
- **Start with the UX, work backwards to the technology.** The doc is shaped as a translation: `## UX` describes how it looks and feels; `## Technology` describes how it gets built. Authoring naturally falls into two passes: product thinking lands UX, then a technical pass resolves library and framework choices and lands Technology. UX leads; Technology serves it.
- **Do not filter. Capture every detail of the spec discussed.** The agent's only judgment is whether content is about the spec or not. Never "is this important enough" — that judgment is the dominant failure mode. If a thread, decision, edge case, behavior, or constraint came up, it lands in the file. The human prunes later; the agent never decides what to leave out.
- **Naming.** `NN-name.impl.md` for solo specs, `NNa-name.impl.md / NNb-name.impl.md / NNc-name.impl.md` for grouped sub-specs sharing a phase number. The spec id matches the parent brief's Phases-table `Spec` column.

---

## Typed structure

The impl is a typed reasoning artifact. The agent can rely on the following always being present:

- The doc is the execution plan for one atomic spec at `osis/{version}/{system}/{iteration-slug}/{spec-id}.impl.md`.
- The header carries three fields in this order: `**Iteration:**`, `**Depends on:**`, `**Status:**`.
- The body carries two H2 sections in this order: `## UX` (how it looks and feels), then `## Technology` (how it gets built).
- The body MAY carry a trailing `## Engineering Notes` H2 section, optional and appended during or after build.

Typing lives at this level. The agent reads any impl by walking these fixtures.

Inside `## UX` and `## Technology`, internal structure is adaptive: H3 subsections appear when the content warrants them (`### Decisions`, `### Architecture`, `### Key Flows`, `### Interfaces`, `### Rollout` are the canonical names when present), not as mandatory headers. Same pattern as the brief, where `## Signals` is always present but the bullets inside it adapt to the iteration.

## Section scaffolds

Reasoning principles the agent runs silently before engaging each section. Not surfaced to the user. Principles are truths, not criteria.

### UX

Principles:
- UX is the foundation of the spec. Everything in Technology serves it. Write UX first, in the product-thinking pass.
- Written from the user's seat, not the system's. Names what the user sees, what they do, what changes for them, in their language.
- Lead with the canonical happy path. Then every alternate state the user can enter: loading, empty, error, success, mid-action, mid-transition. Unstated states are unspecified UX.
- Visual fidelity is load-bearing. Specific layouts (column position, panel size, button placement, color treatment, motion behavior) get described concretely; abstractions lose the bet because the coding agent needs to know what to build, not what general shape it might take.
- Concrete over abstract. Name the specific text, the specific element, the specific gesture. "Tappable" is weaker than "click anywhere lands the cursor at that source position."
- Scope lives here: what the spec covers in the experience, and what it explicitly does not cover. Out-of-scope is part of the experience boundary.
- Pure-infra specs (PTY backends, agent hosts, telemetry pipelines) name indirect user-facing behavior: what the user experiences when the infra works, what they notice when it fails, what feature surfaces it makes possible. UX is never blank for infra; it frames the human consequence of the technical work.
- The audience is a coding agent, not a designer. Include enough detail for a fresh agent to know exactly what to build without asking the human.

### Technology

Principles:
- Technology serves UX. An architectural shape, decision, flow, or interface that does not serve a user-visible demand in the UX section is premature; cut it or move the supporting UX up.
- Authored in a second pass after UX is set. The agent resolves library and framework choices, validates API surface against current documentation for whatever stack the spec touches, and lands the technical translation of the UX commitments. How the agent fetches that documentation is the agent's concern, not the protocol's.
- Surface load-bearing decisions explicitly. When a non-obvious choice was made, write it as a Decisions table (or list) with rationale and rejected alternatives. A decision without its rejected context decays into folklore. Decisions are immutable once recorded; supersede, never edit.
- Surface architecture when the spec involves multiple components, boundaries, or data shapes. Pieces are defined by what crosses their boundaries, not what lives inside them. The shape of the data outlives the shape of the code. Coupling is a budget; each dependency must be named and justified against the spec's appetite.
- Surface internal flows when the system's sequence is load-bearing. A flow is defined by its failure modes, not its happy path; unspecified failure is specified chaos. Every flow names its actor, its trigger, its invariant, and its terminal state. Distinct from the UX section's user-visible journey; internal flows cross component boundaries.
- Surface interfaces and contracts when the spec exposes APIs, events, schemas, or component contracts. Additive change is free; removal is expensive; renaming is removal plus addition. The caller's assumptions are part of the interface whether documented or not. Errors are part of the interface; unspecified failure is an undocumented API.
- Surface rollout / migration when the spec changes user-visible state, data on disk, or deployed surface. Rollback is a first-class path, not a contingency. Old and new coexist during migration; the transition window is where the real design lives. Users experience the migration, not the plan.
- Cross-spec decisions that bind every sibling in the iteration belong in the parent brief's Shared Decisions section, not here. Decisions in this section are local to this spec.
- Internal structure is adaptive. When the content warrants it, use subsections (`### Decisions`, `### Architecture`, `### Key Flows`, `### Interfaces`, `### Rollout`); when it doesn't, prose alone is fine. The typed-ness is at the section level (`## Technology`), not at the subsection level.

⚠️ tension: canonical ADR practice records decisions post-commitment; greenfield coding-agent handoff requires them pre-commitment so the agent inherits the constraint.

### Density

Principles:
- Every detail of the spec discussed lands in the file. Reasoning, rejected alternatives, edge cases, named invariants, constraints, exact phrases the consult resolved on, every state the user can enter, every tradeoff, every consideration. The conversation log does not survive to build time; the impl does.
- The agent does not filter. The only judgment is "is this about the spec" (yes/no). Never "is this important enough" — that judgment is the dominant failure mode the previous convention let slip. If in doubt, capture.
- Verbatim language beats paraphrased summary. When the consult resolved a question with a specific phrase, invariant, constraint, or rejected alternative, that language enters the file unchanged. Paraphrase loses load-bearing detail.
- The consult ends with a density pass: sweep the conversation for any product or technical detail of the spec that did not land in the file, and add it. The human prunes later; the agent never decides what to leave out.
- Length is not a vice; sparseness is. A 250-line single-unit spec that captures every detail discussed is correct. A 60-line single-unit spec that left half the conversation in chat is broken.

### Engineering Notes

Principles:
- Engineering Notes is an optional appended section, written during or after the build. Different temporality from UX and Technology; those are authored before plan mode runs, Notes accumulates during and after.
- Discoveries propagate upward when they invalidate assumptions above, not when they're merely interesting.
- The note is written at the moment of surprise; deferred notes become rationalizations.
- Notes close the loop to the layer that made the assumption: the product doc, the thesis, or the prior spec.
- Silence in Engineering Notes means the build revealed nothing new, which is itself a signal worth questioning.
- A workaround without a named root cause is a future incident.

---

## Template

````markdown
# [Spec Name]

**Iteration:** [parent iteration slug]
**Depends on:** [comma list of sibling spec ids from the brief's Phases table, or — for roots]
**Status:** [not started / in progress / done]

## UX

Written from the user's seat. What they see, do, feel.

Canonical happy path first. Then every state they enter: loading, empty, error, mid-action, mid-transition. Visual fidelity for layouts, motions, gestures. The coding agent reads this to know what to build.

Scope of the experience: what this spec covers, what it explicitly does not.

For pure-infra specs: name the indirect human consequence (what works, what fails, what feature surfaces it makes possible).

## Technology

How it gets built, derived from the UX above.

Surface load-bearing decisions as a table or list with rationale and rejected alternatives. Surface architecture when components, boundaries, or data shapes matter. Surface internal flows when sequence is load-bearing. Surface interface contracts when APIs, events, or schemas are exposed. Surface rollout when the spec changes user-visible state, data on disk, or a deployed surface.

Subsections (`### Decisions`, `### Architecture`, `### Key Flows`, `### Interfaces`, `### Rollout`) when the content warrants them; prose alone when it doesn't.

## Engineering Notes

(Optional, appended during or after build.)

Discoveries during build. Propagate up if they change product direction.

- [Date], [Discovery]
````

---

## Notes

- Two durable typed sections: UX and Technology. The typing is at the section level; internal structure is adaptive.
- Two-pass authoring: UX in the product-thinking pass, Technology in a technical pass against current library and framework documentation.
- One spec = one atomic step. Internal sequence within the spec is plan mode's domain; if a multi-step sequence is load-bearing for authoring, use numbered subheaders inside Technology rather than a separate section.
- Length is not a vice. A 250-line single-unit spec that densely captures every detail discussed is correct. Sparseness is the failure mode this convention prevents.
- Optional sections: Performance budget, Rollback plan (when applicable).
