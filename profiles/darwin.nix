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
    ghostty-bin
    raycast
    karabiner-elements
    nerd-fonts.jetbrains-mono
  ];

  home.file.".config/ghostty/config".text = ''
    font-family = JetBrainsMono Nerd Font
    keybind = opt+h=goto_split:left
    keybind = opt+j=goto_split:bottom
    keybind = opt+k=goto_split:top
    keybind = opt+l=goto_split:right
    keybind = opt+n=new_split:auto
    keybind = opt+q=close_surface
    keybind = opt+w=new_split:up
    keybind = opt+a=new_split:left
    keybind = opt+s=new_split:down
    keybind = opt+d=new_split:right
    keybind = ctrl+n=new_tab
    keybind = ctrl+q=close_tab
  '';

  programs.git.settings = {
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
