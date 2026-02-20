# Configuration Reference

This file documents the configuration system for Flow. For setup instructions, see [`COMMANDS/SETUP.md`](COMMANDS/SETUP.md).

---

## How Configuration Works

Flow uses **template files** in `SPECS/TEMPLATES/` instead of a single config file:

| Template File | Purpose | Referenced By |
|--------------|---------|---------------|
| `TEMPLATES/ProjectInfo.md` | Project name, language, stack | General context |
| `TEMPLATES/QualityGates.md` | Test, lint, coverage commands | EXECUTE.md |
| `TEMPLATES/NFRs.md` | Performance budgets, constraints | REVIEW.md |
| `TEMPLATES/Structure.md` | Directory layout | EXECUTE.md |

## Template Examples

### QualityGates.md

```markdown
<!--
  QUALITY GATES
  Define commands for your project's quality checks
-->

## Quality Gate Commands

### Testing
```bash
pytest -v                  # Run all tests
pytest tests/unit/         # Unit tests only
```

### Linting
```bash
ruff check src/            # Check code style
ruff check --fix src/      # Auto-fix issues
```

### Type Checking
```bash
mypy src/                  # Static type analysis
```

### Coverage
```bash
pytest --cov=src --cov-report=term-missing
```

**Coverage Threshold:** 85%
```

### ProjectInfo.md

```markdown
**Project Name:** My Awesome API

**Description:** High-performance REST API for user management

**Primary Language:** Python

**Package Manager:** pip + uv

**Repository:** https://github.com/myorg/my-api
```

### NFRs.md

```markdown
## Performance Budgets

- **Max Response Time:** 100ms for API calls
- **Max Memory Usage:** 256MB per process
- **Max Cold Start:** 500ms

## Quality Criteria

- **Minimum Test Coverage:** 85%
- **Max Function Length:** 50 lines
- **Max Cyclomatic Complexity:** 10
```

### Structure.md

```markdown
## Directory Layout

```
.
├── src/
│   ├── api/              # API routes
│   ├── models/           # Database models
│   ├── services/         # Business logic
│   └── utils/            # Utilities
├── tests/
│   ├── unit/             # Unit tests
│   └── integration/      # Integration tests
└── docs/                 # Documentation
```

## Key Paths

- **Source:** `src/`
- **Tests:** `tests/`
- **Docs:** `docs/`
```

## First-Time Setup

1. Read [`COMMANDS/SETUP.md`](COMMANDS/SETUP.md)
2. Edit the template files in `SPECS/TEMPLATES/`
3. Verify your quality gate commands work
4. Start using Flow commands

## Language-Specific Examples

### JavaScript/TypeScript

**QualityGates.md:**
```markdown
### Testing
```bash
npm test
npm run test:watch
```

### Linting
```bash
npm run lint
npm run format
```

### Type Checking
```bash
npm run typecheck
```

**Coverage Threshold:** 80%
```

### Rust

**QualityGates.md:**
```markdown
### Testing
```bash
cargo test
cargo test --release
```

### Linting
```bash
cargo clippy -- -D warnings
cargo fmt --check
```

### Type Checking
```bash
cargo check
cargo check --release
```

**Coverage Threshold:** 80%
```

### Go

**QualityGates.md:**
```markdown
### Testing
```bash
go test ./...
go test -race ./...
```

### Linting
```bash
golangci-lint run
go vet ./...
```

### Format Check
```bash
gofmt -l .
```

**Coverage Threshold:** 75%
```

## Advanced: Custom Templates

You can create additional templates:

1. Create `TEMPLATES/Deployment.md`
2. Reference it in your commands: `@SPECS/TEMPLATES/Deployment.md`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Commands not found | Check `TEMPLATES/QualityGates.md` has correct commands |
| Wrong coverage threshold | Edit the threshold in `TEMPLATES/QualityGates.md` |
| Project structure changed | Update `TEMPLATES/Structure.md` |
| Need different NFRs | Edit `TEMPLATES/NFRs.md` |

## Migration from CONFIG.md

If you have an old `CONFIG.md`:

1. Move quality gate commands to `TEMPLATES/QualityGates.md`
2. Move project info to `TEMPLATES/ProjectInfo.md`
3. Move NFRs to `TEMPLATES/NFRs.md`
4. Delete `CONFIG.md`
