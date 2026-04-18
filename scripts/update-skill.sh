#!/bin/bash
# Update the osis skill via the upstream installer.
#
# Output contract:
#   "dev_install" if ~/.claude/skills/osis is a symlink (skill author's dev
#     install — we must not clobber the symlink with downloaded files).
#   Otherwise runs `npx skills add andresCamp/osis-skill` and returns its
#     output.
#
# SKILL.md auto-update step invokes this exact command when the user agrees
# to an upgrade. The matching Bash allow rule is granted by onboard.sh on first
# onboarding, so the agent runs it prompt-free.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_FILE="$SCRIPT_DIR/../version.json"

read_version() {
  sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$1" 2>/dev/null | head -1
}

OLD_VERSION="unknown"
[ -f "$VERSION_FILE" ] && OLD_VERSION=$(read_version "$VERSION_FILE")

if [ -L "$HOME/.claude/skills/osis" ]; then
  echo "dev_install"
  exit 0
fi

npx skills add andresCamp/osis-skill

NEW_VERSION="unknown"
[ -f "$VERSION_FILE" ] && NEW_VERSION=$(read_version "$VERSION_FILE")

bash "$SCRIPT_DIR/track.sh" skill_updated "from=${OLD_VERSION}" "to=${NEW_VERSION}" >/dev/null 2>&1 || true
