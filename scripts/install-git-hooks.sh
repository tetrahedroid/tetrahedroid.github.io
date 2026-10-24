#!/usr/bin/env bash
# Install repo-local hooks into .git/hooks/ (no git config changes).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS_DIR="$ROOT/.git/hooks"
SRC="$ROOT/scripts/git-hooks"

if [[ ! -d "$ROOT/.git" ]]; then
  echo "Not a git working tree: $ROOT" >&2
  exit 1
fi

mkdir -p "$HOOKS_DIR"
for name in pre-push pre-commit; do
  install -m 755 "$SRC/$name" "$HOOKS_DIR/$name"
  echo "installed: .git/hooks/$name"
done
