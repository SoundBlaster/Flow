# SETUP — Project Configuration

**Version:** 1.1.0

## Purpose

SETUP creates `.flow/params.yaml` — the single configuration file that tells Flow about your project. This file lives outside `SPECS/` so it survives Flow updates.

## How It Works

Flow reads project-specific values from `.flow/params.yaml` at the repo root. Commands reference it as `[Params](.flow/params.yaml)` and read only the sections they need.

**Update story:** drop a new `SPECS/` folder into your repo — `.flow/params.yaml` is untouched.

## Create `.flow/params.yaml`

```bash
mkdir -p .flow
```

Paste and fill in this template:

```yaml
# .flow/params.yaml
# Your project config for Flow.
# Safe to edit freely — update Flow by replacing SPECS/, not this file.

project:
  name: MyProject
  description: Short description of what this project does
  language: TypeScript          # e.g. Swift, Python, Rust, Go
  package_manager: npm          # e.g. yarn, pip, cargo, swift
  default_branch: main

verify:
  tests: npm test
  lint: npm run lint
  format: npm run format
  typecheck: npm run typecheck  # optional, remove if not applicable
  coverage: npm run test:coverage
  coverage_threshold: 80        # percent

# Optional: performance budgets checked during REVIEW
nfrs:
  api_response_ms: 200
  memory_mb: 512

# Optional: key paths used in EXECUTE and ARCHIVE
structure:
  source: src/
  tests: tests/
```

## Required vs Optional Fields

| Field | Required | Used By |
|-------|----------|---------|
| `project.name` | yes | all commands |
| `project.default_branch` | yes | BRANCH, SELECT |
| `verify.tests` | yes | EXECUTE |
| `verify.lint` | yes | EXECUTE |
| `verify.format` | no | EXECUTE |
| `verify.typecheck` | no | EXECUTE |
| `verify.coverage` | no | EXECUTE |
| `verify.coverage_threshold` | no | EXECUTE, REVIEW |
| `nfrs.*` | no | REVIEW |
| `structure.*` | no | EXECUTE, ARCHIVE |

## Quick SETUP (For AI Agents)

If you're an AI agent setting up Flow for a user:

1. **Detect tech stack** from existing project files:
   - `package.json` → JavaScript/TypeScript, npm/yarn
   - `pyproject.toml`, `requirements.txt` → Python, pip
   - `Cargo.toml` → Rust, cargo
   - `go.mod` → Go, go modules
   - `Package.swift` → Swift, swift package manager

2. **Infer or ask** the user for:
   - Project name and brief description
   - Test, lint, and format commands
   - Coverage threshold

3. **Create `.flow/params.yaml`** with the template above, filled in.

4. **Verify** the key commands work:
   ```bash
   <test_command> --help || echo "Adjust verify.tests in .flow/params.yaml"
   <lint_command> --help || echo "Adjust verify.lint in .flow/params.yaml"
   ```

## Verification Checklist

- [ ] `.flow/params.yaml` exists at repo root (same level as `SPECS/`)
- [ ] `project.name` is filled in
- [ ] `project.default_branch` matches your repo (e.g., `main`)
- [ ] `verify.tests` command runs successfully
- [ ] `verify.lint` command runs successfully

## Troubleshooting

**Problem:** Commands can't find params
**Solution:** Ensure `.flow/params.yaml` exists at the repo root

**Problem:** Quality gate commands fail
**Solution:** Edit `verify.*` in `.flow/params.yaml` with commands that work in your project

## Next Steps

After SETUP completes:

1. Read `FLOW.md` to understand the workflow
2. Create your first task in `Workplan.md`
3. Run `SELECT` to choose a task
4. Run `PLAN` to create the PRD
5. Run `EXECUTE` to implement
