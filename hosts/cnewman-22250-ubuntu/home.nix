{ ... }:

{
  imports = [
    ../../modules/gui.nix
    ../../modules/linux.nix
  ];

  home.username = "cnewman";
  home.homeDirectory = "/home/cnewman";

  # Per-machine GNOME bits; the shared ones are in modules/gnome.nix.
  #
  # Desktop, so no touchpad and no battery: the laptop's touchpad speed and
  # show-battery-percentage are both deliberately absent. Mouse speed is left at
  # the default 0.0 rather than the laptop's -0.213235 — that value was tuned for
  # a different pointer, and this machine has a plain USB optical mouse.
  dconf.settings = {
    "org/gnome/desktop/peripherals/keyboard".numlock-state = false;

    # 3440x1440 ultrawide, so windows are tiled left/right (super+h/l from
    # modules/gnome.nix) far more than maximized. Two-thirds of this panel is
    # already wider than the laptop's whole screen.
    "org/gnome/mutter".dynamic-workspaces = false;
    "org/gnome/desktop/wm/preferences".num-workspaces = 4;
  };
}
