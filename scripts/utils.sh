#!/usr/bin/env bash
#
#  Copyright (c) 2022: Jacob.Lundqvist@gmail.com
#  License: MIT
#
#  Part of https://github.com/jaclu/tmux-mullvad
#
#  Version: 2.1.0 2022-06-09
#
#  Things used in multiple scripts
#

#
#  Shorthand, to avoid manually typing package name on multiple
#  locations, easily getting out of sync.
#
plugin_name="tmux-mullvad"

#
#  Summer 2022 - Mullvad has changed its status output in the beta
#
#  So depending on what version is running, status needs to be interpreted
#  quite differently.
#  When tmux is started/reloaded a check is made and if the old syntax
#  should be used this file is touched. If not it is removed.
#  This way during regular operations version does not need to be checked,
#  just the presence of this file.
#
old_synatx_indicator="/tmp/tmux-mullvad-old-syntax"


#
#  If log_file is empty or undefined, no logging will occur,
#  so comment it out for normal usage.
#
# log_file="/tmp/$plugin_name.log"


#
#  If $log_file is empty or undefined, no logging will occur.
#
log_it() {
    if [ -z "$log_file" ]; then
        return
    fi
    printf "[%s] %s\n" "$(date '+%H:%M:%S')" "$@" >> "$log_file"
}


#
#  Display $1 as an error message in log and as a tmux display-message
#  If no $2 or set to 0, process is not exited
#
error_msg() {
    local msg="ERROR: $1"
    local exit_code="${2:-0}"

    log_it "$msg"
    tmux display-message "$plugin_name $msg"
    [ "$exit_code" -ne 0 ] && exit "$exit_code"
}


get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value

    option_value="$(tmux show-option -gqv "$option")"

    if [[ -z "$option_value" ]]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}


#
#  Aargh in shell boolean true is 0, but to make the boolean parameters
#  more relatable for users 1 is yes and 0 is no, so we need to switch
#  them here in order for assignment to follow boolean logic in caller
#
bool_param() {
    case "$1" in

        "0") return 1 ;;

        "1") return 0 ;;

        "yes" | "Yes" | "YES" | "true" | "True" | "TRUE" )
            #  Be a nice guy and accept some common positives
            log_it "Converted incorrect positive [$1] to 1"
            return 0
            ;;

        "no" | "No" | "NO" | "false" | "False" | "FALSE" )
            #  Be a nice guy and accept some common negatives
            log_it "Converted incorrect negative [$1] to 0"
            return 1
            ;;

        *)
            log_it "Invalid parameter bool_param($1)"
            error_msg "bool_param($1) - should be 0 or 1"
            ;;

    esac
    return 1 # default to false
}


#
#  Even if you only update status bar every max_cache_time or more seldom,
#  having a cache during a given update lowers CPU waste, since mullvad
#  typically needs to be called multiple times for each update.
#
#  If you do not want to use caching, set max_cache_time=0
#
max_cache_time="$(get_tmux_option "@mullvad_cache_time" 5)"


mullvad_status_cache_age() {
    local status_file="$1"
    local age

    if [ -z "$status_file" ]; then
        error_msg "Call to mullvad_status_cache_age() with no file name!" 1
    fi
    # log_it "caching_mullvad_status() max_cache_time[$max_cache_time]"
    if [ -f "$status_file" ]; then
        age="$(( $(date +%s) - $(date -r "$status_file" +%s) ))"
    else
        age=9999
    fi

    echo "$age"
}


#
#  Caching of status for max_cache_time seconds
#
caching_mullvad_status() {
    local long="$1"
    local status_file="/tmp/mullvad-status"
    local status_file_lock="${status_file}.lock"
    local status

    if [ "$(mullvad_status_cache_age "$status_file")" -gt "$max_cache_time" ]; then
        #
        #  Try to prevent multiple calls to mullvad each time
        #  cache file is too old, since typically there comes several calls
        #  more or less at the same time. Each instance waits a fraction of
        #  a second.
        #  so hopefully only one will do the update.
        #  If multiple updates happens at the same time it's not the end
        #  of the world, just wasting resources.
        #
        #  The builtin Bash RANDOM seems flawed in parallel processing.
        #  If multiple processes uses it at almost exactly the same time,
        #  something like a third of the times in this usage,
        #  they will get the same number.
        #  This forces multiple updates to happen. by using urandom this
        #  is avoided.
        #
        # random_wait="${RANDOM:0:4}"
        random_wait="$(od -A n -t d -N 1 /dev/urandom |tr -d ' ')"
        # log_it "($$) will wait 0.$random_wait"
        sleep 0.$random_wait

        if [ "$(mullvad_status_cache_age "$status_file")" -lt "$max_cache_time" ]; then
            # another process has just updated the cache
            log_it "($$) cache updated during wait"
            caching_mullvad_status "$long"
            return
        fi

        if [ -f "$status_file_lock" ]; then
            random_wait="$(( RANDOM % 20 ))"
            # log_it "($$) update in progress, give it a moment"
            sleep 0.05
            caching_mullvad_status  "$long"
            return
        fi
        touch "$status_file_lock" # prevent multiple processes to update cache

        log_it "($$) Updating status cache"
        status="$(mullvad status -l)"
        echo "$status" > $status_file
        rm "$status_file_lock"
    fi

    case "$long" in

        "l" | "-l")
            cat "$status_file"
            ;;

        "")
            head -n 1 < "$status_file"
            ;;

        *)
            error_msg "caching_mullvad_status($long) - bad param!" 1
    esac
}


