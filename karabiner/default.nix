{ lib, ... }:

{
  home.activation.karabinerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f ~/.config/karabiner/karabiner.json ]; then
      mkdir -p ~/.config/karabiner
      cp ${./karabiner.json} ~/.config/karabiner/karabiner.json
    fi
  '';
}
