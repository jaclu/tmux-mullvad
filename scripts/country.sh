#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/helpers.sh"




print_mullvad_country() {
    [ "$(is_connected)" != "1" ] && return

    if ! is_excluded_country; then
        country_prefix=$(get_tmux_option "@mullvad_country_prefix")
        country_suffix=$(get_tmux_option "@mullvad_country_suffix")
        # shellcheck disable=SC2154
        color_wrap "${country_prefix}$country${country_suffix}"
    fi
}

print_mullvad_country
