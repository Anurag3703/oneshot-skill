# Improve Performance of the Inferred Hot Path

## Objective
Reduce latency or improve throughput of the dominant hot path discoverable in the repository by a measurable amount without changing external behavior.

## Assumptions
- Primary concern is the hottest request/compute path identifiable from benchmarks, profiles, or dominant modules in the workspace
- Public API behavior must remain identical

## Execution Steps
1. Inspect the repository for benchmarks, profiles, performance issues, and dominant hot-path modules.
2. Establish a baseline measurement (existing benchmark or minimal timing harness).
3. Apply the smallest safe optimization consistent with project conventions.
4. Re-measure and record improvement.
5. Protect the gain with a regression check; keep functional tests green.

## Expected Output
- Baseline and post-change measurements
- Minimal optimization diff
- Regression/performance check

## Validation
- Measurements recorded
- Functional behavior unchanged
- Tests pass

## Failure Handling
- If no hot path or metric can be inferred from the workspace, stop implementation and surface one Blocking clarification: which endpoint/workload to optimize and the target metric

## Definition of Done
Measurable improvement demonstrated on the inferred target, tests green, behavior preserved — or a single blocking clarification issued when measurement is impossible.

## Blocking clarification
Only if context yields no measurable target: specify the workload/endpoint and the success metric (e.g. p95 latency, requests/sec).
