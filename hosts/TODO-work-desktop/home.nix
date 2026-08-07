# TODO: work desktop. Confirm the username and `hostname -s` on that machine,
# then rename this directory to the hostname and update the matching attr in
# flake.nix.
{ ... }:

{
  imports = [
    ../../modules/gui.nix
    ../../modules/linux.nix
  ];

  home.username = "cnewman";
  home.homeDirectory = "/home/cnewman";

  # Shared GNOME settings come from modules/gnome.nix. The one per-machine bit
  # the laptop sets — pointer speed — is deliberately absent here since this
  # machine has no touchpad. Capture its values with
  # `dconf dump /org/gnome/desktop/peripherals/` and add a dconf.settings block.
}
