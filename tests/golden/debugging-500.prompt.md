# Diagnose and Fix Intermittent API 500 Errors

## Objective
Find the root cause of intermittent HTTP 500 responses and apply the smallest safe fix so the failure no longer occurs under the same conditions.

## Context
- Investigate API request path, error middleware, logging, and recent changes.
- Prefer evidence from logs, stack traces, and failing tests over speculation.

## Execution Steps
1. Reproduce the 500 or document why it cannot be reproduced reliably.
2. Collect evidence (logs, stack traces, metrics, failing tests, recent commits).
3. State the root cause with supporting evidence.
4. Apply the smallest safe fix.
5. Add a regression test that fails without the fix and passes with it.
6. Re-run the original scenario and the relevant test suite.
7. Confirm no unrelated regressions.

## Expected Output
- Root-cause statement with evidence
- Minimal code fix
- Regression test
- Verification notes

## Validation
- Root cause documented with evidence
- Regression test exists and passes
- Original symptom gone under reproduction steps
- Broader relevant tests still pass

## Failure Handling
- Non-reproducible: capture strongest available evidence and narrow hypotheses before large changes
- Fix ineffective: revise root-cause analysis; do not stack speculative patches

## Definition of Done
Root cause identified and fixed with a regression test; intermittent 500s no longer occur for the previously failing scenario.
