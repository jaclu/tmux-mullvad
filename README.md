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
![blocked](/assets/blocked.png) | VPN Blocked. Most likely network is down, could also be the attempted VPN destination having issues.
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
#{mullvad_server}         | Server used, only displayed when connected.
#{mullvad_ip}             | Public IP# used, only displayed when connected.
#{mullvad_status_color}   | The fg,bg color pair matching the current status wrapped into a tmux status bar color directive. Usage example: `#{mullvad_status_color}Something#[default]`  the above mullvad format strings already comes wrapped in color directives, so this would only be meaningful if you want to display something else that should be colored in accordance with mullvad status.

## Variables that can be set

To disable a setting, set it to " ", spaces will be trimmed and thus nothing will end up being printed, if you set it to "" it will be ignored and the default value will be used.

Variable|Default|Purpose
-|-|-
@mullvad_cache_time              | 5  | Since multiple calls to mullvad status are made for each update of the display, cashing this will greatly improve response times. You can disable all caching by setting this to 0.
@mullvad_disconnected_text       | open padlock icon   | Status
@mullvad_disconnected_fg_color   | |
@mullvad_disconnected_bg_color   | red |
@mullvad_blocked_text            | open padlock icon   | Status
@mullvad_blocked_fg_color        |        |
@mullvad_blocked_bg_color        | purple |
@mullvad_connecting_text         | closed padlock icon | Status
@mullvad_connecting_fg_color     ||
@mullvad_connecting_bg_color     |yellow|
@mullvad_connected_text          | closed padlock icon with key on the side | Status
@mullvad_connected_fg_color      ||
@mullvad_connected_bg_color      |green|
@mullvad_status_prefix           | "" | Prefix for the status text
@mullvad_status_suffix           | "" | Suffix for the status text
@mullvad_status_no_color_prefix  | 0  | Padding, see below
@mullvad_status_no_color_suffix  | 0  | Padding, see below
@mullvad_excluded_country        | "" | If this is the connected country, do not display #{mullvad_country}  or #{mullvad_status} (when connected)
@mullvad_country_prefix          | "" | Prefix for the country name, using color
@mullvad_country_suffix          | "" | Suffix for the country name, using color
@mullvad_country_no_color_prefix | 0  | Padding, see below
@mullvad_country_no_color_suffix | 0  | Padding, see below
@mullvad_excluded_city           | "" | If this is the connected city, do not display #{mullvad_city} (when connected)
@mullvad_city_prefix             | "" | Prefix for the city name
@mullvad_city_suffix             | "" | Suffix for the city name
@mullvad_city_no_color_prefix    | 0  | Padding, see below
@mullvad_city_no_color_suffix    | 0  | Padding, see below
@mullvad_server_prefix           | "" | Prefix for the server name
@mullvad_server_suffix           | "" | Suffix for the server name
@mullvad_server_no_color_prefix  | 0  | Padding, see below
@mullvad_server_no_color_suffix  | 0  | Padding, see below
@mullvad_ip_prefix               | "" | Prefix for the IP#
@mullvad_ip_suffix               | "" | Suffix for the IP#
@mullvad_ip_no_color_prefix      | 0  | Padding, see below
@mullvad_ip_no_color_suffix      | 0  | Padding, see below

## Padding the elements

Unlike the \_prefix and \_suffix variables, that uses the status color,
the \_no_color\_ variables controls if there should be a  space char before or after the corresponding item without any color setting. Only used if the item is not empty and thus displayed.
This helps keeping the Status Bar compact. Setting it to 1 will insert a space char.

You can see how I use it in the example config below.

## Example config

```
set -g @plugin 'jaclu/tmux-mullvad'

#
#  I only want to be notified about where the VPN is connected if not
#  connected to my normal location, typically when avoiding Geo blocks.
#  Since this will negatively impact bandwith and lag, its good to have a
#  visual reminder.
#
set -g @mullvad_excluded_country 'Netherlands' # dont display this country
set -g @mullvad_excluded_city    'Amsterdam'   # dont display this city

#  No colors wanted for disconnected status, just distracting.
set -g @mullvad_disconnected_bg_color ' '

#  Since nothing is printed when connected, we don't need to bother with the colors
set -g @mullvad_connected_text ' '

#  When city/country is printed, use comma as separator
set -g @mullvad_city_suffix ', '

#
#  Keep separation if items are displayed
#
set -g @mullvad_country_no_color_suffix 1
set -g @mullvad_status_no_color_suffix 1

#
#  What I use in status bar to display this status
#
#    #{mullvad_city}#{mullvad_country}#{mullvad_status}

```

## Status Update Interval

Status update won't be instant. The duration depends on the `status-interval` Tmux option. You can set it to a low number to make the refresh faster.

```
set -g status-interval 5
```

## Contributing

Contributions are welcome, and they are greatly appreciated! Every little bit helps, and credit will always be given.

The best way to send feedback is to file an issue at https://github.com/jaclu/tmux-mullvad/issues

##### License

[MIT](LICENSE)
