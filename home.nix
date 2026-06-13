{ pkgs, lib, ... }:

{
  imports = [ ./modules/common.nix ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ ./modules/darwin.nix ]
    ++ lib.optionals pkgs.stdenv.isLinux [ ./modules/linux.nix ];

  home.username = "ccnewman";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/ccnewman" else "/home/ccnewman";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
