<!--
  QUALITY GATES TEMPLATE
  
  Define your project's quality gate commands here.
  These are referenced by EXECUTE.md and other commands.
-->

## Quality Gate Commands

### Testing
```bash
# Replace with your test command:
npm test
# or: pytest
# or: cargo test
# or: go test ./...
```

### Linting
```bash
# Replace with your lint command:
npm run lint
# or: ruff check src/
# or: cargo clippy
# or: golangci-lint run
```

### Type Checking (optional)
```bash
# Replace with your type check command (remove if not applicable):
npm run typecheck
# or: mypy src/
# or: cargo check
```

### Coverage
```bash
# Replace with your coverage command:
npm run test:coverage
# or: pytest --cov=src
# or: cargo tarpaulin
```

**Coverage Threshold:** 80%
