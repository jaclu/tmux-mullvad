#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/scripts/helpers.sh"


commands=(
    "#($CURRENT_DIR/scripts/status.sh)"
    "#($CURRENT_DIR/scripts/country.sh)"
    "#($CURRENT_DIR/scripts/city.sh)"
    "#($CURRENT_DIR/scripts/server.sh)"
    "#($CURRENT_DIR/scripts/ip.sh)"
    "#($CURRENT_DIR/scripts/status_color.sh)"
)

placeholders=(
    "\#{mullvad_status}"
    "\#{mullvad_country}"
    "\#{mullvad_city}"
    "\#{mullvad_server}"
    "\#{mullvad_ip}"
    "\#{mullvad_status_color}"
)


do_interpolation() {
    local interpolated="$1"

    for i in "${!commands[@]}" ; do
        interpolated=${interpolated/${placeholders[$i]}/${commands[$i]}}
    done

    echo "$interpolated"
}

update_tmux_option() {
    local option="$1"
    local option_value
    local new_option_value

    option_value="$(get_tmux_option "$option")"
    new_option_value="$(do_interpolation "$option_value")"
    set_tmux_option "$option" "$new_option_value"
}

main() {
    update_tmux_option "status-right"
    update_tmux_option "status-left"
}

main
