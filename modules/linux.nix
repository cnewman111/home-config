{
  pkgs,
  lib,
  config,
  ...
}:

let
  # Private directory holding symlinks to the system NVIDIA driver libraries
  # btop dlopen()s. Populated by the btopNvidia activation script below.
  nvidiaLibDir = "${config.home.homeDirectory}/.local/lib/nvidia-dlopen";
in
{
  imports = [ ./zsh.nix ./bash.nix ./jetbrains.nix ./gnome.nix ];

  # Counterpart to the alias in modules/darwin.nix. The flake attr auto-detects
  # as $(whoami)@$(hostname -s), so no attr is needed. -b is the standalone
  # equivalent of the Mac's home-manager.backupFileExtension.
  #
  # Uses the home-manager binary this config installs (pinned by flake.lock)
  # rather than `nix run home-manager/master`: the short name is a
  # flake-registry lookup, and a registry that replaces the public one (as on
  # the work machines) has no home-manager entry, so the short form fails there.
  programs.zsh.shellAliases.apply-home-config =
    "home-manager switch -b before-hm --flake ~/sources/home-config";

  home.packages = with pkgs; [
    meld
    pax-utils
    patchelf
    # TUI for pairing/connecting bluetooth devices without the GNOME panel.
    # A client for the system bluetoothd — Ubuntu still owns the daemon.
    # Linux-only: it speaks BlueZ over D-Bus, which macOS has no equivalent of.
    #
    # bluetui rather than bluetuith: bluetuith renders unreadably on a dark
    # terminal and silently ignores invalid theme/keybinding config, so there's
    # no way to tell whether a fix applied. bluetui has vim keys built in.
    bluetui
  ];

  programs.git.settings = {
    diff.tool = lib.mkForce "meld";
    difftool.meld.cmd = ''meld "$LOCAL" "$REMOTE"'';
  };

  # btop is built with -DBTOP_GPU=ON and finds NVIDIA GPUs by dlopen()ing
  # "libnvidia-ml.so.1" by soname. The driver library is Ubuntu's (it must match
  # the running kernel module, so it can never come from nixpkgs), but Nix's
  # glibc ignores /etc/ld.so.cache, so the bare soname doesn't resolve and btop
  # logs "Failed to load libnvidia-ml.so, NVIDIA GPUs will not be detected".
  #
  # Fix is a private directory of symlinks plus LD_LIBRARY_PATH on btop alone.
  # Pointing LD_LIBRARY_PATH at /usr/lib/x86_64-linux-gnu wholesale instead
  # would shadow Nix's own libc for every child process — that aborts binaries
  # outright ("stack smashing detected"), so keep the directory narrow.
  home.activation.btopNvidia = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -e /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 ]; then
      $DRY_RUN_CMD mkdir -p ${nvidiaLibDir}
      $DRY_RUN_CMD ln -sfn /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 \
        ${nvidiaLibDir}/libnvidia-ml.so.1
    else
      $DRY_RUN_CMD rm -rf ${nvidiaLibDir}
    fi
  '';

  programs.btop = {
    # Only btop gets the driver dir, and as a suffix so a Nix-provided library
    # still wins if one ever appears earlier on the path.
    package = pkgs.btop.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
      postInstall = (old.postInstall or "") + ''
        wrapProgram $out/bin/btop \
          --suffix LD_LIBRARY_PATH : ${nvidiaLibDir}
      '';
    });

    settings = {
      # gpu0 is a full box beside cpu/mem/net/proc. show_gpu_info = "Off" keeps
      # the redundant GPU summary out of the cpu box now that the box exists.
      shown_boxes = "cpu mem net proc gpu0";
      show_gpu_info = "Off";
      shown_gpus = "nvidia";
      # Intel iGPU stats need a perf_event PMU, which
      # kernel.perf_event_paranoid = 4 on this machine denies; btop logs
      # "Intel GPU: Failed to initialize PMU" and shows nothing either way.
      # nvml_measure_pcie_speeds is left on — it works on this card.
    };
  };
}
