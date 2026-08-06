{ pkgs, lib, ... }:

let
  mod = if pkgs.stdenv.isDarwin then "opt" else "alt";
  # On Linux the login shell is still bash (nix zsh isn't in /etc/shells), so
  # ghostty is told to launch zsh directly. macOS already defaults to zsh.
  #
  # gtk-titlebar-style = tabs merges the tab bar into the titlebar, dropping the
  # separate title row above it. GTK-only, hence grouped here — the Mac's
  # titlebar is handled by macos-titlebar-style, which already defaults to
  # transparent.
  linuxOnly = lib.optionalString pkgs.stdenv.isLinux ''
    command = ${pkgs.zsh}/bin/zsh
    gtk-titlebar-style = tabs
  '';
in {
  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # ghostty itself is not installed here: brew cask on Mac, snap on Linux
  # (install-linux-apps.sh). This writes config only.
  home.file.".config/ghostty/config".text = ''
    font-family = JetBrainsMono Nerd Font
    theme = Idea
    ${linuxOnly}
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
