#!/usr/bin/env bash
#
#  Copyright (c) 2022: Jacob.Lundqvist@gmail.com
#  License: MIT
#
#  Part of https://github.com/jaclu/tmux-mullvad
#
#  Version: 2.0.0 2022-04-09
#
#  Prints what server is currently being used for vpn
#

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/utils.sh"


print_mullvad_server() {
    local server_prefix
    local server_suffix
    local server_ip
    local server

    [ "$(is_connected)" != "1" ] && return

    status="$(mullvad_status -l)"
    server_prefix=$(get_tmux_option "@mullvad_server_prefix")
    server_suffix=$(get_tmux_option "@mullvad_server_suffix")
    server="$(echo "$status" | grep Relay | awk '{ print $2 }')"
    [ -z "$server" ] && server="*ServerNameUnknown*"
    msg="$(color_wrap "${server_prefix}$server${server_suffix}")"
    # log_it "Server before non blank spaces:[$msg]"
    if [ -n "$msg" ]; then
        if bool_param "$(get_tmux_option "@mullvad_server_no_color_prefix" 0)"; then
           msg=" $msg"
        fi
        if bool_param "$(get_tmux_option "@mullvad_server_no_color_suffix" 0)"; then
            msg="$msg "
        fi
        # log_it "Server after  non blank spaces:[$msg]"
    fi
    # log_it "Server [$msg]"
    echo "$msg"
}

print_mullvad_server
