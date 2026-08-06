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
}
