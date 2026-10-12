#!/bin/sh
# prefix+shift+hjkl: troca com o vizinho nessa direção; sem vizinho, move o pane para esse lado e vira o split.
set -eu

dir="$1"
pane="${HERDR_ACTIVE_PANE_ID:?}"
tab="${HERDR_ACTIVE_TAB_ID:?}"
ws="${HERDR_ACTIVE_WORKSPACE_ID:?}"
herdr="${HERDR_BIN_PATH:-herdr}"

"$herdr" pane swap --direction "$dir" --pane "$pane" | grep -Fq '"reason":"no_neighbor"' || exit 0

# ponytail: com 3+ panes usa o primeiro outro pane da tab; escolher o mais próximo se fizer falta
target=$("$herdr" pane list --workspace "$ws" \
    | jq -r --arg tab "$tab" --arg pane "$pane" \
        '[.result.panes[] | select(.tab_id == $tab and .pane_id != $pane)][0].pane_id // empty')
[ -n "$target" ] || exit 0

case "$dir" in
    down)  src="$pane";   dst="$target"; split=down ;;
    up)    src="$target"; dst="$pane";   split=down ;;
    right) src="$pane";   dst="$target"; split=right ;;
    left)  src="$target"; dst="$pane";   split=right ;;
esac
if [ "$src" = "$pane" ]; then focus=--focus; else focus=--no-focus; fi

# mover dentro da mesma tab é recusado (same_tab): sai para uma tab temporária e volta
"$herdr" pane move "$src" --new-tab --workspace "$ws" --no-focus >/dev/null
"$herdr" pane move "$src" --tab "$tab" --target-pane "$dst" --split "$split" "$focus" >/dev/null
