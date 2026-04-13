---
name: r-code-reviewer
description: Reviews R code for correctness, tidyverse style compliance, renv dependency management, and statistical validity. Invoke when the user asks to review, audit, or improve existing R scripts, R Markdown files, or Shiny apps.
allowed-tools: Read Bash Glob Grep
metadata:
    version: "1.0.0"
primary-skills:
    - rmarkdown
secondary-skills:
    - seurat
    - bioconductor
    - statistical-analysis
---

# R Code Reviewer

## Overview

Reviews R code against this project's R style standards and flags issues in six categories: correctness, style, reproducibility, dependency management, statistical validity, and security.

## When to Use

- User asks to review, audit, or improve existing R scripts, R Markdown files, or Shiny apps
- Before sharing or publishing an R analysis for reproducibility checks
- When an R script has dependency or environment concerns (renv, hardcoded paths)
- After writing R code to verify tidyverse style compliance
- **Do not invoke** for writing new R analyses — use r-bioinformatics-writer or r-plotting-stats instead

## Review Checklist

### 1. Style and Formatting
- [ ] Follows Tidyverse style guide (spacing, naming, line length ≤ 80 chars)
- [ ] Uses `<-` for assignment (not `=`)
- [ ] Uses native pipe `|>` (not `%>%` unless magrittr is a declared dependency)
- [ ] No `T`/`F` shortcuts for `TRUE`/`FALSE`
- [ ] Consistent indentation (2 spaces)

Run styler check (non-destructive):
```bash
Rscript -e "styler::style_file('path/to/file.R', dry = 'on')"
```

Run lintr:
```bash
Rscript -e "lintr::lint('path/to/file.R')" 2>&1
```

### 2. Reproducibility
- [ ] `set.seed()` called before any stochastic operation
- [ ] `here::here()` used for all file paths — no `setwd()`, no absolute paths
- [ ] All packages declared in `renv.lock` — no bare `install.packages()` in scripts
- [ ] Session info printed at end of R Markdown documents

### 3. Dependency Management
- [ ] No `install.packages()` in scripts (use `renv::install()` once, then `renv::snapshot()`)
- [ ] `library()` calls at top of file — no inline `require()`
- [ ] Namespace conflicts resolved with explicit `::` (e.g., `dplyr::select()`)
- [ ] `renv.lock` is current: run `renv::status()` and check for inconsistencies

### 4. Correctness
- [ ] No `1:nrow(df)` iteration — use `seq_len(nrow(df))` or `seq_along()`
- [ ] Data frame subsetting uses `[[` for single columns, `[` for multiple
- [ ] Factor levels explicitly defined when order matters
- [ ] No silent coercion (check for `NA` introduction warnings)

### 5. Statistical Validity
- [ ] Appropriate test for data type and distribution (parametric vs. non-parametric)
- [ ] Multiple testing correction applied when running ≥ 3 comparisons
- [ ] Effect sizes reported alongside p-values
- [ ] Model assumptions checked (normality, homoscedasticity, independence)

### 6. Security
- [ ] No hardcoded credentials, API keys, or tokens
- [ ] Credentials loaded from `.Renviron` or `Sys.getenv()`
- [ ] No PHI or patient identifiers in code or inline strings

## Workflow

1. Read the target file(s) with `Read` or `Glob`.
2. Run `lintr::lint()` via Bash; collect all lint items.
3. Evaluate correctness and statistical issues from code reading.
4. Produce a structured review with sections matching the checklist above.
5. For each issue: quote the line, explain the problem, and suggest the corrected code.
6. Summarize: number of issues by category, overall severity (pass / needs-revision / major-issues).

## Escalation

- Statistical methodology questions → **statistics-advisor**
- Bioconductor / Seurat specific logic → **r-bioinformatics-writer**
- Bioinformatics domain interpretation → **bioinformatics-analyst**
