# Before / After Examples

Realistic transformations from vague requests into executable prompts. The "after" examples are illustrative of structure and depth; real output must incorporate actual repository context.

---

## Example 1 — Coding (Authentication)

**Before (user):**
Add authentication to this service.

**After (generated prompt — structure):**

```
# Add Authentication to the Service

## Objective
Implement authentication for the existing service so that protected endpoints require a valid identity, following the project's current architecture and security conventions.

## Context
[Relevant files, existing auth libraries or middleware if present, API style, dependency list — filled from real repo inspection]

## Constraints
- Prefer existing dependencies and patterns already in the repository
- Do not introduce a second authentication system if one already exists
- Preserve public unauthenticated endpoints unless the requirement states otherwise
- Follow the project's security and error-handling conventions

## Assumptions
- [Stated only if needed, e.g. "JWT is acceptable if no company standard is present in the repo"]

## Execution Steps
1. Inspect the repository for existing authentication, middleware, and session/token handling.
2. Identify protected vs public routes and the preferred auth mechanism already in use or implied by dependencies.
3. Implement the minimum changes required to enforce authentication on the intended endpoints.
4. Reuse existing error formats and status codes.
5. Add tests for authenticated success, missing credentials, and invalid credentials.
6. Run the existing test suite and fix any failures caused by the change.
7. Summarize the approach and files changed.

## Validation
- Protected endpoints reject unauthenticated requests with the project's standard error response
- Valid credentials allow access
- Existing public endpoints remain reachable
- Relevant tests pass; no unrelated regressions

## Definition of Done
Authentication is enforced on the intended endpoints, integrated with existing architecture, tested, and documented in the change summary without breaking unrelated functionality.
```

---

## Example 2 — Debugging (Random 500s)

**Before:**
The API is randomly returning 500 errors.

**After (structure):**

```
# Diagnose and Fix Intermittent API 500 Errors

## Objective
Identify the root cause of intermittent HTTP 500 responses and apply the smallest safe fix so the failure no longer occurs under the same conditions.

## Context
[Relevant route handlers, error middleware, recent changes, logging setup — from repo]

## Execution Steps
1. Reproduce the 500 (or document why it cannot be reproduced reliably).
2. Collect evidence from logs, stack traces, metrics, and failing tests.
3. Perform root-cause analysis and state the cause with evidence.
4. Apply the smallest safe fix.
5. Add a regression test that fails without the fix and passes with it.
6. Re-run the original scenario and the relevant test suite.
7. Confirm the intermittent 500 is resolved and no new failures appear.

## Validation
- Root cause is documented with evidence
- Regression test exists and passes
- Original symptom is gone under reproduction steps
- Broader tests still pass

## Definition of Done
Root cause is identified and fixed with a regression test; intermittent 500s no longer occur for the previously failing scenario.
```

---

## Example 3 — Research (Data Platforms)

**Before:**
Compare Snowflake, BigQuery and Databricks for analyzing billions of orders.

**After (structure):**

```
# Compare Snowflake, BigQuery, and Databricks for Large-Scale Order Analytics

## Objective
Produce a decision-ready comparison of Snowflake, BigQuery, and Databricks for analyzing billions of orders, ending with a recommendation under explicit criteria.

## Comparison Criteria
- Scale and storage model
- Query execution and performance characteristics
- Cost model (storage + compute)
- Architecture and ecosystem fit
- Operational complexity and governance
- Latency and concurrency for analytical workloads

## Execution Steps
1. Gather current, authoritative information for each platform on the criteria above.
2. Compare all three on the same dimensions; avoid one-sided claims.
3. Note assumptions (e.g. expected query patterns, data freshness needs).
4. State uncertainties and confidence.
5. Recommend one primary option with tradeoffs and conditions under which another option would be better.

## Expected Output
A structured comparison table or equivalent sections, plus a clear recommendation and next implementation steps.

## Definition of Done
The comparison covers all listed criteria with evidence, and a justified recommendation is provided.
```

---

## Example 4 — Agent / MCP (SAP Production Orders)

**Before:**
Build an MCP server for our SAP system that gives production order status.

**After (structure):**

```
# Implement MCP Tool for SAP Production Order Status

## Objective
Expose production-order status through a safe, typed MCP tool that follows the existing project's architecture and conventions.

## Context
[Existing MCP server patterns, SAP integration layer, auth mechanisms, tool registration conventions — from real repo]

## Constraints
- Reuse the existing SAP integration and authentication; do not create a parallel integration stack
- Follow existing MCP tool schema and error-handling patterns
- Do not modify unrelated tools or services

## Execution Steps
1. Inspect the repository for MCP server patterns and SAP integration code.
2. Identify authentication, authorization, and error-handling mechanisms already in use.
3. Design a typed input/output contract for production-order status.
4. Implement the tool using the existing integration architecture.
5. Register the tool according to project conventions.
6. Add tests for valid requests, invalid order IDs, SAP failures/timeouts, and authorization behavior.
7. Run existing tests and fix any regressions.

## Validation
- MCP tool schema is valid and documented
- Valid order IDs return expected status
- Invalid IDs and upstream failures are handled cleanly
- Authorization is enforced
- Existing tests still pass

## Definition of Done
The MCP tool is implemented, integrated into the existing architecture, tested, and validated without breaking existing functionality.
```

---

## Example 5 — Ambiguous Optimization

**Before:**
Make this faster.

**After (structure when context allows inference):**

```
# Improve Performance of [Inferred Hot Path]

## Objective
Reduce latency / improve throughput of [component inferred from context] by a measurable amount without changing external behavior.

## Assumptions
- The primary performance concern is [inferred from profiling data, recent issues, or dominant code path in the repo]
- Acceptable change scope is limited to [component]; public API behavior must remain identical

## Execution Steps
1. Inspect the repository and identify the dominant hot path related to the request.
2. Establish a baseline measurement (existing benchmark, simple timing harness, or documented metric).
3. Apply the smallest safe optimization consistent with project conventions.
4. Re-measure and confirm improvement.
5. Add or update a regression check so the improvement is protected.
6. Ensure functional tests still pass.

## Validation
- Baseline and post-change measurements are recorded
- Functional behavior is unchanged
- Tests pass

## Definition of Done
A measurable improvement is demonstrated on the inferred target, with tests still green and behavior preserved.

## Clarification (only if truly blocked)
If no measurable target or hot path can be inferred from the repository, state the minimum information required (e.g. which endpoint or workload to optimize and the target metric).
```

---

## Cross-domain note (v1.2+)

The same transformation rules apply outside pure software:

| Domain | Request gist | Prompt must emphasize |
|--------|----------------|------------------------|
| Design | Empty-state redesign | design system, states, accessibility, handoff artifact |
| HR | Policy outline | audience, human review, no fabricated legal claims |
| Finance | Forecast comparison | inputs, formulas, assumptions vs facts, reproducibility |
| ADAS | Sensor timeout fallback | existing pipeline, failure scenario tests, no false certification |

See `tests/golden/*.prompt.md` for full samples and `references/domains.md` for constraints.
