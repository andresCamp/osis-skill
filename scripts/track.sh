#!/bin/bash
# Pseudonymous telemetry for the osis skill.
#
# Posts a single event to the landing site's /api/t endpoint, which forwards
# to PostHog server-side. Silent and fire-and-forget: backgrounded curl with a
# tight timeout so it never blocks skill activation.
#
# Usage: bash track.sh <event> [key=value ...]
#
# Identity:
#   userId  — stable per Claude install. Lives in ~/.claude/osis-telemetry.json
#             so it survives skill updates (which wipe ~/.claude/skills/osis/).
#   repoId  — stable per onboarded repo. Read from ./osis/osis.json.anonId
#             when present. Legacy repos emit no repoId until migrated.
#
# Opt-out: set OSIS_TELEMETRY=0. Documented in the README.

set -e

# Silent opt-out
if [ "${OSIS_TELEMETRY:-}" = "0" ]; then
  exit 0
fi

EVENT="${1:-}"
if [ -z "$EVENT" ]; then
  exit 0
fi
shift || true

ENDPOINT="${OSIS_TELEMETRY_ENDPOINT:-https://osis.dev/api/t}"

read_json_string() {
  sed -n "s/.*\"$2\"[[:space:]]*:[[:space:]]*\"\\([^\"]*\\)\".*/\\1/p" "$1" 2>/dev/null | head -1
}

# ---------- uuid generator (cross-platform) ----------
gen_uuid() {
  if command -v uuidgen >/dev/null 2>&1; then
    uuidgen | tr '[:upper:]' '[:lower:]'
  elif [ -r /proc/sys/kernel/random/uuid ]; then
    cat /proc/sys/kernel/random/uuid
  elif command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 16 | sed -E 's/(.{8})(.{4})(.{4})(.{4})(.{12})/\1-\2-\3-\4-\5/'
  else
    # Last-resort pseudo-random. Not a real UUID but stable-ish per run.
    printf '%s-%s-%s\n' "$RANDOM$RANDOM" "$RANDOM" "$(date +%s)"
  fi
}

# ---------- user identity (cross-install) ----------
USER_FILE="${HOME}/.claude/osis-telemetry.json"
USER_ID=""

if [ -f "$USER_FILE" ]; then
  USER_ID=$(read_json_string "$USER_FILE" "anonId")
fi

if [ -z "$USER_ID" ]; then
  USER_ID=$(gen_uuid)
  mkdir -p "$(dirname "$USER_FILE")" 2>/dev/null || true
  SKILL_VERSION=""
  VERSION_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/version.json"
  if [ -f "$VERSION_FILE" ]; then
    SKILL_VERSION=$(read_json_string "$VERSION_FILE" "version")
  fi
  CREATED_AT=$(date -u +%FT%TZ)
  cat > "$USER_FILE" <<EOF
{
  "anonId": "${USER_ID}",
  "createdAt": "${CREATED_AT}",
  "firstVersion": "${SKILL_VERSION}"
}
EOF
fi

# ---------- repo identity (per-project) ----------
REPO_ID=""
HAS_OSIS_DIR="false"

if [ -f "osis/osis.json" ]; then
  HAS_OSIS_DIR="true"
  REPO_ID=$(read_json_string "osis/osis.json" "anonId")
fi

# ---------- skill version ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_VERSION=""
if [ -f "$SCRIPT_DIR/../version.json" ]; then
  SKILL_VERSION=$(read_json_string "$SCRIPT_DIR/../version.json" "version")
fi

# ---------- build props JSON ----------
# Start with known fields, then merge any key=value args.
json_escape() {
  # Single-line values only. Strips newlines rather than encoding them —
  # all our values (UUIDs, modes, versions) are single-line by design.
  printf '%s' "$1" | tr -d '\n\r' | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

PROPS="\"skillVersion\":\"$(json_escape "$SKILL_VERSION")\",\"hasOsisDir\":${HAS_OSIS_DIR},\"os\":\"$(json_escape "$(uname -s)")\""

for arg in "$@"; do
  k="${arg%%=*}"
  v="${arg#*=}"
  if [ -n "$k" ] && [ "$k" != "$arg" ]; then
    PROPS="${PROPS},\"$(json_escape "$k")\":\"$(json_escape "$v")\""
  fi
done

# ---------- repoId field ----------
if [ -n "$REPO_ID" ]; then
  REPO_FIELD="\"repoId\":\"$(json_escape "$REPO_ID")\""
else
  REPO_FIELD="\"repoId\":null"
fi

PAYLOAD="{\"event\":\"$(json_escape "$EVENT")\",\"userId\":\"$(json_escape "$USER_ID")\",${REPO_FIELD},\"props\":{${PROPS}}}"

# ---------- fire-and-forget POST ----------
if [ "${OSIS_DEBUG:-}" = "1" ]; then
  echo "osis-telemetry endpoint: $ENDPOINT"
  echo "osis-telemetry payload:  $PAYLOAD"
  if curl -fsS --max-time 3 -X POST "$ENDPOINT" \
    -H 'content-type: application/json' \
    -d "$PAYLOAD" >/dev/null 2>&1; then
    rc=0
  else
    rc=$?
  fi
  echo "osis-telemetry: sent (status=${rc})"
else
  (curl -fsS --max-time 2 -X POST "$ENDPOINT" \
    -H 'content-type: application/json' \
    -d "$PAYLOAD" >/dev/null 2>&1 &) 2>/dev/null || true
fi

exit 0
