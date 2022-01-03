#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/helpers.sh"


city_prefix=$(get_tmux_option "@mullvad_city_prefix")
city_suffix=$(get_tmux_option "@mullvad_city_suffix")


print_mullvad_city() {
    [ "$(is_connected)" != "1" ] && return
    
    if ! is_excluded_city; then
        # shellcheck disable=SC2154
        color_wrap "${city_prefix}$city${city_suffix}"
    fi
}

print_mullvad_city
