#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

blocked_fg_color=$(get_tmux_option "@mullvad_blocked_fg_color")
blocked_bg_color=$(get_tmux_option "@mullvad_blocked_bg_color" "orange")

disconnected_fg_color=$(get_tmux_option "@mullvad_disconnected_fg_color")
disconnected_bg_color=$(get_tmux_option "@mullvad_disconnected_bg_color" "red")

disconnecting_fg_color=$(get_tmux_option "@mullvad_disconnecting_fg_color")
disconnecting_bg_color=$(get_tmux_option "@mullvad_disconnecting_bg_color" "purple")

connecting_fg_color=$(get_tmux_option "@mullvad_connecting_fg_color")
connecting_bg_color=$(get_tmux_option "@mullvad_connecting_bg_color" "yellow")

connected_fg_color=$(get_tmux_option "@mullvad_connected_fg_color")
connected_bg_color=$(get_tmux_option "@mullvad_connected_bg_color" "green")



print_mullvad_status_color() {
    status=$(mullvad status | awk '{print $3}')

    if [[ $status == "Blocked:" ]]; then
	color_statement "$blocked_fg_color" "$blocked_bg_color"
    elif [[ $status == "Disconnected" ]]; then
	color_statement "$disconnected_fg_color" "$disconnected_bg_color"
    elif [[ $status == "Disconnecting..." ]]; then
	color_statement "dis$connecting_fg_color" "$disconnecting_bg_color"
    elif [[ $status == "Connecting" ]]; then
	color_statement "$connecting_fg_color" "$connecting_bg_color"
    elif [[ $status == "Connected" ]]; then
	color_statement "$connected_fg_color" "$connected_bg_color"
    else
	echo "status_color: Unknown status [$status]"
	echo "$(date) status: [$status]" >> /Users/jaclu/tmp/cron/mullvad_unknown_status
    fi
}

print_mullvad_status_color
