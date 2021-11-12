#!/usr/bin/env bash

print_mullvad_country() {
    # needs fix to handle locations like New York, NY, USA
    mullvad status -l | grep Location | awk '{print $3}'
}

print_mullvad_country
