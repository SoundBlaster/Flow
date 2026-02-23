# Workflow: Task System Abstraction via Params + Skills (Flow Method)

> Goal: Make “task tracking” (issues/boards/PR linking) a **portable part of the Flow method** using `.flow/params.yaml` + **Skills**, while keeping Flow **non-agentic** and enforcement done via **guardrails/CI validation**.

---

## Phase 1 — Task System Parameters (portable config)

#### ⬜️ P1-T1: Add `task_system` section to `.flow/params.yaml`
- **Description:** Define a repo-configurable abstraction for task tracking (GitHub/Jira/Linear/none) without any API execution. This is the canonical contract the method relies on.
- **Priority:** P0
- **Dependencies:** none
- **Parallelizable:** no
- **Outputs/Artifacts:**
  - `.flow/params.yaml` (new `task_system` section)
  - `SPECS/COMMANDS/*` references updated (if they mention task fields explicitly)
- **Acceptance Criteria:**
  - [ ] `.flow/params.yaml` includes `task_system.kind` (`github|jira|linear|none`)
  - [ ] `task_system.id_patterns` exists and supports multiple patterns (list)
  - [ ] `task_system.link_templates` exists for task links (e.g., `task_url`, optional `board_url`)
  - [ ] `task_system.required_fields` exists (list of required fields at SELECT/PLAN)
  - [ ] `task_system.states` mapping exists (Flow steps → task states)

#### ⬜️ P1-T2: Define canonical Task Reference block format for artifacts
- **Description:** Standardize how TaskID/TaskURL/Title/Source appear in Workplan/Archive so every Flow run is attached to a “unit of value.”
- **Priority:** P0
- **Dependencies:** P1-T1
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `SPECS/Workplan.md` template section (documented snippet)
  - `SPECS/Archive.md` (or archive template) Task Reference section
  - `SPECS/COMMANDS/SELECT.md`, `SPECS/COMMANDS/PLAN.md`, `SPECS/COMMANDS/ARCHIVE.md` updates (if present)
- **Acceptance Criteria:**
  - [ ] Task Reference block includes `TaskID`, `TaskURL`, `Title`, `Source`
  - [ ] TaskURL is described as derived from `task_system.link_templates`
  - [ ] SELECT requires Task Reference to be filled before proceeding to PLAN
  - [ ] ARCHIVE requires backlinks (TaskID + PR/commit link placeholders)

---

## Phase 2 — Skills: Task Discipline as Method (not tools)

#### ⬜️ P2-T1: Create `skill.task.linkage` (Issue ↔ PR ↔ Workplan ↔ Archive)
- **Description:** Add a Skill doc that defines how to link tasks to PRs/commits and Flow artifacts. This is the heart of portability across trackers.
- **Priority:** P0
- **Dependencies:** P1-T2
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `SPECS/SKILLS/skill.task.linkage.md` (or `.flow/skills/skill.task.linkage.md`)
  - References from relevant commands (SELECT/PLAN/EXECUTE/ARCHIVE)
- **Acceptance Criteria:**
  - [ ] Skill document includes: Purpose, When to use, Steps, Anti-patterns, Evidence
  - [ ] Evidence requires TaskID in PR title/body (or documented alternative)
  - [ ] Evidence requires Task Reference present in Workplan and Archive
  - [ ] Defines backlinks: PR ↔ TaskURL, Archive ↔ PR/commit

#### ⬜️ P2-T2: Create `skill.task.status` (state transitions aligned to Flow)
- **Description:** Add a Skill doc describing how task status changes across Flow steps, mapped via params.
- **Priority:** P1
- **Dependencies:** P1-T1
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `SPECS/SKILLS/skill.task.status.md` (or `.flow/skills/skill.task.status.md`)
- **Acceptance Criteria:**
  - [ ] Skill defines transitions for SELECT → PLAN → EXECUTE → REVIEW → ARCHIVE
  - [ ] Uses `task_system.states` mapping (no hardcoded tracker states)
  - [ ] Evidence includes “status updated” note in Archive (even if manual)

#### ⬜️ P2-T3: Create `skill.task.capture` and `skill.task.triage` (optional but recommended)
- **Description:** Provide guidance for creating a good task (minimal required fields) and triaging (priority/scope/owner).
- **Priority:** P2
- **Dependencies:** P1-T1
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `SPECS/SKILLS/skill.task.capture.md`
  - `SPECS/SKILLS/skill.task.triage.md`
- **Acceptance Criteria:**
  - [ ] Capture skill references `task_system.required_fields`
  - [ ] Triage skill defines criteria for P0–P3 and scope sizing (small diff guidance)
  - [ ] Both include Evidence sections that are checkable in Workplan

---

## Phase 3 — Flow Blueprint (FLOW.md) integration

#### ⬜️ P3-T1: Update `FLOW.md` to include explicit “Task checkpoints”
- **Description:** Treat `FLOW.md` as the blueprint and add explicit gates for task reference, linkage, and status updates.
- **Priority:** P0
- **Dependencies:** P1-T2, P2-T1
- **Parallelizable:** no
- **Outputs/Artifacts:**
  - `FLOW.md` (updated checkpoints)
- **Acceptance Criteria:**
  - [ ] SELECT step includes “Task Reference required” gate
  - [ ] PLAN step includes “required_fields satisfied” gate
  - [ ] EXECUTE includes “PR/commit must include TaskID” guidance (via linkage skill)
  - [ ] ARCHIVE includes “backlinks + status update recorded” gate
  - [ ] `FLOW.md` references the relevant Skills by name

#### ⬜️ P3-T2: Update command docs to reference Skills (not tools)
- **Description:** Ensure each relevant command lists required Skills and required Evidence outputs.
- **Priority:** P1
- **Dependencies:** P2-T1, P2-T2
- **Parallelizable:** yes
- **Outputs/Artifacts:**
  - `SPECS/COMMANDS/SELECT.md`
  - `SPECS/COMMANDS/PLAN.md`
  - `SPECS/COMMANDS/EXECUTE.md` (if exists)
  - `SPECS/COMMANDS/ARCHIVE.md`
- **Acceptance Criteria:**
  - [ ] Each updated command has a “Required Skills” section
  - [ ] Each updated command has “Outputs/Artifacts” and “Evidence” checklists
  - [ ] No command implies automated execution; all actions are method steps

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
