#!/usr/bin/env bash
set -euo pipefail

mkdir -p chapters

for texfile in tex/*.tex; do
  base="$(basename "$texfile" .tex)"
  title="$(echo "$base" | sed 's/^[0-9][0-9]-//' | tr '-' ' ')"

  pandoc "$texfile" \
    --from=latex \
    --to=markdown \
    --wrap=none \
    --shift-heading-level-by=1 \
    --output="chapters/${base}.qmd"

  file="chapters/${base}.qmd"

  # --- FIX 1: image paths ---
  sed -i 's|![](xkcd/|![](../xkcd/|g' "$file"
  sed -i 's|src="xkcd/|src="../xkcd/|g' "$file"

  # --- FIX 2: LaTeX includegraphics fallback ---
  sed -i 's|\\includegraphics.*{xkcd/|![](../xkcd/|g' "$file"

  # prepend chapter heading
  tmpfile="$(mktemp)"
  printf '# %s\n\n' "$(python3 - <<PY
s = "${title}"
print(" ".join(w.capitalize() for w in s.split()))
PY
)" > "$tmpfile"
  cat "$file" >> "$tmpfile"
  mv "$tmpfile" "$file"

done
