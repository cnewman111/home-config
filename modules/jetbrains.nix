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
#   keymaps/GNOME copy.xml     — key bindings (all IDEs)
#   options/ui.lnf.xml         — UI_DENSITY=COMPACT (all IDEs)
#   options/window.layouts.xml — tool window order (CLion only)
#
# The layout puts alt+1..6 in the upper left sidebar and alt+7,8,9,0 in the
# lower one (that's what "isSplit": true means), so the sidebar reads in
# keyboard order. It's CLion-only because it references CMake/Meson.
#
# JetBrains has no global/shared config dir — every setting is per-IDE-per-
# version, which is why this module fans out instead. Note window.layouts.xml
# is rewritten whenever you drag a tool window, so the repo wins on the next
# switch: adjust configs/jetbrains/window.layouts.xml rather than dragging.
#
# ui.lnf.xml only ever holds UISettings; the theme lives in laf.xml, which is
# deliberately NOT managed. window.state.xml is also left alone — it's
# rewritten on every window move and keyed by monitor geometry.
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

      # Tool window layout is CLion-only: it references CMake/Meson, and the
      # sidebar order is built around CLion's alt+N bindings. Other IDEs keep
      # whatever layout they have (import from CLion manually if wanted).
      case "$dir" in
        *"/CLion"*)
          $DRY_RUN_CMD install -m 644 ${../configs/jetbrains/window.layouts.xml} \
            "$dir/options/window.layouts.xml"
          ;;
      esac
    done
  '';
}
