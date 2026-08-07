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

  # Index the fonts installed above into ~/.local/share/fonts so fontconfig —
  # and therefore every GTK/GNOME app — can actually resolve them by family
  # name. Without this the font is on disk but invisible: `fc-match
  # 'JetBrainsMono Nerd Font'` falls back to DejaVu Sans, and setting it as
  # GNOME's monospace font silently does nothing. ghostty loads its font by path
  # from the nix store, which is why it looked fine regardless.
  fonts.fontconfig.enable = true;

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
    keybind = shift+${mod}+w=new_split:up
    keybind = shift+${mod}+a=new_split:left
    keybind = shift+${mod}+s=new_split:down
    keybind = shift+${mod}+d=new_split:right
    keybind = shift+${mod}+h=resize_split:left,40
    keybind = shift+${mod}+j=resize_split:down,40
    keybind = shift+${mod}+k=resize_split:up,40
    keybind = shift+${mod}+l=resize_split:right,40
    keybind = ${mod}+u=scroll_page_fractional:-0.5
    keybind = ${mod}+d=scroll_page_fractional:0.5
    keybind = ${mod}+g=scroll_to_top
    keybind = shift+${mod}+g=scroll_to_bottom
    keybind = ${mod}+e=equalize_splits
    keybind = ${mod}+f=toggle_fullscreen
    keybind = ${mod}+y=copy_to_clipboard
    keybind = ${mod}+p=paste_from_clipboard
    keybind = ctrl+n=new_tab
    keybind = ctrl+q=close_tab
    keybind = ctrl+r=prompt_tab_title
  '';
}
