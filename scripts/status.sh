#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/helpers.sh"


disconnected_text=$(get_tmux_option "@mullvad_disconnected_text" "🔓")
blocked_text=$(get_tmux_option "@mullvad_blocked_text" "🔓")
connecting_text=$(get_tmux_option "@mullvad_connecting_text" "🔒")
connected_text=$(get_tmux_option "@mullvad_connected_text" "🔐")

status_prefix=$(get_tmux_option "@mullvad_status_prefix")
status_suffix=$(get_tmux_option "@mullvad_status_suffix")


print_mullvad_status() {
    #
    #  If this script does not recognize the status,
    #  display it as reported from mullvad
    #
    local status

    status="$(mullvad_status | grep status | awk '{print $3}')"
    
    if [[ $status == "Disconnected" ]]; then
        status="$(trim "$disconnected_text")"
    elif [[ $status == "Blocked:" ]]; then
        status="$(trim "$blocked_text")"
    elif [[ $status == "Connecting" ]]; then
        status="$(trim "$connecting_text")"
    elif [[ $status == "Connected" ]]; then
        if is_excluded_country; then
            status=""
        else
            status="$(trim "$connected_text")"
        fi
    fi
    [ -n "$status" ] && color_wrap "$status_prefix$status$status_suffix"
}

print_mullvad_status
