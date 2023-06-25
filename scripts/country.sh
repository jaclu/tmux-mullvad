#!/usr/bin/env bash
#
#  Copyright (c) 2022: Jacob.Lundqvist@gmail.com
#  License: MIT
#
#  Part of https://github.com/jaclu/tmux-mullvad
#
#  Version: 2.0.0 2022-04-09
#
#  Prints what country the VPN server is located in
#

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$CURRENT_DIR/utils.sh"

print_mullvad_country() {
    local country_prefix
    local country_suffix
    local country # defined in is_excluded_country()
    local msg

    [[ "$(is_connected)" != "1" ]] && return

    if ! is_excluded_country; then
        country_prefix=$(get_tmux_option "@mullvad_country_prefix")
        country_suffix=$(get_tmux_option "@mullvad_country_suffix")
        # shellcheck disable=SC2154
        msg="$(color_wrap "${country_prefix}$country${country_suffix}")"
        # log_it "Country before non blank spaces:[$msg]"
        if [[ -n "$msg" ]]; then
            if bool_param "$(get_tmux_option "@mullvad_country_no_color_prefix" 0)"; then
                msg=" $msg"
            fi
            if bool_param "$(get_tmux_option "@mullvad_country_no_color_suffix" 0)"; then
                msg="$msg "
            fi
            # log_it "Country after  non blank spaces:[$msg]"
        fi
        # log_it "Country [$msg]"
        echo "$msg"
    fi
}

print_mullvad_country
