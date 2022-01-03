#!/usr/bin/env bash

max_cache_time=5


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


set_tmux_option() {
    local option=$1
    local value=$2

    tmux set-option -gq "$option" "$value"
}


caching_mullvad_status() {
    status_file="/tmp/mullvad-status"
    status_file_lock="${status_file}.lock"

    if [ -f "$status_file" ]; then
        age="$(( $(date +%s) - $(date -r "$status_file" +%s) ))"
    else
        age=9999
    fi


    if [ "$age" -ge "$max_cache_time" ]; then
        #
        #  Try to prevent multiple calls to mullvad
        #  each time cache file is too old, since typically there comes
        #  several calls more or less at the same time.
        #  Not perfect, but seems to work most of the time, so at least
        #  thid reduces the amount of redundant calls.
        #
        if [ -f "$status_file_lock" ]; then
            sleep 1
            # recurse to get current staus, then abort
            caching_mullvad_status
            return
        fi
        touch "$status_file_lock"
        status="$(mullvad status -l)"
        echo "$status" > $status_file
        rm "$status_file_lock"
    else
        status="$(cat "$status_file")"
    fi
    echo "$status"
}



is_connected() {
    if [ "$(caching_mullvad_status | grep status | awk '{print $3}')" = "Connected" ]; then
        echo "1"
    else
        echo "0"
    fi
}


trim() {
    local var="$*"

    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"

    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"

    echo "$var"
}


color_statement() {
    local fg
    local bg

    fg="$(trim "$1")"
    bg="$(trim "$2")"

    if [ -n "$fg" ] && [ -n "$bg" ]; then
        echo "#[fg=$fg,bg=$bg]"
    elif [ -n "$fg" ] && [ -z "$bg" ]; then
        echo "#[fg=$fg]"
    elif [ -z "$fg" ] && [ -n "$bg" ]; then
        echo "#[bg=$bg]"
    fi    
}


is_excluded_country() {
    local excluded_country
    excluded_country=$(get_tmux_option "@mullvad_excluded_country")

    # not local, can be used by caller
    country="$(trim "$(caching_mullvad_status | grep Location | cut -d',' -f2-)")"
    case "$country" in
        
        "$excluded_country")
            return 0
            ;;

        *)
            return 1
            ;;
    esac
}


is_excluded_city() {
    local excluded_city

    excluded_city=$(get_tmux_option "@mullvad_excluded_city")

    # not local, can be used by caller
    city="$(caching_mullvad_status | grep Location | cut -d' ' -f2- | cut -d',' -f1)"

    case "$city" in
        
        "$excluded_city")
            return 0
            ;;

        *)
            return 1
            ;;
    esac
}


#
#  If color is defined for current status, wrap text in a color statement
#
color_wrap() {
    local txt="$1"
    local status_color

    [ -z "$txt" ] && return
    
    status_color="$("$CURRENT_DIR/status_color.sh")"
    if [ -n "$status_color" ]; then
        echo "$status_color$txt#[default]"
    else
        echo "$txt"
    fi
}
