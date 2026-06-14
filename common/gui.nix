{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains-toolbox
    brave
    google-chrome
    _1password-gui
    _1password-cli
    nerd-fonts.jetbrains-mono
  ];
}
