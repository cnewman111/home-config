{ ... }:

{
  imports = [
    ../../modules/gui.nix
    ../../modules/linux.nix
  ];

  home.username = "cnewman";
  home.homeDirectory = "/home/cnewman";
}
