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

p = Path("$file")
lines = p.read_text().splitlines()

new_lines = []

for line in lines:
    # Fix paths first
    line = line.replace('(xkcd/', '(../xkcd/')
    line = line.replace('src="xkcd/', 'src="../xkcd/')

    # Convert includegraphics safely
    if '\\includegraphics' in line:
        start = line.find('{')
        end = line.find('}')
        if start != -1 and end != -1:
            path = line[start+1:end]
            line = f"![](../{path})"

    # Fix linewidth
    line = line.replace('0.5\\linewidth', '50%')
    line = line.replace('0.4\\linewidth', '40%')
    line = line.replace('0.3\\linewidth', '30%')

    new_lines.append(line)

p.write_text("\n".join(new_lines))
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
