# SPECS — Project Specifications

This folder contains the **Flow workflow** and project specifications.

## Folder Structure

```
SPECS/
├── README.md                 # This file
├── CONFIG_EXAMPLE.md         # Configuration reference and examples
├── Workplan.md               # Task tracker template
├── COMMANDS/                 # Workflow commands (prompts for AI agents)
│   ├── README.md             # Commands overview
│   ├── SETUP.md              # 🚀 START HERE: Configure Flow for your project
│   ├── FLOW.md               # Main workflow documentation
│   ├── SELECT.md             # Task selection
│   ├── PLAN.md               # Task planning
│   ├── EXECUTE.md            # Task execution with quality gates
│   ├── ARCHIVE.md            # Task archival
│   ├── REVIEW.md             # Code review
│   ├── PROGRESS.md           # Progress tracking
│   ├── REBUILD.md            # Spec-driven rebuilds
│   └── PRIMITIVES/           # Helper commands
│       ├── COMMIT.md
│       ├── ARCHIVE_TASK.md
│       ├── FOLLOW_UP.md
│       ├── DOCS.md
│       └── REFACTORING.md
├── TEMPLATES/                # 🎨 PROJECT-SPECIFIC CONFIGURATION
│   ├── ProjectInfo.md        # Edit: Project name, description, stack
│   ├── QualityGates.md       # Edit: Test, lint, coverage commands
│   ├── NFRs.md               # Edit: Performance budgets (optional)
│   └── Structure.md          # Edit: Directory layout (optional)
├── INPROGRESS/               # Active task artifacts (created during workflow)
│   └── next.md               # Current task pointer
└── ARCHIVE/                  # Completed task artifacts (created during workflow)
    ├── INDEX.md              # Archive index
    └── {TASK_ID}_{NAME}/     # Individual task folders
```

## Getting Started

### 1. Configure Flow for Your Project

**Read and follow:** [`COMMANDS/SETUP.md`](COMMANDS/SETUP.md)

This guides you through editing the template files in `TEMPLATES/`.

### 2. Create Your Workplan

Copy [`Workplan.md`](Workplan.md) and customize it with your actual tasks.

### 3. Run the Workflow

Follow the steps in [`COMMANDS/FLOW.md`](COMMANDS/FLOW.md):

1. **SELECT** — Choose a task from the workplan
2. **PLAN** — Write the implementation PRD
3. **EXECUTE** — Implement with quality gates
4. **ARCHIVE** — Move completed work to archive
5. **REVIEW** — Review and capture findings

## The Template System

Flow uses **template files** instead of rigid configuration:

| Template | What to put there | Why it matters |
|----------|------------------|----------------|
| `TEMPLATES/QualityGates.md` | Your test, lint, and coverage commands | EXECUTE uses these to validate your code |
| `TEMPLATES/ProjectInfo.md` | Project name, tech stack, description | Context for AI agents |
| `TEMPLATES/NFRs.md` | Performance budgets, constraints | REVIEW checks against these |
| `TEMPLATES/Structure.md` | Directory layout | Navigation context |

### How Templates Work

Commands reference templates using `@` notation:

```markdown
<!-- In EXECUTE.md -->

## Quality Gates

@SPECS/TEMPLATES/QualityGates.md

Run the commands listed above.
```

When an AI agent reads this, it automatically loads the template content.

### Customizing Templates

1. Open any file in `TEMPLATES/`
2. Edit the Markdown content
3. Save — changes are effective immediately

Templates are plain Markdown — no special syntax required.

## Customization Examples

### Python Project

**TEMPLATES/QualityGates.md:**
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

### JavaScript Project

**TEMPLATES/QualityGates.md:**
```markdown
### Testing
```bash
npm test
```

### Linting
```bash
npm run lint
```

**Coverage Threshold:** 80%
```

## Files You Should Edit

| File | When | Why |
|------|------|-----|
| `TEMPLATES/*.md` | Once at setup | Configure for your project |
| `Workplan.md` | At planning | Define your roadmap |
| `INPROGRESS/*.md` | During workflow | Active task artifacts |
| `ARCHIVE/INDEX.md` | During archive | Track completed work |

## Files You Should NOT Edit

| File | Reason |
|------|--------|
| `COMMANDS/*.md` | Core workflow — upgrade-safe |
| `COMMANDS/PRIMITIVES/*.md` | Helper commands — upgrade-safe |
| `CONFIG_EXAMPLE.md` | Reference documentation |

## Upgrading Flow

To update to a newer version of Flow:

1. Keep your `TEMPLATES/` — they contain your project config
2. Keep your `Workplan.md` — it has your tasks
3. Keep your `ARCHIVE/` — it has your history
4. Replace `COMMANDS/` with the new version
5. Re-read `SETUP.md` for any new configuration options

## Need Help?

1. Read [`COMMANDS/SETUP.md`](COMMANDS/SETUP.md) for configuration help
2. Read [`COMMANDS/FLOW.md`](COMMANDS/FLOW.md) for workflow help
3. Read [`CONFIG_EXAMPLE.md`](CONFIG_EXAMPLE.md) for examples
