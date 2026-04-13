---
name: jupyter-notebooks
description: Best practices for reproducible research with Jupyter notebooks — structure, parameterization, and version control.
allowed-tools: Read Write Edit Bash
---

# Jupyter Notebooks for Reproducible Research

## Notebook Structure

Organize every notebook in this order:
1. **Title cell** (Markdown) — title, author, date, purpose
2. **Imports** — all imports in a single cell at the top
3. **Parameters** — all configurable values (paths, seeds, thresholds) in one tagged cell
4. **Data loading** — one cell per data source
5. **Analysis sections** — clearly headed Markdown cells separating each step
6. **Results/figures** — one cell per output
7. **Session info** — final cell: `import session_info; session_info.show()`

## Reproducibility Rules

- Set seeds explicitly and early:
  ```python
  import random, numpy as np
  random.seed(42); np.random.seed(42)
  ```
- Use `pathlib.Path` for all file paths; never hardcode absolute paths.
- Tag parameter cells for papermill:
  ```python
  # Parameters (papermill tag: parameters)
  input_path = "data/raw.h5ad"
  n_neighbors = 15
  ```
- Restart kernel and run all cells before saving — never commit notebooks with stale outputs.
- Clear outputs before committing: `jupyter nbconvert --clear-output --inplace notebook.ipynb`

## Version Control

```bash
# Clear outputs before staging
jupyter nbconvert --clear-output --inplace *.ipynb
git add *.ipynb
```

Add to `.gitignore`: `.ipynb_checkpoints/`

## Parameterized Execution (papermill)

```bash
# Run notebook with custom parameters
papermill input.ipynb output.ipynb -p n_neighbors 30 -p resolution 0.5
```

## Converting to Reports

```bash
# HTML report
jupyter nbconvert --to html --execute notebook.ipynb

# PDF (requires LaTeX)
jupyter nbconvert --to pdf --execute notebook.ipynb

# Python script (for code review)
jupyter nbconvert --to script notebook.ipynb
```

## nbdime for Diffs

```bash
nbdime config-git --enable   # enable notebook-aware git diffs
nbdiff notebook_v1.ipynb notebook_v2.ipynb
```
