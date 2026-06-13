{ pkgs, lib, ... }:

{
  imports = [ ./common-headless.nix ./common-gui.nix ];

  home.packages = with pkgs; [
    jetbrains-toolbox
    raycast
    brave
    google-chrome
    karabiner-elements
  ];

  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 14;
      macos-titlebar-style = "hidden";
      window-padding-x = 8;
      window-padding-y = 8;
    };
  };

  home.activation.karabinerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f ~/.config/karabiner/karabiner.json ]; then
      mkdir -p ~/.config/karabiner
      cp ${../karabiner.json} ~/.config/karabiner/karabiner.json
    fi
  '';
}
