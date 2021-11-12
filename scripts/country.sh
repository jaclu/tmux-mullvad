#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

source "$CURRENT_DIR/helpers.sh"

excluded_country=$(get_tmux_option "@mullvad_excluded_country")




print_mullvad_country() {
    if [ "$(is_connected)" = "1" ]; then
        country="$(trim $(mullvad status -l | grep Location | cut -d',' -f2-))"
        [ "$country" != "$excluded_country" ] && echo "$country"
    fi
}

print_mullvad_country
