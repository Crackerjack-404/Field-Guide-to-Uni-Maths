#!/usr/bin/env bash
set -euo pipefail

mkdir -p generated

for texfile in latex/*.tex; do
  base="$(basename "$texfile" .tex)"
  pandoc "$texfile" \
    --from=latex \
    --to=markdown \
    --wrap=none \
    --output="generated/${base}.Rmd"
done
