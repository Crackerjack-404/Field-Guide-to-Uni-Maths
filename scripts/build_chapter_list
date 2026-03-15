#!/usr/bin/env python3
from pathlib import Path

chapter_files = sorted(Path("chapters").glob("*.qmd"))

chapters_yaml = "\n".join([f"    - {p.as_posix()}" for p in chapter_files])

content = f"""project:
  type: book
  output-dir: docs

book:
  title: "Field Guide to Mathematics at University"
  author: "First Year Student 25/26" 
  chapters:
    - index.qmd
{chapters_yaml}

format:
  html:
    theme: cosmo
    css: styles.css
    toc: true
    search: true
    number-sections: true
"""

Path("_quarto.yml").write_text(content, encoding="utf-8")
