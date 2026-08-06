{ pkgs, lib, ... }:

{
  imports = [ ./bash.nix ./jetbrains.nix ];

  # Counterpart to the alias in modules/darwin.nix. The flake attr auto-detects
  # as $(whoami)@$(hostname -s), so no attr is needed. -b is the standalone
  # equivalent of the Mac's home-manager.backupFileExtension.
  #
  # Uses the home-manager binary this config installs (pinned by flake.lock)
  # rather than `nix run home-manager/master`: the short name is a
  # flake-registry lookup, and a registry that replaces the public one (as on
  # the work machines) has no home-manager entry, so the short form fails there.
  programs.bash.shellAliases.apply-home-config =
    "home-manager switch -b before-hm --flake ~/sources/home-config";

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
