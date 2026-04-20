#!/bin/bash
# Render the osis activation header — horizontal layout with color support.
#
# Runs as SKILL.md bash injection preprocessing on skill activation. The
# output is inlined into SKILL.md before Claude sees it, so this isn't a
# tool call — no permission rule needed, no visible activity in the
# conversation view.
#
# Layout: mark left, copy right, side-by-side (the original horizontal).
# The context line (product · phase) is colored using ANSI codes, driven
# by the `color` field in osis/osis.json.
#
# If CWD has no osis/osis.json, context becomes "Ready to onboard".

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Self-healing: ensure global permissions are configured so the skill works
# in every project, not just those that have run onboard.sh.
bash "$SCRIPT_DIR/ensure-global-perms.sh" >/dev/null 2>&1 || true

# Extract version from version.json
VERSION=$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$SKILL_DIR/version.json" | head -1)
[ -z "$VERSION" ] && VERSION="unknown"

# Read product/org name and activeVersion from CWD's osis/osis.json if it exists.
# Resolution order for the header's product slot:
#   1. osis.json `product` field (type: "product")
#   2. osis.json `org` field (type: "org")
#   3. Current directory basename (always, when the above are null or missing)
# OSIS_SCAFFOLDED drives the greeting flavor (bootstrap vs returning).
OSIS_SCAFFOLDED=false
PRODUCT=""
ACTIVE_VERSION=""
if [ -f "osis/osis.json" ]; then
  OSIS_SCAFFOLDED=true
  TYPE=$(sed -n 's/.*"type"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' osis/osis.json | head -1)
  if [ "$TYPE" = "org" ]; then
    PRODUCT=$(sed -n 's/.*"org"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' osis/osis.json | head -1)
  else
    PRODUCT=$(sed -n 's/.*"product"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' osis/osis.json | head -1)
    ACTIVE_VERSION=$(sed -n 's/.*"activeVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' osis/osis.json | head -1)
  fi
fi
# Always fall back to repo directory basename so the header info column
# never shows a stale "Osis" placeholder when a real project name is available.
if [ -z "$PRODUCT" ]; then
  PRODUCT=$(basename "$(pwd)")
fi

# Current date (full weekday + month + day + year)
DATE=$(date "+%A, %B %-d, %Y")

# Pick a time-of-day opening phrase for the greeting.
HOUR=$(date +%H)
HOUR_INT=$((10#$HOUR))

if [ $HOUR_INT -ge 5 ] && [ $HOUR_INT -lt 12 ]; then
  OPENINGS=(
    "Good morning 👋"
    "Morning 👋"
    "Rise and shine 👋"
  )
elif [ $HOUR_INT -ge 12 ] && [ $HOUR_INT -lt 18 ]; then
  OPENINGS=(
    "Good afternoon 👋"
    "Welcome back 👋"
    "Nice to see you 👋"
    "Afternoon 👋"
  )
elif [ $HOUR_INT -ge 18 ] && [ $HOUR_INT -lt 22 ]; then
  OPENINGS=(
    "Good evening 👋"
    "Welcome back 👋"
    "Nice to see you 👋"
    "Evening 👋"
  )
else
  OPENINGS=(
    "Burning the midnight oil 🌙"
    "Still at it 🌙"
    "Night owl 🌙"
    "Welcome back 🌙"
  )
fi

OPENING="${OPENINGS[$((RANDOM % ${#OPENINGS[@]}))]}"

if [ "$OSIS_SCAFFOLDED" = false ]; then
  GREETING="Welcome to Osis 👋 Let's set up ${PRODUCT}."
else
  GREETING="${OPENING} Let's keep building ${PRODUCT}."
fi

# Horizontal layout: mark left, copy right.
LOGO_FILE="$SKILL_DIR/assets/logo.txt"

# Info column — 6 rows to match the 6-line logo.
# Row 1: glyph + bold brand + version + link. Row 2: italic tagline.
# Row 3: empty. Row 4: bold product + phase. Row 5: date. Row 6: empty.
INFO=()
INFO+=("▲ **Osis** v${VERSION} · [osis.dev](https://www.osis.dev)")
INFO+=("*Build products people love, faster*")
INFO+=("⠀")
INFO+=("⠀")
INFO+=("**${PRODUCT}** · ${ACTIVE_VERSION:-}")
INFO+=("${DATE}")

LOGO_WIDTH=16

echo '⠀'

if [ -f "$LOGO_FILE" ]; then
  i=0
  while IFS= read -r logo_line || [ -n "$logo_line" ]; do
    char_count=$(printf '%s' "$logo_line" | wc -m | tr -d ' ')
    pad_count=$((LOGO_WIDTH - char_count))
    if [ $pad_count -gt 0 ]; then
      pad=$(printf '%*s' "$pad_count" '')
    else
      pad=''
    fi
    printf "%s%s${INFO[$i]:-}\n" "$logo_line" "$pad"
    i=$((i + 1))
  done < "$LOGO_FILE"
else
  for line in "${INFO[@]}"; do
    [ -n "$line" ] && echo "$line"
  done
fi

echo '⠀'
echo '⠀'
echo "$GREETING"

# Fire-and-forget telemetry. Backgrounded with its own curl timeout so it
# cannot block the activation render.
(bash "$SCRIPT_DIR/track.sh" skill_activated >/dev/null 2>&1 &) 2>/dev/null || true
