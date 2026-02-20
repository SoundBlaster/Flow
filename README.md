# Flow — Agentic Workflow Framework

**Version:** 1.0.0

> **Flow** is a documentation-driven agentic workflow framework for software development.

## Overview

Flow mimics real-world software development through a linear, step-by-step execution of commands. Each command is a prompt that guides AI agents (and humans) through a structured workflow.

```
SELECT → PLAN → EXECUTE → ARCHIVE → REVIEW → FOLLOW-UP → ARCHIVE-REVIEW
   ↓       ↓        ↓         ↓         ↓          ↓             ↓
 COMMIT  COMMIT   COMMIT    COMMIT    COMMIT     COMMIT        COMMIT
```

## Philosophy

- **Method over implementation** — Flow defines the process, not the code
- **Linear execution** — Step-by-step workflow without skipping phases
- **Documentation-driven** — PRDs and specs are first-class artifacts
- **Source of Truth** — `SPECS/Workplan.md` tracks all tasks
- **Language-agnostic** — Works with any tech stack via templates

## Quick Start

### 1. Copy Flow to Your Project

```bash
# Copy the SPECS folder to your project
cp -r /path/to/Flow/SPECS ./SPECS
```

### 2. Configure for Your Project

```bash
# Read the setup guide
cat SPECS/COMMANDS/SETUP.md

# Edit templates to match your project
edit SPECS/TEMPLATES/QualityGates.md    # Your test/lint commands
edit SPECS/TEMPLATES/ProjectInfo.md     # Project name & stack
edit SPECS/TEMPLATES/NFRs.md            # Performance budgets (optional)
```

### 3. Create Your Workplan

```bash
# Customize the workplan with your tasks
edit SPECS/Workplan.md
```

### 4. Run the Workflow

Follow the steps in `SPECS/COMMANDS/FLOW.md`:

1. **SELECT** — Choose the next task from the workplan
2. **PLAN** — Create the implementation PRD
3. **EXECUTE** — Implement with quality gates
4. **ARCHIVE** — Move completed work to archive
5. **REVIEW** — Review and capture findings

## Structure

```
SPECS/
├── COMMANDS/              # Workflow prompts (read-only)
│   ├── FLOW.md            # Main workflow
│   ├── SETUP.md           # Configuration guide
│   ├── SELECT.md          # Task selection
│   ├── PLAN.md            # Task planning
│   ├── EXECUTE.md         # Implementation
│   ├── ARCHIVE.md         # Task archival
│   ├── REVIEW.md          # Code review
│   └── PRIMITIVES/        # Helper commands
├── TEMPLATES/             # 🎨 Your project config (edit these)
│   ├── QualityGates.md    # Test, lint, coverage commands
│   ├── ProjectInfo.md     # Project metadata
│   ├── NFRs.md            # Performance budgets
│   └── Structure.md       # Directory layout
├── Workplan.md            # Your task tracker (edit this)
├── INPROGRESS/            # Active task artifacts
└── ARCHIVE/               # Completed task artifacts
```

## The Template System

Flow uses **template files** for project-specific configuration:

- **QualityGates.md** — Your test, lint, and coverage commands
- **ProjectInfo.md** — Project name, language, stack
- **NFRs.md** — Performance budgets and constraints
- **Structure.md** — Directory layout

Commands reference templates using `@` notation:

```markdown
<!-- In EXECUTE.md -->
@SPECS/TEMPLATES/QualityGates.md
```

This means:
- No rigid config file format to learn
- Templates are plain Markdown
- Easy to edit and version control
- Commands get context automatically

## Commands

| Command | Purpose |
|---------|---------|
| **SETUP** | Configure Flow for your project |
| SELECT | Pick the next task from the workplan |
| PLAN | Write the implementation PRD |
| EXECUTE | Run implementation with quality gates |
| ARCHIVE | Move completed tasks to archive |
| REVIEW | Structured code review |
| FOLLOW-UP | Create tasks from review findings |

## Example: Quality Gates Template

Your `SPECS/TEMPLATES/QualityGates.md`:

```markdown
### Testing
```bash
pytest -v
```

### Linting
```bash
ruff check src/
```

**Coverage Threshold:** 85%
```

The `EXECUTE` command reads this and runs your specific quality gates.

## Language Support

Flow works with any language:

- **JavaScript/TypeScript** — npm, yarn, pnpm
- **Python** — pytest, ruff, mypy
- **Rust** — cargo, clippy
- **Go** — go test, golangci-lint
- **And more...** — Any language with CLI tools

See `SPECS/CONFIG_EXAMPLE.md` for language-specific examples.

## Current State Tracking

- **Active task:** `SPECS/INPROGRESS/next.md`
- **Task PRD:** `SPECS/INPROGRESS/{TASK_ID}_{NAME}.md`
- **Archive:** `SPECS/ARCHIVE/{TASK_ID}_{NAME}/`
- **Workplan:** `SPECS/Workplan.md`

## Skills (Optional)

Flow can be enhanced by AI agent skills that wrap prompts into shortcuts:

- `flow-run` — Run the complete workflow end-to-end
- `flow-primitive-commit` — Create focused commits

Skills live in `.agents/skills/`.

## Documentation

- `SPECS/README.md` — Complete documentation
- `SPECS/COMMANDS/SETUP.md` — Configuration guide
- `SPECS/COMMANDS/FLOW.md` — Workflow reference
- `SPECS/CONFIG_EXAMPLE.md` — Configuration examples

## License

MIT License — Copyright (c) 2026 Egor Merkushev
