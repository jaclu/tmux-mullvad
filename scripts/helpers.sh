

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value="$(tmux show-option -gqv "$option")"

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



trim() {
    local var="$*"

    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"

    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   

    echo "$var"
}

color_statement() {
    local fg="$(trim "$1")"
    local bg="$(trim "$2")"
    
    if [ -n "$fg" ] && [ -n "$bg" ]; then
	echo "#[fg=$fg,bg=$bg]"
    elif [ -n "$fg" ] && [ -z "$bg" ]; then
	echo "#[fg=$fg]"
    elif [ -z "$fg" ] && [ -n "$bg" ]; then
	echo "#[bg=$bg]"
    fi    
}
