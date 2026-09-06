# Context sources (token-efficient)

Load when building the Context section of a generated prompt.

## Priority order

1. **User constraints** — requirements, non-goals, success metrics, environment  
2. **Workspace identity** — language/stack manifests, README, docs, policy folders, design system paths, data dictionaries  
3. **Task neighborhood** — only artifacts that own the change  
4. **Conventions** — how similar work is tested, reviewed, or approved here  

## By domain — high-signal sources

| Domain | Seek | Skip |
|--------|------|------|
| Software | entrypoints, owning module, tests, CI test command, API contracts | node_modules, dist, lockfile bodies |
| AI/ML | eval scripts, data schema paths, model/service entry, latency notes | large weight files, raw datasets |
| ADAS | requirements/specs, interface defs, scenario tests, safety notes in-repo | binary logs, unlabeled bag dumps |
| Design | brief, component library tokens, accessibility notes, target platform | full binary design exports in prompt |
| HR | policy templates, process docs, role text, stated compliance limits | confidential employee data |
| Finance | metric definitions, templates, field names, stated systems/time range | live credentials, bulk extracts |

## Include format (sparse)

```
- path/or/doc — role; key symbols or fields
- CI/process: `npm test` / "HR policy review checklist"
```

Prefer ≤5 short bullets unless the task truly needs more. Code excerpts ≤5 lines each.

## Always exclude

- Secrets, `.env*`, keys, tokens, personal data  
- `node_modules/`, `vendor/`, `dist/`, `build/`, `.git/`  
- Lockfile bodies, bulk generated code, raw dataset blobs  
- Unrelated monorepo packages outside the task boundary  

## Empty or non-code workspace

State under Context: what is missing. Rely on Assumptions. Use one **Blocking clarification** only if correctness cannot proceed.
