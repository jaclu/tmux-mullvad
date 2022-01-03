#!/usr/bin/env bash

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


is_connected() {
    if [ "$(mullvad status | awk '{print $3}')" = "Connected" ]; then
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
    country="$(trim "$(mullvad status -l | grep Location | cut -d',' -f2-)")"

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
    city="$(mullvad status -l | grep Location | cut -d' ' -f2- | cut -d',' -f1)"

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
