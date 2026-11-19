#!/usr/bin/env bash
# Builds every map into build/<name>.rbxl (or just one: scripts/build.sh lava-run).
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build

maps=("$@")
if [ ${#maps[@]} -eq 0 ]; then
  for d in maps/*/; do maps+=("$(basename "$d")"); done
fi

for m in "${maps[@]}"; do
  rojo build "maps/$m" --output "build/$m.rbxl"
done
