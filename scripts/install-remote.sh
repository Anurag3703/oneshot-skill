#!/usr/bin/env bash
# One-line GitHub install. Safe to pipe:
#   curl -fsSL https://raw.githubusercontent.com/Anurag3703/oneshot-skill/main/scripts/install-remote.sh | bash
#
# Override:
#   curl -fsSL ... | REPO=my-org/my-repo REF=main bash
#   curl -fsSL ... | WITH_ORG=1 bash
set -euo pipefail

DEFAULT_HOST="${DEFAULT_HOST:-github.com}"
DEFAULT_REPO="${DEFAULT_REPO:-Anurag3703/oneshot-skill}"

HOST="${HOST:-$DEFAULT_HOST}"
REPO="${REPO:-$DEFAULT_REPO}"
REF="${REF:-main}"
WITH_ORG="${WITH_ORG:-0}"

TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "Downloading $REPO@$REF from $HOST …"
DOWNLOAD_SUCCESS=0

# Method 1: Try gh CLI if available (works seamlessly with GHE SSO/auth)
if command -v gh >/dev/null 2>&1; then
  if GH_HOST="$HOST" gh api "/repos/${REPO}/tarball/${REF}" 2>/dev/null | tar -xz -C "$TMP" 2>/dev/null; then
    DOWNLOAD_SUCCESS=1
  fi
fi

# Method 2: Try direct archive tarball via curl
if [[ $DOWNLOAD_SUCCESS -eq 0 ]]; then
  if [[ "$HOST" == "github.com" ]]; then
    if curl -fsSL "https://codeload.github.com/${REPO}/tar.gz/${REF}" 2>/dev/null | tar -xz -C "$TMP" 2>/dev/null; then
      DOWNLOAD_SUCCESS=1
    fi
  else
    if curl -fsSL "https://${HOST}/${REPO}/archive/refs/heads/${REF}.tar.gz" 2>/dev/null | tar -xz -C "$TMP" 2>/dev/null; then
      DOWNLOAD_SUCCESS=1
    fi
  fi
fi

# Method 3: Fallback to git clone shallow
if [[ $DOWNLOAD_SUCCESS -eq 0 ]]; then
  CLONE_DIR="$TMP/repo"
  if git clone --depth 1 --branch "$REF" "https://${HOST}/${REPO}.git" "$CLONE_DIR" 2>/dev/null; then
    DOWNLOAD_SUCCESS=1
  fi
fi

if [[ $DOWNLOAD_SUCCESS -eq 0 ]]; then
  echo "Download failed. Check your access to https://${HOST}/${REPO} and that REF (${REF}) is valid."
  exit 1
fi

# Locate root directory containing SKILL.md
ROOT="$(find "$TMP" -mindepth 1 -maxdepth 1 -type d | head -1)"

if [[ -f "$ROOT/SKILL.md" && -f "$ROOT/scripts/install.sh" ]]; then
  SKILL="$ROOT"
elif [[ -d "$ROOT/contextual-prompt-generator" ]]; then
  SKILL="$ROOT/contextual-prompt-generator"
elif [[ -f "$TMP/repo/SKILL.md" && -f "$TMP/repo/scripts/install.sh" ]]; then
  SKILL="$TMP/repo"
else
  echo "Could not find contextual-prompt-generator in $REPO"
  exit 1
fi

ARGS=()
if [[ "$WITH_ORG" == "1" ]]; then
  ARGS+=(--with-org)
fi

if [[ ${#ARGS[@]} -gt 0 ]]; then
  bash "$SKILL/scripts/install.sh" "${ARGS[@]}"
else
  bash "$SKILL/scripts/install.sh"
fi
