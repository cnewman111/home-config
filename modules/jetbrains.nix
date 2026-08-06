# Keymap and UI settings for JetBrains IDEs (CLion / PyCharm / WebStorm via
# Toolbox).
#
# Linux-only: the keymap's parent is "Default for GNOME", which doesn't exist
# on macOS. A Mac would need its own keymap with a "macOS" parent.
#
# JetBrains stores config per IDE *version* (~/.config/JetBrains/CLion2026.1/),
# so a new directory appears on every upgrade. The glob below installs into
# every IDE dir that exists, which keeps them from drifting apart the way they
# had before this module existed.
#
# Managed here:
#   keymaps/GNOME copy.xml  — key bindings
#   options/ui.lnf.xml      — UI_DENSITY=COMPACT (compact mode)
#
# ui.lnf.xml only ever holds UISettings; the theme lives in laf.xml, which is
# deliberately NOT managed. Two files that look tempting but shouldn't be
# managed: window.state.xml (rewritten on every window move, and keyed by
# monitor geometry) and window.layouts.xml (rewritten whenever a tool window is
# dragged).
#
# The IDE rewrites these files when you change settings in its GUI, and
# activation overwrites them back on the next switch — so edit the repo copies
# under configs/jetbrains/, not the GUI. Restart the IDE to pick up changes.
{ lib, ... }:

{
  home.activation.jetbrainsKeymap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for dir in "$HOME"/.config/JetBrains/*/; do
      [ -d "$dir" ] || continue
      $DRY_RUN_CMD mkdir -p "$dir/keymaps" "$dir/options"
      $DRY_RUN_CMD install -m 644 ${../configs/jetbrains/keymap.xml} \
        "$dir/keymaps/GNOME copy.xml"
      $DRY_RUN_CMD install -m 644 ${../configs/jetbrains/ui.lnf.xml} \
        "$dir/options/ui.lnf.xml"
    done
  '';
}
