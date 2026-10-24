#!/usr/bin/env bash
# Remove macOS/Google Drive junk that breaks git when it lands inside .git/
# - Icon*  (real name is often Icon + CR, shown as Icon?)
# - .DS_Store
#
# .gitignore cannot protect .git internals. Run this when git misbehaves:
#   make clean
#   ./scripts/clean-gdrive-junk.sh
#
# Longer-term: keep git repos off Google Drive sync, or exclude .git from sync.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

python3 - <<'PY'
import os
import sys

root = os.getcwd()
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

in_git = [p for p in removed if "/.git/" in p or p.endswith("/.git/" + os.path.basename(p))]
# recount paths under .git
in_git = [p for p in removed if "/.git/" in p.replace(root, "", 1) or p[len(root):].startswith("/.git/")]

for p in removed:
    print(p)
print(f"Removed: {len(removed)} (under .git: {sum(1 for p in removed if '/.git/' in p)})")
PY
