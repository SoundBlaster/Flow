# Flow — Agentic Workflow Framework

**Version:** 1.2.0

> **Flow** is a documentation-driven agentic workflow framework for software development.

## Overview

Flow mimics real-world software development through a linear, step-by-step execution of commands. Each command is a prompt that guides AI agents (and humans) through a structured workflow.

```
BRANCH → SELECT → PLAN → EXECUTE → ARCHIVE → REVIEW → FOLLOW-UP → ARCHIVE-REVIEW
   ↓        ↓       ↓        ↓         ↓         ↓          ↓             ↓
 COMMIT   COMMIT  COMMIT   COMMIT    COMMIT    COMMIT     COMMIT        COMMIT
```

## Philosophy

- **Method over implementation** — Flow defines the process, not the code
- **Linear execution** — Step-by-step workflow without skipping phases
- **Documentation-driven** — PRDs and specs are first-class artifacts
- **Source of Truth** — `SPECS/Workplan.md` tracks all tasks
- **Language-agnostic** — Works with any tech stack via `.flow/params.yaml`

## Quick Start

### 1. Install Flow

```bash
# Clone Flow, then run the installer pointing at your repo
./install.sh /path/to/your/repo

# Or from inside your repo
/path/to/flow/install.sh
```

The installer copies `SPECS/COMMANDS/` and creates `SPECS/Workplan.md`, `SPECS/ARCHIVE/INDEX.md`, and `SPECS/INPROGRESS/next.md` from templates — skipping any that already exist.

### Production Default: Pinned + Verified Bootstrap

For working repositories, treat Flow as a tooling dependency. Pin a release tag and verify checksums before install.

Reference bootstrap script:

```bash
bash docs/flow-bootstrap.sh .
```

Script contract (`docs/flow-bootstrap.sh`):

- Reads `FLOW_VERSION` (default pinned value)
- Reads `FLOW_REPO` (defaults to `SoundBlaster/Flow`)
- Downloads `flow-${FLOW_VERSION}-minimal.zip` and `SHA256SUMS` from the same release
- Fails hard on missing assets or checksum mismatch
- Installs only after verification passes

Typical wrapper target in consumer repos:

```make
flow-install:
	@FLOW_VERSION?=v1.2.0 bash tools/flow-bootstrap.sh
```

### 2. Configure for Your Project

```bash
# Create and fill in your project config
mkdir -p .flow
# See SPECS/COMMANDS/SETUP.md for the full template
```

```yaml
# .flow/params.yaml
project:
  name: MyProject
  default_branch: main

verify:
  tests: npm test
  lint: npm run lint
  coverage_threshold: 80
```

### 3. Add Your Tasks

```bash
edit SPECS/Workplan.md    # Replace example tasks with yours
```

### 4. Run the Workflow

Follow the steps in `SPECS/COMMANDS/FLOW.md`:

1. **BRANCH** — Create a feature branch for the task
2. **SELECT** — Choose the next task from the workplan
3. **PLAN** — Create the implementation PRD
4. **EXECUTE** — Implement with quality gates
5. **ARCHIVE** — Move completed work to archive
6. **REVIEW** — Review and capture findings
7. **FOLLOW-UP** — Add remediation tasks when review finds issues
8. **ARCHIVE-REVIEW** — Archive the review report

## Structure

```
.flow/
└── params.yaml                  # Your project config (survives Flow updates)

SPECS/
├── Workplan.md                  # Your task tracker        ← user data
├── ARCHIVE/                     # Completed PRDs           ← user data
│   ├── INDEX.md
│   └── {TASK_ID}_{TASK_NAME}/
│       ├── {TASK_ID}_{TASK_NAME}.md
│       └── {TASK_ID}_Validation_Report.md
├── INPROGRESS/                  # Active tasks             ← user data
│   ├── next.md
│   └── {TASK_ID}_{TASK_NAME}.md
└── COMMANDS/                    # ← update Flow by replacing this folder

templates/                           # Install-time scaffolding (not copied to user repos)
├── Workplan_Example.md          # → SPECS/Workplan.md on first install
├── Archive_Index_Example.md     # → SPECS/ARCHIVE/INDEX.md on first install
└── next_example.md              # → SPECS/INPROGRESS/next.md on first install
    ├── FLOW.md                  # Main workflow reference
    ├── SETUP.md                 # Configuration guide
    ├── SELECT.md                # Task selection
    ├── PLAN.md                  # Task planning
    ├── EXECUTE.md               # Implementation
    ├── ARCHIVE.md               # Task archival
    ├── REVIEW.md                # Code review
    └── PRIMITIVES/              # Helper commands
```

## Configuration

Flow reads project-specific values from `.flow/params.yaml` at the repo root:

| Section | Purpose | Used By |
|---------|---------|---------|
| `project.*` | Project name, language, default branch | all commands |
| `verify.*` | Test, lint, format, coverage commands | EXECUTE |
| `nfrs.*` | Performance budgets | REVIEW |
| `structure.*` | Key directory paths | EXECUTE, ARCHIVE |

Commands reference it as `[Params](.flow/params.yaml)`. See `SPECS/COMMANDS/SETUP.md` for the full template.

## Updating Flow

```bash
# Run the installer again — only SPECS/COMMANDS/ is overwritten
./install.sh /path/to/your/repo

# Your workplan, archive, and .flow/params.yaml are never touched
```

## Security Notes

- Release assets include `SHA256SUMS` for integrity verification.
- Bootstrap verification is mandatory: mismatches must stop installation.
- This avoids silent corruption/tampering and makes CI behavior deterministic.

## Commands

| Command | Purpose |
|---------|---------|
| **SETUP** | Create `.flow/params.yaml` for your project |
| SELECT | Pick the next task from the workplan |
| PLAN | Write the implementation PRD |
| EXECUTE | Run implementation with quality gates |
| ARCHIVE | Move completed tasks to archive |
| REVIEW | Structured code review |
| FOLLOW-UP | Create tasks from review findings |

## Language Support

Flow works with any language — configure your toolchain in `.flow/params.yaml` under `verify.*`:

| Language | Tests | Lint |
|----------|-------|------|
| JavaScript/TypeScript | `npm test` | `npm run lint` |
| Python | `pytest` | `ruff check src/` |
| Rust | `cargo test` | `cargo clippy` |
| Go | `go test ./...` | `golangci-lint run` |
| Swift | `swift test` | `swiftlint` |

## Current State Tracking

- **Active task:** `SPECS/INPROGRESS/next.md`
- **Task PRD:** `SPECS/INPROGRESS/{TASK_ID}_{NAME}.md`
- **Archive:** `SPECS/ARCHIVE/{TASK_ID}_{NAME}/`
- **Workplan:** `SPECS/Workplan.md`

## Documentation

- `SPECS/COMMANDS/FLOW.md` — Workflow reference
- `SPECS/COMMANDS/SETUP.md` — Configuration guide
- `SPECS/COMMANDS/README.md` — Commands overview
- `docs/flow-bootstrap.sh` — Reference secure bootstrap script for consumer repos
- `docs/Flow_Dependency.md` — Tooling dependency contract and update pattern

## License

MIT License — Copyright (c) 2026 Egor Merkushev
