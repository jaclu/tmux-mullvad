#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

source "$CURRENT_DIR/helpers.sh"


print_mullvad_status() {
    status=$(mullvad status | awk '{print $3}')

    if [[ $status == "Disconnected" ]]; then
	disconnected_text=$(get_tmux_option "@mullvad_disconnected_text" "🔓")
        trim "$disconnected_text"
    elif [[ $status == "Blocked:" ]]; then
	blocked_text=$(get_tmux_option "@mullvad_blocked_text" "🔓")
        trim "$blocked_text"
    elif [[ $status == "Connecting" ]]; then
	connecting_text=$(get_tmux_option "@mullvad_connecting_text" "🔓")
        trim "$connecting_text"
    elif [[ $status == "Connected" ]]; then
	connected_text=$(get_tmux_option "@mullvad_connected_text" "🔐")
        trim "$connected_text"
    fi
}

print_mullvad_status
