# Osis

Build products people love, faster. Product management that lives in your codebase.

Osis is an agent skill that turns your CLI coding agent into an elite product leader. It is a typed reasoning system for product development that keeps clean, evolving product context in your repo.

## What it does

- Thinks through a product lens — challenges assumptions, surfaces tensions, drives clarity
- Maintains a clarity funnel inside your repo: manifesto, thesis, product, strategy, briefs, implementation docs
- Discusses first, writes when aligned — never speculatively updates docs
- Uses proven frameworks: JTBD, PR/FAQ, North Star, loops, non-goals
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
bash ~/.claude/skills/osis/scripts/bootstrap.sh v1

# Monorepo / org
bash ~/.claude/skills/osis/scripts/bootstrap.sh --org my-org
```

This scaffolds a product documentation structure in your repo:

```
osis/
  osis.json              ← machine state + file manifest
  README.md              ← protocol explainer
  manifesto.md           ← product declaration
  brand.md               ← voice, positioning, language
  design-system.md       ← interface principles and primitives
  twin.md                ← what the product IS (code → natural language)
  {version}/             ← what the product is BECOMING
    thesis.md
    product.md
    strategy.md
    changelog.md
    {system}-product.md  ← optional, for multi-system products
    {iteration-slug}/
      brief.md
      signals/           ← raw inputs that informed decisions
      {phase-name}.impl.md
```

## Modes

| Mode | What it does |
|------|-------------|
| **Bootstrap** | Scans your codebase, generates a digital twin, scaffolds the v1 doc structure, and starts the first product conversation |
| **Consult** | Ingest a signal (feedback, idea, observation), discuss, route it to the right typed doc, and update docs when aligned |
| **Update** | Surface implementation discoveries back up the funnel when they change product direction |
| **Analyze** | Compare code or artifacts against docs — drift detection, feature QA, alignment checks |
| **Twin** | Re-scan codebase and regenerate the digital twin |

## Monorepo Support

For orgs with multiple products, Osis creates an org-level `osis.json` that maps products and routes conversations to the right context:

```json
{
  "version": "1.0.0",
  "type": "org",
  "org": "my-org",
  "products": {}
}
```

The org layer owns routing and constraints. Each product keeps its own `osis/` directory with product-level docs and version folders.

## Versioning

The skill tracks its version in `version.json` and checks for updates automatically on first interaction per conversation. No action required — you'll see a notification if a new version is available.

## Structure

```
skills/osis/
  SKILL.md             ← skill definition (loaded by the agent)
  version.json         ← skill version for auto-update checks
  scripts/
    bootstrap.sh            ← project scaffolding script
  references/
    protocol.md        ← full protocol specification
    templates.md       ← all spec templates
    drift-scan.md      ← automated drift scan setup
```

## Development

To work on the skill locally, clone the repo and symlink it into your Claude Code skills directory:

```bash
# Clone the skill repo (skip if you already have it)
git clone https://github.com/andresCamp/osis-skill.git

# Remove any existing install
rm -rf ~/.claude/skills/osis

# Symlink your local clone
ln -s "$(pwd)/osis-skill" ~/.claude/skills/osis
```

The symlink tells Osis you're a dev — the auto-update check will print `dev_install` and skip downloading, so it won't clobber your local changes. Pull updates yourself with `git pull` inside the repo.

To go back to the regular install:

```bash
rm ~/.claude/skills/osis
npx skills add andresCamp/osis-skill
```

## License

MIT