#
#  If you do not want caching, use this
#
no_caching_mullvad_status() {
    local long="$1"

    case "$long" in

        "l" | "-l")
            mullvad status -l
            ;;
        "")
            mullvad status
            ;;

        *)
            error_msg "no_caching_mullvad_status($long) - bad param!" 1
    esac
}


#
#  Optional param is -l, will display extended status
#
mullvad_status() {
    if [ "$max_cache_time" -gt 0 ]; then
        caching_mullvad_status "$1"
    else
        no_caching_mullvad_status "$1"
    fi
}


is_connected() {
    if mullvad_status | grep -q Connected; then
        echo "1"
    else
        echo "0"
    fi
}


trim() {
    local var="$*"

    # remove leading white space characters
    var="${var#"${var%%[![:space:]]*}"}"

    # remove trailing white space characters
    var="${var%"${var##*[![:space:]]}"}"

    echo "$var"
}


color_statement() {
    local fg
    local bg

    fg="$(trim "$1")"
    bg="$(trim "$2")"

    if [ -z "$fg" ] && [ -z "$bg" ]; then
        return
    elif [ -n "$fg" ] && [ -n "$bg" ]; then
        echo "#[fg=$fg,bg=$bg]"
    elif [ -n "$fg" ] && [ -z "$bg" ]; then
        echo "#[fg=$fg]"
    elif [ -z "$fg" ] && [ -n "$bg" ]; then
        echo "#[bg=$bg]"
    fi
}


mullvad_status_colors() {
    local status
    local fg_color
    local bg_color

    status="$(mullvad_status| grep status | awk '{print $3}')"
    #
    #  To reduce overhead, only those colors actually needed are read from tmux
    #
    if [[ $status == "Disconnected" ]]; then
        fg_color=$(get_tmux_option "@mullvad_disconnected_fg_color")
        bg_color=$(get_tmux_option "@mullvad_disconnected_bg_color" "red")
    elif [[ $status == "Connecting" ]]; then
        fg_color=$(get_tmux_option "@mullvad_connecting_fg_color")
        bg_color=$(get_tmux_option "@mullvad_connecting_bg_color" "yellow")
    elif [[ $status == "Connected" ]]; then
        fg_color=$(get_tmux_option "@mullvad_connected_fg_color")
        bg_color=$(get_tmux_option "@mullvad_connected_bg_color" "green")
    else #  Default to Blocked color, to show something is off
        fg_color=$(get_tmux_option "@mullvad_blocked_fg_color")
        bg_color=$(get_tmux_option "@mullvad_blocked_bg_color" "purple")
    fi
    color_statement "$fg_color" "$bg_color"
}


#
#  If color is defined for current status, wrap text in a color statement
#
color_wrap() {
    local txt="$1"
    local status_color

    [ -z "$txt" ] && return

    status_color="$(mullvad_status_colors)"
    if [ -n "$status_color" ]; then
        echo "$status_color$txt#[default]"
    else
        echo "$txt"
    fi
}


is_excluded_country() {
    local excluded_country
    # $country is shared with caller

    excluded_country=$(get_tmux_option "@mullvad_excluded_country")

    # not local, can be used by caller
    if [ -f "$old_synatx_indicator" ]; then
        country="$(trim "$(mullvad_status -l | grep Location | cut -d',' -f2-)")"
    else
        country="$(trim "$(mullvad_status -l | grep "Connected to" | cut -d',' -f2-)")"
    fi
    case "$country" in

        *"navailable"*)
            #
            # Fake excluded, to avoid the Location unavailable Prompt that
            # sometimes come up during connection.
            #
            return 0
            ;;

        "$excluded_country")
            return 0
            ;;

        *)
            return 1
            ;;
    esac
}
