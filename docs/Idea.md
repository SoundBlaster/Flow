# Idea — Flow prompts + configs (canon/overlay/lock)

## Context

Flow is a prompt-based agentic workflow framework that standardizes open-source contribution through a **linear 10-step process**:

SELECT → BRANCH → PLAN → EXECUTE → ARCHIVE → REVIEW → FOLLOW-UP → ARCHIVE-REVIEW → PR → CI-REVIEW.

The key design goal is **method over tools**:
- humans review **compiled, readable instructions**
- agents maintain **machine-friendly configuration** and apply the workflow consistently.

This document captures the core concept we discussed: **separate “what the workflow is” from “how this repo instantiates it”**, and make updates safe.

---

## Problem

If a repository is bootstrapped interactively (agent writes prompts/instructions on first run), then future updates of Flow become hard:
- repo maintainers edit generated Markdown
- upstream updates cannot be layered cleanly
- it becomes unclear what is “canonical” vs “local customization”

We need a model where:
- upstream workflow evolves without breaking repos
- repo customization stays minimal, structured, and migratable
- humans read stable Markdown outputs, not config “mush”

---

## Solution: Canon + Overlay + Render (source vs artifact)

Flow adopts a three-layer approach:

### 1) Canon (Upstream workflow definition)
A canonical workflow definition (conceptually “Hypercode”) lives upstream.
It defines:
- the 10 steps and their meaning
- stable IDs for steps/operations
- expected inputs/outputs per step
- policies/guardrails (allowed side effects, allowlists)
- variables (placeholders) that may be configured per repo

**Canon is the source of truth for structure.**
It is versioned and updatable.

Example location (concept):
- `UPSTREAM/WORKFLOWS/flow-swiftpm.hc`

### 2) Overlay (Repo-local customization)
A repo keeps a small customization layer (conceptually “Cascade Sheet”) that contains:
- values for repo-specific variables (test command, lint command, default branch, etc.)
- minimal patch operations (append/replace) to extend allowlists or paths
- optional `why` notes for auditability

Overlay must be:
- small and readable
- machine-writable (agents can bootstrap/update it)
- safe to merge during upstream updates

Example location:
- `.agentready/repo.hcs`

### 3) Render (Compiled human-facing prompts/docs)
From (Canon + Overlay), Flow produces compiled artifacts:
- `AGENTS/WORKFLOW.md` — human summary of the workflow
- `AGENTS/EFFECTIVE.md` — human summary of “effective config”
- `AGENTS/PROMPTS/*.md` — step prompts the agent actually follows
- `AGENTS/.build/flow.lock.json` — machine lockfile (versions + hashes + effective values)

These outputs are **generated artifacts**, safe to overwrite on every compile.

---

## Why this works

- Humans read Markdown outputs (stable format, clear picture).
- Agents write/maintain overlay (structured diffs, minimal conflicts).
- Upstream workflow updates are safe because local customizations are layered, not copied into text.
- Lockfile provides reproducibility and makes migrations possible (detect drift, warn on breaking changes).

---

## Local-first adoption (Dry-run “half mode”)

To reduce friction, Flow must work locally without pushing anything:
- compile validates and renders outputs
- no network access
- no command execution by default
- writes only to `AGENTS/` (and `.agentready/` only during bootstrap)

Conceptual commands:
- `flow bootstrap` → create/update `.agentready/repo.hcs`
- `flow compile --dry-run` → render compiled artifacts + validate policies

---

## Guardrails and Safety (L4-ish upgrades)

Flow’s process guardrails are strengthened by repository boundaries:

### CODEOWNERS as boundaries
Use `.github/CODEOWNERS` to map paths to owners.
When GitHub settings enforce “Require review from Code Owners”, changes to owned paths cannot be merged without required approvals.

### Frozen contracts
Add `contracts/` for stability boundaries:
- contract changes require stricter review (CODEOWNERS)
- PRD must explicitly declare “Contracts touched”
- validation plan must exist (tests/snapshots)

### Lightweight coordination: Area locks
For multi-agent work, add:
- `SPECS/INPROGRESS/locks/<AREA>.lock`

SELECT/PLAN must:
- determine affected Areas
- check for conflicting locks
- claim locks for current task

This prevents multiple agents from stepping on the same area.

---

## What stays tool-agnostic

Flow does **not** mandate:
- a specific agent vendor
- a specific runtime (Actions/local/0AL)
- a specific test/lint stack

Flow mandates only:
- step semantics + required artifacts
- strict ordering (unless explicitly conditional)
- policy boundaries (what can be changed/run)
- reproducible documentation outputs

---

## Minimal data model (conceptual)

### Variables (repo-specific)
- `repo.default_branch`
- `verify.tests.command`
- `verify.lint.command`
- `verify.format.command`

### Patch ops (overlay)
Keep patch operations limited for safety and migratability:
- `replace`
- `append`
- `remove`
- `merge` (optional)

### Stable IDs
All steps/ops have stable IDs so overlay references are resilient to text changes.

---

## Deliverable outcome

A repository adopting Flow has:
- a consistent, repeatable agent workflow
- predictable reviewable outputs
- safe boundaries and enforced gates
- easy upstream updates (canon changes + unchanged overlay + recompile)

This makes Flow a “methodology framework” that can later be reimplemented
without Hypercode/Hyperprompt — the core value is the contract structure and layering model.
