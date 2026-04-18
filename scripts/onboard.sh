#!/bin/bash
# Initialize osis doc structure for a project (first-run onboarding)
# Usage:
#   bash onboard.sh [product-version]         — scaffold product osis
#   bash onboard.sh --org [org-name]          — scaffold org osis (monorepo)
# Examples:
#   bash onboard.sh v1
#   bash onboard.sh --org cloudnine

set -e

# Grant the osis skill the permissions it needs to run prompt-free:
#
#   1. `permissions.additionalDirectories`: points at ~/.claude/skills/osis/
#      so Claude Code trusts the entire skill directory like it's part of the
#      project. Silently grants Read access to SKILL.md, references/*, scripts/*,
#      and anything else bundled with the skill. This is the documented Anthropic
#      mechanism for "grant file access" (see Claude Code permissions docs).
#
#   2. `permissions.allow` Bash exact-match rules:
#      - bash invocation of scripts/render-header.sh: runs as SKILL.md bash
#        injection preprocessing on activation to compose the Claude-Code-style
#        header (logo + dynamic info). Zero tool calls visible, but `bash` still
#        requires an explicit allow rule.
#      - bash invocation of scripts/update-skill.sh: the one-tap upgrade flow,
#        runs as an agent tool call when the user says yes to the release banner.
#      - bash invocation of scripts/track.sh: fire-and-forget telemetry for
#        activation, onboarding, and upgrade events.
#
#      Note: the auto-update remote version check (`curl ...`) also runs as
#      SKILL.md bash injection, but its exact-match allow rule is handled
#      separately via the ancient settings.local.json history — keep it there
#      so the curl works prompt-free. (TODO: consider migrating it into this
#      rules array for consistency.)
#
# Expands $HOME at write time so each user gets rules with their own absolute
# paths. Idempotent — safe to re-run.
ensure_skill_permissions() {
  local settings=".claude/settings.local.json"
  local skill_dir="${HOME}/.claude/skills/osis"
  local rules=(
    "Bash(bash ${skill_dir}/scripts/render-header.sh)"
    "Bash(bash ${skill_dir}/scripts/update-skill.sh)"
    "Bash(bash ${skill_dir}/scripts/onboard.sh *)"
    "Bash(bash ${skill_dir}/scripts/track.sh *)"
    "Bash(bash ${skill_dir}/scripts/session-id.sh)"
    'Bash(curl -fsL --max-time 3 https://raw.githubusercontent.com/andresCamp/osis-skill/main/version.json)'
  )

  mkdir -p .claude

  if [ ! -f "$settings" ]; then
    # Build a fresh settings file with additionalDirectories + allow rules.
    {
      echo '{'
      echo '  "permissions": {'
      echo '    "additionalDirectories": ['
      echo "      \"${skill_dir}\""
      echo '    ],'
      echo '    "allow": ['
      local i
      for i in "${!rules[@]}"; do
        if [ "$i" -lt $((${#rules[@]} - 1)) ]; then
          echo "      \"${rules[$i]}\","
        else
          echo "      \"${rules[$i]}\""
        fi
      done
      echo '    ]'
      echo '  }'
      echo '}'
    } > "$settings"
    return
  fi

  # Merge additionalDirectories if not already present.
  if ! grep -qF "$skill_dir" "$settings"; then
    if command -v jq >/dev/null 2>&1; then
      local tmp
      tmp=$(mktemp)
      jq --arg dir "$skill_dir" \
        '.permissions = (.permissions // {}) | .permissions.additionalDirectories = ((.permissions.additionalDirectories // []) + [$dir] | unique)' \
        "$settings" > "$tmp" && mv "$tmp" "$settings"
    else
      echo ""
      echo "⚠ Could not auto-add osis skill dir to $settings."
      echo "  Add this entry to permissions.additionalDirectories manually:"
      echo "    \"${skill_dir}\""
      echo ""
    fi
  fi

  # Merge any missing allow rules into the existing file.
  local rule
  for rule in "${rules[@]}"; do
    if grep -qF "$rule" "$settings"; then
      continue
    fi

    if command -v jq >/dev/null 2>&1; then
      local tmp
      tmp=$(mktemp)
      jq --arg rule "$rule" \
        '.permissions = (.permissions // {}) | .permissions.allow = ((.permissions.allow // []) + [$rule] | unique)' \
        "$settings" > "$tmp" && mv "$tmp" "$settings"
    else
      echo ""
      echo "⚠ Could not auto-add osis skill permission to $settings."
      echo "  Add this line to permissions.allow manually:"
      echo "    \"${rule}\""
      echo ""
    fi
  done
}

ensure_skill_permissions || true

# Also ensure global permissions so the skill works in every project.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$SCRIPT_DIR/ensure-global-perms.sh" >/dev/null 2>&1 || true

# Org mode
if [ "$1" = "--org" ]; then
  ORG="${2:-my-org}"

  if [ -d "osis" ] && [ -f "osis/osis.json" ]; then
    echo "osis/ already exists. Aborting."
    exit 1
  fi

  mkdir -p "osis"

  # Stable repo anonId for telemetry.
  if command -v uuidgen >/dev/null 2>&1; then
    ORG_ANON_ID=$(uuidgen | tr '[:upper:]' '[:lower:]')
  elif [ -r /proc/sys/kernel/random/uuid ]; then
    ORG_ANON_ID=$(cat /proc/sys/kernel/random/uuid)
  else
    ORG_ANON_ID="r-$RANDOM$RANDOM-$(date +%s)"
  fi

  # Create org osis.json atomically — tempfile + rename so a partial write
  # can't corrupt the anonId and force later telemetry to emit null repoId.
  TMP_OSIS_JSON=$(mktemp "osis/.osis.XXXXXX" 2>/dev/null) || TMP_OSIS_JSON="osis/osis.json.tmp.$$"
  cat > "$TMP_OSIS_JSON" << EOF
{
  "protocolShape": "1.0",
  "type": "org",
  "org": "${ORG}",
  "anonId": "${ORG_ANON_ID}",
  "createdAt": "$(date -u +%FT%TZ)",
  "products": {}
}
EOF
  mv "$TMP_OSIS_JSON" "osis/osis.json"

  # Create repo-map twin placeholder
  cat > "osis/twin.md" << 'EOF'
# Repo Map Twin

Agent-readable map of the products and systems in this repo.

<!-- Generated during osis onboarding -->
EOF

  echo ""
  echo "Created org osis structure:"
  echo ""
  echo "  osis/"
  echo "    osis.json      (type: org)"
  echo "    twin.md"
  echo ""
  echo "Next steps:"
  echo "  1. Add products to osis.json"
  echo "  2. Run 'osis' to onboard the primary product"
  echo "  3. Add charter.md later if shared parent constraints become real"
  echo ""

  bash "$SCRIPT_DIR/track.sh" skill_onboarded mode=org >/dev/null 2>&1 || true
  exit 0
fi

# Product mode (default)
VERSION="${1:-v1}"
BASE="osis/${VERSION}"

if [ -d "osis" ] && [ -d "$BASE" ]; then
  echo "Directory $BASE already exists. Aborting."
  exit 1
fi

mkdir -p "$BASE"

# Generate a stable repo anonId for telemetry (non-PII).
if command -v uuidgen >/dev/null 2>&1; then
  REPO_ANON_ID=$(uuidgen | tr '[:upper:]' '[:lower:]')
elif [ -r /proc/sys/kernel/random/uuid ]; then
  REPO_ANON_ID=$(cat /proc/sys/kernel/random/uuid)
else
  REPO_ANON_ID="r-$RANDOM$RANDOM-$(date +%s)"
fi
REPO_CREATED_AT=$(date -u +%FT%TZ)

# Create osis.json (only if it doesn't exist — don't overwrite org json)
# Initial manifest lists ONLY always-created docs. The subagent regenerates
# the manifest when earned docs (manifesto, thesis, product, brand, etc.)
# are materialized during the first clarity session.
if [ ! -f "osis/osis.json" ]; then
  # Atomic write — partial writes would leave a corrupt anonId and force
  # later telemetry to emit null repoId for this repo forever.
  TMP_OSIS_JSON=$(mktemp "osis/.osis.XXXXXX" 2>/dev/null) || TMP_OSIS_JSON="osis/osis.json.tmp.$$"
  cat > "$TMP_OSIS_JSON" << EOF
{
  "protocolShape": "1.0",
  "type": "product",
  "product": null,
  "activeVersion": "${VERSION}",
  "anonId": "${REPO_ANON_ID}",
  "createdAt": "${REPO_CREATED_AT}",
  "lastTwinUpdate": null,
  "files": {
    "twin": "osis/twin.md",
    "inbox": [],
    "${VERSION}": {
      "changelog": "osis/${VERSION}/changelog.md",
      "systems": {
        "core": {}
      }
    }
  }
}
EOF
  mv "$TMP_OSIS_JSON" "osis/osis.json"
fi

# Create README at osis root (only if it doesn't exist)
if [ ! -f "osis/README.md" ]; then
  cat > "osis/README.md" << 'EOF'
# Product Documentation

This folder contains the product docs for this project, managed by the [osis protocol](https://osis.dev).

Osis is a typed reasoning system for product development. It maintains clean, evolving product context across abstraction layers.

- **`twin.md`** — what the product IS. Code compressed into natural language.
- **Product constraint docs** — added as clarity becomes real (`manifesto.md`, `brand.md`, `design-system.md`, etc.)
- **`{version}/`** — what the product is BECOMING. Thesis, strategy, and system folders (`core/` always; satellites when complexity warrants).

## For AI Agents

Before starting work on any product feature, read in this order:

1. `osis.json` — understand the current state
2. `twin.md` — understand the product as it exists today
3. Active version `core/product.md` — understand what the product is
4. Active iteration `brief.md` — understand the current bet
5. Relevant `{phase}.impl.md` — understand how to build it

If a doc doesn't exist yet, flag it before proceeding.

Learn more at [osis.dev](https://osis.dev).
EOF
fi

# Create twin placeholder (only if it doesn't exist)
if [ ! -f "osis/twin.md" ]; then
  cat > "osis/twin.md" << 'EOF'
# Digital Twin

Agent-readable operational map of the product.
Not a source of truth for product decisions.

<!-- Generated by osis. Run osis twin update to refresh. -->
EOF
fi

# Create changelog (always exists, starts empty)
cat > "$BASE/changelog.md" << 'EOF'
# Changelog
EOF

# Create inbox directory (always exists, flat, starts empty)
mkdir -p "osis/inbox"

# Create core system folder (always exists, empty).
# core/product.md is NOT created as a stub — it materializes in-session when
# the builder confirms what the product IS at this version. Same for thesis,
# strategy, manifesto, brand, design-system: earned, not scaffolded.
mkdir -p "$BASE/core"

# Wire up CLAUDE.md at project root so future agent sessions pick up product context.
# Idempotent: skip if the Product Knowledge section already exists.
CLAUDE_MD="CLAUDE.md"
if ! grep -q "^## Product Knowledge" "$CLAUDE_MD" 2>/dev/null; then
  # Add a leading blank line if the file exists and doesn't end with one
  if [ -f "$CLAUDE_MD" ] && [ -s "$CLAUDE_MD" ]; then
    printf '\n## Product Knowledge\n\nProduct context lives in the `osis/` directory. Consult these before making product decisions or significant changes:\n\n- `osis/twin.md`: agent-readable operational map of the product\n- `osis/manifesto.md` (if present): product declaration\n- `osis/%s/thesis.md` (if present): current version hypothesis\n- `osis/%s/core/product.md` (if present): current version definition\n- `osis/%s/core/{iteration}/brief.md` (if present): current iteration bet\n\nOther docs (brand, design-system, strategy, charter) appear only when they earn a place in the product. Active version: `%s`. Say "osis" to consult the product expert.\n' "$VERSION" "$VERSION" "$VERSION" >> "$CLAUDE_MD"
  else
    printf '# Project\n\n## Product Knowledge\n\nProduct context lives in the `osis/` directory. Consult these before making product decisions or significant changes:\n\n- `osis/twin.md`: agent-readable operational map of the product\n- `osis/manifesto.md` (if present): product declaration\n- `osis/%s/thesis.md` (if present): current version hypothesis\n- `osis/%s/core/product.md` (if present): current version definition\n- `osis/%s/core/{iteration}/brief.md` (if present): current iteration bet\n\nOther docs (brand, design-system, strategy, charter) appear only when they earn a place in the product. Active version: `%s`. Say "osis" to consult the product expert.\n' "$VERSION" "$VERSION" "$VERSION" > "$CLAUDE_MD"
  fi
fi

echo ""
echo "Created minimum Osis root:"
echo ""
echo "  osis/"
echo "    osis.json"
echo "    README.md"
echo "    twin.md"
echo "    inbox/"
echo "    $VERSION/"
echo "      changelog.md"
echo "      core/"
echo ""
echo "Earned docs (manifesto, thesis, product, brief, brand, design-system)"
echo "materialize in-session when the builder expresses them."
echo ""
echo "CLAUDE.md wired with Product Knowledge pointers."
echo ""
echo "Next step:"
echo "  Say 'osis' to start onboarding."
echo ""

bash "$SCRIPT_DIR/track.sh" skill_onboarded "mode=product" "version=${VERSION}" >/dev/null 2>&1 || true
