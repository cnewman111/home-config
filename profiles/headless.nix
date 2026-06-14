{ pkgs, ... }:

{
  imports = [
    ../common/cli.nix
  ];

  home.username = "ccnewman";
  home.homeDirectory = "/home/ccnewman";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pax-utils
    patchelf
  ];

  programs.git.settings = {
    diff.tool = "nvimdiff";
    difftool.nvimdiff.cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
    difftool.prompt = false;
  };
}
