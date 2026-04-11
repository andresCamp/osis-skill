#!/bin/bash
# Initialize osis doc structure for a project
# Usage:
#   bash bootstrap.sh [product-version]         — scaffold product osis
#   bash bootstrap.sh --org [org-name]          — scaffold org osis (monorepo)
# Examples:
#   bash bootstrap.sh mystory-v1
#   bash bootstrap.sh --org cloudnine

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

  # Create org osis.json
  cat > "osis/osis.json" << EOF
{
  "version": "1.0.0",
  "type": "org",
  "org": "${ORG}",
  "products": {}
}
EOF

  # Create org charter placeholder
  cat > "osis/charter.md" << 'EOF'
# [Org Name] — Charter

<!-- Populated by osis bootstrap scan -->
EOF

  echo ""
  echo "Created org osis structure:"
  echo ""
  echo "  osis/"
  echo "    osis.json      (type: org)"
  echo "    charter.md"
  echo ""
  echo "Next steps:"
  echo "  1. Add products to osis.json"
  echo "  2. Create symlinks: ln -s ../apps/product/osis osis/product"
  echo "  3. Run 'osis' to bootstrap each product"
  echo ""
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

# Create osis.json (only if it doesn't exist — don't overwrite org json)
if [ ! -f "osis/osis.json" ]; then
  cat > "osis/osis.json" << EOF
{
  "version": "1.0.0",
  "type": "product",
  "product": null,
  "activeVersion": "${VERSION}",
  "lastTwinUpdate": null,
  "files": {
    "twin": "osis/twin.md",
    "manifesto": "osis/manifesto.md",
    "brand": "osis/brand.md",
    "design-system": "osis/design-system.md",
    "${VERSION}": {
      "thesis": "osis/${VERSION}/thesis.md",
      "product": "osis/${VERSION}/product.md",
      "strategy": "osis/${VERSION}/strategy.md",
      "changelog": "osis/${VERSION}/changelog.md"
    }
  }
}
EOF
fi

# Create README at osis root (only if it doesn't exist)
if [ ! -f "osis/README.md" ]; then
  cat > "osis/README.md" << 'EOF'
# Product Documentation

This folder contains the product docs for this project, managed by the [osis protocol](https://osis.dev).

Osis is a typed reasoning system for product development. It maintains clean, evolving product context across abstraction layers.

- **`twin.md`** — what the product IS. Code compressed into natural language.
- **`manifesto.md`** — why this product exists. The enduring declaration.
- **`{version}/`** — what the product is BECOMING. Thesis, product definition, strategy.

## For AI Agents

Before starting work on any product feature, read in this order:

1. `osis.json` — understand the current state
2. `twin.md` — understand the product as it exists today
3. Active version `product.md` — understand what the product is
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

# Create product-level placeholders (only if they don't exist)
if [ ! -f "osis/manifesto.md" ]; then
  cat > "osis/manifesto.md" << 'EOF'
# [Product Name]

<!-- Run osis bootstrap to build this with guidance -->
EOF
fi

if [ ! -f "osis/brand.md" ]; then
  cat > "osis/brand.md" << 'EOF'
# [Product Name] — Brand

<!-- Run osis bootstrap to build this with guidance -->
EOF
fi

if [ ! -f "osis/design-system.md" ]; then
  cat > "osis/design-system.md" << 'EOF'
# [Product Name] — Design System

<!-- Run osis bootstrap to build this with guidance -->
EOF
fi

# Create version-level docs
cat > "$BASE/thesis.md" << 'EOF'
# [Product Name] [Version] — Thesis

<!-- Run osis bootstrap to build this with guidance -->
EOF

cat > "$BASE/product.md" << 'EOF'
# [Product Name] [Version] — Product

<!-- Run osis bootstrap to build this with guidance -->
EOF

cat > "$BASE/strategy.md" << 'EOF'
# [Product Name] [Version] — Strategy

<!-- Run osis bootstrap to build this with guidance -->
EOF

# Create changelog
cat > "$BASE/changelog.md" << 'EOF'
# Changelog
EOF

echo ""
echo "Created osis doc structure:"
echo ""
echo "  osis/"
echo "    osis.json"
echo "    README.md"
echo "    twin.md"
echo "    manifesto.md"
echo "    brand.md"
echo "    design-system.md"
echo "    $VERSION/"
echo "      thesis.md"
echo "      product.md"
echo "      strategy.md"
echo "      changelog.md"
echo ""
echo "Next steps:"
echo "  1. Run 'osis bootstrap' to build your product docs"
echo "  2. Add product doc pointers to your CLAUDE.md or agent config"
echo ""
