#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/helpers.sh"


print_mullvad_status() {
    local status

    #
    #  If this script does not recognize the status,
    #  display it as reported from mullvad
    #
    status="$(mullvad_status | grep status | awk '{print $3}')"
    
    if [[ $status == "Disconnected" ]]; then
        disconnected_text=$(get_tmux_option "@mullvad_disconnected_text" "🔓")
        status="$(trim "$disconnected_text")"
    elif [[ $status == "Blocked:" ]]; then
        blocked_text=$(get_tmux_option "@mullvad_blocked_text" "🔓")
        status="$(trim "$blocked_text")"
    elif [[ $status == "Connecting" ]]; then
        connecting_text=$(get_tmux_option "@mullvad_connecting_text" "🔒")
        status="$(trim "$connecting_text")"
    elif [[ $status == "Connected" ]]; then
        if is_excluded_country; then
            status=""
        else
            connected_text=$(get_tmux_option "@mullvad_connected_text" "🔐")
            status="$(trim "$connected_text")"
        fi
    fi
    if [ -n "$status" ]; then
        status_prefix=$(get_tmux_option "@mullvad_status_prefix")
        status_suffix=$(get_tmux_option "@mullvad_status_suffix")
        color_wrap "$status_prefix$status$status_suffix"
    fi
}

print_mullvad_status
