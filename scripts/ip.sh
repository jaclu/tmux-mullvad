#!/usr/bin/env bash

print_mullvad_ip() {
    mullvad status -l | grep IPv4 | cut -d' ' -f2
}

print_mullvad_ip
