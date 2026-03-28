#!/usr/bin/env bash
# notify.sh
# Notification hook — fires when Claude Code needs user attention.
# Sends a system notification on macOS or Linux.
# Always exits 0 (never blocks).

INPUT=$(cat)
MSG=$(python3 -c "
import sys, json
try:
    d = json.loads(sys.stdin.read())
    print(d.get('message', 'Claude Code needs your attention'))
except Exception:
    print('Claude Code needs your attention')
" <<< "$INPUT" 2>/dev/null || echo "Claude Code needs your attention")

TITLE="Scientific Orchestrator"

if [[ "$(uname)" == "Darwin" ]]; then
    # macOS — use osascript
    osascript -e "display notification \"$MSG\" with title \"$TITLE\"" 2>/dev/null || true
elif command -v notify-send &>/dev/null; then
    # Linux with libnotify
    notify-send "$TITLE" "$MSG" 2>/dev/null || true
fi
# Silent on other platforms

exit 0
