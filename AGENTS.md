# Flow - Agentic Workflow

## Project Overview

**Flow** is a text prompt-based agentic workflow framework designed for open source contribution. It mimics real-world software development processes through a linear, step-by-step execution of commands.

Each command in Flow is a prompt that guides AI agents through a structured workflow. The framework is methodology-focused rather than code-focused - it provides a standardized process for task selection, planning, execution, review, and archival.

### Core Philosophy

- **Method over implementation**: Flow defines the process, not the code
- **Linear execution**: Step-by-step workflow without skipping phases
- **Source of Truth**: `SPECS/Workplan.md` is the single source of truth for all tasks
- **Current state tracking**: Active tasks are temporarily placed in the `SPECS/INPROGRESS/` folder with `next.md` logging the current task

## Project Structure

```
Flow/
├── README.md              # Project overview and ideology
├── LICENSE                # MIT License
├── .gitignore             # Excludes logs/ directory
└── AGENTS.md              # This file
```

### Key Directories (Referenced by Workflow)

- `SPECS/COMMANDS/` - Workflow command definitions (FLOW.md, SELECT.md, PLAN.md, etc.)
- `SPECS/Workplan.md` - Product roadmap and task queue
- `SPECS/INPROGRESS/` - Currently active task artifacts
- `SPECS/ARCHIVE/` - Completed task archives

## Technology Stack

- **Language**: Markdown-based workflow definitions
- **Storage**: Git-based version control
- **Skills**: Skill standard framework (`~/.agents/skills/`)

## Workflow Commands

The Flow workflow consists of 8 main commands executed in sequence:

1. **BRANCH** - Create feature branch for the task
2. **SELECT** - Choose the next task from the workplan
3. **PLAN** - Create task PRD with deliverables and acceptance criteria
4. **EXECUTE** - Implement the task according to PRD
5. **ARCHIVE** - Move completed task artifacts to archive
6. **REVIEW** - Review the implementation
7. **FOLLOW-UP** - Address review findings (if any)
8. **ARCHIVE-REVIEW** - Archive review reports

These are grouped under the **FLOW** meta-command which serves as the entry point.

## Skills

Flow is enhanced by agent skills that wrap prompts into CLI shortcuts. Skills are installed at `~/.agents/skills/` and include:

### Core Flow Skills

| Skill | Purpose | Location |
|-------|---------|----------|

## Development Conventions

### Commit Message Patterns

Follow these patterns when committing during workflow execution:

- **Branch**: `Branch for {TASK_ID}: {short description}`
- **Select**: `Select task {TASK_ID}: {TASK_NAME}`
- **Plan**: `Plan task {TASK_ID}: {TASK_NAME}`
- **Execute**: `Implement {TASK_ID}: {brief description of changes}`
- **Archive**: `Archive task {TASK_ID}: {TASK_NAME} ({VERDICT})`
- **Review**: `Review {TASK_ID}: {short subject}`
- **Follow-up**: `Follow-up {TASK_ID}: {short subject}`

### File Naming Conventions

- Task PRD: `SPECS/INPROGRESS/{TASK_ID}_{TASK_NAME}.md`
- Validation Report: `SPECS/INPROGRESS/{TASK_ID}_Validation_Report.md`
- Review Report: `SPECS/INPROGRESS/REVIEW_{subject}.md`
- Archive folder: `SPECS/ARCHIVE/{TASK_ID}_{TASK_NAME}/`

### Git Workflow

1. Ensure `main` is up to date before starting
2. Create feature branch: `feature/{TASK_ID}-{short-description}`
3. Stage only task-relevant files (avoid `git add .`)
4. Use present-tense commit subjects
5. Create commit checkpoint after each major phase

## Testing and Quality Gates

During the EXECUTE phase, run required quality gates:

- Run test suite
- Linting (if configured)
- Type checking (if configured)
- Test Code Coverage

## Execution Contract

When running the Flow workflow:

1. Read `SPECS/COMMANDS/FLOW.md` at the beginning as source of truth
2. Complete steps in order without skipping unless explicitly allowed
3. Create commit checkpoint after each major step
4. Run required quality gates during EXECUTE
5. Record artifacts in expected locations
6. If REVIEW has no actionable issues, skip FOLLOW-UP and proceed directly to ARCHIVE-REVIEW

## License

MIT License - Copyright (c) 2026 Egor Merkushev
