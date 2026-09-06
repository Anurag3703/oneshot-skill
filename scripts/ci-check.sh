#!/usr/bin/env bash
# Full local CI for contextual-prompt-generator: package validate + smoke + fixture eval.
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOT_CREATOR="/root/.grok/skills/skill-creator/scripts"

echo "=== 1. Package validation ==="
if [[ -x "$ROOT_CREATOR/validate-skill.sh" ]]; then
  bash "$ROOT_CREATOR/validate-skill.sh" "$SKILL_DIR"
else
  echo "WARN: validate-skill.sh not found; skipping official validator"
fi

echo
echo "=== 2. Smoke checks ==="
bash "$SKILL_DIR/scripts/smoke-check.sh"

echo
echo "=== 3. Fixture / golden eval ==="
bash "$SKILL_DIR/scripts/eval-fixtures.sh"

echo
echo "=== CI checks passed ==="
