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
    pax-utils
  ];

  programs.git.settings = {
    diff.tool = "nvimdiff";
    difftool.nvimdiff.cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
    difftool.prompt = false;
  };
}
