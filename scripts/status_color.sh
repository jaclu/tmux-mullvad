#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/helpers.sh"


blocked_fg_color=$(get_tmux_option "@mullvad_blocked_fg_color")
blocked_bg_color=$(get_tmux_option "@mullvad_blocked_bg_color" "purple")

disconnected_fg_color=$(get_tmux_option "@mullvad_disconnected_fg_color")
disconnected_bg_color=$(get_tmux_option "@mullvad_disconnected_bg_color" "red")

connecting_fg_color=$(get_tmux_option "@mullvad_connecting_fg_color")
connecting_bg_color=$(get_tmux_option "@mullvad_connecting_bg_color" "yellow")

connected_fg_color=$(get_tmux_option "@mullvad_connected_fg_color")
connected_bg_color=$(get_tmux_option "@mullvad_connected_bg_color" "green")


print_mullvad_status_color() {
    status="$(mullvad_status| grep status | awk '{print $3}')"

    if [[ $status == "Blocked:" ]]; then
        color_statement "$blocked_fg_color" "$blocked_bg_color"
    elif [[ $status == "Disconnected" ]]; then
        color_statement "$disconnected_fg_color" "$disconnected_bg_color"
    elif [[ $status == "Connecting" ]]; then
        color_statement "$connecting_fg_color" "$connecting_bg_color"
    elif [[ $status == "Connected" ]]; then
        color_statement "$connected_fg_color" "$connected_bg_color"
    else
        echo "status_color: Unknown status [$status]"
    fi
}

print_mullvad_status_color
