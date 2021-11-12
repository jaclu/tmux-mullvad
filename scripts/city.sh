#!/usr/bin/env bash

print_mullvad_city() {
    # needs fix to handle locations like New York, NY, USA
    mullvad status -l | grep Location | awk '{print $2}' | cut -d, -f1
}

print_mullvad_city
