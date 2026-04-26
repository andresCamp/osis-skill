# Migration

Read this file only when `scripts/update-skill.sh` has just returned successfully (not `dev_install`). It runs as the second half of the update sequence.

The job is simple: converge the user's `osis/` folder to the current protocol shape. All operations happen in place on `osis/`. Git is the rollback. No sibling folders, no `osis-a/osis-b` swaps.

The source of truth for what to do is `CHANGELOG.md` at the skill root. Each release's `### Migration` section names the operations (legacy releases used `### Structural Changes` or briefly `### Shape`; all formats parse). This file says how to apply each operation.

## Skill Path

`${CLAUDE_SKILL_DIR}` refers to the skill's install directory (typically `~/.claude/skills/osis`). After `update-skill.sh` succeeds, this directory contains the newly installed files, including the updated `CHANGELOG.md`, `references/protocol.md`, and the per-doc files under `references/docs/`.

## Flow

```text
update-skill.sh returned success
    |
    Read osis.json at project root
    |
    Compare osis.json.protocolShape vs current protocol version
    (current version = header of ${CLAUDE_SKILL_DIR}/references/protocol.md)
    |
    ├── Match (or no protocolShape field and folder already matches
    │   current shape)
    │   |
    │   Silent no-op. Report:
    │   "✅ You're on the new version."
    │   then on a new line: `▲ What's on your mind?`
    │
    └── Mismatch
        |
        Pre-flight (silent)
        |
        Read ${CLAUDE_SKILL_DIR}/CHANGELOG.md
        |
        Collect all `### Migration` bullets (or legacy `### Shape`
        / `### Structural Changes`) from entries strictly newer than
        osis.json.protocolShape, in order from oldest to newest.
        |
        Apply each operation in order (see Operations below)
        |
        Update osis.json.protocolShape to current protocol version
        |
        Post-migration (silent)
        |
        Report warmly, then `/clear` nudge
```

## Pre-flight

Silent, no prompts. The principle: proceed seamlessly, git is the rollback.

1. `git rev-parse --abbrev-ref HEAD`. If not on `main`, note it for the final report (warn but proceed).
2. `git status --porcelain osis/`. If `osis/` has uncommitted changes, snapshot them:
   - `git add osis/`
   - `git commit -m "osis: snapshot before migration"`
   - `git push` (best effort; if push fails because no remote is set, continue silently)
3. If `osis/` is clean, skip straight to migration.

The user does not see any prompt during pre-flight. If a commit happens, it's noted in the final report.

## CHANGELOG Parsing

Read `${CLAUDE_SKILL_DIR}/CHANGELOG.md`. Collect bullets from every `### Migration` section (or legacy `### Shape` / `### Structural Changes`) belonging to a version strictly greater than the user's current `protocolShape`. Parse each bullet as `{Operation}: {details}`.

Operations to recognize:

- `Add: {path}` (legacy: `New:`, briefly `Added:`)
- `Rename: {old_path} → {new_path}` (legacy: `Rename:` for files, `Folder:` for folders, briefly `Renamed:`; folder paths end with `/`)
- `Reshape: {path}` (legacy: `Reshape:`, briefly `Reshaped:`)
- `Remove: {path}` (legacy: `Deprecate:`, briefly `Removed:`)

Path placeholders (`{version}`, `{iteration}`, `{system}`, `{phase}`) resolve against the user's `osis.json` and folder contents. For patterns containing wildcards (`phase-*/`, `iteration-*/`), enumerate matches in the user's folder and apply per match.

If an operation's source path doesn't exist in the user's folder (e.g. `Rename: vision.md → manifesto.md` when the user already migrated manually), skip that operation silently. Idempotent.

## Operations

### Rename: A → B  (legacy: `Folder: A/ → B/` for folders, briefly `Renamed:`)

`mv A B`. Byte-faithful. No content modification.

If the containing folder for `B` doesn't exist yet, create it first.

For folder paths (trailing `/` on both sides) with wildcard patterns (`phase-*/` → `iteration-*/`), enumerate matches and pick reasonable new names:

- `phase-1-ship/` → `iteration-1-ship/` (preserve the slug after the number)
- `phase-2-lifecycle/` → `iteration-2-lifecycle/`

Use `mv` for the rename. Files inside the folder move with it; no per-file operations needed unless a subsequent `Rename` or `Reshape` targets a specific file.

### Reshape: P  (legacy: briefly `Reshaped:`)

The doc at path `P` keeps its identity, but its template has changed. Rewrite its content into the new shape:

1. Read the current file at `P`.
2. Read the current template for this doc type from `${CLAUDE_SKILL_DIR}/references/docs/funnel/{doc}.md` or `${CLAUDE_SKILL_DIR}/references/docs/engine/{doc}.md`.
3. Extract the product decisions from the old content.
4. Write the new doc at `P` using the new template shape, placing decisions into the best-fit sections.
5. Any content that doesn't clearly map to a new section goes under a footer:
   ```markdown
   ---
   <!-- Preserved from previous shape. Reorganize when ready. -->
   [verbatim orphan content]
   ```

