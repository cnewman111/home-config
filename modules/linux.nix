{ pkgs, lib, ... }:

{
  imports = [ ./bash.nix ];

  home.packages = with pkgs; [
    meld
    pax-utils
    patchelf
  ];

  programs.git.settings = {
    diff.tool = lib.mkForce "meld";
    difftool.meld.cmd = ''meld "$LOCAL" "$REMOTE"'';
  };
}
