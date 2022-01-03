### Options

To "disable" a setting, set it to " ", spaces will be trimmed and thus nothing will end up being printed, if you set it to "" it will be ignored and the default value will be used

Variable|Meaning
-|-
@mullvad_disconnected_text | Status - Defaults to an open padlock icon.
@mullvad_blocked_text      | Status - Defaults to an open padlock icon.
@mullvad_connecting_text   | Status - Defaults to an closed padlock icon.
@mullvad_connected_text    | Status - Defaults to a closed padlock icon with key on the side. I typically set this to ' ', since the default is to be connected, I only want to be reminded if not connected. If set to a space, this text will not be displayed.
@mullvad_status_prefix     | Prefix for the status text
@mullvad_status_suffix     | Prefix for the status text


Here are all available options with their default values.

Code|Action
-|-
#{mullvad_status}         | Displays an icon for connected, disconnected, connecting, blocked<br> If connected displays country connected to, unless country is listed in @mullvad_excluded_country
#{mullvad_country}        | Country used
#{mullvad_server}         | Server used
#{mullvad_city}           | City used
#{mullvad_ip}             | IP# used
#{mullvad_status_color}

```sh




<p align="center">
    <a href="https://github.com/maxrodrigo/tmux-nordvpn">
        <img src="assets/mullvad-32x32.png" alt="tmux-mullvad logo" width="32">
    </a>
    <h3 align="center">Mullvad Tmux Plugin</h3>
    <p align="center">
        Monitor <a href="https://mullvad.net/">Mullvad</a> connection status from Tmux.
    </p>
</p>

## Table of Contents

* [Demo](#demo)
* [Getting Started](#getting-started)
    * [Installation](#installation)
    * [Requirements](#requirements)
* [Usage](#usage)
    * [Supported Format Strings](#supported-format-strings)
    * [Options](#options)
    * [Examples](#examples)
* [Status Update Interval](#status-update-interval)
* [Contributing](#contributing)

## Demo

![tmux-nordvpn demo](assets/demo.svg)

## Getting Started

### Installation

#### Tmux Plugin Manager (recommended)

Add plugin to the list of [TPM](https://github.com/tmux-plugins/tpm) plugins in `.tmux.conf`:

```sh
set -g @plugin 'jaclu/tmux-mullvad'
```

Hit `prefix + I` to fetch the plugin and source it.

If format strings are added to `status-right`, they should now be visible.

#### Manual Installation

Clone the repository:

```sh
git clone https://github.com/jaclu/tmux-mullvad ~/.tmux/tmux-mullvad
```

Add this line to the bottom of `.tmux.conf`:

```txt
run-shell ~/.tmux/tmux-mullvad/mullvad.tmux
```

Reload Tmux environment:

```sh
tmux source-file ~/.tmux.conf
```

If format strings are added to `status-right`, they should now be visible.

### Requirements

The plugin relays on the mullvad native application to be installed and running.

Mullvad homepage: https://mullvad.net/

## Usage

Add any of the [supported format strings](#supported-format-strings) to `status-right` or `status-left`.

```sh
set -g status-right 'NordVPN: #{nordvpn_status_color}#{nordvpn_status} (#{nordvpn_country})'
```

### Supported Format Strings

- `#{nordvpn_status}` - connection status.
- `#{nordvpn_server}` - current server.
- `#{nordvpn_country}` - current connection country.
- `#{nordvpn_city}` - current connection city.
- `#{nordvpn_ip}` - current connection IP address.
- `#{nordvpn_status_color}` - change foreground and background color based on the VPN status.

@nordvpn_exclude_server_domain true # remove "nordvpn.com" from the server name.

@nordvpn_connected_text "Connected" # text to display when connected
@nordvpn_connecting_text "Connecting" # text to display when connecting
@nordvpn_disconnected_text "Disconnected" # text to display when disconnected

@nordvpn_connected_fg_color "green" # foreground color when connected.
@nordvpn_connecting_fg_color "yellow" # foreground color when connecting.
@nordvpn_disconnected_fg_color "red" # foreground color when disconnected.

@nordvpn_connected_bg_color "" # background color when connected.
@nordvpn_connecting_bg_color "" # background color when connecting.
@nordvpn_disconnected_bg_color "" # background color when disconnected.
```

### Examples

```sh
# .tmux.conf
set -g @nordvpn_connected_text "c"
set -g @nordvpn_connecting_text "…"
set -g @nordvpn_disconnected_text "d"

set -g status-left "#[fg=blue]vpn: #{nordvpn_status_color}#{nordvpn_status} #[fg=cyan]#{nordvpn_server}"
```

```sh
# .tmux.conf
set -g @nordvpn_connected_text "Connected to"
set -g @nordvpn_connecting_text "Connecting to"

set -g status-left "NordVPN #{nordvpn_status_color}#{nordvpn_status} #{nordvpn_city}, #{nordvpn_country} [#{nordvpn_ip}]"
```

## Status Update Interval

Status update won't be instant. The duration depends on the `status-interval` Tmux option. You can set `status-interval` to a low number to make the refresh faster.

```sh
set -g status-interval 5
```

## Contributing

Contributions are welcome, and they are greatly appreciated! Every little bit helps, and credit will always be given.

The best way to send feedback is to file an issue at https://github.com/maxrodrigo/tmux-nordvpn/issues
