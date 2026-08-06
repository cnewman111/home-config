{ lib, ... }:

let
  # Same alias name on every machine, different body per platform — see
  # modules/linux.nix. $(hostname -s) matches the flake's darwinConfigurations
  # key, so this line needs no edit on a new Mac.
  applyAliases.apply-home-config =
    "sudo darwin-rebuild switch --flake ~/sources/home-config#$(hostname -s)";
in {
  programs.zsh.shellAliases = applyAliases;
  programs.bash.shellAliases = applyAliases;

  programs.zsh.profileExtra = lib.mkBefore (builtins.readFile ../configs/zprofile);

  # Karabiner rewrites this file itself when settings change in its UI, so the
  # repo copy is authoritative and overwrites it on every switch. Edit the repo
  # file, not the UI.
  home.activation.karabinerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/karabiner
    install -m 644 ${../configs/karabiner.json} ~/.config/karabiner/karabiner.json
  '';
}
