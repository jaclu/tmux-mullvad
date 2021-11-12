#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"
source "$CURRENT_DIR/helpers.sh"

exclude_server_domain=$(get_tmux_option "@mullvad_exclude_server_domain" true)




print_mullvad_server() {

    [ "$(is_connected)" != "1" ] && return

    server_ip="$(mullvad status -l | grep "Connected to" | awk '{ print $6}' | cut -d':' -f1 )"
    server="$(mullvad relay list | grep $server_ip | awk '{print $1}')"
    if $exclude_server_domain; then
        echo $server
    else
        echo ${server}/mullvad.net
    fi
}

print_mullvad_server
