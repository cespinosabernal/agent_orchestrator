# Python Development Rules

## Environment
- **Never** `pip install` into base conda. Always activate a named env first:
  ```
  mamba activate sci-orchestrator
  mamba install -c conda-forge <package>
  ```
- If a package is PyPI-only, use `pip install` inside the activated env (not base).
- Lock environments with `conda env export > environment.yml` after adding packages.

## Code Quality
- Python 3.10+; type hints required on all function signatures.
- Google-style docstrings for all public functions/classes.
- Format with `ruff format`; lint with `ruff check`.
- Line length: 88 characters (black-compatible).
- No unused imports; no bare `except:`.
- **Auto-triggered:** `ruff format` and `ruff check` run automatically after every file edit via the PostToolUse hook. Lint issues are printed to context — fix them before proceeding.

## Security
- No hardcoded credentials. Load from environment variables or `.env` (gitignored).
- No PHI written to disk unencrypted. De-identify before processing.
- Never commit `.env`, API keys, or secrets.

## Scripts and Notebooks
- Standalone scripts: include `if __name__ == "__main__":` guard.
- Jupyter notebooks: clear outputs before committing.
- Use `pathlib.Path` over `os.path` for file operations.

## Testing
- Write pytest tests for non-trivial functions.
- Run tests before committing: `pytest -x -q`.
