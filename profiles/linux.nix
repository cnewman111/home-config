{ pkgs, ... }:

let
  userInfo = import ../user.nix;
in {
  imports = [
    ../common.nix
  ];

  home.username = userInfo.username;
  home.homeDirectory = "/home/${userInfo.username}";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    meld
    pax-utils
    patchelf
  ];

  programs.git.settings = {
    diff.tool = "meld";
    difftool.meld.cmd = ''meld "$LOCAL" "$REMOTE"'';
    difftool.prompt = false;
  };

  home.file.".config/ghostty/config".text = ''
    font-family = JetBrainsMono Nerd Font
    keybind = alt+h=goto_split:left
    keybind = alt+j=goto_split:bottom
    keybind = alt+k=goto_split:top
    keybind = alt+l=goto_split:right
    keybind = alt+n=new_split:auto
    keybind = alt+q=close_surface
    keybind = alt+w=new_split:up
    keybind = alt+a=new_split:left
    keybind = alt+s=new_split:down
    keybind = alt+d=new_split:right
    keybind = ctrl+n=new_tab
    keybind = ctrl+q=close_tab
  '';
}
