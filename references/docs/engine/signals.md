# signals.md (raw intel)

Type: Raw intel
Question: What did we observe before interpretation?
Path: `osis/{version}/{system}/{iteration-slug}/signals/{date}--{slug}.md` or `osis/inbox/{date}--{slug}.md`

Signals can live at root (inbox, pre-triage) or inside an iteration (post-triage). Triage mode routes inbox items into iteration signals, doc updates, or discards.

---

## Section scaffolds

Reasoning principles the agent runs silently before engaging each section. Not surfaced to the user. Principles are truths, not criteria.

### Frontmatter (type, date, source, summary)

Principles:
- Metadata decays slower than memory; the fields captured at moment-of-capture are the only ones recoverable later.
- A signal routes on type, timestamps when it occurred, sources who it came from, and summarizes in the language of the observed, not the observer.
- Searchability is a function of consistency in the shallow fields; drift in the header fractures the corpus.
- Provenance is part of the content; frontmatter carries source, date, confidence, and whether interpretation has occurred. A signal without provenance cannot be weighed against another.

### Body (raw content)

Principles:
- Raw observation decays when interpretation is entangled with it; the observation and the inference must survive as separable artifacts.
- Fidelity lives in the subject's own words, behaviors, and artifacts, not in the scribe's paraphrase of the point.
- What is emotionally vivid, contradictory, or surprising is load-bearing; smoothing it out destroys the signal.
- A body written to prove a thesis stops being intel and becomes argument.

---

## Template

````markdown
---
type: [observation | feedback | research | transcript | metric]
date: [YYYY-MM-DD]
source: [where this came from]
summary: [one-line summary of what was observed]
---

[Raw content. However messy. The brief extracts the insight.
Do not interpret here. Raw only.]
````

---

## Notes

- Raw over interpreted. Keep the observation separate from the synthesis that lives in `brief.md`.
- The one-line summary should stay neutral and observational. Name what was observed, not the interpretation that belongs in `brief.md`.
