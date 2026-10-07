#!/usr/bin/env bash
# Notificações do macOS para os hooks do Claude Code. Recebe o evento em $1 e o
# payload do hook em stdin.
#
# Publica através de ~/Applications/Claude Code Notifier.app, uma cópia do
# terminal-notifier com o ícone do Ghostty: o macOS tira sempre o ícone do bundle
# de quem publica, e não há API para o substituir em tempo de execução. O
# rebuild-notifier.sh ao lado reconstrói essa app.
#
# Variáveis de ambiente:
#   CLAUDE_NOTIFY_DEBUG=1        regista cada decisão em ~/.claude/hooks/notify.log
#   CLAUDE_NOTIFY_MIN_SECONDS=N  turnos abaixo de N segundos não avisam (omissão: 30)
set -uo pipefail

NOTIFIER="$HOME/Applications/Claude Code Notifier.app/Contents/MacOS/terminal-notifier"
[ -x "$NOTIFIER" ] || NOTIFIER="$(command -v terminal-notifier 2>/dev/null || true)"
STATE="${TMPDIR:-/tmp}/claude-notify-$(id -u)"
LOG="$HOME/.claude/hooks/notify.log"
MIN_SECONDS="${CLAUDE_NOTIFY_MIN_SECONDS:-30}"

event="${1:-stop}"
payload="$(cat)"

# Dentro do herdr avisa o plugin herdr-focus-notify; sair evita a notificação dupla.
[ "${HERDR_ENV:-}" = 1 ] && exit 0

log() {
  [ -n "${CLAUDE_NOTIFY_DEBUG:-}" ] || return 0
  printf '%s [%s] %s\n' "$(date '+%F %T')" "$event" "$*" >> "$LOG"
}
field() { printf '%s' "$payload" | jq -r "$1 // empty" 2>/dev/null; }

mkdir -p "$STATE"
key="$(field '.session_id')"
[ -n "$key" ] || key="sem-sessao"
key="${key//[^A-Za-z0-9_-]/_}"
stamp="$STATE/$key.start"

# UserPromptSubmit só marca o início, para o Stop poder dizer quanto demorou.
if [ "$event" = "start" ]; then
  date +%s > "$stamp"
  log "inicio marcado"
  exit 0
fi

# Duração do turno, em texto curto.
human=""
elapsed=""
if [ -r "$stamp" ]; then
  began="$(cat "$stamp" 2>/dev/null)"
  case "$began" in ''|*[!0-9]*) began="" ;; esac
  if [ -n "$began" ]; then
    elapsed=$(( $(date +%s) - began ))
    if   [ "$elapsed" -ge 3600 ]; then human="$(( elapsed / 3600 ))h$(( (elapsed % 3600) / 60 ))m"
    elif [ "$elapsed" -ge 60 ];   then human="$(( elapsed / 60 ))m$(( elapsed % 60 ))s"
    else                               human="${elapsed}s"
    fi
  fi
fi
[ "$event" = "stop" ] && rm -f "$stamp"

# Cada evento decide o texto, o som, e se pode ser calado.
por_duracao=0
case "$event" in
  notification)
    message="$(field '.message')"
    [ -n "$message" ] || message="À espera de ti"
    sound="Ping"
    ;;
  stop|*)
    message="Acabou o turno${human:+ — $human}"
    sound="Glass"; por_duracao=1
    ;;
esac

if [ "$por_duracao" = 1 ] && [ -n "$elapsed" ] && [ "$elapsed" -lt "$MIN_SECONDS" ]; then
  log "calado: turno de ${elapsed}s, abaixo dos ${MIN_SECONDS}s"
  exit 0
fi

cwd="$(field '.cwd')"
[ -n "$cwd" ] || cwd="$PWD"
subtitle="$(basename "$cwd")"
click=""
# Trazer o terminal à frente; o bundle id vem herdado do lançamento.
[ -n "${__CFBundleIdentifier:-}" ] && click="open -b '${__CFBundleIdentifier}'"

log "a publicar: [$subtitle] $message | click=${click:-nenhum}"
if [ -n "$NOTIFIER" ] && [ -x "$NOTIFIER" ]; then
  args=(-title "Claude Code" -subtitle "$subtitle" -message "$message"
        -sound "$sound" -group "claude-$key-$event")
  [ -n "$click" ] && args+=(-execute "$click")
  "$NOTIFIER" "${args[@]}" >/dev/null 2>&1
  log "terminal-notifier saiu com $?"
else
  osascript -e "display notification \"${message//\"/\\\"}\" with title \"Claude Code\" subtitle \"${subtitle//\"/\\\"}\" sound name \"$sound\"" >/dev/null 2>&1
  log "osascript (sem terminal-notifier) saiu com $?"
fi
exit 0
