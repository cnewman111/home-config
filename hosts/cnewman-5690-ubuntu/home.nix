{ ... }:

{
  imports = [
    ../../modules/gui.nix
    ../../modules/linux.nix
  ];

  home.username = "cnewman";
  home.homeDirectory = "/home/cnewman";

  # Per-machine GNOME bits; the shared ones are in modules/gnome.nix.
  # Pointer speeds are the GUI slider values rounded to the 6 significant
  # figures Nix's float-to-string gives, so a later `dconf dump` matches this
  # file exactly.
  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse".speed = -0.213235;
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = -0.051471;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/desktop/peripherals/keyboard".numlock-state = false;

    # Laptop-only — the desktop has no battery to report.
    "org/gnome/desktop/interface".show-battery-percentage = true;
  };
}
