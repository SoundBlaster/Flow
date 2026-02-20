# Workflow Commands

**Version:** 1.0.0

## Overview

This folder holds the command prompts that orchestrate the documentation-driven workflow. Each command focuses on one phase:

| Command | Purpose | Reference |
|---------|---------|-----------|
| **SETUP** | **Configure Flow for your project (run first!)** | [SETUP.md](./SETUP.md) |
| SELECT  | Pick the next task from the workplan | [SELECT.md](./SELECT.md) |
| PLAN    | Write the implementation PRD for the selected task | [PLAN.md](./PLAN.md) |
| EXECUTE | Run pre-flight/post-flight steps around your coding | [EXECUTE.md](./EXECUTE.md) |
| PROGRESS | Optional checkpointing inside `next.md` | [PROGRESS.md](./PROGRESS.md) |
| REVIEW  | Produce structured code reviews | [REVIEW.md](./REVIEW.md) |
| ARCHIVE | Move finished PRDs into `SPECS/ARCHIVE/` | [ARCHIVE.md](./ARCHIVE.md) |
| REBUILD | Spec-driven rebuild workflow | [REBUILD.md](./REBUILD.md) |

Additional helpers live in `PRIMITIVES/` (toolchain, commits, doc updates, archive maintenance).
Main tasks tracker: `SPECS/Workplan.md`.

## Workflow

```
SELECT → updates SPECS/INPROGRESS/next.md
 PLAN  → creates SPECS/INPROGRESS/{TASK}.md
EXECUTE → tests, linting, commits
             ↓
          ARCHIVE → moves completed PRDs into SPECS/ARCHIVE/
```

Running `PROGRESS` lets you keep `next.md` up to date during long tasks, while `REVIEW` provides independent quality checkpoints before or after merging.

## Structure

```
SPECS/
├── Workplan.md         # Main task tracker
├── CONFIG.md           # Project-specific configuration (optional)
├── ARCHIVE/            # Completed PRDs and specs
│   ├── INDEX.md        # Archive index
│   └── {TASK_ID}_{TASK_NAME}/  # Task-specific folder
│       ├── {TASK_ID}_{TASK_NAME}.md
│       └── {TASK_ID}_Validation_Report.md
├── INPROGRESS/         # Active task metadata and working PRDs
│   ├── next.md         # Current task summary
│   └── {TASK_ID}_{TASK_NAME}.md  # Detailed PRD per task
├── RULES/              # Writing rules (optional)
├── COMMANDS/           # This folder
│   ├── README.md
│   ├── SELECT.md
│   ├── PLAN.md
│   ├── EXECUTE.md
│   ├── PROGRESS.md
│   ├── REVIEW.md
│   ├── ARCHIVE.md
│   ├── REBUILD.md
│   └── PRIMITIVES/     # Helper primitives
└── ...others…          # Documentation, etc.
```

## Quick Start

1. Run `SELECT` to choose the highest-priority task from `SPECS/Workplan.md` and write `SPECS/INPROGRESS/next.md`.
2. Run `PLAN` to produce the PRD in `SPECS/INPROGRESS/{TASK_ID}_{TASK_NAME}.md`.
3. Run `EXECUTE` to follow the PRD, run tests/linting, and commit.
4. Repeat. When a task finishes, move it to `SPECS/ARCHIVE/` via ARCHIVE.

## First-Time Setup

**New to Flow? Start with SETUP:**

1. Read [`SETUP.md`](./SETUP.md) — guides you through configuration
2. Edit template files in `SPECS/TEMPLATES/`:
   - `ProjectInfo.md` — project name, description, stack
   - `QualityGates.md` — your test/lint/coverage commands
   - `NFRs.md` — performance budgets (optional)
   - `Structure.md` — directory layout (optional)

## Customization via Templates

Flow uses **template files** instead of a rigid config file:

```
SPECS/TEMPLATES/
├── ProjectInfo.md      # @SPECS/TEMPLATES/ProjectInfo.md
├── QualityGates.md     # @SPECS/TEMPLATES/QualityGates.md
├── NFRs.md             # @SPECS/TEMPLATES/NFRs.md
└── Structure.md        # @SPECS/TEMPLATES/Structure.md
```

Commands reference these templates using `@` notation. Example from EXECUTE.md:

```markdown
## Quality Gates

@SPECS/TEMPLATES/QualityGates.md

Run the commands defined above.
```

This means:
- Templates are human-readable Markdown
- You can use formatting, comments, examples
- Commands get your project-specific instructions automatically
- No special parsing or syntax to learn

## Notes

- **Run SETUP first** to configure templates for your project
- Keep `SPECS/INPROGRESS/` slim—only one task should be active at a time.
- Document completed work in `SPECS/ARCHIVE/` (PRDs stay for reference) and update `SPECS/Workplan.md` when needed.
- This workflow is language-agnostic. Configure your quality gates in `SPECS/TEMPLATES/QualityGates.md`.
