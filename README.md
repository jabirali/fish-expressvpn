# Fish ExpressVPN

Fish plugin for controlling [ExpressVPN][1] via [`fzf`][2]. This is really just
a simple wrapper around the command-line utility `expressvpn`. Instead of typing 
`expressvpn list all`, `expressvpn connect <server>`, and `expressvpn disconnect`,
you can now use a single command `vpn`, which exposes these functions via `fzf`:

![screenshot](screenshot.png)

In addition to the special items `auto` and `none`, all ExpressVPN servers 
can be searched, selected, and then connected to from the `fzf` interface.
Just install `expressvpn` and `fzf`, and then add this plugin via [`fisher`][3]:

    fisher add jabirali/fish-expressvpn

Then type `vpn` when you wish to connect/disconnect from the VPN service.
While the main advantage of this function is that it makes VPN selection
more interactive, you *can* also use it non-interactively. In other words,
instead of typing `vpn` and selecting an option, you can type `vpn none`,
`vpn auto`, or `vpn sweden`, and these would run `expressvpn disconnect`,
`expressvpn connect`, and `expressvpn connect sweden`, respectively.

## Issues

On Ubuntu 20.04, you may run into issues with internet connectivity of
Snap applications when activating ExpressVPN. This is because ExpressVPN
replaces `/etc/resolv.conf` with a symlink, and the AppArmor confinement
of Snap applications block them from reading the target of this link. 

If you want this plugin to automatically change that symlink to a 
hard copy, after connecting, which fixes the above issue, set
`$expressvpn_relink` to a non-empty value in your `config.fish`:

    set expressvpn_relink on

This requires your `sudo` password when connecting. If you get tired
of that, you can use `sudo visudo` to edit your `/etc/sudoers` file,
and add the following line to disable password prompts for the
command that fixes your `resolv.conf`:

    # ExpressVPN
    ALL ALL=(ALL) NOPASSWD: /bin/cp --remove-destination /var/lib/expressvpn/resolv.conf /etc/resolv.conf

[1]: https://www.expressvpn.com/
[2]: https://github.com/junegunn/fzf
[3]: https://github.com/jorgebucaran/fisher
