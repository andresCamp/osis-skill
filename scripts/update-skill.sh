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
# to an upgrade. The matching Bash allow rule is granted by init.sh on first
# bootstrap, so the agent runs it prompt-free.
set -e

if [ -L "$HOME/.claude/skills/osis" ]; then
  echo "dev_install"
  exit 0
fi

npx skills add andresCamp/osis-skill
