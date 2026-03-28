#!/usr/bin/env bash
# post-edit-format.sh
# PostToolUse hook for Edit and Write on Python files.
# Runs ruff format + ruff check after Claude edits a .py file.
# Gracefully skips if ruff is not installed.
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

# Only act on Python files
[[ "$FILE_PATH" == *.py ]] || exit 0

# Skip if file no longer exists
[[ -f "$FILE_PATH" ]] || exit 0

ISSUES=""

# ── ruff format (replaces black) ─────────────────────────────────────────────
if command -v ruff &>/dev/null; then
    ruff format --quiet "$FILE_PATH" 2>/dev/null || true

    # ── ruff check (lint, no auto-fix — report only) ─────────────────────────
    LINT=$(ruff check --output-format concise "$FILE_PATH" 2>&1 || true)
    if [[ -n "$LINT" ]]; then
        ISSUES="$LINT"
    fi
elif command -v black &>/dev/null; then
    black --quiet "$FILE_PATH" 2>/dev/null || true
fi

# Print lint issues to stdout so Claude sees them as context
if [[ -n "$ISSUES" ]]; then
    echo "[ruff] Lint issues in $FILE_PATH:"
    echo "$ISSUES"
fi

exit 0
