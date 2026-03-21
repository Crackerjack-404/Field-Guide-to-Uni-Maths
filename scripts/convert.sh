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

  # --- FIX ALL IMAGE ISSUES USING PYTHON ---
  python3 - <<PY
from pathlib import Path
import re

p = Path("$file")
text = p.read_text()

# --- Fix paths ---
text = text.replace('(xkcd/', '(../xkcd/')
text = text.replace('src="xkcd/', 'src="../xkcd/')

# --- Convert includegraphics safely ---
text = re.sub(
    r'\\includegraphics(?:\[[^\]]*\])?{([^}]*)}',
    r'![](../\1)',
    text
)

# --- Fix linewidth → percentage ---
text = text.replace('0.5\\linewidth', '50%')
text = text.replace('0.4\\linewidth', '40%')
text = text.replace('0.3\\linewidth', '30%')

# --- Clean spacing ---
text = re.sub(r'{\s*width\s*=\s*([^}]*)}', r'{width=\1}', text)

p.write_text(text)
PY

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

echo "Done."
