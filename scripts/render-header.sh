#!/bin/bash
# Render the osis activation header — mark + dynamic info, side-by-side.
#
# Runs as SKILL.md bash injection preprocessing on skill activation. The
# output is inlined into SKILL.md before Claude sees it, so this isn't a
# tool call — no permission rule needed, no visible activity in the
# conversation view.
#
# Layout (Claude Code style):
#   [logo row 1]  **Osis** v{version} · www.osis.dev
#   [logo row 2]  Build products people love, faster
#   [logo row 3]
#   [logo row 4]  {product} · {activePhase}    (from ./osis/osis.json in CWD)
#   [logo row 5]  {current date}
#   [logo row 6]
#
# If CWD has no osis/osis.json, row 4 becomes "Ready to bootstrap a product".

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Extract version from version.json
VERSION=$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$SKILL_DIR/version.json" | head -1)
[ -z "$VERSION" ] && VERSION="unknown"

# Read product + activePhase from CWD's osis/osis.json if it exists
PRODUCT=""
PHASE=""
if [ -f "osis/osis.json" ]; then
  PRODUCT=$(sed -n 's/.*"product"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' osis/osis.json | head -1)
  PHASE=$(sed -n 's/.*"activePhase"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' osis/osis.json | head -1)
fi

# Compose the project context line
if [ -n "$PRODUCT" ] && [ -n "$PHASE" ]; then
  CONTEXT="${PRODUCT} · ${PHASE}"
elif [ -n "$PRODUCT" ]; then
  CONTEXT="${PRODUCT}"
else
  CONTEXT="Ready to bootstrap a product"
fi

# Current date (full weekday + month + day + year)
DATE=$(date "+%A, %B %-d, %Y")

# Pick a time-of-day opening phrase for the greeting. Each bucket has 3-4
# variants; we random-pick per activation for variety so the skill doesn't
# always say the exact same "Good morning". The suffix is fixed:
# "Let's keep building [product name]." — only the opening phrase rotates.
HOUR=$(date +%H)
HOUR_INT=$((10#$HOUR))  # 10# forces base-10 (handles "08", "09" without octal parse errors)

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

# Random pick from the variant list
OPENING="${OPENINGS[$((RANDOM % ${#OPENINGS[@]}))]}"

# Assemble the final greeting line. Fresh bootstraps (no osis.json) get a
# fixed welcome message because "Let's keep building your product" is awkward
# when you haven't started anything yet — it's the user's first interaction
# with Osis, so we explicitly welcome them. Existing projects get the rotated
# opening phrase + "Let's keep building [product]" suffix as before.
if [ -z "$PRODUCT" ]; then
  GREETING="Welcome to Osis 👋 Let's set up your product."
else
  GREETING="${OPENING} Let's keep building ${PRODUCT}."
fi

# Info column — 6 rows to match the 6-line logo.
# Row 1 uses markdown `**Osis**` for bold rendering and `[text](url)` for a
# clickable link. These render live in Claude Code's markdown UI (bold gets
# the terminal's native bold weight, the URL becomes clickable). We are NOT
# wrapping the header in a code block — that would make markdown literal and
# lose bold + link. Instead, line 1 of the logo uses braille blank characters
# (U+2800) for its leading "spaces", which markdown preserves because they're
# not whitespace to it. Lines 2-6 use regular spaces and are preserved as
# mid-paragraph continuations.
INFO=(
  "**Osis** v${VERSION} · [www.osis.dev](https://www.osis.dev)"
  "Build products people love, faster"
  ""
  "${CONTEXT}"
  "${DATE}"
  ""
)

# Read and print the logo side-by-side with the info column.
# logo.txt is pre-padded to a consistent visible width per line, so we just
# concatenate with a 2-space gap.
LOGO_FILE="$SKILL_DIR/assets/logo.txt"
if [ ! -f "$LOGO_FILE" ]; then
  # Fall back to info column only if logo is missing
  for line in "${INFO[@]}"; do
    [ -n "$line" ] && echo "$line"
  done
  exit 0
fi

# Pad each logo line to LOGO_WIDTH visible characters so the info column
# aligns cleanly. We use `wc -m` (character count) instead of bash's ${#var}
# or awk's length() because the logo uses multi-byte braille characters —
# only `wc -m` reliably counts code points on both macOS (BSD) and Linux.
LOGO_WIDTH=20
# Emit a divider line at the top, then the header. The divider uses Unicode
# box-drawing characters (U+2500 ─) rather than markdown `---`, so it's a
# real visible glyph regardless of markdown interpretation — no need to
# worry about setext-h2 collisions or blank-line requirements for horizontal
# rules. ~56 chars wide to roughly match the header's visual width.
echo '────────────────────────────────────────────────────────'
echo ''

# Then the header lines themselves (logo + info column, side-by-side).
i=0
while IFS= read -r logo_line || [ -n "$logo_line" ]; do
  char_count=$(printf '%s' "$logo_line" | wc -m | tr -d ' ')
  pad_count=$((LOGO_WIDTH - char_count))
  if [ $pad_count -gt 0 ]; then
    pad=$(printf '%*s' "$pad_count" '')
  else
    pad=''
  fi
  printf '%s%s  %s\n' "$logo_line" "$pad" "${INFO[$i]:-}"
  i=$((i + 1))
done < "$LOGO_FILE"

# Blank line, then the time-aware greeting (variant picked above).
echo ''
echo "$GREETING"
