#!/usr/bin/env bash
set -euo pipefail

# Flow installer
# Usage:
#   ./install.sh              — install into current directory
#   ./install.sh /path/repo   — install into target directory

TARGET="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Flow into: $TARGET"
echo ""

# --- COMMANDS (always updated) ---
mkdir -p "$TARGET/SPECS/COMMANDS"
cp -r "$SCRIPT_DIR/SPECS/COMMANDS/." "$TARGET/SPECS/COMMANDS/"
echo "✓ SPECS/COMMANDS/ updated"

# --- User files (only created if missing) ---

if [ ! -f "$TARGET/SPECS/Workplan.md" ]; then
  mkdir -p "$TARGET/SPECS"
  cp "$SCRIPT_DIR/SPECS/COMMANDS/Workplan_Example.md" "$TARGET/SPECS/Workplan.md"
  echo "✓ SPECS/Workplan.md created"
else
  echo "  SPECS/Workplan.md already exists — skipped"
fi

if [ ! -f "$TARGET/SPECS/ARCHIVE/INDEX.md" ]; then
  mkdir -p "$TARGET/SPECS/ARCHIVE/_Historical"
  cp "$SCRIPT_DIR/SPECS/COMMANDS/Archive_Index_Example.md" "$TARGET/SPECS/ARCHIVE/INDEX.md"
  echo "✓ SPECS/ARCHIVE/INDEX.md created"
else
  echo "  SPECS/ARCHIVE/INDEX.md already exists — skipped"
fi

if [ ! -f "$TARGET/SPECS/INPROGRESS/next.md" ]; then
  mkdir -p "$TARGET/SPECS/INPROGRESS"
  cp "$SCRIPT_DIR/SPECS/COMMANDS/next_example.md" "$TARGET/SPECS/INPROGRESS/next.md"
  echo "✓ SPECS/INPROGRESS/next.md created"
else
  echo "  SPECS/INPROGRESS/next.md already exists — skipped"
fi

if [ ! -d "$TARGET/.flow" ]; then
  mkdir -p "$TARGET/.flow"
  echo "✓ .flow/ created"
else
  echo "  .flow/ already exists — skipped"
fi

echo ""
echo "Done. Next: fill in .flow/params.yaml — see SPECS/COMMANDS/SETUP.md"
