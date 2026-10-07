#!/bin/sh
# Alt+hjkl: dentro do vim a tecla segue para ele (redimensiona os splits), fora redimensiona o pane.
set -eu

dir="$1"
pane="${HERDR_ACTIVE_PANE_ID:?}"
herdr="${HERDR_BIN_PATH:-herdr}"

case "$dir" in
    left) key="alt+h" ;;
    down) key="alt+j" ;;
    up) key="alt+k" ;;
    right) key="alt+l" ;;
esac

if "$herdr" pane process-info --pane "$pane" \
    | jq -e '.result.process_info.foreground_processes[]?.name | ascii_downcase | select(test("^g?(view|l?n?vim?x?)(diff)?$"))' >/dev/null; then
    exec "$herdr" pane send-keys "$pane" "$key"
fi
exec "$herdr" pane resize --direction "$dir" --pane "$pane"
