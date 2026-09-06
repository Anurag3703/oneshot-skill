# Eval rubric

Score a generated prompt 0–2 on each dimension. Production target: **total ≥ 12 / 14** and no dimension at 0.

| # | Dimension | 0 | 1 | 2 |
|---|-----------|---|---|---|
| 1 | Task alignment | Wrong goal or ignores request | Partial goal | Exact objective matches user intent |
| 2 | Context relevance | Dump / irrelevant / invented | Some relevant, some noise | Only task-relevant, compressed |
| 3 | Specificity | Vague verbs only | Mixed | Observable outcomes, named artifacts |
| 4 | Executability | Agent would need many questions | Some gaps | Capable agent can start immediately |
| 5 | Validation | Missing | Vague checks | Concrete, testable checks |
| 6 | Definition of Done | Missing or "code written" | Weak | Clear completion conditions |
| 7 | Token discipline | Full files / trees / fluff | Mildly long | Dense; empty sections omitted |

## Hard fails (auto score 0 total)

- Invents tools, files, or APIs not implied by context  
- Contains secrets or credential placeholders presented as real  
- Coding task with no inspect/test language when repo context exists  
- Debugging task with no reproduce / root-cause / regression language  
- Ambiguous "make it faster" with generic optimize-everything and no measurable target or blocking clarification  

## Structural checklist (CI)

Required headings when applicable:

- `## Objective`
- `## Execution Steps` (or equivalent numbered plan)
- `## Validation`
- `## Definition of Done`

Coding should also imply or include constraints around minimal change and tests.  
Debugging should mention reproduce, root cause, and regression test.

## Token budget guidance for generated prompts

| Scope | Soft target |
|-------|-------------|
| Simple coding change | ≤ 400 words |
| Multi-file feature | ≤ 700 words |
| Research comparison | ≤ 600 words |
| Architecture decision | ≤ 800 words |

Over budget is acceptable only when validation/DoD would otherwise be incomplete.
