.PHONY: all test version-check ref-check install-test idempotency-test lint help

COMMANDS_DIR := SPECS/COMMANDS
VERSION      := $(shell cat SPECS/VERSION 2>/dev/null | tr -d '[:space:]')

all: test

## Run all integrity checks
test: version-check ref-check install-test idempotency-test lint
	@echo ""
	@echo "All checks passed."

## Check SPECS/VERSION matches **Version:** in every command file
version-check:
	@echo "==> version-check ($(VERSION))"
	@failed=0; \
	for f in $(COMMANDS_DIR)/*.md; do \
		if grep -q "^\*\*Version:\*\*" "$$f"; then \
			v=$$(grep "^\*\*Version:\*\*" "$$f" | awk '{print $$2}'); \
			if [ "$$v" != "$(VERSION)" ]; then \
				echo "  FAIL $$f: found $$v"; \
				failed=1; \
			fi; \
		fi; \
	done; \
	[ $$failed -eq 0 ] && echo "  ok"; \
	exit $$failed

## Check for stale references to the old config system
ref-check:
	@echo "==> ref-check"
	@failed=0; \
	for pattern in "@SPECS/TEMPLATES" "SPECS/CONFIG\.md" "CONFIG_EXAMPLE"; do \
		if grep -rn "$$pattern" $(COMMANDS_DIR)/ 2>/dev/null; then \
			echo "  FAIL: stale reference '$$pattern'"; \
			failed=1; \
		fi; \
	done; \
	[ $$failed -eq 0 ] && echo "  ok"; \
	exit $$failed

## Test install.sh creates all expected files in a fresh directory
install-test:
	@echo "==> install-test"
	@tmp=$$(mktemp -d); \
	trap "rm -rf $$tmp" EXIT; \
	./install.sh "$$tmp" > /dev/null; \
	failed=0; \
	for f in \
		"$$tmp/SPECS/VERSION" \
		"$$tmp/SPECS/COMMANDS/FLOW.md" \
		"$$tmp/SPECS/COMMANDS/SELECT.md" \
		"$$tmp/SPECS/COMMANDS/PLAN.md" \
		"$$tmp/SPECS/COMMANDS/EXECUTE.md" \
		"$$tmp/SPECS/COMMANDS/REVIEW.md" \
		"$$tmp/SPECS/COMMANDS/ARCHIVE.md" \
		"$$tmp/SPECS/COMMANDS/SETUP.md" \
		"$$tmp/SPECS/COMMANDS/PRIMITIVES/COMMIT.md" \
		"$$tmp/SPECS/Workplan.md" \
		"$$tmp/SPECS/ARCHIVE/INDEX.md" \
		"$$tmp/SPECS/INPROGRESS/next.md"; do \
		if [ ! -f "$$f" ]; then \
			echo "  FAIL missing: $$f"; failed=1; \
		fi; \
	done; \
	if [ ! -d "$$tmp/.flow" ]; then \
		echo "  FAIL missing: .flow/"; failed=1; \
	fi; \
	[ $$failed -eq 0 ] && echo "  ok"; \
	exit $$failed

## Test install.sh does not overwrite existing user files on re-run
idempotency-test:
	@echo "==> idempotency-test"
	@tmp=$$(mktemp -d); \
	trap "rm -rf $$tmp" EXIT; \
	./install.sh "$$tmp" > /dev/null; \
	echo "custom" > "$$tmp/SPECS/Workplan.md"; \
	./install.sh "$$tmp" > /dev/null; \
	if [ "$$(cat $$tmp/SPECS/Workplan.md)" != "custom" ]; then \
		echo "  FAIL: Workplan.md was overwritten on re-run"; \
		exit 1; \
	fi; \
	echo "  ok"

## Lint install.sh with shellcheck (skipped if not installed)
lint:
	@echo "==> lint"
	@if command -v shellcheck > /dev/null 2>&1; then \
		shellcheck install.sh && echo "  ok"; \
	else \
		echo "  skip (shellcheck not installed)"; \
	fi

## Show available targets
help:
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/## //' | awk '{cmd=$$0; getline desc; print cmd": "desc}'
