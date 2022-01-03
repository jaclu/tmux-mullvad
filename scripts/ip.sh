#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/helpers.sh"


print_mullvad_ip() {
    mullvad_status | grep IPv4 | cut -d' ' -f2
}

print_mullvad_ip
