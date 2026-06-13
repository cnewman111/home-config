{ pkgs, ... }:

{
  imports = [
    ../common/cli.nix
    ../common/gui.nix
  ];

  home.username = "ccnewman";
  home.homeDirectory = "/home/ccnewman";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ghostty
    meld
    pax-utils
    patchelf
  ];

  programs.git.extraConfig = {
    diff.tool = "meld";
    difftool.meld.cmd = ''meld "$LOCAL" "$REMOTE"'';
    difftool.prompt = false;
  };
}
