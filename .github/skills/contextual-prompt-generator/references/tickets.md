# Ticket intake

Use when the user pastes or references a work ticket. Goal: normalize messy ticket text into the same plan → execute pipeline.

## Recognize

| Signal | Example |
|--------|---------|
| Jira key | `PROJ-123`, `ABC-9` |
| Jira paste | Summary, Description, Acceptance Criteria, Issue Type |
| GitHub | `Fixes #42`, issue title + body markdown |
| Linear | `ENG-123`, status/priority headers |
| Azure DevOps | Work item ID, Repro Steps, Acceptance Criteria |
| Slack/email dump | Mixed UI labels + ticket fields |

## Field mapping

| Ticket field | Plan field |
|--------------|------------|
| Summary / Title | Objective (primary) |
| Description / Body | Context + requirements |
| Acceptance Criteria / AC | Validation + Definition of Done |
| Repro steps | Debugging execution steps |
| Priority / Severity | Ordering only; do not over-scope |
| Labels / Components | Hints for which area of the repo |
| Comments | Use only if they add requirements; skip debate noise |
| Attachments mentioned | Note paths/names; do not invent binary content |

## Noise to drop

- “Reporter”, “Watchers”, “Created/Updated” timestamps (unless SLA-critical)
- Empty template headings
- Long historical comment threads without decisions
- Duplicate paste of the same AC
- Browser/Jira chrome (“Export”, “Share”, “Capture”)

## Execution rules

1. Prefer **Acceptance Criteria** over vague description text when both exist.  
2. If AC is checklist-shaped, each item becomes a validation bullet.  
3. Bug tickets → debugging strategy (reproduce → root cause → fix → regression test).  
4. Story/feature tickets → coding/minimal-change strategy.  
5. Spike/research tickets → research/analysis; deliver findings, not unsolicited production code.  
6. Always include ticket key in the final summary when known.

## Incomplete tickets

| What user gave | Action |
|----------------|--------|
| Key only (`PROJ-123`) | Search workspace for that key (branch name, commit, docs). If nothing found, ask for title/AC or paste. |
| Title only | Infer scope from title + repo; execute if clear; else one blocking question. |
| AC only | Objective = satisfy AC; implement minimally. |
| Conflicting AC vs description | Follow AC; note conflict. |

## Example normalization (internal)

**Paste:** Jira story with summary “Add retry to payment client”, AC “3 retries, exponential backoff, no change to public API”.

**Internal objective:** Add payment-client retries (max 3, exponential backoff) without changing the public API.

**Validation:** AC items checked; existing payment tests pass; no API contract change.

Then execute — do not return the normalization as the user-facing answer unless asked for the plan.
