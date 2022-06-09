#!/usr/bin/env bash
#
#  Copyright (c) 2022: Jacob.Lundqvist@gmail.com
#  License: MIT
#
#  Part of https://github.com/jaclu/tmux-mullvad
#
#  Version: 2.2.0 2022-06-09
#
#  Prints what city the VPN server is located in
#

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/utils.sh"


is_excluded_city() {
    local excluded_city

    excluded_city=$(get_tmux_option "@mullvad_excluded_city")

    # not local, can be used by caller
    if [ -f "$old_synatx_indicator" ]; then
        city="$(mullvad_status -l | grep Location | cut -d' ' -f2- | cut -d',' -f1)"
    else
        city="$(mullvad_status -l | grep 'Connected to' | awk '{ print $5}' | cut -d',' -f1)"
    fi
    case "$city" in

        *"navailable"*)
            #
            # Fake excluded, to avoid the Location unavailable Prompt that
            # sometimes come up during connection.
            #
            return 0
            ;;

        "$excluded_city")
            return 0
            ;;

        *)
            return 1
            ;;
    esac
}


print_mullvad_city() {
    local city_prefix
    local city_suffix
    local city  # defined in is_excluded_city()
    local msg

    [ "$(is_connected)" != "1" ] && return

    if ! is_excluded_city; then
        city_prefix=$(get_tmux_option "@mullvad_city_prefix")
        city_suffix=$(get_tmux_option "@mullvad_city_suffix")
        msg="$(color_wrap "${city_prefix}$city${city_suffix}")"
        # log_it "City before non blank spaces:[$msg]"
        if [ -n "$msg" ]; then
            if bool_param "$(get_tmux_option "@mullvad_city_no_color_prefix" 0)"; then
               msg=" $msg"
            fi
            if bool_param "$(get_tmux_option "@mullvad_city_no_color_suffix" 0)"; then
                msg="$msg "
            fi
            # log_it "City after  non blank spaces:[$msg]"
        fi
        # log_it "City [$msg]"
        echo "$msg"
    fi
}

print_mullvad_city
