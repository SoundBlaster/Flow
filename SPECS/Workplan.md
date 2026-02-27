# Workflow: Task System Abstraction via Params + Skills (Flow Method)

> Goal: Make “task tracking” (issues/boards/PR linking) a **portable part of the Flow method** using `.flow/params.yaml` + **Skills**, while keeping Flow **non-agentic** and enforcement done via **guardrails/CI validation**.

---

## Phase 1 — Task System Parameters (portable config)

#### ✅ P1-T1: Add `task_system` section to `.flow/params.yaml`
- **Description:** Define a repo-configurable abstraction for task tracking (GitHub/Jira/Linear/none) without any API execution. This is the canonical contract the method relies on.
- **Priority:** P0
- **Dependencies:** none
- **Parallelizable:** no
- **Outputs/Artifacts:**
  - `.flow/params.yaml` (new `task_system` section)
  - `SPECS/COMMANDS/*` references updated (if they mention task fields explicitly)
- **Acceptance Criteria:**
  - [ ] `.flow/params.yaml` includes minimal `task_system.kind` (`github|jira|linear|none`)
  - [ ] Optional task-system detail fields are intentionally lightweight in params and delegated to Skills
  - [ ] Command docs clearly state which task metadata is sourced from Skill guidance vs params
  - [ ] Schema/validation documents which `task_system` keys are required vs optional

#### ⬜️ P1-T2: Define canonical TaskID types + runtime I/O contract
- **Description:** Define abstract TaskID categories and the normalized task-reference I/O that runtime commands consume/produce, independent of any specific task tool.
- **Priority:** P0
- **Dependencies:** P1-T1
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `SPECS/Workplan.md` section describing TaskID type families (e.g., numeric, prefixed, slug/hybrid)
  - Canonical Task Reference input/output contract for SELECT/PLAN/ARCHIVE
  - `SPECS/COMMANDS/SELECT.md`, `SPECS/COMMANDS/PLAN.md`, `SPECS/COMMANDS/ARCHIVE.md` updated to use the abstract contract
- **Acceptance Criteria:**
  - [ ] Common TaskID type families are documented with examples
  - [ ] Runtime contract defines required inputs (`TaskID`, `Title`, `Source`) and outputs (`TaskRef`, archive backlink placeholders)
  - [ ] SELECT/PLAN/ARCHIVE explicitly consume/emit the same normalized task reference fields
  - [ ] Commands remain compatible with task-management Skills at runtime without hardcoding one tool

---

## Phase 2 — Runtime Task Interop (tool/skill agnostic)

#### ⬜️ P2-T1: Define task-management adapter contract for runtime commands
- **Description:** Specify a tool-agnostic adapter contract that any task-management implementation (manual process, script, or Skill) can satisfy at runtime.
- **Priority:** P0
- **Dependencies:** P1-T2
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - Adapter contract doc (inputs/outputs for pick/select/plan/archive operations)
  - References from relevant commands (SELECT/PLAN/EXECUTE/ARCHIVE)
- **Acceptance Criteria:**
  - [ ] Contract defines required runtime operations and normalized return fields
  - [ ] Contract explicitly permits multiple implementations (tool CLI, API wrapper, Skill, or manual)
  - [ ] Evidence requirements are expressed in artifact terms (Workplan/Archive links), not vendor-specific actions

#### ⬜️ P2-T2: Define task state transition abstraction aligned to Flow steps
- **Description:** Describe state transition intent across Flow phases without binding to tracker-specific state names.
- **Priority:** P1
- **Dependencies:** P1-T1
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - State transition mapping spec tied to Flow steps
- **Acceptance Criteria:**
  - [ ] Transitions are defined for SELECT → PLAN → EXECUTE → REVIEW → ARCHIVE
  - [ ] Mapping uses abstract lifecycle states and allows implementation-level translation
  - [ ] Archive evidence includes a recorded status-change note (manual or automated)

#### ⬜️ P2-T3: Define task capture + triage minimum contract (optional but recommended)
- **Description:** Provide a minimal, implementation-agnostic contract for creating and triaging tasks (priority/scope/owner).
- **Priority:** P2
- **Dependencies:** P1-T1
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - Capture contract doc (minimum fields and validation)
  - Triage contract doc (priority rubric and sizing guidance)
- **Acceptance Criteria:**
  - [ ] Capture contract references the minimal required task metadata from params
  - [ ] Triage contract defines P0–P3 criteria and small-diff guidance
  - [ ] Both contracts define evidence that is checkable in Workplan artifacts

---

## Phase 3 — Flow Blueprint (FLOW.md) Runtime Integration

#### ⬜️ P3-T1: Update `FLOW.md` with runtime task checkpoints
- **Description:** Treat `FLOW.md` as the runtime blueprint and add explicit gates for normalized task references, linkage evidence, and status recording.
- **Priority:** P0
- **Dependencies:** P1-T2, P2-T1
- **Parallelizable:** no
- **Outputs/Artifacts:**
  - `FLOW.md` (updated checkpoints)
