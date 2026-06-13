{ pkgs, lib, ... }:

{
  imports = [
    ../common/cli.nix
    ../common/gui.nix
  ];

  home.username = "ccnewman";
  home.homeDirectory = "/Users/ccnewman";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ghostty
    raycast
    karabiner-elements
  ];

  programs.git.extraConfig = {
    diff.tool = "nvimdiff";
    difftool.nvimdiff.cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
    difftool.prompt = false;
  };

  home.activation.karabinerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f ~/.config/karabiner/karabiner.json ]; then
      mkdir -p ~/.config/karabiner
      cp ${../karabiner.json} ~/.config/karabiner/karabiner.json
    fi
  '';
}
