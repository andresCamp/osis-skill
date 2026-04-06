# Osis

Build products people love, faster. Product management that lives in your codebase.

Osis is a [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that turns your AI agent into an elite product leader. It automates product strategy and documentation using frameworks from the world's best companies.

## What it does

- Thinks through a product lens — challenges assumptions, surfaces tensions, drives clarity
- Manages product specs, vision docs, changelogs, and signals inside your repo
- Discusses first, writes when aligned — never speculatively updates docs
- Uses proven frameworks: Jobs-to-be-Done, working backwards, first principles

## Install

Copy the skill into your Claude Code skills directory:

```bash
git clone https://github.com/andresCamp/osis-skill.git ~/.claude/skills/osis
```

Or add as a git submodule in your project:

```bash
git submodule add https://github.com/andresCamp/osis-skill.git skills/osis
```

Then symlink to your Claude Code skills directory:

```bash
ln -s "$(pwd)/skills/osis" ~/.claude/skills/osis
```

## Usage

Once installed, just say "osis" in any Claude Code conversation to activate the product lens. You can also:

- Share product feedback or user signals
- Ask about specs or product direction
- Discuss strategy and get challenged on assumptions
- Update product documentation when aligned

## License

MIT
