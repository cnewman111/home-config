{ lib, ... }:

let
  gv = lib.hm.gvariant;
in
{
  # GNOME settings via dconf. Home Manager writes these on every activation, so
  # the repo wins over anything changed in the Settings GUI — same contract as
  # configs/karabiner.json and the JetBrains keymap.
  #
  # Anything genuinely per-machine stays out of here and lives in the host file —
  # currently just pointer speed, which differs between mouse and touchpad.
  #
  # Volatile state is also deliberately absent: favorite-apps (the dock is
  # rearranged per project), the wallpaper (picked per machine and per mood),
  # app-picker-layout, command-history, control-center/last-panel, notification
  # application-children and window geometry are all rewritten by GNOME as you
  # use it, and declaring them would fight you on every switch.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # Yaru-red* comes from Ubuntu's yaru-theme packages, not nixpkgs.
      gtk-theme = "Yaru-red-dark";
      icon-theme = "Yaru-red";
      clock-format = "12h";
      # Match the ghostty font in gui.nix. Needs fonts.fontconfig.enable (also
      # set there) or the family won't resolve and GNOME silently falls back.
      # "JetBrainsMono Nerd Font", not the NL variant — NL is no-ligatures.
      monospace-font-name = "JetBrainsMono Nerd Font 12";
    };

    # auto-maximize makes GNOME maximize any large new window, which fights the
    # super+hjkl tiling below — a freshly opened window arrives maximized and has
    # to be unmaximized before it can be tiled. center-new-windows is the
    # cosmetic half of the same fix.
    #
    # scale-monitor-framebuffer unlocks the 125/150/175% scales in Settings ->
    # Displays; without it mutter only offers integer 1x/2x. Wayland-only in
    # practice — the X11 equivalent is the separate x11-randr-fractional-scaling
    # flag, which scales via xrandr and is blurry, so it's left off.
    "org/gnome/mutter" = {
      auto-maximize = false;
      center-new-windows = true;
      experimental-features = [ "scale-monitor-framebuffer" ];
    };

    # Swap Caps Lock and left Ctrl outright: Caps Lock acts as Ctrl and the
    # physical Ctrl key becomes Caps Lock, so Caps Lock is still reachable.
    # (`ctrl:nocaps`, the other common choice, makes Caps Lock a second Ctrl and
    # discards Caps Lock entirely.) This is the xkb option rather than a remap
    # elsewhere so it applies to every GNOME session including the login screen.
    "org/gnome/desktop/input-sources" = {
      sources = [ (gv.mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "ctrl:swapcaps" ];
      per-window = false;
    };

    # Window management mirrors the ghostty/vim split bindings in gui.nix:
    # super+hjkl for the window itself, ctrl+alt+hl to move between workspaces,
    # ctrl+shift+alt+hl to drag the window along.
    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ "<Super>k" ];
      unmaximize = [ "<Super>j" ];
      # Unbound: super+h is tiling below, and GNOME's default minimize would
      # otherwise swallow it.
      minimize = gv.mkEmptyArray gv.type.string;
      switch-to-workspace-left = [ "<Control><Alt>h" ];
      switch-to-workspace-right = [ "<Control><Alt>l" ];
      move-to-workspace-left = [ "<Control><Shift><Alt>h" ];
      move-to-workspace-right = [ "<Control><Shift><Alt>l" ];
    };

    # Half-screen tiling lives under mutter, not desktop/wm.
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Super>h" ];
      toggle-tiled-right = [ "<Super>l" ];
    };

    # Lock on super+delete. GNOME's default super+l is tile-right above.
    #
    # NOT super+escape: mutter already grabs that for
    # org.gnome.mutter.wayland.keybindings restore-shortcuts, and a compositor
    # grab beats gnome-settings-daemon, so gsd-media-keys just logs "Failed to
    # grab accelerator for keybinding settings:screensaver" and the key does
    # nothing. That schema applies on X11 too despite the "wayland" in its name.
    #
    # Super+1..9 is left alone deliberately — that's switch-to-application-N,
    # i.e. jump to the Nth dock favourite.
    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = [ "<Super>Delete" ];
    };

    # Blank the screen after 5 min but never suspend on AC; lock as soon as it
    # blanks.
    "org/gnome/desktop/session".idle-delay = gv.mkUint32 300;
    "org/gnome/desktop/screensaver".lock-delay = gv.mkUint32 0;
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-ac-timeout = 3600;
    };

    "org/gnome/desktop/media-handling".autorun-never = true;

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      search-view = "list-view";
      search-filter-time-type = "last_modified";
    };

    # Ubuntu Dock. The extension is ubuntu-dock@ubuntu.com but it reads the
    # upstream dash-to-dock schema, so these keys are Ubuntu-only in practice —
    # inert on a stock GNOME host, absent entirely on the Mac.
    #
    # Default is 48px icons spanning the full screen height, which is huge on a
    # 1080p panel. extend-height = false is what actually shrinks the dock to a
    # floating strip; the icon size alone leaves the full-height bar in place.
    "org/gnome/shell/extensions/dash-to-dock" = {
      dash-max-icon-size = 32;
      extend-height = false;
      show-trash = false;
      show-mounts = false;
    };
  };
}
