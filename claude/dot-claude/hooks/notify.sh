#!/usr/bin/env bash
# Claude Code hook: macOS notification naming the tmux session, so several
# agents running in parallel panes can be told apart without switching to each
# one. Wired to Stop (turn finished) and Notification (waiting on you).
set -uo pipefail

payload=$(cat)
event=$(jq -r '.hook_event_name // ""' <<<"$payload")
msg=$(jq -r '.message // ""' <<<"$payload")
cwd=$(jq -r '.cwd // ""' <<<"$payload")

# The tmux session name is the label the user actually recognises; fall back to
# the project directory when claude is not running inside tmux.
where=""
[ -n "${TMUX_PANE:-}" ] && where=$(tmux display-message -p -t "$TMUX_PANE" '#S' 2>/dev/null)
[ -n "$where" ] || where=$(basename "${cwd:-$PWD}")

case "$event" in
  Stop) title="✅ $where"; : "${msg:=Agente terminou}" ;;
  *)    title="⏳ $where"; : "${msg:=Precisa de input}" ;;
esac

# argv, not string interpolation: the message is untrusted payload and would
# otherwise break out of the AppleScript quoting.
osascript - "$title" "$msg" <<'APPLESCRIPT'
on run argv
  display notification (item 2 of argv) with title (item 1 of argv) sound name "Ping"
end run
APPLESCRIPT
