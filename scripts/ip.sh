#!/usr/bin/env bash
#
#  Copyright (c) 2022: Jacob.Lundqvist@gmail.com
#  License: MIT
#
#  Part of https://github.com/jaclu/tmux-mullvad
#
#  Version: 2.0.0 2022-04-09
#
#  Prints public IP#
#

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/utils.sh"


print_mullvad_ip() {
    local msg

    [ "$(is_connected)" != "1" ] && return

    msg="$(mullvad_status -l | grep IPv4 | cut -d' ' -f2)"

    log_it "IP# before non blank spaces:[$msg]"
    if [ -n "$msg" ]; then
        if bool_param "$(get_tmux_option "@mullvad_ip_no_color_prefix" 0)"; then
           msg=" $msg"
        fi
        if bool_param "$(get_tmux_option "@mullvad_ip_no_color_suffix" 0)"; then
            msg="$msg "
        fi
        log_it "IP# after  non blank spaces:[$msg]"
    fi
    log_it "IP# [$msg]"
    echo "$msg"
}

print_mullvad_ip
