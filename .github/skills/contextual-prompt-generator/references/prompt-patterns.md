# Reusable Prompt Patterns

Concise patterns to compose into the final executable prompt. Adapt wording to the concrete task and context.

## Coding Implementation Pattern

```
## Execution Steps
1. Inspect the repository structure, build system, and coding conventions.
2. Locate existing components related to [feature area].
3. Identify the minimum set of files that must change.
4. Implement the change following existing patterns; do not introduce a parallel architecture.
5. Preserve unrelated functionality and public APIs unless the objective requires otherwise.
6. Add or update tests that cover the new behavior and key edge cases.
7. Run the relevant test suite and fix any failures caused by the change.
8. Validate the implementation against the objective and constraints.
9. Summarize files changed and the rationale for the approach.
```

## Debugging Pattern

```
## Execution Steps
1. Reproduce the reported failure or document why reproduction is not possible.
2. Gather evidence (logs, stack traces, failing tests, metrics, recent changes).
3. Perform root-cause analysis; state the cause with supporting evidence.
4. Implement the smallest safe fix that addresses the root cause.
5. Add a regression test that fails without the fix and passes with it.
6. Re-run the original failure scenario and the broader relevant test suite.
7. Confirm no unrelated regressions were introduced.
```

## Research / Comparison Pattern

```
## Execution Steps
1. Restate the precise research question and decision criteria.
2. Gather information from authoritative primary sources.
3. Compare options on the same dimensions (e.g. scale, performance, cost, operability, security).
4. Note uncertainty, assumptions, and confidence levels.
5. Produce a clear recommendation with tradeoffs and an actionable next step.
```

## Architecture Decision Pattern

```
## Execution Steps
1. Capture functional and non-functional requirements (scale, latency, availability, security, cost).
2. List viable options that fit the existing system constraints.
3. Evaluate each option against the criteria; call out failure modes.
4. Recommend one option with explicit tradeoffs.
5. Outline an implementation path, migration risks, and rollback considerations.
```

## MCP / Agent Tool Pattern

```
## Execution Steps
1. Inspect the repository for existing MCP server or agent tool patterns.
2. Identify authentication, error-handling, and interface conventions already in use.
3. Design the new tool with a clear typed input/output contract.
4. Reuse existing integration and auth mechanisms; do not create a parallel stack.
5. Implement the tool and register it according to project conventions.
6. Add tests for valid inputs, invalid inputs, upstream failures, and authorization cases.
7. Validate schema, behavior, and that existing tools still work.
```

## Validation Block Pattern

```
## Validation
- [ ] Required tests pass
- [ ] Build / type-check succeeds
- [ ] Public contracts and APIs remain compatible (unless change is intentional)
- [ ] Edge cases listed in the objective are covered
- [ ] No unrelated regressions
```

## Failure Handling Block Pattern

```
## Failure Handling
- Missing files or dependencies: search the repository and recover if possible; only ask the user when recovery is impossible.
- Test failures: diagnose, fix, and re-run before declaring done.
- Approach blocked: try the next compatible approach that still satisfies constraints.
- Ambiguous requirements that block correctness: state the ambiguity and the minimum clarification needed.
```

## Definition of Done Pattern

```
## Definition of Done
The task is complete only when:
1. The stated objective is met by the delivered artifacts.
2. Validation checks pass.
3. Unrelated functionality is preserved.
4. Changes are summarized so a reviewer can understand what was done and why.
```
