# Camera Frame Timeout Fallback in Perception Pipeline

## Objective
Add a timeout fallback when camera frames stop arriving in the existing perception pipeline, with safe degraded behavior and tests/scenarios covering the failure mode.

## Context
- Inspect perception pipeline modules, frame ingestion, and existing fault-handling patterns
- Prefer existing architecture; do not invent a parallel stack

## Constraints
- Minimal change set; preserve unrelated perception behavior
- Do not claim functional-safety certification (e.g. ASIL/ISO) not evidenced in-repo
- Explicit handling when frames stop (timeout threshold from config or existing constants when present)
- Deterministic fallback behavior

## Execution Steps
1. Inspect the repository for camera/frame ingestion, perception pipeline entry, and existing timeout or watchdog patterns.
2. Identify the smallest safe insertion point for a frame-timeout fallback.
3. Implement fallback behavior consistent with existing fault handling.
4. Add tests or scenarios for frame stop / timeout and recovery if frames resume.
5. Run relevant tests; fix regressions.
6. Document residual risks briefly in the change summary.

## Expected Output
- Minimal code change for timeout fallback
- Tests/scenarios for frame loss
- Short risk note (no false certification claims)

## Validation
- Timeout path exercised by test or scenario
- Normal frame flow still works
- No unrelated regressions
- No invented safety certification language

## Failure Handling
- Missing pipeline module: search repo for ingestion and fault handlers before adding new frameworks
- Unclear threshold: use existing config constants if present; otherwise one Blocking clarification for timeout value

## Definition of Done
Timeout fallback implemented on the existing pipeline, tested for frame-stop scenarios, and documented without claiming safety certification not in context.
