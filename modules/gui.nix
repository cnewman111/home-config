{ pkgs, ... }:

let
  mod = if pkgs.stdenv.isDarwin then "opt" else "alt";
in {
  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # ghostty itself is not installed here: brew cask on Mac, snap on Linux
  # (install-linux-apps.sh). This writes config only.
  home.file.".config/ghostty/config".text = ''
    font-family = JetBrainsMono Nerd Font
    theme = Idea
    keybind = ${mod}+h=goto_split:left
    keybind = ${mod}+j=goto_split:bottom
    keybind = ${mod}+k=goto_split:top
    keybind = ${mod}+l=goto_split:right
    keybind = ${mod}+n=new_split:auto
    keybind = ${mod}+q=close_surface
    keybind = ${mod}+w=new_split:up
    keybind = ${mod}+a=new_split:left
    keybind = ${mod}+s=new_split:down
    keybind = ${mod}+d=new_split:right
    keybind = ctrl+n=new_tab
    keybind = ctrl+q=close_tab
  '';
}
