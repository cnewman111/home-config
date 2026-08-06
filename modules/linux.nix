{ pkgs, lib, ... }:

{
  imports = [ ./bash.nix ./jetbrains.nix ];

  # Counterpart to the alias in modules/darwin.nix. Uses the home-manager
  # binary from programs.home-manager.enable — the version pinned in
  # flake.lock, not upstream master. The flake attr auto-detects as
  # $(whoami)@$(hostname -s), so no attr is needed. -b is the standalone
  # equivalent of the Mac's home-manager.backupFileExtension.
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
