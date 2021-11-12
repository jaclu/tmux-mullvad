#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

source "$CURRENT_DIR/helpers.sh"


disconnected_text=$(get_tmux_option "@mullvad_disconnected_text" "🔓")
blocked_text=$(get_tmux_option "@mullvad_blocked_text" "🔓")
connecting_text=$(get_tmux_option "@mullvad_connecting_text" "🔒")
connected_text=$(get_tmux_option "@mullvad_connected_text" "🔐")


#
#  #{?mullvad_connected_flag,
#      #{mullvad_country}
#      ,
#      #{mullvad_status_color}#{mullvad_status}#[default]
#  }

#{mullvad_country},
#
#

#
#  TODO:  use #{?} to only show country when connected
#         alternative aproach dont show city & country when not connected

print_mullvad_status() {
    local status=$(mullvad status | awk '{print $3}')

    mullvad_connected_flag=0

    if [[ $status == "Disconnected" ]]; then
        trim "$disconnected_text"
    elif [[ $status == "Blocked:" ]]; then
        trim "$blocked_text"
    elif [[ $status == "Connecting" ]]; then
        trim "$connecting_text"
    elif [[ $status == "Connected" ]]; then
        mullvad_connected_flag=1
        country="$($CURRENT_DIR/country.sh)"
        if [ -n "$country" ]; then
            echo "🔐 $country"
        else
            trim "$connected_text"
        fi
    fi
}

print_mullvad_status
