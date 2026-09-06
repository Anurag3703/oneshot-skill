# Domain packs

Load only the section matching the user's domain. Software and AI are primary; others are supported with the same pipeline.

Shared rule for every domain: observable Validation + concrete Definition of Done. Never invent company policy, legal advice, or safety certification.

---

## Software / coding (primary)

**Context:** manifests, owning modules, tests, CI commands, API contracts.  
**Constraints:** minimal change, compatibility, security of secrets/PII in code.  
**Validation:** build/typecheck, targeted tests, no unrelated regressions.  
**DoD:** behavior matches objective; tests green; change summarized.

## AI / ML (primary)

**Context:** training/eval scripts, data paths or schemas, model/service entrypoints, latency notes.  
**Constraints:** success metric, data assumptions, cost/latency budgets if known.  
**Validation:** eval method stated; failure cases covered; deployment/monitoring notes if in scope.  
**DoD:** metric and eval defined; implementation or plan matches objective; risks listed.

## ADAS / embedded / safety-adjacent

**Context:** requirements/specs, interfaces, existing perception/planning/control modules, test benches, safety notes in-repo.  
**Constraints:** do not claim functional-safety certification; prefer existing architecture; deterministic behavior where required; explicit ODD (operational design domain) if present.  
**Validation:** scenario/tests named; failure modes (sensor loss, latency overrun) addressed; no silent behavior change on safety paths.  
**DoD:** change limited to stated scope; tests/scenarios pass or are clearly specified; residual risks documented.

**Avoid:** inventing ISO/ASIL compliance evidence not in context.

## Design (product / UX / visual)

**Context:** briefs, existing components/design system tokens, accessibility notes, target surfaces (web/mobile).  
**Constraints:** audience, brand/system consistency, accessibility, delivery format (Figma-ready spec, markdown UI copy, component props — only what the workspace supports).  
**Validation:** requirements from the brief covered; states (empty/loading/error) specified if UI; accessibility checks listed.  
**DoD:** usable artifact delivered in the requested format; open questions isolated, not buried.

**Avoid:** dumping full binary design files into the prompt; reference paths/names only.

## HR (people / process)

**Context:** existing policy templates, role descriptions, process docs, compliance constraints stated by the user.  
**Constraints:** neutral professional tone; no fabricated legal claims; respect confidentiality; jurisdiction only if provided.  
**Validation:** required sections present; actionable next steps; sensitive fields called out for human review.  
**DoD:** finished draft or process spec matching the request; human-review items listed explicitly.

**Avoid:** presenting the agent output as final legal/HR advice.

## Finance (analysis / reporting / process)

**Context:** metric definitions, report templates, data field names, systems named by the user, audit constraints if any.  
**Constraints:** show formulas/assumptions; no invented market data; separate fact vs assumption; reproducibility of calculations.  
**Validation:** inputs and formulas stated; units and time range clear; sensitivity or known limitations noted when material.  
**DoD:** decision-ready artifact with traceable assumptions; numbers reproducible from stated inputs.

**Avoid:** fabricating financial figures or regulatory conclusions.

---

## Choosing domain + task type

1. Infer domain from vocabulary (code/repo → software; model/eval → AI; vehicle/perception → ADAS; brief/UI → design; policy/hiring → HR; P&L/forecast → finance).  
2. Infer task type (implement, debug, compare, draft, analyze, plan).  
3. Merge: domain supplies constraints/validation flavor; task type supplies step structure.  
4. If mixed (e.g. AI + software service), prefer software execution steps plus AI eval constraints.
