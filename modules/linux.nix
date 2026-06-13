{ pkgs, ... }:

{
  imports = [ ./common-headless.nix ./common-gui.nix ];

  home.packages = with pkgs; [
    meld
    pax-utils
    patchelf
  ];

  programs.git.extraConfig = {
    diff.tool = "meld";
    difftool.meld.cmd = ''meld "$LOCAL" "$REMOTE"'';
  };
}
