# Add Authentication to the Service

## Objective
Enforce authentication on protected endpoints of the existing service using the project's current architecture and conventions.

## Context
- No repository context was attached; treat stack and auth library as discoverable in-repo.
- Prefer existing middleware/session/token patterns if present.

## Constraints
- Reuse existing dependencies and error formats; do not introduce a parallel auth system
- Preserve intentionally public endpoints
- Minimal change set; no unrelated refactors

## Assumptions
- If the repo has no auth standard, JWT or session middleware already common in the stack is acceptable once identified from dependencies

## Execution Steps
1. Inspect the repository for existing auth, middleware, route layout, and test commands.
2. Identify protected vs public routes and the preferred auth mechanism already in use or implied by dependencies.
3. Implement the minimum changes to require auth on intended endpoints.
4. Reuse existing error response shapes and status codes.
5. Add tests for success with valid credentials, missing credentials, and invalid credentials.
6. Run the existing test suite; fix failures caused by the change.
7. Summarize files changed and rationale.

## Expected Output
- Auth middleware or equivalent integrated on protected routes
- Tests covering the cases above
- Short change summary

## Validation
- Unauthenticated requests to protected routes are rejected with the project's standard error response
- Valid credentials grant access
- Public endpoints remain reachable
- Relevant tests pass; no unrelated regressions

## Failure Handling
- Missing auth libraries: adopt the closest existing dependency pattern; do not invent a new stack
- Test failures: diagnose and fix before done
- Clarify only if product requirements conflict (e.g. which routes must stay public) and cannot be inferred

## Definition of Done
Authentication is enforced on the intended endpoints, integrated with existing architecture, tested, and summarized without breaking unrelated functionality.
