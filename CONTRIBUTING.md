# Contributing to Flow

## Ways to Contribute

- Fix wording or clarity issues in command files
- Add or improve primitives
- Improve `install.sh` or `Makefile`
- Report issues or suggest new commands

## Project Structure

```
SPECS/
├── VERSION              # Single source of version truth
└── COMMANDS/            # Workflow command files (Markdown)
    └── PRIMITIVES/      # Reusable sub-steps

templates/               # Install-time scaffolding (not workflow commands)
install.sh               # Installer
Makefile                 # Integrity checks
```

User configuration lives in `.flow/params.yaml` in each project repo — it is not part of this repo.

## Making Changes

### Editing a command

1. Edit the file in `SPECS/COMMANDS/`
2. If the change is user-visible, bump `**Version:**` in that file and update `SPECS/VERSION`
3. Run `make test` — all checks must pass
4. Open a PR

### Adding a new command

1. Create `SPECS/COMMANDS/{NAME}.md` following the existing structure:
   ```
   # NAME — Short Description
   **Version:** {current version from SPECS/VERSION}
   ## Purpose
   ## Inputs
   ## Algorithm / Steps
   ## Output
   ```
2. Add it to the command table in `SPECS/COMMANDS/README.md`
3. Reference it from `SPECS/COMMANDS/FLOW.md` if it belongs in the main workflow
4. Run `make test`

### Adding a new primitive

Same as a command but goes in `SPECS/COMMANDS/PRIMITIVES/`. Add a frontmatter block:

```yaml
---
name: "primitive_name"
description: "One sentence on when to use it."
---
```

### Modifying `install.sh`

- Run `shellcheck install.sh` before committing (or `make lint`)
- Add new user files to the `install-test` checklist in `Makefile`
- Verify idempotency: re-running must not overwrite existing user files

### Adding an install template

Templates live in `templates/`, not in `SPECS/COMMANDS/`. Add the copy step to `install.sh` and the file path to the `install-test` target in `Makefile`.

## Versioning

Flow uses [Semantic Versioning](https://semver.org).

| Change | Bump |
|--------|------|
| Wording fix, typo | none |
| Updated command logic, new field in params | MINOR |
| New command | MINOR |
| Breaking change to workflow or params schema | MAJOR |

When bumping: update `SPECS/VERSION` and the `**Version:**` header in every file you changed. `make version-check` will catch mismatches.

## Before Submitting

```bash
make test
```

All targets must pass (lint is skipped if `shellcheck` is not installed).

## Commit Style

Use present-tense imperative subject lines:

```
Add REBUILD command for spec-driven rebuilds
Fix stale SPECS/CONFIG.md reference in PLAN.md
Bump version to 1.2.0
```

## Pull Request

- Keep PRs focused on one concern
- Describe what changed and why in the PR body
- Link related issues if any
