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

Say "osis" to activate. On first run, Osis onboards into your project:

```bash
# Single product
bash ~/.claude/skills/osis/scripts/onboard.sh v1

# Monorepo / org
bash ~/.claude/skills/osis/scripts/onboard.sh --org my-org
```

This scaffolds the minimum Osis root in your repo:

```
osis/
  osis.json              ← machine state + file manifest
  README.md              ← protocol explainer
  twin.md                ← what the product IS (code in natural language)
  inbox/                 ← imported signals (pre-triage)
  {version}/
    changelog.md
    core/                ← always exists; the top-level system
```

Earned docs materialize in-session when the builder expresses them or the repo already carries them:

```
osis/
  manifesto.md           ← product declaration
  brand.md               ← voice, positioning, language
  design-system.md       ← interface principles and primitives
  {version}/
    thesis.md            ← the strategic bet
    strategy.md          ← focus and wedge (on its own session)
    core/
      product.md         ← the product definition
      {iteration-slug}/
        brief.md         ← the current bet
        signals/         ← raw inputs that informed this iteration
        {phase-name}.impl.md
    {system}/            ← only when complexity warrants
      product.md
      {iteration-slug}/
        ...
```

Onboarding is the first clarity session: the skill loads your repo as context, asks one sharp question, and captures your current thinking into the right docs as you talk.

## Modes

| Mode | What it does |
|------|-------------|
| **Onboarding** | Scans your codebase, generates a digital twin, scaffolds the v1 doc structure, and starts the first product conversation |
| **Consult** | Ingest a signal (feedback, idea, observation), discuss, route it to the right typed doc, and update docs when aligned |
| **Update** | Surface implementation discoveries back up the funnel when they change product direction |
| **Analyze** | Compare code or artifacts against docs — drift detection, feature QA, alignment checks |
| **Twin** | Re-scan codebase and regenerate the digital twin |

## Monorepo Support

For orgs with multiple products, Osis creates an org-level `osis.json` that maps products and routes conversations to the right context:

```json
{
  "protocolShape": "1.0",
  "type": "org",
  "org": "my-org",
  "products": {}
}
```

The org layer owns routing and constraints. Each product keeps its own `osis/` directory with product-level docs and version folders.

## Versioning

The skill tracks its version in `version.json` and checks for updates automatically on first interaction per conversation. No action required — you'll see a notification if a new version is available.

## Telemetry

Osis sends minimal pseudonymous usage metrics in the background to measure activation, onboarding, and update activity.

- Stable machine-scoped `userId`
- Stable repo-scoped `repoId` for onboarded repos
- Event metadata only: skill version, OS, onboarding mode, and update versions

Osis does not send repo contents or product names. To disable telemetry, set `OSIS_TELEMETRY=0`.

## Structure

```
skills/osis/
  SKILL.md             ← skill definition (loaded by the agent)
  version.json         ← skill version for auto-update checks
  CHANGELOG.md         ← release log (read by the migration flow)
  scripts/
    onboard.sh         ← minimum-root scaffold (first-run onboarding)
    update-skill.sh    ← one-tap upgrade
    render-header.sh   ← activation header + greeting
    session-id.sh      ← current session id (for doc footers)
    track.sh           ← pseudonymous telemetry
  references/
    protocol.md        ← full protocol specification
    templates.md       ← all doc templates
    onboarding.md      ← first-session playbook
    maintenance.md     ← update, analyze, twin modes
    migration.md       ← protocol-shape migration flow
    triage.md          ← inbox triage playbook
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
