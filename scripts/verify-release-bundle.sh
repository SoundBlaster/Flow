#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <zip-file>" >&2
  exit 1
fi

zip_file="$1"

if [ ! -f "$zip_file" ]; then
  echo "ERROR: zip not found: $zip_file" >&2
  exit 1
fi

bundle_root="$(zipinfo -1 "$zip_file" | head -n1 | cut -d/ -f1)"
zip_listing="$(zipinfo -1 "$zip_file")"

if [ -z "$bundle_root" ]; then
  echo "ERROR: cannot determine bundle root in $zip_file" >&2
  exit 1
fi

if ! printf '%s\n' "$zip_listing" | grep -qE "^${bundle_root}/install\.sh$"; then
  echo "ERROR: install.sh is missing from release bundle" >&2
  exit 1
fi

if ! printf '%s\n' "$zip_listing" | grep -qE "^${bundle_root}/SPECS/VERSION$"; then
  echo "ERROR: SPECS/VERSION is missing from release bundle" >&2
  exit 1
fi

if ! printf '%s\n' "$zip_listing" | grep -qE "^${bundle_root}/SPECS/COMMANDS/"; then
  echo "ERROR: SPECS/COMMANDS is missing from release bundle" >&2
  exit 1
fi

if ! printf '%s\n' "$zip_listing" | grep -qE "^${bundle_root}/SPECS/ROLES/"; then
  echo "ERROR: SPECS/ROLES is missing from release bundle" >&2
  exit 1
fi

if ! printf '%s\n' "$zip_listing" | grep -qE "^${bundle_root}/\.agents/plugins/marketplace\.json$"; then
  echo "ERROR: .agents/plugins/marketplace.json is missing from release bundle" >&2
  exit 1
fi

for required_skill in flow-run flow-setup flow-update; do
  if ! printf '%s\n' "$zip_listing" | grep -qE "^${bundle_root}/\.agents/skills/${required_skill}/SKILL\.md$"; then
    echo "ERROR: .agents/skills/${required_skill}/SKILL.md is missing from release bundle" >&2
    exit 1
  fi
done

if ! printf '%s\n' "$zip_listing" | grep -qE "^${bundle_root}/plugins/flow/\.codex-plugin/plugin\.json$"; then
  echo "ERROR: plugins/flow/.codex-plugin/plugin.json is missing from release bundle" >&2
  exit 1
fi

for forbidden in \
  "${bundle_root}/SPECS/Workplan.md" \
  "${bundle_root}/SPECS/INPROGRESS/" \
  "${bundle_root}/SPECS/ARCHIVE/"; do
  if printf '%s\n' "$zip_listing" | grep -q "^${forbidden}"; then
    echo "ERROR: forbidden path present in release bundle: ${forbidden}" >&2
    exit 1
  fi
done

echo "release bundle verification passed"
