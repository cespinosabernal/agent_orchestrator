#!/usr/bin/env bash
# post-edit-format.sh
# PostToolUse hook for Edit and Write on Python and R files.
# Python: runs ruff format + ruff check (falls back to black).
# R/Rmd/qmd: runs styler::style_file() then lintr::lint() for reporting.
# Always exits 0 (non-blocking); lint output goes to stdout
# so Claude sees it as context.

INPUT=$(cat)
FILE_PATH=$(python3 -c "
import sys, json
try:
    d = json.loads(sys.stdin.read())
    ti = d.get('tool_input', {})
    print(ti.get('file_path', ''))
except Exception:
    print('')
" <<< "$INPUT" 2>/dev/null || echo "")

# Skip if file no longer exists
[[ -f "$FILE_PATH" ]] || exit 0

ISSUES=""

# ── Python files ─────────────────────────────────────────────────────────────
if [[ "$FILE_PATH" == *.py ]]; then
    if command -v ruff &>/dev/null; then
        ruff format --quiet "$FILE_PATH" 2>/dev/null || true
        LINT=$(ruff check --output-format concise "$FILE_PATH" 2>&1 || true)
        if [[ -n "$LINT" ]]; then
            ISSUES="$LINT"
        fi
    elif command -v black &>/dev/null; then
        black --quiet "$FILE_PATH" 2>/dev/null || true
    fi

    if [[ -n "$ISSUES" ]]; then
        echo "[ruff] Lint issues in $FILE_PATH:"
        echo "$ISSUES"
    fi

# ── R / Rmd / qmd files ──────────────────────────────────────────────────────
elif [[ "$FILE_PATH" == *.R || "$FILE_PATH" == *.Rmd || "$FILE_PATH" == *.qmd ]]; then
    if command -v Rscript &>/dev/null; then
        # Format with styler (silently; modifies file in-place)
        Rscript -e "
if (requireNamespace('styler', quietly = TRUE)) {
  styler::style_file('$FILE_PATH')
} else {
  message('[styler] not installed — skipping format')
}
" 2>/dev/null || true

        # Lint with lintr (report only, never block)
        LINT=$(Rscript -e "
if (requireNamespace('lintr', quietly = TRUE)) {
  lints <- lintr::lint('$FILE_PATH')
  if (length(lints) > 0) print(lints)
} else {
  message('[lintr] not installed — skipping lint')
}
" 2>&1 || true)
        if [[ -n "$LINT" && "$LINT" != *"not installed"* ]]; then
            echo "[lintr] Lint issues in $FILE_PATH:"
            echo "$LINT"
        fi
    fi
fi

exit 0
