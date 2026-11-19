#!/usr/bin/env bash
# Everything CI checks, in the same order. Run before you push:  bash scripts/check.sh
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== format (StyLua)";              stylua --check src maps tests scripts tools
echo "== lint (Selene)";                selene src maps tests scripts tools
echo "== tests (Lune)";                 lune run tests/run
echo "== generated maps up to date";    lune run scripts/build-maps --check
echo "== maps";                         lune run scripts/validate-maps
echo "== build every place (Rojo)";     bash scripts/build.sh
echo "All checks passed."
