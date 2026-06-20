---
name: implement
version: 1.0.0
description: |
  Six phases workflow for implementing code changes using LLM agents.
  Scope → Localize → Plan → Implement → Verify → Cross-Review.
  Use when asked to "implement", "build a feature", "fix this bug",
  or when starting any non-trivial code change.
triggers:
  - implement this
  - build this feature
  - implement workflow
  - structured implementation
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Agent
  - AskUserQuestion
---

# /implement — Implementation Workflow

Follow these six phases in order. Each phase has a gate — do not proceed until the gate is met.

---

## Phase 1: Scope (Definition of Ready)

Before touching code, answer these five questions. If any answer is unclear, ask the user.

1. **What is the observable behavior change?** (not "refactor X" — what does the user see differently?)
2. **What are the boundaries?** (files/modules in scope, what is explicitly NOT in scope)
3. **What are the negative constraints?** (do not change unrelated files, do not add new dependencies, do not refactor surrounding code)
4. **What are the verification criteria?** (specific tests, commands, or observable outcomes that prove success — must be runnable, not subjective)
5. **What is the risk tier?** (reversible file edit → irreversible schema change → production-affecting)

**Gate:** All five questions answered. Write them down as a checklist before proceeding.

---

## Phase 2: Localize (Hierarchical, Not Broad)

Use coarse-to-fine localization. Do NOT read entire directories or do broad exploration.

1. **File level:** Identify the 2-5 most relevant files. Use grep/find for symbols, not directory walks.
2. **Function level:** Read only the relevant functions/classes in those files. Use skeleton views (signatures, not full source) to orient first.
3. **Line level:** Identify the specific lines that need to change.

Read only what you need.

**Gate:** You can name the specific functions and approximate line ranges that will change.

---

## Phase 3: Plan (Annotate, Don't Implement)

Write a concrete plan as a numbered list of changes. Each item must specify:
- **File and function** to modify
- **What changes** (add/modify/remove)
- **Why** (links back to scope)

### Plan review cycle

If the task is non-trivial (>3 files or >50 lines changed), use the annotation cycle:

1. Write the plan
2. Present to user for review
3. Address feedback WITHOUT implementing — revise the plan only
4. Repeat until user approves

### Prompt template for planning

When generating a plan, structure your thinking as:

> Given the scope [X] and constraints [Y], I need to change:
> 1. `file:function` — [what] because [why]
> 2. `file:function` — [what] because [why]
>
> I will NOT: [negative constraints from Phase 1]
>
> Verification: after implementation, I will run [specific commands] and expect [specific outcomes]

**Gate:** Plan exists with specific file:function targets, user has approved (or task is trivial enough to skip approval).

---

## Phase 4: Implement (One Vertical Slice at a Time)

Implement in vertical slices, not horizontal layers. Each slice:
1. Makes one logical change
2. Can be independently verified
3. Does not leave the codebase in a broken state

### Implementation constraints

Include these in your working context:
- Do not deviate from the approved plan
- Do not change files not listed in the plan
- Do not add packages, abstractions, or refactors beyond what the plan specifies
- Do not add comments explaining what the code does (only why, when non-obvious)
- If you discover the plan is wrong, STOP and revise the plan first — do not improvise

### After each slice

Run the relevant subset of verification criteria. Fix failures immediately before moving to the next slice. This catches errors while context is fresh.

**Gate:** All slices implemented. No known test failures.

---

## Phase 5: Verify (Separate Diagnosis from Fixing)

Run the full verification criteria from Phase 1. If anything fails:

### Two-pass error handling

**Pass 1 — Diagnose only (do not edit files):**
> Run the failing test/command. Read the error output. Explain:
> 1. What does this error tell us?
> 2. What is the root cause? (not the symptom)
> 3. What is the minimal fix?

**Pass 2 — Fix only confirmed issues:**
Apply ONLY the fix identified in Pass 1. Re-run verification.

### Retry limits

After round 3, you are likely introducing new bugs or looping.

- **Round 1-3:** Fix normally using the two-pass method above
- **Round 4:** If still failing, STOP. Present the situation to the user: what works, what doesn't, what you've tried. Let the user decide next steps.
- **Never:** Do not retry the same fix that already failed. Do not apply a fix without first diagnosing in a separate pass.

### Chain-of-thought repair prompts

When debugging, always explain the bug before fixing it. This adds ~5pp success rate over jumping straight to a fix:

> The test fails because [error]. This happens because [root cause in the code].
> The fix is [specific change] in [file:line].

**Gate:** All verification criteria from Phase 1 pass, OR user has been informed of remaining issues and decided how to proceed.

---

## Phase 6: Cross-Review (Optional but Recommended)

For non-trivial changes, get a second opinion from a different model or fresh context.
- Different failure modes across model families
- Fresh context outperforms same-context review (no accumulated bias)

### How to request cross-review

Use the `/codex` skill or ask the user to review. When requesting review from another agent:

> Review this diff for:
> 1. Logic errors (does the code do what the plan says?)
> 2. Edge cases (what inputs would break this?)
> 3. Unintended side effects (what else does this change affect?)
>
> Do NOT suggest style changes, refactors, or improvements beyond the scope of [original task].
> If you find no issues, say "no issues found" — do not invent concerns.

### Review response handling

- **Assess only first.** Read the review. Decide which findings are real. Do not apply all suggestions blindly.
- **Fix confirmed issues only.** Apply the two-pass method from Phase 5.
- **Three review rounds is sufficient.** Research shows iterating review beyond round 3 produces noise, not signal.

**Gate:** Review complete (or skipped for trivial changes). Implementation is done.
