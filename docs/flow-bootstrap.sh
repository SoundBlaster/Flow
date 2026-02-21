#!/usr/bin/env bash
set -euo pipefail

# Reference bootstrap for consumer repositories.
# Installs pinned Flow release assets after mandatory SHA256 verification.

FLOW_VERSION="${FLOW_VERSION:-v1.2.0}"
FLOW_REPO="${FLOW_REPO:-SoundBlaster/Flow}"
TARGET_DIR="${1:-.}"

# Optional override for tests/forks.
FLOW_RELEASE_BASE="${FLOW_RELEASE_BASE:-https://github.com/${FLOW_REPO}/releases/download}"

artifact="flow-${FLOW_VERSION}-minimal.zip"
sums_file="SHA256SUMS"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

zip_path="$tmp/$artifact"
sums_path="$tmp/$sums_file"

curl_args=(-fsSL)
if [[ "$FLOW_RELEASE_BASE" == https://* ]]; then
  curl_args+=(--proto '=https' --tlsv1.2)
fi

curl "${curl_args[@]}" \
  -o "$zip_path" \
  "${FLOW_RELEASE_BASE}/${FLOW_VERSION}/${artifact}"

curl "${curl_args[@]}" \
  -o "$sums_path" \
  "${FLOW_RELEASE_BASE}/${FLOW_VERSION}/${sums_file}"

expected_hash="$(awk -v file="$artifact" '$2==file {print $1}' "$sums_path")"
if [ -z "$expected_hash" ]; then
  echo "ERROR: checksum entry for ${artifact} not found in ${sums_file}" >&2
  exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
  actual_hash="$(sha256sum "$zip_path" | awk '{print $1}')"
elif command -v shasum >/dev/null 2>&1; then
  actual_hash="$(shasum -a 256 "$zip_path" | awk '{print $1}')"
else
  echo "ERROR: neither sha256sum nor shasum is available for verification" >&2
  exit 1
fi

if [ "$actual_hash" != "$expected_hash" ]; then
  echo "ERROR: checksum mismatch for ${artifact}" >&2
  echo "expected: $expected_hash" >&2
  echo "actual:   $actual_hash" >&2
  exit 1
fi

unzip -q "$zip_path" -d "$tmp"
bash "$tmp/flow-${FLOW_VERSION}-minimal/install.sh" "$TARGET_DIR"
