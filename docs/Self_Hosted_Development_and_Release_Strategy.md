# Self-Hosted Development and Release Strategy

## Context

Flow is now used to develop itself. That creates two classes of files inside one repository:

1. **Runtime/distribution artifacts** (stable files users should install).
2. **Operational workspace files** (active work-in-progress for this repository).

The key question is whether to split by branches (`dev` vs `main`) or keep one branch and control release artifact composition.

## Options Compared

### Option A — Single branch + curated release bundle (recommended)

- Keep regular day-to-day work on the main development branch.
- Continue using `SPECS/Workplan.md`, `SPECS/INPROGRESS/`, and `SPECS/ARCHIVE/` for real workflow execution.
- Release workflow packages **only explicitly selected files** into the zip.

**Pros**
- Lowest operational cost (no parallel branch maintenance).
- Preserves transparent project history in one place.
- Keeps methodology “live” and dogfooded.
- Eliminates accidental shipping of temporary files when release bundle is controlled.

**Cons**
- Requires disciplined curation of release-allowed files.

### Option B — `dev` branch for workspace + `main` branch for clean release state

- Keep all working files in `dev`; cherry-pick/merge only selected artifacts to `main`.

**Pros**
- Main branch stays visually clean.

**Cons**
- Higher maintenance burden.
- More merge/cherry-pick conflicts.
- Higher risk of accidental drift between real process and shipped process.

## Recommendation

Choose **Option A**.

For Flow specifically, branch splitting introduces process overhead without giving better guarantees than a deterministic release bundle. The release bundle is already minimal and explicit; extending this mechanism is safer and cheaper than maintaining dual-branch curation.

## Practical Policy

Define three categories under `SPECS/`:

1. **Ship** (static product artifacts):
   - `SPECS/COMMANDS/**`
   - `SPECS/VERSION`
   - Optional stable docs that are part of product behavior (if needed later)
2. **Scaffold** (optional installer templates, not mandatory in release zip):
   - `templates/**`
3. **Workspace (never shipped in release zip)**:
   - `SPECS/Workplan.md`
   - `SPECS/INPROGRESS/**`
   - `SPECS/ARCHIVE/**`

## Guardrails

1. Keep release artifact creation **allowlist-based** (never wildcard `SPECS/**`).
2. Add a CI check that validates release contents are only from the allowlist.
3. Document the policy in `RELEASING.md` so maintainers treat it as a contract.
4. Optionally add a `release-manifest.txt` file used by workflow packaging to avoid logic drift.

## Implementation Status

The recommended guardrails are now implemented:

1. `release-manifest.txt` defines exact shipped paths.
2. `.github/workflows/release.yml` builds by manifest via `scripts/build-release-bundle.sh`.
3. Release bundle policy validation is enforced via `scripts/verify-release-bundle.sh` and covered by `make test`.
