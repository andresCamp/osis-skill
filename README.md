# Osis

Build products people love, faster. Product management that lives in your codebase.

Osis is an agent skill that turns your CLI coding agent into an elite product leader. It automates product strategy and documentation using frameworks from the world's best companies.

## What it does

- Thinks through a product lens — challenges assumptions, surfaces tensions, drives clarity
- Manages product specs, vision docs, changelogs, and signals inside your repo
- Discusses first, writes when aligned — never speculatively updates docs
- Uses proven frameworks: Jobs-to-be-Done, working backwards, first principles
- Supports monorepos with multi-product orchestration
- Auto-update notifications via `version.json`

## Install

```bash
npx skills add andresCamp/osis-skill
```

Then say "osis" in any conversation with your agent.

## Usage

Say "osis" to activate. On first run, Osis bootstraps your project:

```bash
# Single product
bash ~/.claude/skills/osis/scripts/init.sh myapp-v1

# Monorepo / org
bash ~/.claude/skills/osis/scripts/init.sh --org my-org
```

This scaffolds a product documentation structure in your repo:

```
osis/
  osis.json              ← machine state + config
  twin.md                ← what the product IS (code → natural language)
  {product}-v{n}/        ← what the product is BECOMING
    vision.md
    product-spec.md
    changelog.md
    phase-{N}-{slug}/
      game-plan.md
      signals/           ← raw inputs that informed decisions
```

## Modes

| Mode | What it does |
|------|-------------|
| **Bootstrap** | Scans your codebase, generates a digital twin, seeds vision and product spec |
| **Consult** | Ingest a signal (feedback, idea, observation), discuss, update specs when aligned |
| **Update** | Surface implementation discoveries back into specs |
| **Analyze** | Compare code or artifacts against specs — drift detection, feature QA, alignment checks |
| **Twin** | Re-scan codebase and regenerate the digital twin |

## Monorepo Support

For orgs with multiple products, Osis creates an org-level `osis.json` that maps products and routes conversations to the right context:

```json
{
  "type": "org",
  "org": "my-org",
  "products": {},
  "files": {
    "twin": "osis/twin.md",
    "vision": "osis/vision.md"
  }
}
```

Each product gets its own versioned spec directory while sharing the org-level twin and vision.

## Versioning

The skill tracks its version in `version.json` and checks for updates automatically on first interaction per conversation. No action required — you'll see a notification if a new version is available.

## Structure

```
skills/osis/
  SKILL.md             ← skill definition (loaded by the agent)
  version.json         ← skill version for auto-update checks
  scripts/
    init.sh            ← project scaffolding script
  references/
    protocol.md        ← full protocol specification
    templates.md       ← all spec templates
    drift-scan.md      ← automated drift scan setup
```

## License

MIT
