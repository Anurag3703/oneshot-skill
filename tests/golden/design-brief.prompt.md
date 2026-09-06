# Redesign Settings Page Empty State

## Objective
Produce an implementation-ready specification for the settings page empty state that matches the existing design system and covers key UI states.

## Context
- Infer design-system tokens and settings route from the workspace when present
- Target surface is the settings empty state (no user configuration yet)

## Constraints
- Match existing design-system components and spacing language
- Include empty, loading, and error-capable copy/structure as applicable
- Accessibility: focus order, contrast, and non-color-only meaning
- Do not invent brand rules not present in context

## Execution Steps
1. Inspect workspace for design-system components, settings page structure, and any empty-state patterns.
2. Define content and layout for the empty state aligned to existing patterns.
3. Specify component usage, spacing, and copy.
4. Call out accessibility requirements for the state.
5. List open questions only if they block implementation.

## Expected Output
- Concise UI spec (markdown) usable by engineering or design handoff
- Component names from the design system when known

## Validation
- Brief requirements covered
- Empty (and related) states specified
- Accessibility checks listed
- No unrelated pages redesigned

## Definition of Done
A usable empty-state spec exists that matches system conventions and is ready for implementation without a second clarifying round for basic structure.
