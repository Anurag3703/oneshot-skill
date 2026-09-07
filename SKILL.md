---
name: contextual-prompt-generator
description: "MANDATORY one-shot execution workflow. Use first, before searching files or running commands, when the user asks to implement, fix, add, build, refactor, debug, draft, analyze, or complete a concrete task; pastes a Jira, Linear, GitHub, or Azure DevOps ticket; shares a ticket key such as CDBASE-28987; or asks to make a task executable, do this in one shot, or handle it end to end. After loading, follow this skill's plan -> execute -> validate pipeline in the same session. Do not merely acknowledge or bypass the skill."
metadata:
  version: "2.2.0"
  type: workflow
  category: task-execution
---

# Contextual Prompt Generator

**This is an execution skill, not a copy-paste prompt factory.**

## Mandatory handoff

For a matching task, this skill owns the workflow. Load it before any repository search, command, implementation, or test. Build the internal plan, then execute it in this session. Do not invoke the skill and continue with an independent workflow. If the user asks for a prompt or plan only, stop before execution; otherwise planning without execution is incomplete.

When the user states a task, do this in the background, then do the work:

1. Understand intent  
2. Classify task type + domain  
3. Gather only relevant context  
4. Build a tight internal plan (objective, constraints, steps, validation, DoD)  
5. **Execute that plan in this session**  
6. Validate against DoD  
7. Report what changed — briefly  

The compiled plan stays **internal** unless the user asks to see it.

## Ticket intake (Jira and similar)

When the user pastes a ticket, drops a key (`PROJ-123`), or links a ticket, treat that as the task source.

**Supported shapes (any mix):**
- Jira paste (summary, description, acceptance criteria, comments clutter)
- Linear / GitHub Issues / Azure DevOps / Asana-style paste
- Ticket key only + short note (“do PROJ-456”)
- Messy copy from email or Slack that includes ticket fields

**Extract (internal):**
1. ID / key if present
2. Title / summary → Objective seed
3. Description / body → requirements
4. Acceptance criteria → Validation + DoD
5. Priority / type / labels → constraints only if they affect work
6. Ignore noise: watcher lists, long comment threads, empty templates, UI chrome

**Then:** same pipeline — plan in background → execute → short summary.  
Mention ticket key in the completion summary when known.

**If acceptance criteria conflict with the repo:** prefer explicit AC, note conflict under assumptions, implement the smallest coherent interpretation.

**If the paste is incomplete** (title only, no AC): infer from repo + title; ask one blocking question only if the goal is still ambiguous.

Details: [references/tickets.md](references/tickets.md)

## Default mode: plan → execute (one-shot)

User says something like:

- “Add rate limiting to the public API”  
- “Fix the intermittent 500s on checkout”  
- “Draft a remote-work policy outline for managers”  
- pasted Jira/Linear/GitHub ticket body  
- “Implement PROJ-123” / “Do this ticket: …”  

You:

- Build the plan silently  
- Apply org profile constraints if `org-engineering-profile` is available  
- Perform the work (code, docs, analysis, etc.)  
- Run sensible checks  
- Reply with a short completion summary (files touched, decisions, residual risks)  

**Do not** dump the full internal prompt as the main answer.  
**Do not** stop after planning. Planning without execution is failure unless blocked.

## Optional modes (user can steer)

| User intent | Behavior |
|-------------|----------|
| Normal task request | Plan in background → **execute** → summary |
| “Show the plan” / “show the prompt” / “don’t implement yet” | Compile and **show** plan only |
| “Just the prompt for another agent” | Emit executable prompt text only |
| “Also …” / “use X instead” on active task | **Patch** plan → continue execution (no full restart) |
| Unrelated question | Answer normally; do not run this pipeline |

Treat these as lightweight options the user can invoke in chat — no special UI required.

## Pipeline (internal — do not emit by default)

1. Intent  
2. Task type + domain  
3. Required info  
4. Context (filter + compress)  
5. Constraints + assumptions (+ org profile if present)  
6. Execution steps  
7. Expected output + validation + DoD  
8. Critic gate  
9. **Execute**  
10. Verify DoD → short report  

## Task types

| Type | Focus while executing |
|------|------------------------|
| coding | inspect repo, minimal change, tests, no regressions |
| debugging | reproduce, root cause, smallest fix, regression test |
| architecture | criteria, tradeoffs, recommendation, path |
| research | sources, same criteria, uncertainty, recommendation |
| writing | audience, tone, finished artifact |
| analysis | inputs, method, metrics, conclusions |
| planning | goals, milestones, risks, owners |
| process/policy | rules, stakeholders, human-review flags |
| ML/AI | metric, data, eval, latency/cost, failures |
| agent/MCP | existing patterns, contracts, auth, tests |
| ambiguous | measurable target or one blocking clarification |

Details on demand: [references/task-types.md](references/task-types.md), [references/domains.md](references/domains.md)

## Context (token-efficient)

1. User constraints  
2. Workspace signals (manifests, README, docs, CI, policies)  
3. Task-local artifacts only  
4. Team conventions  

Include paths + short excerpts. Exclude secrets, lockfile bodies, `node_modules`, bulk binaries.  
See [references/context-sources.md](references/context-sources.md)

## Org profile (optional)

If **org-engineering-profile** is installed, merge 3–8 relevant bullets into constraints/validation/DoD while executing.  
No profile → neutral rules only. Never invent company policy.

## Execution rules

**Do**

- Finish the task in-session when possible  
- Minimal, compatible changes; preserve unrelated behavior  
- State assumptions only when needed  
- Recover from failures before asking the user  
- Ask **one** blocking clarification only when correctness is impossible otherwise  
- End with observable validation against DoD  

**Do not**

- Return a giant prompt and stop (unless user asked for prompt-only)  
- Invent APIs, files, policies, or tools  
- Dump full trees or irrelevant files  
- Force coding rituals onto non-code tasks  
- Restart full planning on every small follow-up  

## Critic (internal)

Before executing, check: aligned, sparse context, specific steps, validation, DoD, domain-appropriate.  
Gate: *Can this be executed now without an unnecessary question?* If no, revise plan or ask one blocking question.

## What the user should see

**Default completion reply (keep short):**

```text
Done.

- Objective: …
- Changes: (paths / artifacts)
- Validation: (what was checked)
- Notes: (assumptions or residual risks, if any)
```

If prompt-only mode:

```text
[Full executable plan/prompt]
```

## Ambiguous tasks

Infer a measurable target when context allows; otherwise one blocking clarification. Do not invent a vague “make everything better” execution.

## Distribution

Org-neutral. Works alone or with **org-engineering-profile**.  
Bump `metadata.version` on behavior changes. No secrets in the skill.
