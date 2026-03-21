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

text = re.sub(r'!\[\]\(xkcd/', '![](../xkcd/', text)
text = re.sub(r'src="xkcd/', 'src="../xkcd/', text)
text = re.sub(r'\\includegraphics.*?{xkcd/', '![](../xkcd/', text)

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
