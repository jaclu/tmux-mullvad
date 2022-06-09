#!/usr/bin/env bash
#
#  Copyright (c) 2022: Jacob.Lundqvist@gmail.com
#  License: MIT
#
#  Part of https://github.com/jaclu/tmux-mullvad
#
#  Version: 2.0.1 2022-06-09
#
#  Prints current status
#

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/utils.sh"


print_mullvad_status() {
    local status
    local msg

    get_connection_status

    log_it "Status reported [$status]"
    if [[ $status == "Disconnected" ]]; then
        status="$(trim "$(get_tmux_option "@mullvad_disconnected_text" "🔓")")"
    elif [[ $status == "Blocked:" ]]; then
        status="$(trim "$(get_tmux_option "@mullvad_blocked_text" "🔓")")"
    elif [[ $status == "Connecting" ]]; then
        status="$(trim "$(get_tmux_option "@mullvad_connecting_text" "🔒")")"
    elif [[ $status == "Connected" ]]; then
        #
        #  I use @mullvad_excluded_country to filter out my home country, I only
        #  want to see status if connected somewhere else, for avoiding geo blocks.
        #  Then it is a good reminder to disable it once it is no longer needed to avoid
        #  bandwidth loss and extra lag
        #
        if is_excluded_country; then
            status=""
        else
            status="$(trim "$(get_tmux_option "@mullvad_connected_text" "🔐")")"
        fi
    fi
    if [ -n "$status" ]; then
        status_prefix=$(get_tmux_option "@mullvad_status_prefix")
        status_suffix=$(get_tmux_option "@mullvad_status_suffix")
        msg="$(color_wrap "$status_prefix$status$status_suffix")"
        # log_it "Status before non blank spaces:[$msg]"
        if [ -n "$msg" ]; then
            if bool_param "$(get_tmux_option "@mullvad_status_no_color_prefix" 0)"; then
               msg=" $msg"
            fi
            if bool_param "$(get_tmux_option "@mullvad_status_no_color_suffix" 0)"; then
                msg="$msg "
            fi
            # log_it "Status after  non blank spaces:[$msg]"
        fi
        # log_it "Status: [$msg]"
        echo "$msg"
    fi
}

print_mullvad_status
