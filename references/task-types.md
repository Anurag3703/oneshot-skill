# Task Type Strategies

Use these strategies to adapt the generated prompt. Only load details needed for the current task type.

## Coding

Prioritize repository inspection, existing architecture, minimal changes, compatibility, tests, and regression prevention.

Required prompt elements:
- Inspect repository structure and conventions first
- Identify the smallest set of files to touch
- Preserve unrelated functionality
- Implement against existing patterns (do not invent parallel architecture)
- Run existing tests; add targeted tests for the change
- Report files changed and rationale

Validation defaults:
- Build / type-check succeeds
- Relevant unit and integration tests pass
- No new linter errors in touched files
- Behavior matches the stated objective

## Debugging

Prioritize reproduction, root-cause analysis, evidence, smallest safe fix, and regression tests.

Required prompt elements:
- Reproduce the failure (or document why it cannot be reproduced)
- Collect evidence from logs, stack traces, metrics, or failing tests
- Identify root cause before proposing a fix
- Apply the smallest safe change
- Add or update a regression test that would have caught the issue
- Verify the original failure is resolved and no new failures appear

Validation defaults:
- Failure is reproducible (or documented as non-reproducible)
- Root cause is stated with evidence
- Fix is minimal and targeted
- Regression test exists and passes
- Original symptom is gone

## Architecture

Prioritize requirements, scale, latency, availability, security, cost, failure modes, tradeoffs, recommendation, and implementation path.

Required prompt elements:
- Restate functional and non-functional requirements
- Evaluate options against explicit criteria (scale, latency, availability, security, cost, operability)
- Call out failure modes and mitigation
- Make a clear recommendation with tradeoffs
- Provide a concrete implementation path (phases, risks, migration)

Validation defaults:
- Criteria are explicit and scored or ranked
- Recommendation is justified
- Implementation path is actionable

## Research

Prioritize precise question, authoritative sources, evidence, source comparison, uncertainty, conclusions, and actionable recommendation.

Required prompt elements:
- Precise research question
- Preferred source types (official docs, RFCs, peer-reviewed, primary data)
- Comparison dimensions when multiple options exist
- Explicit uncertainty and confidence
- Actionable recommendation tied to the evidence

Validation defaults:
- Claims are backed by cited or named sources
- Alternatives are compared on the same criteria
- Recommendation follows from the evidence

## Writing

Prioritize audience, objective, tone, format, constraints, and a final usable artifact.

Required prompt elements:
- Target audience
- Purpose of the document
- Tone and style constraints
- Required structure or template
- Length or format limits
- Deliver the finished artifact, not an outline unless requested

## AI / ML

Prioritize objective, data, model or system architecture, evaluation, latency, cost, deployment, monitoring, and failure cases.

Required prompt elements:
- Success metric and evaluation method
- Data assumptions and constraints
- Architecture that fits existing systems when applicable
- Latency and cost budgets if known
- Deployment and monitoring expectations
- Known failure modes and handling

## Agent Development

Prioritize tools and interfaces, safety, state management, evaluation, and integration with existing agent patterns.

Required prompt elements:
- Tool/interface contracts (inputs, outputs, errors)
- Authentication and authorization model
- Alignment with existing agent or MCP patterns in the repo
- Safety and abuse considerations
- Evaluation or test plan for the agent behavior

## Ambiguous / Optimization

When the request is underspecified (e.g. "make it faster"):

1. Infer what can be measured from available context
2. State the inference as an explicit assumption
3. Define a measurable target and validation method
4. Only require clarification when critical information cannot be inferred

## Analysis

Prioritize question, data/sources, method, metrics, conclusions, and decision impact.

Required prompt elements:
- Decision or question the analysis serves
- Inputs and definitions (metrics, time range, filters)
- Method steps
- Explicit assumptions
- Conclusions tied to evidence; limitations

Validation defaults:
- Inputs and formulas/definitions stated
- Assumptions separated from facts
- Recommendation or conclusion is actionable

## Planning

Prioritize goals, scope, milestones, owners, dependencies, and risks.

Required prompt elements:
- Goal and out-of-scope
- Phased plan with checkpoints
- Dependencies and risks
- Success metrics per phase

Validation defaults:
- Plan is executable without hidden steps
- Risks have mitigations or owners
- Success criteria are observable

## Process / policy

Prioritize current state, stakeholders, rules, exceptions, and rollout.

Required prompt elements:
- Purpose and audience
- Steps or rules in order
- Exceptions and escalation
- Compliance or review requirements if stated
- Rollout / communication notes

Validation defaults:
- Required sections present
- Human-review items listed for legal/HR/finance-sensitive content
- No fabricated regulatory claims
