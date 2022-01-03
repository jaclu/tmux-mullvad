## Purpose

To display mullvad VPN status


## Requirements

The plugin expects the mullvad native application to be installed and running.

Mullvad homepage: https://mullvad.net/


## Installation

### Using [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

1. Add plugin to the list of TPM plugins in `.tmux.conf`:

    ```
    set -g @plugin 'jaclu/tmux-mullvad'
    ```

2. Hit `prefix + I` to fetch the plugin and source it. You should now be able to use the plugin.

Add plugin to the list of TPM plugins in `.tmux.conf`:

```tmux
set -g @plugin 'jaclu/tmux-mullvad'
```

Hit `<prefix> + I` to fetch the plugin and source it.

### Manual Installation

1. Clone this repo:

    ```console
    $ git clone https://github.com/jaclu/tmux-mullvad ~/some/path
    ```

2. Source the plugin in your `.tmux.conf` by adding the following to the bottom of the file:

    ```
    run-shell ~/some/path/mullvad.tmux
    ```

3. Reload the environment by running:

    ```console
    $ tmux source-file ~/.tmux.conf
    ```




## Usage

Add any of the supported format strings to `status-left` or `status-right`.

```tmux
set -g status-left "[#{session_name}]#{mullvad_city}#{mullvad_country}#{mullvad_status} "
```



## Supported Format Strings

Code|Action
-|-
#{mullvad_status}         | Displays connection status, defaults to a padlock icon
#{mullvad_country}       | Country used, only displayed when connected.
#{mullvad_city}           | City used, only displayed when connected.
#{mullvad_server}         | Server used
#{mullvad_ip}             | IP# used
#{mullvad_status_color}   | The fg,bg color pair matching the current status wrapped into a tmux status bar color directive. Usage example: ``` #{mullvad_status_color}Something#[default] ```  the above mullvad format strings already comes wrapped in color directives, so this would only be meaningful if you want to display something else that should be colored in accordance with mullvad status.

## Variables that can be set

To disable a setting, set it to " ", spaces will be trimmed and thus nothing will end up being printed, if you set it to "" it will be ignored and the default value will be used.

Variable|Default|Purpose
-|-|-
@mullvad_disconnected_text | open padlock icon   | Status
@mullvad_disconnected_fg_color| |
@mullvad_disconnected_bg_color| red |
@mullvad_blocked_text      | open padlock icon   | Status
@mullvad_blocked_fg_color  |        |
@mullvad_blocked_bg_color  | purple |
@mullvad_connecting_text   | closed padlock icon | Status
@mullvad_connecting_fg_color||
@mullvad_connecting_bg_color|yellow|
@mullvad_connected_text    | closed padlock icon with key on the side | Status - I typically set this to ' ', since the default is to be connected, I only want to be reminded if not connected. If set to a space, this text will not be displayed.
@mullvad_connected_fg_color||
@mullvad_connected_bg_color|green|
@mullvad_status_prefix     | "" | Prefix for the status text.
@mullvad_status_suffix     | "" | Prefix for the status text.
@mullvad_country_prefix    | "" | Prefix for the country name.
@mullvad_country_suffix    | "" | Suffix for the country name.
@mullvad_city_prefix       | "" | Prefix for the city name.
@mullvad_city_suffix       | "" | Suffix for the city name.
@mullvad_server_prefix     | "" | Prefix for the server name.
@mullvad_server_suffix     | "" | Suffix for the server name.
@mullvad_excluded_country  | "" | If this is the connected country, do not display #{mullvad_country}  or #{mullvad_status} (when connected)
@mullvad_excluded_city     | "" | If this is the connected city, do not display #{mullvad_city}


## Example config

```tmux

set -g @plugin 'jaclu/tmux-mullvad'

# No colors wanted for disconnected status, just distracting.
set -g @mullvad_disconnected_bg_color ' '

# no icon displayed if connected, I just want to know when I am not connected!
set -g @mullvad_connected_text ' '

#  I only want to see connection details, if connected to "somewhere else"
set -g @mullvad_excluded_country 'Netherlands' # dont display this country
set -g @mullvad_excluded_city    'Amsterdam'   # dont display this city

#
#  Make spacing sensible, based on my status bar config:
#     #{mullvad_city}#{mullvad_country}#{mullvad_status}
#  This way I get nice separation when items are displayed, 
#  and no extra spaces when nothing is displayed.
#  I wish more plugins would include prefix/suffix to make
#  things look nice!
#
set -g @mullvad_city_prefix ' '
set -g @mullvad_city_suffix ', '
set -g @mullvad_country_suffix ' '
set -g @mullvad_status_suffix ' '

```




## Status Update Interval

Status update won't be instant. The duration depends on the `status-interval` Tmux option. You can set `status-interval` to a low number to make the refresh faster.

```sh
set -g status-interval 5
```

## Contributing

Contributions are welcome, and they are greatly appreciated! Every little bit helps, and credit will always be given.

The best way to send feedback is to file an issue at https://github.com/jaclu/tmux-mullvad/issues
