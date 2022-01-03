#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/helpers.sh"


server_prefix=$(get_tmux_option "@mullvad_server_prefix")
server_suffix=$(get_tmux_option "@mullvad_server_suffix")


print_mullvad_server() {
    [ "$(is_connected)" != "1" ] && return

    server_ip="$(caching_mullvad_status | grep "Connected to" | awk '{ print $6}' | cut -d':' -f1 )"
    server="$(mullvad relay list | grep "$server_ip" | awk '{print $1}')"

    color_wrap "${server_prefix}$server${server_suffix}"
}

print_mullvad_server