- **Acceptance Criteria:**
  - [ ] SELECT step includes “normalized Task Reference required” gate
  - [ ] PLAN step includes “minimum task metadata present” gate
  - [ ] EXECUTE includes “PR/commit carries TaskID” guidance without requiring a specific integration method
  - [ ] ARCHIVE includes “backlinks + status-update note recorded” gate
  - [ ] `FLOW.md` references the adapter/interop contract rather than a single tool

#### ⬜️ P3-T2: Update command docs to consume abstract runtime contracts
- **Description:** Ensure each relevant command declares normalized inputs/outputs, evidence checklists, and optional runtime integration mechanisms.
- **Priority:** P1
- **Dependencies:** P2-T1, P2-T2
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `SPECS/COMMANDS/SELECT.md`
  - `SPECS/COMMANDS/PLAN.md`
  - `SPECS/COMMANDS/EXECUTE.md` (if exists)
  - `SPECS/COMMANDS/ARCHIVE.md`
- **Acceptance Criteria:**
  - [ ] Each updated command has an “Inputs/Outputs” section using normalized task fields
  - [ ] Each updated command has “Evidence” checklists tied to Workplan/Archive artifacts
  - [ ] Commands may call a runtime Skill/adapter but do not assume one vendor/tool implementation

---

## Phase 4 — Guardrails and CI Validation (enforcement without agentification)

#### ⬜️ P4-T1: Add schema validation for `.flow/params.yaml` and Skill metadata
- **Description:** Add CI job that validates structural correctness and reference integrity (skills referenced by commands exist, required params exist).
- **Priority:** P0
- **Dependencies:** P1-T1, P2-T1
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `.github/workflows/flow-validate.yml`
  - `SPECS/SCHEMAS/flow-params.schema.json` (or similar)
  - `SPECS/SCHEMAS/flow-policy.schema.json` (if already planned)
- **Acceptance Criteria:**
  - [ ] CI fails if `.flow/params.yaml` missing required keys for `task_system`
  - [ ] CI fails if `FLOW.md` references missing skills (by canonical id)
  - [ ] CI fails if commands reference missing skill docs
  - [ ] CI produces clear error messages pointing to missing/invalid fields

#### ⬜️ P4-T2: Add PR template “Flow Evidence” (TaskID + Skills evidence)
- **Description:** Enforce discipline by requiring TaskID and evidence checklist in PR description.
- **Priority:** P1
- **Dependencies:** P2-T1, P1-T2
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `.github/pull_request_template.md`
- **Acceptance Criteria:**
  - [ ] Template has TaskID + TaskURL fields
  - [ ] Template has checklist for Workplan link + Archive update
  - [ ] Template has “Skills applied” checklist referencing `skill.task.linkage` at minimum

#### ⬜️ P4-T3: Add diff-scope guardrails (protected paths / max diff)
- **Description:** Add CI/Action that warns/fails on oversized diffs and protected path edits unless explicitly justified (method guardrails).
- **Priority:** P2
- **Dependencies:** P4-T1
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `.flow/policy.yaml` (if not already present) or extend it
  - `.github/workflows/flow-guardrails.yml`
- **Acceptance Criteria:**
  - [ ] Policy supports `protected_paths` and `max_diff_lines`
  - [ ] CI checks PR diff size and fails/warns when over limit
  - [ ] CI checks changed files against `protected_paths` and requires justification text in PR body

---

## Phase 5 — Documentation and Adoption

#### ⬜️ P5-T1: Document “Task System portability” in README
- **Description:** Explain how a repo can adopt Flow with GitHub Issues, Jira, Linear, or “none,” purely via params + skills.
- **Priority:** P2
- **Dependencies:** P1-T1, P2-T1, P4-T1
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `README.md` (section: Task system abstraction)
  - `examples/params.github.yaml`, `examples/params.jira.yaml`, `examples/params.linear.yaml`
- **Acceptance Criteria:**
  - [ ] README explains `task_system` fields with at least one complete example
  - [ ] Examples cover different TaskID patterns and link templates
  - [ ] README clarifies Flow is a method, not a runner/agent

---

## Optional Follow-ups

#### ⬜️ FU-TASK-EVIDENCE-1: Add “Archive entry lint” (ensures backlinks exist)
- **Description:** Add a linter that checks Archive entries contain TaskID + PR/commit link placeholders.
- **Priority:** P3
- **Dependencies:** P1-T2, P4-T1
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `scripts/flow-archive-lint.sh` (or equivalent)
  - CI integration into `flow:validate`
- **Acceptance Criteria:**
  - [ ] CI fails if Archive entry missing TaskID
  - [ ] CI fails if Archive entry missing PR/commit link
