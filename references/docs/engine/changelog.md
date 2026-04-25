# changelog.md (decision record)

Type: Decision record
Question: What shipped and what drifted?
Path: `osis/{version}/changelog.md`

One per version. Single source of truth for all iterations in that version.

---

## Section scaffolds

Reasoning principles the agent runs silently before engaging each section. Not surfaced to the user. Principles are truths, not criteria.

### Entry header (date, change name)

Principles:
- An entry is a time-anchored identity: the date fixes it in history, the name makes it referenceable by everyone downstream.
- Reverse-chronological order is how humans actually read history; the top of the file is the present.
- Naming at the altitude of user-visible change beats naming at the altitude of implementation.
- The changelog records user-meaningful change, not repository exhaust; commits belong to git, decisions belong here.

### Changes

Principles:
- What shipped is the fact; why it shipped is the memory that prevents the next team from undoing it.
- Grouping by kind (added, changed, removed, fixed) is what turns a list into a scannable artifact.
- Concrete magnitudes and named surfaces carry more information than adjectives about improvement.

### Drift

Principles:
- Every shipped thing diverges from its spec; unrecorded divergence compounds into incoherence.
- Naming drift is not an admission of failure; it is the mechanism by which spec and reality stay in dialogue.
- Drift that is observed and logged stops being risk and becomes input.

### Follow-up

Principles:
- An action item without an owner and a trigger is a wish; the record of the decision must carry the record of who moves next.
- Postmortems without follow-through create the illusion of improvement while degrading it.
- Follow-ups are promises to the future self of the team; their value is the cost of breaking them.

---

## Template

````markdown
# Changelog

## [Date], [Change Name]

### Changes
- `[file]`, what changed and why

### Drift
- **[Drift]** `[file]`, spec says X, code does Y
- **[Missing]** `[file]`, code with no spec
- **[Stale]** `[file]`, spec references dead code

### Follow-up
- [ ] [action needed]
````

---

## Notes

- A changelog entry should make sense to someone reading it months later with no context.
- Group multiple findings from a single Analyze pass under one date heading.
