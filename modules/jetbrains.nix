# Keymap sync for JetBrains IDEs (CLion / PyCharm / WebStorm via Toolbox).
#
# Linux-only: the keymap's parent is "Default for GNOME", which doesn't exist
# on macOS. A Mac would need its own keymap with a "macOS" parent.
#
# JetBrains stores config per IDE *version* (~/.config/JetBrains/CLion2026.1/),
# so a new directory appears on every upgrade. The glob below installs the
# repo's keymap into every IDE dir that exists, which keeps them from drifting
# apart the way they had before this module existed.
#
# The IDE rewrites this file when you change bindings in Settings > Keymap, and
# activation overwrites it back on the next switch — so edit
# configs/jetbrains/keymap.xml, not the GUI. Restart the IDE to pick up changes.
{ lib, ... }:

{
  home.activation.jetbrainsKeymap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for dir in "$HOME"/.config/JetBrains/*/; do
      [ -d "$dir" ] || continue
      $DRY_RUN_CMD mkdir -p "$dir/keymaps"
      $DRY_RUN_CMD install -m 644 ${../configs/jetbrains/keymap.xml} \
        "$dir/keymaps/GNOME copy.xml"
    done
  '';
}
