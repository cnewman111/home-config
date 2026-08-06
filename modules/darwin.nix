{ lib, ... }:

{
  programs.zsh.profileExtra = lib.mkBefore (builtins.readFile ../configs/zprofile);

  # Karabiner rewrites this file itself when settings change in its UI, so the
  # repo copy is authoritative and overwrites it on every switch. Edit the repo
  # file, not the UI.
  home.activation.karabinerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/karabiner
    install -m 644 ${../configs/karabiner.json} ~/.config/karabiner/karabiner.json
  '';
}
