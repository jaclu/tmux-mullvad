# Tmux-mullvad

## Purpose

Monitoring Mullvad VPN status

## Screenshots

All status icons, labels, spacing around them and colors can be altered in your config, these are just defaults, and some samples of my preferred style

Display|Description
-|-
![disconnected_default](/assets/disconnected_default.png) | Disconnected status has it's color, if you would prefer to have a strong indicator that VPN is not active.
![disconnected_no_bg](/assets/disconnected_no_bg.png) | When I can't use VPN, like sometimes with Primevideo, it's enough for me to see the open padlock.<br> I find a bg color to be overly distracting.
![connecting](/assets/connecting.png) | Connecting ...
![blocked](/assets/blocked.png) | VPN Blocked. Most likely my connection is down, could also be that the VPN destination has issues, why not try another city?
![connected](/assets/connected.png) | Connected has it's color, same as with disconnected, some might prefer to change or disable the bg color.
![connected_silent](/assets/connected_silent.png) | Being connected in my home country is the default, so then I don't need any notification.
![connected_country](/assets/connected_country.png) | When connected in another country, it makes sense to see where the VPN is routed.
![connected_city](/assets/connected_city.png) | If you want more specifics, then add city.

#### Dependencies

`tmux 2.2` or higher, `mullvad` Should be installed along with the native Mullvad application.

Mullvad homepage: https://mullvad.net/

## Installation

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'jaclu/tmux-mullvad'

Hit `prefix + I` to fetch the plugin and source it. That's it!

### Manual Installation

Clone the repository:

    $ git clone https://github.com/jaclu/tmux-mullvad ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/mullvad.tmux

Reload TMUX environment with `$ tmux source-file ~/.tmux.conf`, and that's it.

## Usage

Add any of the supported format strings to `status-left` or `status-right`.

```
set -g status-left "[#{session_name}]#{mullvad_country}#{mullvad_status}"
```

## Supported Format Strings

Code|Action
-|-
#{mullvad_status}         | Displays connection status, defaults to a padlock icon
#{mullvad_country}       | Country used, only displayed when connected.
#{mullvad_city}           | City used, only displayed when connected.
#{mullvad_server}         | Server used
#{mullvad_ip}             | IP# used
#{mullvad_status_color}   | The fg,bg color pair matching the current status wrapped into a tmux status bar color directive. Usage example: `#{mullvad_status_color}Something#[default]`  the above mullvad format strings already comes wrapped in color directives, so this would only be meaningful if you want to display something else that should be colored in accordance with mullvad status.

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
@mullvad_status_suffix     | "" | Suffix for the status text.
@mullvad_country_prefix    | "" | Prefix for the country name.
@mullvad_country_suffix    | "" | Suffix for the country name.
@mullvad_city_prefix       | "" | Prefix for the city name.
@mullvad_city_suffix       | "" | Suffix for the city name.
@mullvad_server_prefix     | "" | Prefix for the server name.
@mullvad_server_suffix     | "" | Suffix for the server name.
@mullvad_excluded_country  | "" | If this is the connected country, do not display #{mullvad_country}  or #{mullvad_status} (when connected)
@mullvad_excluded_city     | "" | If this is the connected city, do not display #{mullvad_city} (when connected)

## Example config

```
set -g @plugin 'jaclu/tmux-mullvad'

# No colors wanted for disconnected status, just distracting.
set -g @mullvad_disconnected_bg_color ' '

#  I only want to see connection details, if connected to "somewhere else"
set -g @mullvad_excluded_country 'Netherlands' # don't display this country
set -g @mullvad_excluded_city    'Amsterdam'   # don't display this city

#
#  Making spacing sensible, based on my status bar config:
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

Status update won't be instant. The duration depends on the `status-interval` Tmux option. You can set it to a low number to make the refresh faster.

```
set -g status-interval 5
```

## Items to tweak

To make this more responsive, I cache the mullvad status for 5 seconds, even if you show updates less common this will still help, since there will be multiple status checks each time mullvad status is displayed. This can be found in scripts/helpers.sh

Item one to tweak is the cache timeout, at the top of the file max_cache_time is set

Item two to tweak would be to disable caching. Check the function mullvad_status() here you can choose to use caching or not.

## Contributing

Contributions are welcome, and they are greatly appreciated! Every little bit helps, and credit will always be given.

The best way to send feedback is to file an issue at https://github.com/jaclu/tmux-mullvad/issues

##### License

[MIT](LICENSE)
