#!/usr/bin/env bash
# Structural smoke checks for contextual-prompt-generator.
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0

check() {
  local desc="$1"
  shift
  if "$@"; then
    echo "PASS: $desc"
  else
    echo "FAIL: $desc"
    FAIL=1
  fi
}

echo "Smoke checks for $SKILL_DIR"
echo

check "SKILL.md exists" test -f "$SKILL_DIR/SKILL.md"
check "references/task-types.md exists" test -f "$SKILL_DIR/references/task-types.md"
check "references/prompt-patterns.md exists" test -f "$SKILL_DIR/references/prompt-patterns.md"
check "references/examples.md exists" test -f "$SKILL_DIR/references/examples.md"
check "references/context-sources.md exists" test -f "$SKILL_DIR/references/context-sources.md"
check "references/eval-rubric.md exists" test -f "$SKILL_DIR/references/eval-rubric.md"
check "references/domains.md exists" test -f "$SKILL_DIR/references/domains.md"
check "references/tickets.md exists" test -f "$SKILL_DIR/references/tickets.md"

check "SKILL.md starts with ---" bash -c "head -1 '$SKILL_DIR/SKILL.md' | grep -q '^---$'"
check "name is contextual-prompt-generator" grep -q '^name: contextual-prompt-generator$' "$SKILL_DIR/SKILL.md"
check "description is present and non-TODO" \
  bash -c "grep -q '^description: ' '$SKILL_DIR/SKILL.md' && ! grep -qi 'TODO' '$SKILL_DIR/SKILL.md'"
check "version is set" grep -q 'version:' "$SKILL_DIR/SKILL.md"

DESC=$(grep '^description: ' "$SKILL_DIR/SKILL.md" | sed 's/^description: //')
for phrase in "execute" "one shot" "Jira"; do
  if echo "$DESC" | grep -qi "$phrase"; then
    echo "PASS: description mentions '$phrase'"
  else
    echo "FAIL: description missing '$phrase'"
    FAIL=1
  fi
done

for section in "Pipeline" "Context" "Critic" "DoD" "Default mode"; do
  check "body contains '$section'" grep -q "$section" "$SKILL_DIR/SKILL.md"
done

LINES=$(wc -l < "$SKILL_DIR/SKILL.md" | tr -d ' ')
if [[ "$LINES" -le 250 ]]; then
  echo "PASS: SKILL.md line count $LINES (<= 250)"
else
  echo "FAIL: SKILL.md too long ($LINES lines) — move detail to references/"
  FAIL=1
fi

for id in coding-auth debugging-500 research-compare mcp-sap ambiguous-faster design-brief hr-policy finance-forecast adas-scenario; do
  check "fixture $id request" test -f "$SKILL_DIR/tests/fixtures/$id/request.txt"
  check "fixture $id expected" test -f "$SKILL_DIR/tests/fixtures/$id/expected-sections.json"
  check "golden $id" test -f "$SKILL_DIR/tests/golden/$id.prompt.md"
done

for scenario in Authentication 500 Snowflake MCP faster; do
  check "examples.md covers '$scenario'" grep -qi "$scenario" "$SKILL_DIR/references/examples.md"
done

echo
if [[ $FAIL -eq 0 ]]; then
  echo "All smoke checks passed."
  exit 0
else
  echo "Some smoke checks failed."
  exit 1
fi
