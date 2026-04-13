---
paths:
  - "**/*.R"
  - "**/*.Rmd"
  - "**/*.qmd"
  - "repo/**/*.R"
  - "repo/**/*.Rmd"
  - "repo/**/*.qmd"
---

# R Development Rules

## Environment
- **Never** use `install.packages()` in scripts. Use `renv` for reproducibility:
  ```r
  renv::restore()   # restore from renv.lock
  renv::install("pkg")  # install and record in renv.lock
  renv::snapshot()  # update renv.lock after changes
  ```
- All R projects in `repo/` must have an `renv.lock` file.
- Commit `renv.lock`; do not commit `renv/library/`.

## Code Style
- Follow Tidyverse style guide.
- Format with `styler::style_file()` or `styler::style_dir()`.
- Lint with `lintr::lint()` — target zero warnings.
- Prefer `<-` for assignment; use `=` only for function arguments.
- Use `|>` (native pipe, R 4.1+) over `%>%`.
- **Auto-triggered:** `styler::style_file()` and `lintr::lint()` run automatically after every `.R`/`.Rmd`/`.qmd` edit via the PostToolUse hook. Lint issues are printed to context — fix them before proceeding.

## Package Preferences
- Data manipulation: `dplyr`, `tidyr`, `data.table` for large data.
- Visualization: `ggplot2`; publication plots via `patchwork` or `cowplot`.
- Single-cell: `Seurat` v5, `SingleCellExperiment`, `scater`/`scran`.
- Statistics: `lme4`, `emmeans`, `broom`, `survival`.
- Bioinformatics: `Bioconductor` packages (`DESeq2`, `edgeR`, `limma`).

## Project Structure
```
project/
├── R/            # reusable functions (sourced, not executed)
├── scripts/      # analysis scripts (numbered: 01_, 02_, ...)
├── data/         # raw data (gitignored)
├── results/      # outputs (gitignored)
├── renv.lock     # dependency lock file (committed)
└── README.md
```

## Reproducibility
- Set seeds explicitly: `set.seed(42)`.
- Report R and package versions in output: `sessionInfo()`.
- Use `here::here()` for all file paths (never `setwd()`).
