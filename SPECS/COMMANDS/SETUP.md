# SETUP — Project Configuration Agent

**Version:** 1.0.0

## Purpose

SETUP guides you through customizing the Flow workflow for your specific project. It creates personalized template files that are referenced by the main workflow commands.

## Prerequisites

- Flow workflow copied to your project (SPECS/ folder)
- You know your project's tech stack and conventions

## How SETUP Works

Instead of a rigid config file, Flow uses **template files** in `SPECS/TEMPLATES/`. These are Markdown files that get referenced by workflow commands using `@` notation (e.g., `@SPECS/TEMPLATES/QualityGates.md`).

This means:
- Templates are human-readable and editable
- You can use Markdown formatting in your config
- Commands reference only the templates they need
- No parsing or special syntax required

## Template Files

| Template | Purpose | Referenced By |
|----------|---------|---------------|
| `TEMPLATES/ProjectInfo.md` | Project name, language, stack | FLOW.md, README.md |
| `TEMPLATES/QualityGates.md` | Test, lint, coverage commands | EXECUTE.md |
| `TEMPLATES/NFRs.md` | Performance budgets, constraints | REVIEW.md |
| `TEMPLATES/Structure.md` | Directory layout | EXECUTE.md, ARCHIVE.md |

## SETUP Session

Run through these steps to customize Flow for your project:

### Step 1: Project Information

Edit `SPECS/TEMPLATES/ProjectInfo.md`:

```markdown
**Project Name:** My Awesome API

**Description:** RESTful API for managing user data with real-time updates

**Primary Language:** TypeScript

**Package Manager:** npm

**Repository:** https://github.com/myorg/my-api
```

### Step 2: Quality Gates

Edit `SPECS/TEMPLATES/QualityGates.md` with your project's commands:

```markdown
## Quality Gate Commands

### Testing
```bash
npm test
```

### Linting
```bash
npm run lint
```

### Type Checking
```bash
npm run typecheck
```

### Coverage
```bash
npm run test:coverage
```

**Coverage Threshold:** 85%
```

### Step 3: Performance Budgets (Optional)

Edit `SPECS/TEMPLATES/NFRs.md` if you have specific constraints:

```markdown
## Performance Budgets

- **Max Response Time:** 100ms for API calls
- **Max Memory Usage:** 256MB per process
```

### Step 4: Project Structure

Edit `SPECS/TEMPLATES/Structure.md` to match your layout:

```markdown
## Directory Layout

```
src/
├── routes/           # API routes
├── models/           # Data models
├── services/         # Business logic
└── utils/            # Utilities
tests/
├── unit/             # Unit tests
└── integration/      # Integration tests
```
```

## Quick SETUP (For AI Agents)

If you're an AI agent setting up Flow for a user:

1. **Read existing project files** to detect tech stack:
   - `package.json` → JavaScript/TypeScript, npm/yarn
   - `pyproject.toml`, `requirements.txt` → Python, pip
   - `Cargo.toml` → Rust, cargo
   - `go.mod` → Go, go modules

2. **Ask the user** (or infer):
   - Project name and brief description
   - Test command they use
   - Lint command they use
   - Coverage threshold they target

3. **Generate the 4 template files** based on gathered info

4. **Verify** by checking if commands in QualityGates.md work:
   ```bash
   # Test the test command
   cd <project_root> && <test_command> --help || echo "Command needs adjustment"
   ```

## Template Reference Syntax

Commands reference templates using Markdown file references:

```markdown
## Quality Gates

@SPECS/TEMPLATES/QualityGates.md

Proceed with the commands defined above.
```

When an AI agent reads this, it loads the template content automatically.

## Customizing Further

### Adding Your Own Templates

You can create additional templates in `SPECS/TEMPLATES/`:

1. Create `TEMPLATES/Deployment.md`
2. Reference it in your custom commands: `@SPECS/TEMPLATES/Deployment.md`

### Per-Environment Overrides

Create environment-specific templates:

- `TEMPLATES/QualityGates.local.md` - Local development
- `TEMPLATES/QualityGates.ci.md` - CI/CD pipeline

Reference the appropriate one in your commands.

## Verification Checklist

After SETUP, verify your configuration:

- [ ] `SPECS/TEMPLATES/ProjectInfo.md` has project name
- [ ] `SPECS/TEMPLATES/QualityGates.md` has working commands
- [ ] Test command runs: `<your_test_cmd> --help` (or equivalent)
- [ ] Lint command runs: `<your_lint_cmd> --help` (or equivalent)
- [ ] Workplan exists: `SPECS/Workplan.md` (use the template)

## Troubleshooting

**Problem:** Commands say "template not found"
**Solution:** Ensure template files exist in `SPECS/TEMPLATES/`

**Problem:** Quality gate commands don't work
**Solution:** Edit `QualityGates.md` and replace with commands that work in your project

**Problem:** Want to reset to defaults
**Solution:** Copy content from `CONFIG_EXAMPLE.md` (reference documentation)

## Example: Complete SETUP Session

```
$ cd my-project

# 1. Copy Flow workflow (already done)
$ ls SPECS/COMMANDS/
FLOW.md SELECT.md PLAN.md EXECUTE.md ...

# 2. Run SETUP (guided or automatic)
$ cat SPECS/COMMANDS/SETUP.md  # Read instructions

# 3. Edit templates
$ edit SPECS/TEMPLATES/ProjectInfo.md     # Set name
$ edit SPECS/TEMPLATES/QualityGates.md    # Set commands
$ edit SPECS/TEMPLATES/NFRs.md            # Set budgets (optional)
$ edit SPECS/TEMPLATES/Structure.md       # Set paths

# 4. Create workplan
$ cp SPECS/Workplan.md SPECS/Workplan.md.bak
$ edit SPECS/Workplan.md                  # Add your tasks

# 5. Verify
$ npm test                                # Test command works

# 6. Start using Flow
$ cat SPECS/COMMANDS/FLOW.md              # Read workflow
# Follow BRANCH → SELECT → PLAN → EXECUTE → ARCHIVE → REVIEW
```

## Next Steps

After SETUP completes:

1. Read `FLOW.md` to understand the workflow
2. Create your first task in `Workplan.md`
3. Run `SELECT` to choose a task
4. Run `PLAN` to create the PRD
5. Run `EXECUTE` to implement

## Notes

- Templates are Markdown files, not code - edit them freely
- Keep commands in `QualityGates.md` simple and tested
- Templates can include comments (HTML-style: `<!-- comment -->`)
- The Flow commands are designed to work without templates too (they use generic defaults)
