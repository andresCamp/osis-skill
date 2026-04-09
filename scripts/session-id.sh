#!/bin/bash
# Print the current Claude Code session ID for the project at $PWD.
#
# Resolution: finds the most recently modified .jsonl file in
# ~/.claude/projects/<project-slug>/, where <project-slug> is the absolute
# project path with / replaced by -.
#
# Exits 1 silently if no session file is found, so callers can decide
# whether to skip the footer write rather than blocking.

set -e

SLUG=$(pwd | tr / -)
SESSION_DIR="$HOME/.claude/projects/$SLUG"

if [ ! -d "$SESSION_DIR" ]; then
  exit 1
fi

LATEST=""
LATEST_MTIME=0

for f in "$SESSION_DIR"/*.jsonl; do
  [ -e "$f" ] || continue
  # macOS uses BSD stat (-f %m), Linux uses GNU stat (-c %Y).
  MTIME=$(stat -f %m "$f" 2>/dev/null || stat -c %Y "$f" 2>/dev/null || echo 0)
  if [ "$MTIME" -gt "$LATEST_MTIME" ]; then
    LATEST="$f"
    LATEST_MTIME=$MTIME
  fi
done

if [ -z "$LATEST" ]; then
  exit 1
fi

basename "$LATEST" .jsonl
