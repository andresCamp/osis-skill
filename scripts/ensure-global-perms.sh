#!/bin/bash
# Ensure the osis skill's permissions are in the user's global Claude settings.
#
# Writes to ~/.claude/settings.json so the skill directory is accessible from
# ANY project — not just projects that have run onboard.sh. This is the correct
# scope because the skill is installed globally (~/.claude/skills/osis/).
#
# Idempotent — safe to call on every activation. Only touches the file when
# something is actually missing.

set -e

SETTINGS="${HOME}/.claude/settings.json"
SKILL_DIR="${HOME}/.claude/skills/osis"

# The permissions the skill needs globally:
#   - additionalDirectories: so SKILL.md !cat/!bash preprocessing can read skill files
#   - allow rules: so the agent can run skill scripts as tool calls
RULES=(
  "Bash(bash ${SKILL_DIR}/scripts/render-header.sh)"
  "Bash(bash ${SKILL_DIR}/scripts/update-skill.sh)"
  "Bash(bash ${SKILL_DIR}/scripts/session-id.sh)"
  "Bash(bash ${SKILL_DIR}/scripts/ensure-global-perms.sh)"
  "Bash(bash ${SKILL_DIR}/scripts/onboard.sh *)"
  "Bash(bash ${SKILL_DIR}/scripts/track.sh *)"
  "Bash(curl -fsL --max-time 3 https://raw.githubusercontent.com/andresCamp/osis-skill/main/version.json)"
)

# Require jq for safe JSON manipulation of global settings.
if ! command -v jq >/dev/null 2>&1; then
  echo "⚠ jq not found — cannot auto-configure global permissions."
  echo "  Install jq or manually add to ${SETTINGS}:"
  echo "    permissions.additionalDirectories: [\"${SKILL_DIR}\"]"
  exit 1
fi

mkdir -p "$(dirname "$SETTINGS")"

# Create the file if it doesn't exist.
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

changed=false

# Ensure additionalDirectories contains the skill dir.
if ! jq -e --arg dir "$SKILL_DIR" \
  '.permissions.additionalDirectories // [] | index($dir)' \
  "$SETTINGS" >/dev/null 2>&1; then
  tmp=$(mktemp)
  jq --arg dir "$SKILL_DIR" \
    '.permissions = (.permissions // {}) | .permissions.additionalDirectories = ((.permissions.additionalDirectories // []) + [$dir] | unique)' \
    "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
  changed=true
fi

# Ensure each allow rule is present.
for rule in "${RULES[@]}"; do
  if ! jq -e --arg rule "$rule" \
    '.permissions.allow // [] | index($rule)' \
    "$SETTINGS" >/dev/null 2>&1; then
    tmp=$(mktemp)
    jq --arg rule "$rule" \
      '.permissions = (.permissions // {}) | .permissions.allow = ((.permissions.allow // []) + [$rule] | unique)' \
      "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
    changed=true
  fi
done

if [ "$changed" = true ]; then
  echo "global-perms-updated"
else
  echo "global-perms-ok"
fi
