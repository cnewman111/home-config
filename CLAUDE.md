# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal cross-machine config managed with Nix flakes: Home Manager on every machine, plus nix-darwin layered on top for the Mac (system-level settings + core Homebrew casks).

Organized by **machine, not platform**: `hosts/<hostname>/home.nix` composes the feature modules it wants from `modules/`. Three machines: work laptop (`cnewman-5690-ubuntu`), work desktop (stubbed as `TODO-work-desktop`), and MacBook Pro (`Colins-MacBook-Pro`, user `ccnewman`).

## Apply / update commands

```bash
# Linux — attr auto-detects as $(whoami)@$(hostname -s)
nix run home-manager/master -- switch --flake ~/sources/home-config

# Mac (first run, or any time nix isn't on sudo's PATH)
sudo nix run nix-darwin -- switch --flake ~/sources/home-config#Colins-MacBook-Pro
# Mac (after first apply)
sudo darwin-rebuild switch --flake ~/sources/home-config#Colins-MacBook-Pro

# Update all flake inputs (then re-run switch)
nix flake update ~/sources/home-config
```

There are no tests or linters. To validate a change without applying it:

```bash
# eval every host (the darwin one works from Linux too — no aarch64-darwin builder needed)
nix eval --raw .#homeConfigurations."cnewman@cnewman-5690-ubuntu".activationPackage.drvPath
nix eval --raw .#darwinConfigurations."Colins-MacBook-Pro".system.drvPath

# diff a built generation against what's live — the real check for refactors
nix build .#homeConfigurations."cnewman@cnewman-5690-ubuntu".activationPackage
nix run nixpkgs#nvd -- diff ~/.local/state/nix/profiles/home-manager ./result
```

Prefer these targeted evals over `nix flake check`, which is much noisier.

To inspect a resolved value (useful for confirming a module landed where you think):

```bash
nix eval --raw '.#homeConfigurations."cnewman@cnewman-5690-ubuntu".config.home.file.".config/ghostty/config".text'
# darwin values live under .config.home-manager.users.ccnewman.*
```

## Architecture

`flake.nix` has two small factories and one entry per machine:

- **`mkHome system hostModule`** → `home.lib.homeManagerConfiguration`. Always prepends `modules/common.nix`. Used for the Linux hosts, keyed `"<user>@<hostname>"` so `home-manager switch --flake .` auto-detects with no attribute.
- **`mkDarwin system username hostDir`** → `nix-darwin.lib.darwinSystem`. Loads `<hostDir>/system.nix`, registers `home-manager.darwinModules.home-manager`, and sets `home-manager.users.<username>.imports = [ modules/common.nix <hostDir>/home.nix ]`. One `darwin-rebuild switch` applies system + user together.

`modules/common.nix` is the always-on aggregator (imports `git.nix`, `dev.nix`; sets `stateVersion` and `programs.home-manager.enable` once). Everything else is opt-in via a host's `imports` list — Linux hosts take `gui.nix` + `linux.nix` (which pulls in `bash.nix`), the Mac takes `gui.nix` + `darwin.nix` (which pulls in `zsh.nix`).

There is no system layer on Linux because hardware varies too much (see README).

## Conventions worth knowing

