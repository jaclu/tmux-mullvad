# Tmux-mullvad

#### Recent changes

- The latest beta has changed output for `mullvad status`. On startup, output is checked and if the old notation is used, a file under /tmp is touched, so that version checks are not needed for each action. If file is present, use old notation, if absent use new.<br> This means that if you change to or from the beta when tmux is running, you need to source the config for the plugin to become aware of the changed status notation.

## Purpose

Monitoring Mullvad VPN status

## Screenshots

All status icons, labels, spacing around them and colors can be altered in your config, these are just defaults, and some samples of my preferred style


Display|Description
-|-
![disconnected_default](https://user-images.githubusercontent.com/5046648/163687522-2c98d82d-3fdf-4f0c-98c7-ca16527838e7.png) | Disconnected status has it's color, if you would prefer to have a strong indicator that VPN is not active.
![disconnected_no_bg](https://user-images.githubusercontent.com/5046648/163687537-182b6ad2-3a80-4996-b04c-469818762fc7.png) | When I can't use VPN, like sometimes with Primevideo, it's enough for me to see the open padlock.<br> I find a bg color to be overly distracting.
![connecting](https://user-images.githubusercontent.com/5046648/163687559-c830a39b-d768-4f3e-b116-300d802b00e5.png) | Connecting ...
![blocked](https://user-images.githubusercontent.com/5046648/163687576-dae64eab-5c29-49d7-a4e5-ea074995a77e.png) | VPN Blocked. Most likely your device is not connected to the internet. Could also be the attempted VPN destination having issues.
![connected](https://user-images.githubusercontent.com/5046648/163687581-1a60a1fd-1879-4ff6-b769-d3c8c69948ed.png) | Connected has it's color, same as with disconnected, some might prefer to change or disable the bg color.
![connected_silent](https://user-images.githubusercontent.com/5046648/163687580-f3a84044-4a7e-4a4d-9915-aec15503149c.png) | Being connected in my home country is the default, so then I don't need any notification.
![connected_country](https://user-images.githubusercontent.com/5046648/163687579-77a1b902-df8d-46fe-9ed2-d6ad992ad2ec.png) | When connected in another country, it makes sense to see where the VPN is routed.
![connected_city](https://user-images.githubusercontent.com/5046648/163687577-b61d88a9-3bcd-43a4-bc61-bf39d2a76a8a.png) | If you want more specifics, then add city.

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

### Supported Format Strings

Code|Action
-|-
#{mullvad_status}         | Displays connection status, defaults to a padlock icon
#{mullvad_country}       | Country used, only displayed when connected.
#{mullvad_city}           | City used, only displayed when connected.
#{mullvad_server}         | Server used, only displayed when connected.
#{mullvad_ip}             | Public IP# used, only displayed when connected.
#{mullvad_status_color}   | The fg,bg color pair matching the current status wrapped into a tmux status bar color directive. Usage example: `#{mullvad_status_color}Something#[default]`  the above mullvad format strings already comes wrapped in color directives, so this would only be meaningful if you want to display something else that should be colored in accordance with mullvad status.

### Variables that can be set

To disable a setting, set it to " ", spaces will be trimmed and thus nothing will end up being printed, if you set it to "" it will be ignored and the default value will be used.

Variable|Default|Purpose
-|-|-
@mullvad_cache_time              | 5  | Since typically multiple checks of mullvad status are made for each update of the display, cashing this will greatly improve response times. You can disable all caching by setting this to 0.<br> Even if this matches your status interval, this will still make the check much faster, since only one actual status check is done.
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

### Padding the elements

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
#  What I use in status bar to display this status.
#  Since no_color padding is used if something is displayed, there is no need
#  to waste space in the status bar for separation that will just end up being
#  a double space when nothing is displayed.
#
#    other stuff before#{mullvad_city}#{mullvad_country}#{mullvad_status}other stuff after...

```

## Status Update Interval

Status update won't be instant. The lag depends on the `status-interval` Tmux option. You can set it to a low number to make the refresh faster.

```
set -g status-interval 5
```

## Contributing

Contributions are welcome, and they are greatly appreciated! Every little bit helps, and credit will always be given.

The best way to send feedback is to file an issue at https://github.com/jaclu/tmux-mullvad/issues

##### License

[MIT](LICENSE)
