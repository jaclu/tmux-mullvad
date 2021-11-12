#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

source "$CURRENT_DIR/helpers.sh"


print_mullvad_city() {
    if [ "$(is_connected)" = "1" ]; then
        mullvad status -l | grep Location | cut -d' ' -f2- | cut -d',' -f1
    fi
}

print_mullvad_city
