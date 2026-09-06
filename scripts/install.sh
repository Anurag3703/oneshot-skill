#!/usr/bin/env bash
# Install contextual-prompt-generator into Copilot (and Grok) skill paths.
# Like npm install: one command, copies the skill where Copilot looks.
#
# Usage:
#   bash scripts/install.sh              # current repo + user-global
#   bash scripts/install.sh --global     # user-global only
#   bash scripts/install.sh --repo       # current repo only (.github/skills)
#   bash scripts/install.sh --with-org   # also install sibling org-engineering-profile
set -euo pipefail

SKILL_SRC="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_NAME="contextual-prompt-generator"
WITH_ORG=0
MODE="both"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global) MODE="global"; shift ;;
    --repo) MODE="repo"; shift ;;
    --with-org) WITH_ORG=1; shift ;;
    -h|--help)
      sed -n '2,12p' "$0"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

copy_skill() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  mkdir -p "$dest"
  # Do not copy tests into Copilot runtime (smaller install)
  cp -R "$src/SKILL.md" "$dest/"
  [[ -f "$src/README.md" ]] && cp "$src/README.md" "$dest/"
  [[ -d "$src/references" ]] && cp -R "$src/references" "$dest/"
  echo "Installed $(basename "$dest") -> $dest"
}

install_one() {
  local src="$1" dest="$2"
  copy_skill "$src" "$dest"
}

ORG_SRC="$(cd "$SKILL_SRC/.." && pwd)/org-engineering-profile"

# User-global Copilot / Grok locations
GLOBAL_DESTS=(
  "$HOME/.github/skills/$SKILL_NAME"
  "$HOME/.copilot/skills/$SKILL_NAME"
  "$HOME/.grok/skills/$SKILL_NAME"
)

REPO_DEST=""
if git rev-parse --show-toplevel >/dev/null 2>&1; then
  ROOT="$(git rev-parse --show-toplevel)"
  REPO_DEST="$ROOT/.github/skills/$SKILL_NAME"
fi

did=0

if [[ "$MODE" == "both" || "$MODE" == "repo" ]]; then
  if [[ -n "$REPO_DEST" ]]; then
    install_one "$SKILL_SRC" "$REPO_DEST"
    did=1
    if [[ $WITH_ORG -eq 1 && -d "$ORG_SRC" ]]; then
      copy_skill "$ORG_SRC" "$ROOT/.github/skills/org-engineering-profile"
    fi
  elif [[ "$MODE" == "repo" ]]; then
    echo "Not inside a git repo; skip --repo" >&2
  fi
fi

if [[ "$MODE" == "both" || "$MODE" == "global" ]]; then
  for dest in "${GLOBAL_DESTS[@]}"; do
    install_one "$SKILL_SRC" "$dest"
    did=1
    if [[ $WITH_ORG -eq 1 && -d "$ORG_SRC" ]]; then
      copy_skill "$ORG_SRC" "$(dirname "$dest")/org-engineering-profile"
    fi
  done
fi

if [[ $did -eq 0 ]]; then
  echo "Nothing installed." >&2
  exit 1
fi

echo
echo "Next: reload Copilot Chat / start a new session."
echo "Then ask a task or paste a ticket. No slash command required."
