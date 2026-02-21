.PHONY: all test version-check ref-check install-test minimal-bundle-test bootstrap-verify-test bootstrap-mismatch-test idempotency-test lint help

COMMANDS_DIR := SPECS/COMMANDS
VERSION      := $(shell cat SPECS/VERSION 2>/dev/null | tr -d '[:space:]')

all: test

## Run all integrity checks
test: version-check ref-check install-test minimal-bundle-test bootstrap-verify-test bootstrap-mismatch-test idempotency-test lint
	@echo ""
	@echo "All checks passed."

## Check SPECS/VERSION matches **Version:** in every command file
version-check:
	@echo "==> version-check ($(VERSION))"
	@failed=0; \
	for f in $(shell find $(COMMANDS_DIR) -type f -name '*.md' | sort); do \
		if ! grep -q "^\*\*Version:\*\*" "$$f"; then \
			echo "  FAIL $$f: missing **Version:** header"; \
			failed=1; \
			continue; \
		fi; \
		v=$$(grep -m1 "^\*\*Version:\*\*" "$$f" | awk '{print $$2}'); \
		if [ "$$v" != "$(VERSION)" ]; then \
			echo "  FAIL $$f: found $$v"; \
			failed=1; \
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

## Test install.sh works from a minimal bundle (install.sh + SPECS/COMMANDS only)
minimal-bundle-test:
	@echo "==> minimal-bundle-test"
	@src=$$(mktemp -d); \
	dst=$$(mktemp -d); \
	trap "rm -rf $$src $$dst" EXIT; \
	mkdir -p "$$src/SPECS"; \
	cp install.sh "$$src/install.sh"; \
	cp -r SPECS/COMMANDS "$$src/SPECS/COMMANDS"; \
	chmod +x "$$src/install.sh"; \
	"$$src/install.sh" "$$dst" > /dev/null; \
	failed=0; \
	for f in \
		"$$dst/SPECS/VERSION" \
		"$$dst/SPECS/COMMANDS/FLOW.md" \
		"$$dst/SPECS/Workplan.md" \
		"$$dst/SPECS/ARCHIVE/INDEX.md" \
		"$$dst/SPECS/INPROGRESS/next.md"; do \
		if [ ! -f "$$f" ]; then \
			echo "  FAIL missing: $$f"; failed=1; \
		fi; \
	done; \
	[ $$failed -eq 0 ] && echo "  ok"; \
	exit $$failed

## Test docs/flow-bootstrap.sh with local release assets and SHA256 verification
bootstrap-verify-test:
	@echo "==> bootstrap-verify-test"
	@release_root=$$(mktemp -d); \
	target_root=$$(mktemp -d); \
	src=$$(mktemp -d); \
	trap "rm -rf $$release_root $$target_root $$src" EXIT; \
	version="v-test"; \
	artifact="flow-$${version}-minimal.zip"; \
	mkdir -p "$$src/flow-$${version}-minimal/SPECS"; \
	cp install.sh "$$src/flow-$${version}-minimal/install.sh"; \
	cp -r SPECS/COMMANDS "$$src/flow-$${version}-minimal/SPECS/COMMANDS"; \
	( cd "$$src" && zip -rq "$$artifact" "flow-$${version}-minimal" ); \
	mkdir -p "$$release_root/$${version}"; \
	mv "$$src/$$artifact" "$$release_root/$${version}/$$artifact"; \
	if command -v sha256sum >/dev/null 2>&1; then \
		( cd "$$release_root/$${version}" && sha256sum "$$artifact" > SHA256SUMS ); \
	else \
		( cd "$$release_root/$${version}" && shasum -a 256 "$$artifact" > SHA256SUMS ); \
	fi; \
	FLOW_VERSION="$$version" FLOW_RELEASE_BASE="file://$$release_root" bash docs/flow-bootstrap.sh "$$target_root" > /dev/null; \
	failed=0; \
	for f in \
		"$$target_root/SPECS/VERSION" \
		"$$target_root/SPECS/COMMANDS/FLOW.md" \
		"$$target_root/SPECS/Workplan.md" \
		"$$target_root/SPECS/ARCHIVE/INDEX.md" \
		"$$target_root/SPECS/INPROGRESS/next.md"; do \
		if [ ! -f "$$f" ]; then \
			echo "  FAIL missing: $$f"; failed=1; \
		fi; \
	done; \
	[ $$failed -eq 0 ] && echo "  ok"; \
	exit $$failed

## Test docs/flow-bootstrap.sh fails on checksum mismatch
bootstrap-mismatch-test:
	@echo "==> bootstrap-mismatch-test"
	@release_root=$$(mktemp -d); \
	target_root=$$(mktemp -d); \
	src=$$(mktemp -d); \
	trap "rm -rf $$release_root $$target_root $$src" EXIT; \
	version="v-test"; \
	artifact="flow-$${version}-minimal.zip"; \
	mkdir -p "$$src/flow-$${version}-minimal/SPECS"; \
	cp install.sh "$$src/flow-$${version}-minimal/install.sh"; \
	cp -r SPECS/COMMANDS "$$src/flow-$${version}-minimal/SPECS/COMMANDS"; \
	( cd "$$src" && zip -rq "$$artifact" "flow-$${version}-minimal" ); \
	mkdir -p "$$release_root/$${version}"; \
	mv "$$src/$$artifact" "$$release_root/$${version}/$$artifact"; \
	echo "deadbeef  $$artifact" > "$$release_root/$${version}/SHA256SUMS"; \
	if FLOW_VERSION="$$version" FLOW_RELEASE_BASE="file://$$release_root" bash docs/flow-bootstrap.sh "$$target_root" > /dev/null 2>&1; then \
		echo "  FAIL: bootstrap succeeded with invalid checksum"; \
		exit 1; \
	fi; \
	echo "  ok"

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
	@awk ' \
		/^## / { desc=substr($$0, 4); next } \
		/^[a-zA-Z0-9_.-]+:/ { \
			if (desc != "") { \
				split($$1, target, ":"); \
				printf "%-20s %s\n", target[1], desc; \
				desc=""; \
			} \
		} \
	' $(MAKEFILE_LIST)
