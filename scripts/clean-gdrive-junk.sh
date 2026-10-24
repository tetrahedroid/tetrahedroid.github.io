#!/usr/bin/env bash
# Remove macOS/Google Drive junk that breaks git when it lands inside .git/
# - Icon*  (real name is often Icon + CR, shown as Icon?)
# - .DS_Store
#
# .gitignore cannot protect .git internals. Run via:
#   make clean
#   ./scripts/clean-gdrive-junk.sh
# or automatically from pre-commit / pre-push hooks (make hooks).
#
# Longer-term: keep git repos off Google Drive sync, or exclude .git from sync.
set -euo pipefail

QUIET=0
if [[ "${1:-}" == "--quiet" ]]; then
  QUIET=1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export QUIET
python3 - <<'PY'
import os
import sys

root = os.getcwd()
quiet = os.environ.get("QUIET") == "1"
removed = []
for dirpath, dirnames, filenames in os.walk(root):
    for name in filenames:
        if name.startswith("Icon") or name == ".DS_Store":
            path = os.path.join(dirpath, name)
            try:
                os.remove(path)
                removed.append(path)
            except OSError as e:
                print(f"fail: {path}: {e}", file=sys.stderr)

n_git = sum(1 for p in removed if "/.git/" in p)
if not quiet:
    for p in removed:
        print(p)
    print(f"Removed: {len(removed)} (under .git: {n_git})")
elif removed:
    print(f"clean-gdrive-junk: removed {len(removed)} file(s) ({n_git} under .git)")
PY
