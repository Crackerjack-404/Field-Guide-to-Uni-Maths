#!/usr/bin/env bash
set -euo pipefail

mkdir -p chapters

for texfile in tex/*.tex; do
  base="$(basename "$texfile" .tex)"
  pandoc "$texfile" \
    --from=latex \
    --to=markdown \
    --wrap=none \
    --output="chapters/${base}.qmd"
done
