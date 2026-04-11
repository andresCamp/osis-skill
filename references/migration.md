# Migration Guide: Protocol v0.1.0 → v1.0.0

> Reference for existing projects upgrading to the new protocol.

---

## What Changed

The protocol moved from a phase-centric model to a clarity funnel with typed reasoning artifacts.

### Structural Changes

| Old (v0.1.0) | New (v1.0.0) | Notes |
|---|---|---|
| `{product}-v{n}/` | `{version}/` (e.g. `v1/`) | Simplified version folders |
| `phase-{N}-{slug}/` | `{iteration-slug}/` | Iteration replaces phase as the folder |
| Phase folder with system specs inside | Flat `{phase}.impl.md` files inside iteration | Phase is a doc, not a folder |
| `vision.md` (canon) | `manifesto.md` (product level) | Manifesto is the enduring declaration |
| `product-spec.md` (canon) | `product.md` (version level) | Renamed, scoped to version |
| — | `thesis.md` (version level) | New: the strategic bet for this version |
| — | `strategy.md` (version level) | New: market, wedge, GTM, success criteria |
| — | `brand.md` (product level) | New: voice, positioning, language |
| — | `design-system.md` (product level) | New: interface principles, visual language |
| — | `charter.md` (org level) | New: mission, values, decision principles |
| — | `brief.md` (iteration level) | New: signal, insight, bet |
| `game-plan.md` | Absorbed by `brief.md` + `{phase}.impl.md` | Game plan is killed |
| `{system}--product-spec.md` | `{system}-product.md` (at version level) | Simplified naming, moved up |
| `{system}--design-spec.md` | Killed | Link to designs from impl doc |
| `{system}--implementation-spec.md` | `{phase-name}.impl.md` | Renamed, flat inside iteration |
| Roadmap in product-spec Section 9 | No standalone roadmap | Structure IS the roadmap |
| `signals/` inside phase | `signals/` inside iteration | Moved up one level |
| `archive/` | Previous iterations/versions are the archive | No separate archive folder |

### osis.json Changes

| Old field | New field |
|---|---|
| `"version": "1.0"` | `"version": "1.0.0"` |
| `"productVersion"` | `"activeVersion"` |
| `"activePhase"` | Removed (iterations replace phases) |
| `"lastDriftScan"` | Removed |
| `files.vision` | `files.manifesto` |
| `files.{v}.vision` | `files.{v}.thesis` |
| `files.{v}.product-spec` | `files.{v}.product` |

### Concept Changes

| Old concept | New concept |
|---|---|
| Canon (vision + product spec) | Product level (manifesto + brand + design system) |
| Phase (the unit of work) | Iteration (product direction) containing phases (execution slices) |
| System specs inside phase | System product docs at version level |
| Specs flow down, discoveries flow up | Same, but now explicit as "upward propagation" principle |

---

## Migration Steps

> TODO: Detailed step-by-step migration procedure. Key info for when we return to this:
>
> 1. Back up existing osis/ folder
> 2. Create new product-level docs (manifesto from old vision, brand + design-system as new)
> 3. Move version docs (product-spec → product, create thesis + strategy)
> 4. Convert phases to iterations (game plan → brief, impl specs → flat impl docs)
> 5. Move signals from phase folders to iteration folders
> 6. Update osis.json to v2.0 schema
> 7. Remove archive folder (old iterations ARE the archive)
> 8. Update CLAUDE.md pointers
