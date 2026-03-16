#!/usr/bin/env python3
from pathlib import Path

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
    - file: chapters/01-jump.qmd
      title: "The Jump"
    - file: chapters/02-lectures.qmd
      title: "Lectures and Coursework"
    - file: chapters/03-workshops.qmd
      title: "Workshops and Other Resources"
    - file: chapters/04-problem-solving.qmd
      title: "Problem Solving"
    - file: chapters/05-exams.qmd
      title: "Exams"
    - file: chapters/06-time-management.qmd
      title: "Time Management"
    - file: chapters/07-future.qmd
      title: "Future"
    - file: chapters/08-useful-links.qmd
      title: "Useful Links"


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
