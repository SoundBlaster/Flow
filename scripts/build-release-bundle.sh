#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <version-tag> <output-dir>" >&2
  exit 1
fi

version_tag="$1"
out_dir="$2"
manifest_file="release-manifest.txt"

if [ ! -f "$manifest_file" ]; then
  echo "ERROR: manifest not found: $manifest_file" >&2
  exit 1
fi

bundle_dir="$out_dir/flow-${version_tag}-minimal"
artifact_zip="$out_dir/flow-${version_tag}-minimal.zip"
artifact_sums="$out_dir/SHA256SUMS"

rm -rf "$bundle_dir"
mkdir -p "$bundle_dir"

while IFS= read -r entry; do
  [ -z "$entry" ] && continue
  case "$entry" in
    \#*)
      continue
      ;;
  esac

  if [ ! -e "$entry" ]; then
    echo "ERROR: manifest entry not found: $entry" >&2
    exit 1
  fi

  parent_dir="$(dirname "$bundle_dir/$entry")"
  mkdir -p "$parent_dir"
  cp -R "$entry" "$bundle_dir/$entry"
done < "$manifest_file"

( cd "$out_dir" && zip -rq "$(basename "$artifact_zip")" "$(basename "$bundle_dir")" )

if command -v sha256sum >/dev/null 2>&1; then
  ( cd "$out_dir" && sha256sum "$(basename "$artifact_zip")" > "$(basename "$artifact_sums")" )
else
  ( cd "$out_dir" && shasum -a 256 "$(basename "$artifact_zip")" > "$(basename "$artifact_sums")" )
fi

echo "BUNDLE_DIR=$(basename "$bundle_dir")"
echo "ARTIFACT_ZIP=$(basename "$artifact_zip")"
echo "ARTIFACT_SUMS=$(basename "$artifact_sums")"
