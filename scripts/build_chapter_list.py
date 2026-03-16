#!/usr/bin/env python3
from pathlib import Path

chapter_files = sorted(Path("chapters").glob("*.qmd"))

chapters_yaml = "\n".join([f"    - {p.as_posix()}" for p in chapter_files])

content = f"""project:
  type: book
  output-dir: docs
  resources: 
    - pdf 
    - xkcd 

book:
  title: "Field Guide to Mathematics at University"
  author: "First Year Student 25/26" 

  sidebar: 
    search: true 
    tools: 
      - icon: download 
        href: assets/field-guide.pdf 
        text: Download PDF 
  
  chapters:
    - index.qmd
{chapters_yaml}


format:
  html:
    theme:
      light: cosmo
      dark: darkly
    css: styles.css
    include-in-header:
      - text: |
          <script src="progress.js"></script>
    toc: true
    search: true
    number-sections: true
    respect-user-color-scheme: true
    toggle: true
    page-navigation: true
    date: last-modified
"""
Path("_quarto.yml").write_text(content, encoding="utf-8")
