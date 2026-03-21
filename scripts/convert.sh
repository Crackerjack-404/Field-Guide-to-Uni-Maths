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

  # --- FIX 1: image paths (most important) ---
  sed -i 's|![](xkcd/|![](../xkcd/|g' "$file"
  sed -i 's|src="xkcd/|src="../xkcd/|g' "$file"

  # --- FIX 2: remove leftover LaTeX graphics ---
  sed -i 's|\\includegraphics.*{xkcd/|![](../xkcd/|g' "$file"

  # --- FIX 3: ensure .png extension exists (if missing) ---
  sed -i 's|![](../xkcd/\([^.)]*\))|![](../xkcd/\1.png)|g' "$file"

  # prepend a proper chapter heading
  tmpfile="$(mktemp)"
  printf '# %s\n\n' "$(python3 - <<PY
s = "${title}"
print(" ".join(w.capitalize() for w in s.split()))
PY
)" > "$tmpfile"
  cat "chapters/${base}.qmd" >> "$tmpfile"
  mv "$tmpfile" "chapters/${base}.qmd"
done

