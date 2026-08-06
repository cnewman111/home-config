{ pkgs, lib, ... }:

let
  # Counterpart to the alias in modules/darwin.nix. The flake attr auto-detects
  # as $(whoami)@$(hostname -s), so no attr is needed. -b is the standalone
  # equivalent of the Mac's home-manager.backupFileExtension.
  applyAliases.apply-home-config =
    "nix run home-manager/master -- switch -b before-hm --flake ~/sources/home-config";
in {
  programs.zsh.shellAliases = applyAliases;
  programs.bash.shellAliases = applyAliases;

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
