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

if [ -z "$bundle_root" ]; then
  echo "ERROR: cannot determine bundle root in $zip_file" >&2
  exit 1
fi

if ! zipinfo -1 "$zip_file" | grep -qE "^${bundle_root}/install\.sh$"; then
  echo "ERROR: install.sh is missing from release bundle" >&2
  exit 1
fi

if ! zipinfo -1 "$zip_file" | grep -qE "^${bundle_root}/SPECS/VERSION$"; then
  echo "ERROR: SPECS/VERSION is missing from release bundle" >&2
  exit 1
fi

for forbidden in \
  "${bundle_root}/SPECS/Workplan.md" \
  "${bundle_root}/SPECS/INPROGRESS/" \
  "${bundle_root}/SPECS/ARCHIVE/"; do
  if zipinfo -1 "$zip_file" | grep -q "^${forbidden}"; then
    echo "ERROR: forbidden path present in release bundle: ${forbidden}" >&2
    exit 1
  fi
done

echo "release bundle verification passed"
