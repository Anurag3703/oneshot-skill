# contextual-prompt-generator

Production-oriented Copilot Agent Skill that compiles a natural-language task plus relevant context into a dense, execution-ready prompt for another AI agent.

**Version:** see `metadata.version` in `SKILL.md` (currently 2.2.0).

## Install (like npm install)

**After the skill is on GitHub / GitHub Enterprise** (testers need nothing copied first):

```bash
GH_HOST=bmw.ghe.com gh api /repos/Anurag-TA-Tiwari/contextual-prompt-generator/contents/scripts/install-remote.sh -H "Accept: application/vnd.github.raw" | bash
```

Or via `curl`:
```bash
curl -fsSL https://bmw.ghe.com/raw/Anurag-TA-Tiwari/contextual-prompt-generator/main/scripts/install-remote.sh | bash
```

Details: [INSTALL.md](INSTALL.md)

Local (you already have the folder):

```bash
bash scripts/install.sh
```

## Goals

- High-quality, one-shot executable prompts across teams
- **Primary:** software, AI/ML, coding
- **Also supported:** ADAS, design, HR, finance (same pipeline; domain packs on demand)
- Minimal token use (lean skill body + sparse generated prompts)
- Org-neutral, secret-free, registry-ready

## What it does

```
USER INTENT → task type → relevant context only → constraints/assumptions
→ steps → output → validation → definition of done → FINAL PROMPT
```

Not a generic template. Downstream agents should be able to execute without unnecessary clarification.

## Activation

Triggers include: create a prompt for this task; turn this requirement into a prompt; make this task executable by an AI agent; generate a one-shot implementation prompt; agent prompt using repository context; convert requirement into an execution plan/prompt.

## Layout

```
contextual-prompt-generator/
├── SKILL.md                 # Loaded on activation (kept lean)
├── README.md
├── references/              # Loaded on demand
│   ├── task-types.md
│   ├── prompt-patterns.md
│   ├── examples.md
│   ├── context-sources.md   # What to fetch / exclude / compress
│   ├── domains.md           # Software, AI, ADAS, design, HR, finance
│   └── eval-rubric.md       # Quality scoring
├── scripts/
│   ├── smoke-check.sh       # Package structure
│   ├── eval-fixtures.sh     # Golden prompt quality gates
│   └── ci-check.sh          # validate + smoke + eval
└── tests/
    ├── fixtures/<id>/       # request.txt + expected-sections.json
    └── golden/<id>.prompt.md
```

## Token discipline

| Layer | Policy |
|-------|--------|
| SKILL.md | Core rules only; detail in references; line budget enforced in smoke |
| Generated prompt | Omit empty sections; paths + short excerpts; no tree dumps |
| Context | Priority filter + exclude lists; soft word budgets in eval-rubric |

## Test locally

```bash
bash scripts/ci-check.sh
```

Or stepwise:

```bash
bash /root/.grok/skills/skill-creator/scripts/validate-skill.sh .
bash scripts/smoke-check.sh
bash scripts/eval-fixtures.sh
```

### Live Copilot check

1. Open a real repo workspace  
2. Ask: `Create a one-shot implementation prompt for: <task>`  
3. Confirm: Objective, sparse Context, Constraints, Steps, Validation, DoD  
4. Confirm no vague phrases and no full-file dumps  

### Fixtures

| ID | Request gist |
|----|----------------|
| coding-auth | Add authentication to this service |
| debugging-500 | API randomly returning 500s |
| research-compare | Snowflake vs BigQuery vs Databricks |
| mcp-sap | MCP server for SAP production order status |
| ambiguous-faster | Make this faster |
| design-brief | Settings empty-state redesign |
| hr-policy | Remote-work eligibility outline |
| finance-forecast | Quarterly revenue forecast |
| adas-scenario | Camera frame timeout fallback |

## Cross-team usage

1. Install skill directory on the shared Copilot skills path / company registry  
2. Keep this skill **org-neutral**  
3. Put company standards (allowed libraries, security baseline) in a **separate** org skill if needed — do not fork personal prefs into this package  
4. Pilot on 1–2 teams; feed failure modes back into `references/` and fixtures  

## Registry checklist

- [ ] `scripts/ci-check.sh` passes  
- [ ] No secrets, internal URLs, or personal data  
- [ ] `metadata.version` bumped for breaking prompt-structure changes  
- [ ] Description triggers reviewed  
- [ ] Golden prompts still pass eval after edits  

## Adding a task type

1. One row in the task table in `SKILL.md`  
2. Strategy blurb in `references/task-types.md`  
3. Optional pattern in `references/prompt-patterns.md`  
4. Fixture + golden + `expected-sections.json`  
5. Re-run `ci-check.sh`  

## Improving quality

- Prefer tighter Context rules over longer skill text  
- Add a fixture when a real failure mode appears  
- Score live prompts with `references/eval-rubric.md` (target ≥ 12/14)  


## Companion: org-engineering-profile

For company-wide security baselines, approved libraries, and review rules, install the separate skill:

`../org-engineering-profile/`

The neutral compiler merges short, task-relevant org bullets when that skill is present. Customize `TODO_ORG_*` placeholders before rollout. Never put secrets in either skill.
