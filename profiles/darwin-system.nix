{ ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Determinate Systems installer manages the Nix daemon and settings.
  nix.enable = false;

  system.primaryUser = "ccnewman";
  system.stateVersion = 5;

  users.users.ccnewman = {
    name = "ccnewman";
    home = "/Users/ccnewman";
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # "none" leaves casks installed outside this list (e.g. via install-mac-apps.sh) alone.
      cleanup = "none";
    };
    casks = [
      "karabiner-elements"
      "raycast"
      "brave-browser"
      "jetbrains-toolbox"
    ];
    brews = [
      "displayplacer"
    ];
  };

  system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 0.6875;

  # Lock the built-in display to "Most Space" (2056x1329) at every login.
  # Runs as user (not root) because WindowServer only accepts display changes from the
  # logged-in user's GUI session. To re-apply without logging out:
  #   launchctl kickstart -k gui/$(id -u)/org.nixos.preferredDisplay
  launchd.user.agents.preferredDisplay = {
    serviceConfig = {
      RunAtLoad = true;
      StandardOutPath = "/tmp/preferredDisplay.log";
      StandardErrorPath = "/tmp/preferredDisplay.log";
    };
    script = ''
      DISPLAYPLACER=/opt/homebrew/bin/displayplacer
      if [ -x "$DISPLAYPLACER" ]; then
        BUILTIN_ID=$("$DISPLAYPLACER" list 2>/dev/null | \
          awk '/Persistent screen id:/{id=$NF} /Type: MacBook built in screen/{print id; exit}')
        if [ -n "$BUILTIN_ID" ]; then
          "$DISPLAYPLACER" \
            "id:$BUILTIN_ID res:2056x1329 hz:120 color_depth:8 scaling:on origin:(0,0) degree:0"
        fi
      fi
    '';
  };
}