Never delete information. Osis wrote this content through product conversations; osis is just rewriting its own output in the new shape.

### Add: P  (legacy: `New: P`, briefly `Added:`)

The doc is new to the protocol at this version. Create it:

1. Scaffold an empty shell at `P` using the current template from the matching file in `references/docs/funnel/` or `references/docs/engine/`.
2. Scan the rest of `osis/` for product decisions that could seed this doc. For example, `{version}/strategy.md` might seed from wedge or positioning content in an existing product spec. `brand.md` might seed from voice or positioning notes elsewhere.
3. If obvious source content exists, draft the new doc with it. If not, leave the shell empty.
4. Either way, the file exists in the new shape. The user refines during Consult conversations.

### Remove: P  (legacy: `Deprecate: P`, briefly `Removed:`)

`git rm -f P`. The `-f` is required when `P` has just been rename-staged by a preceding `Rename` op in the same run; otherwise plain `git rm` refuses because the path has changes staged in the index. Git history preserves the file either way.

If product decisions from the removed doc should live somewhere in the new shape, a concurrent `Reshape` or `Add` entry in the same release's Migration section will describe where. The agent reads all operations for the release first, then applies them; for content absorption, extract from the removed doc before deletion.

## Post-migration

Silent, no prompts.

1. Update `osis.json`:
   - Set `protocolShape` to the current protocol version (e.g. `"1.0"`).
   - Regenerate the `files` manifest from the new folder contents, matching the schema documented in the current `references/protocol.md` (`## osis.json Schema`). The manifest may include new fields like `inbox` or new version shapes that the old folder didn't have.
   - **Forward-compat rule:** preserve every field present in the old `osis.json` that the migration agent doesn't explicitly modify. This includes `anonId`, `createdAt`, `product`, `color`, `inbox`, and any other fields the user or a later skill version may have added. The migration only touches `protocolShape`, `files`, and fields explicitly named by the release's Structural Changes.
2. Commit and push:
   - `git add osis/`
   - `git commit -m "osis: migrate to protocol v{X}"`
   - `git push` (best effort)

## Report

Short, warm, no dev-speak. Choose from these shapes based on what happened.

**Clean migration, no notes:**

```
✅ You're on the new version. Your docs are in the new shape and committed.

Run /clear and say osis to pick up.
```

**Migration with content preserved under footer comments:**

```
✅ You're on the new version. Your docs are in the new shape and committed. A few places have preserved content at the bottom (marked with comments) you may want to reorganize.

Run /clear and say osis to pick up.
```

**Migration with notes (non-main branch, no git remote, etc.):**

```
✅ You're on the new version. Your docs are in the new shape.

A few notes:
  • {one-line note, e.g. "You're on branch 'feature/x' so changes aren't on main"}
  • {one-line note, e.g. "No git remote set, so nothing was pushed"}

Run /clear and say osis to pick up.
```

The report is the complete user-facing output for the update sequence. Do not append `▲ What's on your mind?` after migration ran. The `/clear` nudge is the transition.

## Language Rules

Never use in any user-facing output (release banner, report, HTML comments in docs): `migration`, `migrated`, `migrating`, `upgrade`, `upgraded`, `breaking change`, `schema`, `protocol drift`, `v0`, `v1.0.0`, `legacy`, `converted`, `transformed`.

Use instead: `new version`, `new shape`, `new docs`, `committed`, `ready`, `preserved`.

Never use em dashes (`—`). Use commas, periods, colons, or parentheses.

## Edge Cases

- **No `osis.json`**: fresh repo, no migration needed. The skill runs onboarding instead. Not this mode's concern.
- **No `protocolShape` field in `osis.json`**: assume the folder is on the earliest documented shape. Walk CHANGELOG from the first entry forward and apply all structural changes.
- **`osis/` folder doesn't exist**: no migration possible. Skip silently.
- **Source path missing for a `Rename`**: skip that operation (idempotent).
- **Monorepo (`type: "org"`)**: run the full migration flow once per product path the org `osis.json` references, plus the org-level `osis/` itself. Combine reports.
- **Existing orphan backup folders (`osis.backup-*/`, `osis-a/`, `osis-b/`)**: leave them alone. They are not part of the active osis folder.
- **Git push fails**: continue silently. Note in the report if relevant.
- **`git commit` fails due to a pre-commit hook**: surface the hook output in the report and ask the user how to proceed. Do not bypass the hook.

## Not This Mode's Job

- Deciding whether to update. That's the Auto-Update section in `SKILL.md`.
- Reshaping docs the user has clearly hand-edited beyond osis's output (rare, but the agent uses judgment; when in doubt, preserve under a footer comment and let the user decide).
- Running a twin rescan. Old twin stays as-is unless the CHANGELOG explicitly reshapes it.
- Teaching the user about the protocol. That happens during Consult, not during the update flow.