- **Composition over conditionals.** Prefer a new module a host opts into over a `lib.mkIf pkgs.stdenv.isDarwin` branch inside a shared file. The one place a platform conditional is right is where a single setting differs by a token — see the `mod = if pkgs.stdenv.isDarwin then "opt" else "alt"` ghostty modifier in `modules/gui.nix`.
- **No headless profile.** "Headless" is just a host that doesn't import `gui.nix`. Don't reintroduce a headless profile.
- **Username/hostname are literals.** `home.username` is a plain string in each Linux host file; the Mac's comes from `home-manager.users.<username>` in `flake.nix`. There is no `user.nix` and no `machine/<hostname>` branch workflow — both were removed. Everything evaluates and applies from `main`.
- **`configs/zprofile` is Mac-only.** It `eval`s `/opt/homebrew/bin/brew shellenv` and prepends a macOS Python 3.12 framework path, so it's read in by `modules/darwin.nix` via `lib.mkBefore`, never by `shell.nix`. Don't move it back into shared shell config — it produces errors in Linux shells.
- **Git difftool baseline is `nvimdiff`,** set in `modules/git.nix`. `modules/linux.nix` overrides to `meld` with `lib.mkForce` (required — the baseline already sets `diff.tool`). Both `difftool.<name>.cmd` definitions end up in the generated gitconfig; only `diff.tool` decides which is used.
- **Local overrides are intentional.** `modules/bash.nix` sources `~/.bashrc.local` / `~/.profile.local`; `modules/zsh.nix` sources `~/.zshrc.local` / `~/.zprofile.local`. These are never managed by Home Manager — they're where machine-specific or private config goes (work aliases, credentials, per-machine PATH). Don't move their contents into the repo.
- **One shell per platform.** bash on Linux (`modules/linux.nix` imports `bash.nix`), zsh on macOS (`modules/darwin.nix` imports `zsh.nix`) — matching each platform's login-shell default. Neither host configures the other shell, so no `~/.zshrc` is generated on Linux. Aliases live once in `modules/aliases.nix`, imported by both, so the two shells can't drift. zsh enables completion + autosuggestion + syntax highlighting because macOS doesn't ship the bash-completion scripts Ubuntu provides.
- **LazyVim is seeded, not declared.** `modules/dev.nix` has a `home.activation.lazyVim` block that `git clone`s the LazyVim starter into `~/.config/nvim` once if missing, then unconditionally syncs `configs/nvim/lua/` over it. Edits to the upstream starter survive; anything under `configs/nvim/lua/` is authoritative and overwrites the local copy on every switch.
- **Ghostty is not installed by Nix.** `modules/gui.nix` writes `~/.config/ghostty/config` only. The binary comes from a brew cask on Mac and snap (`install-linux-apps.sh`) on Linux.
- **nixGL is deliberately absent.** It's only needed for Nix-built OpenGL binaries on non-NixOS, and this repo installs none — everything in `dev.nix` is terminal CLI. Only revisit if a Nix-built GUI app is added.
- **Homebrew cleanup is `"none"`.** `hosts/Colins-MacBook-Pro/system.nix` lists only the casks that must be on the Mac. Optional GUI apps are installed interactively via `install-mac-apps.sh`. `cleanup = "none"` is what lets those coexist — don't change it to `"uninstall"` or it'll wipe everything not in the `casks = [...]` list on the next switch.
- **`install-{mac,linux}-apps.sh` are separate from Nix on purpose.** Idempotent fzf pickers for things that don't belong in the declarative config (per-machine GUI picks, snap-only apps on Linux).
- **JetBrains keymaps are synced by glob.** `modules/jetbrains.nix` (Linux only) installs `configs/jetbrains/keymap.xml` into every `~/.config/JetBrains/*/keymaps/` directory on each activation. The glob exists because JetBrains config is per IDE *version* — a new dir appears on every upgrade, and before this module the same keymap had drifted into three different variants across four IDEs. Like Karabiner, the IDE rewrites the file when you edit bindings in its GUI, so edit the repo copy instead; restart the IDE to pick up changes. The keymap's `parent="Default for GNOME"` doesn't exist on macOS, which is why this is Linux-only.
- **Karabiner config is overwritten on every switch.** `modules/darwin.nix` copies `configs/karabiner.json` into `~/.config/karabiner/` on every activation. Karabiner also rewrites that file at runtime when you change things in its UI, so UI-side tweaks get clobbered on the next switch — edit the repo file instead. This is intentional: the repo is the single source of truth.
- **`preferredDisplay` launchd agent** in `hosts/Colins-MacBook-Pro/system.nix` locks the MacBook built-in display to "Most Space" at login via `displayplacer`. It runs as the user (not root) because WindowServer only accepts display changes from the GUI session. To re-apply without logging out: `launchctl kickstart -k gui/$(id -u)/org.nixos.preferredDisplay`.
