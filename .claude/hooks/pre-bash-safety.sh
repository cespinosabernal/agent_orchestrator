#!/usr/bin/env bash
# pre-bash-safety.sh
# PreToolUse hook for Bash commands.
# Blocks dangerous patterns before execution.
# Exit 2 = block the command and show error to Claude.
# Exit 0 = allow.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(python3 -c "
import sys, json
try:
    d = json.loads(sys.stdin.read())
    print(d.get('tool_input', {}).get('command', ''))
except Exception:
    print('')
" <<< "$INPUT" 2>/dev/null || echo "")

# ── 1. Enforce mamba over pip ────────────────────────────────────────────────
# Direct 'pip install' into base pollutes the environment.
if echo "$COMMAND" | grep -qE '(^|\s)pip\s+install\b'; then
    cat >&2 <<'EOF'
BLOCKED: Direct `pip install` is not allowed.
Use mamba in an activated conda environment:

    mamba create -n sci-orchestrator python=3.11   # once
    mamba activate sci-orchestrator
    mamba install -c conda-forge <package>

If a package is only on PyPI, use pip inside the active env (not base):
    mamba activate sci-orchestrator && pip install <package>
EOF
    exit 2
fi

# ── 2. Block pipe-to-shell patterns ─────────────────────────────────────────
# curl/wget output piped directly to a shell is a supply-chain risk.
if echo "$COMMAND" | grep -qE '(curl|wget)[^|]*\|\s*(bash|sh|zsh|fish|python3?)\b'; then
    cat >&2 <<'EOF'
BLOCKED: Pipe-to-shell pattern detected (curl/wget | bash/sh/python).
Download the script first, inspect it, then execute it:

    curl -fsSL <url> -o install.sh
    cat install.sh   # review
    bash install.sh
EOF
    exit 2
fi

# ── 3. Block catastrophic recursive deletes ──────────────────────────────────
# Allow normal rm usage; only block root/home-level recursive deletes.
if echo "$COMMAND" | grep -qE 'rm\s+.*(-[a-zA-Z]*r[a-zA-Z]*f|-[a-zA-Z]*f[a-zA-Z]*r|--recursive)'; then
    if echo "$COMMAND" | grep -qE 'rm\s+.*(-rf|-fr|--recursive).*(\s+/[^/\w]|\s+/\*|\s+~/?(\s|$))'; then
        echo "BLOCKED: Recursive delete targeting root or home directory." >&2
        exit 2
    fi
fi

# ── 4. Block sudo rm ─────────────────────────────────────────────────────────
if echo "$COMMAND" | grep -qE '\bsudo\s+rm\b'; then
    echo "BLOCKED: sudo rm is not allowed." >&2
    exit 2
fi

# ── 5. Block inline credential writes ────────────────────────────────────────
# Catches: echo "sk-abc123" >> .env  or  export OPENAI_API_KEY=sk-...
if echo "$COMMAND" | grep -qE "(echo|printf|export)\s+.*['\"]?(sk-[a-zA-Z0-9]{20,}|AKIA[A-Z0-9]{16}|ghp_[a-zA-Z0-9]{36})"; then
    echo "BLOCKED: Potential API key detected in command. Load credentials from .env, never inline." >&2
    exit 2
fi

exit 0
