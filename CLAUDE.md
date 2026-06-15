# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal cross-machine config managed with Nix flakes: Home Manager on every machine, plus nix-darwin layered on top for Macs (system-level settings + core Homebrew casks). Three profiles: `darwin`, `linux`, `headless`.

## Apply / update commands

```bash
# Mac (first run, or any time nix isn't on sudo's PATH)
sudo nix run nix-darwin -- switch --flake ~/sources/home-config#darwin
# Mac (after first apply)
sudo darwin-rebuild switch --flake ~/sources/home-config#darwin

# Linux
nix run home-manager/master -- switch --flake ~/sources/home-config#linux
nix run home-manager/master -- switch --flake ~/sources/home-config#headless

# Update all flake inputs (then re-run switch)
nix flake update ~/sources/home-config
```

There are no tests, linters, or build steps — the only way to validate a change is to run the appropriate `switch` command above on a real machine of that type.

## Setting up a new machine

`user.nix` is the single source of truth for the username (imported by `flake.nix`, `darwin-system.nix`, `linux.nix`, and `headless.nix`). On `main` it's a `throw` with branching instructions, so applying `main` directly fails fast.

Every machine gets its own long-lived branch (`machine/<hostname>`): create it, replace the throw in `user.nix` with `username = "..."`, commit, and stay on that branch for every `switch`. Pull `main` into the branch to pick up shared updates — never merge the username change back to `main`.

## Architecture

`flake.nix` exposes three outputs:

- `darwinConfigurations.darwin` — built by `nix-darwin.lib.darwinSystem`. Entry point is `profiles/darwin-system.nix`. nix-darwin pulls in `home-manager.darwinModules.home-manager` and registers `profiles/darwin.nix` as the user's HM config. So on Mac, system and user config are applied by a single `darwin-rebuild switch`.
- `homeConfigurations.linux` and `homeConfigurations.headless` — built by `home-manager.lib.homeManagerConfiguration`. Home Manager only; there is no system layer on Linux because hardware varies too much (see README).

Every profile imports `common.nix`, which is the shared core: packages, zsh/bash, git, the LazyVim bootstrap, and the local-override sourcing hooks. Platform profiles add only the deltas (e.g. ghostty config differs by modifier key, diff tool differs by availability).

## Conventions worth knowing

- **Local overrides are intentional.** `common.nix` sources `~/.zshrc.local`, `~/.bashrc.local`, `~/.profile.local`, `~/.zprofile.local` if they exist. These files are never managed by Home Manager — they're where machine-specific or private config goes. Don't move their contents into the repo.
- **LazyVim is seeded, not declared.** `common.nix` has a `home.activation.lazyVim` block that `git clone`s LazyVim starter into `~/.config/nvim` once if missing, then unconditionally syncs `configs/nvim/lua/` over it. Edits to the upstream starter survive; edits to anything under `configs/nvim/lua/` are authoritative and overwrite the local copy on every switch.
- **Homebrew cleanup is `"none"`.** `darwin-system.nix` lists only the casks that must be on every Mac (Karabiner, Raycast, Brave, JetBrains Toolbox). Optional GUI apps are installed interactively via `install-mac-apps.sh` (fzf multi-select over `brew install --cask`). Setting cleanup to `"none"` is what lets those coexist — don't change it to `"uninstall"` or it'll wipe everything not in the `casks = [...]` list on the next switch.
- **`install-{mac,linux}-apps.sh` are separate from Nix on purpose.** They're idempotent fzf pickers for things that don't belong in the declarative config (per-machine GUI picks, snap-only apps on Linux).
- **Karabiner config is overwritten on every switch.** `darwin.nix` copies `configs/karabiner.json` into `~/.config/karabiner/` on every activation. Karabiner also rewrites that file at runtime when you change things in its UI, so any UI-side tweaks get clobbered on the next switch — edit the repo file instead.
- **`preferredDisplay` launchd agent** in `darwin-system.nix` locks the MacBook built-in display to "Most Space" at login via `displayplacer`. It runs as the user (not root) because WindowServer only accepts display changes from the GUI session. To re-apply without logging out: `launchctl kickstart -k gui/$(id -u) org.nixos.preferredDisplay`.
- **Pre-existing dotfiles block first apply.** Home Manager refuses to overwrite an existing `~/.zshrc` / `~/.bashrc`. Move them aside or merge into `~/.zshrc.local` before the first switch.
