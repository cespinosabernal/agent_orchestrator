---
name: rmarkdown
description: R Markdown for reproducible scientific reports — document structure, knitr options, parameterized reports, and rendering.
allowed-tools: Read Write Edit Bash
---

# R Markdown for Reproducible Research

## Document Structure

```yaml
---
title: "Analysis Title"
author: "Your Name"
date: "`r Sys.Date()`"
output:
  html_document:
    toc: true
    toc_float: true
    code_folding: show
    fig_width: 8
    fig_height: 5
params:
  input_file: "data/raw.h5ad"
  seed: 42
---
```

## Global Chunk Options (place after YAML)

```r
knitr::opts_chunk$set(
  echo    = TRUE,
  warning = FALSE,
  message = FALSE,
  cache   = FALSE,        # set TRUE only for slow chunks; invalidate carefully
  fig.align = "center",
  dpi     = 300
)
```

## Code Chunk Conventions

- Name every chunk: ` ```{r load-data} `
- Use `cache = TRUE` only for genuinely slow steps; always set `dependson`.
- Use `results = "asis"` for `knitr::kable()` and `gt::gt()` tables.
- Separate data loading, transformation, and visualization into distinct named chunks.

## Parameterized Reports

Access params in code as `params$seed`, `params$input_file`.

```bash
# Render with custom params from command line
Rscript -e "rmarkdown::render('analysis.Rmd', params=list(input_file='data/alt.csv'))"
```

## Rendering

```r
# HTML (default)
rmarkdown::render("analysis.Rmd")

# PDF (requires LaTeX via tinytex)
rmarkdown::render("analysis.Rmd", output_format = "pdf_document")

# GitHub-flavored markdown (for repo README-style outputs)
rmarkdown::render("analysis.Rmd", output_format = "github_document")
```

## Reproducibility

- Use `renv` — all packages resolved from `renv.lock`.
- Use `here::here()` for all file paths; never `setwd()`.
- Set seed at the top of the document: `set.seed(params$seed)`.
- Print session info in the last chunk:
  ```r
  sessionInfo()
  ```
- Never commit rendered HTML/PDF — add `*.html` and `*.pdf` to `.gitignore` for analysis outputs.
