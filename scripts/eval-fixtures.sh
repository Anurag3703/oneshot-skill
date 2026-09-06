#!/usr/bin/env bash
# Evaluate golden (or candidate) prompts against fixture expected-sections.json.
# Usage:
#   eval-fixtures.sh
#   FIXTURE=coding-auth eval-fixtures.sh path/to/candidate.prompt.md
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
export SKILL_DIR
export FIXTURES="$SKILL_DIR/tests/fixtures"
export GOLDEN="$SKILL_DIR/tests/golden"

if [[ $# -ge 1 ]]; then
  export CANDIDATE="$1"
  : "${FIXTURE:?Set FIXTURE=<fixture-id> when evaluating a single file}"
  export FIXTURE
else
  unset CANDIDATE || true
  unset FIXTURE || true
fi

python3 - <<'PY'
import json, os, re, sys
from pathlib import Path

skill = Path(os.environ["SKILL_DIR"])
fixtures = Path(os.environ["FIXTURES"])
golden = Path(os.environ["GOLDEN"])

fail = 0
passed = 0

def check_prompt(fid: str, prompt_path: Path, exp_path: Path):
    global fail, passed
    if not exp_path.is_file():
        print(f"FAIL: {fid} — missing expected-sections.json")
        fail += 1
        return
    if not prompt_path.is_file():
        print(f"FAIL: {fid} — missing prompt {prompt_path}")
        fail += 1
        return

    body = prompt_path.read_text(encoding="utf-8")
    exp = json.loads(exp_path.read_text(encoding="utf-8"))
    local_fail = 0

    for heading in exp.get("required_headings") or []:
        pat = re.compile(rf"^#{{1,3}}\s*{re.escape(heading)}\s*$", re.I | re.M)
        if not pat.search(body) and not re.search(re.escape(heading), body, re.I):
            print(f"  miss heading: {heading}")
            local_fail = 1

    for group in exp.get("required_keywords_any") or []:
        if not any(kw.lower() in body.lower() for kw in group):
            print(f"  miss keyword group: {group}")
            local_fail = 1

    for phrase in exp.get("forbidden_phrases") or []:
        if phrase.lower() in body.lower():
            print(f"  forbidden phrase: {phrase}")
            local_fail = 1

    words = len(body.split())
    if words > 1500:
        print(f"  warn: very long prompt ({words} words)")

    if local_fail:
        print(f"FAIL: {fid}")
        fail += 1
    else:
        print(f"PASS: {fid} ({words} words)")
        passed += 1

print("Evaluating fixtures against golden prompts")
print(f"Skill: {skill}")
print()

candidate = os.environ.get("CANDIDATE")
fixture = os.environ.get("FIXTURE")

if candidate and fixture:
    check_prompt(fixture, Path(candidate), fixtures / fixture / "expected-sections.json")
else:
    for exp in sorted(fixtures.glob("*/expected-sections.json")):
        fid = exp.parent.name
        check_prompt(fid, golden / f"{fid}.prompt.md", exp)

print()
print(f"Results: {passed} passed, {fail} failed")
sys.exit(1 if fail else 0)
PY
