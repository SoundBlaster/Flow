# Flow Tooling Dependency Contract

Use Flow as a pinned tooling dependency, not a runtime library.

## Required Inputs

- `FLOW_VERSION` (tag, for example `v1.2.0`)
- Optional `FLOW_REPO` (defaults to `SoundBlaster/Flow`)

## Required Behavior

1. Download release assets from the same tag:
   - `flow-${FLOW_VERSION}-minimal.zip`
   - `SHA256SUMS`
2. Verify `flow-${FLOW_VERSION}-minimal.zip` against `SHA256SUMS`.
3. Exit non-zero on any download or checksum failure.
4. Unzip and run installer only after verification succeeds.

## Reference Script

See `docs/flow-bootstrap.sh`.

## Consumer Repository Wrapper

Example wrapper (`tools/flow-bootstrap.sh`):

```bash
#!/usr/bin/env bash
set -euo pipefail
FLOW_VERSION="${FLOW_VERSION:-v1.2.0}" bash docs/flow-bootstrap.sh .
```

Example Make target:

```make
flow-install:
	@FLOW_VERSION?=v1.2.0 bash tools/flow-bootstrap.sh
```

## Bot-Driven Version Updates

Configure Renovate/Dependabot to update only pinned `FLOW_VERSION` lines in wrapper scripts and Make targets.
