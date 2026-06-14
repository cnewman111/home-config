#!/usr/bin/env sh
# Installs Mac GUI apps that can't be managed by Nix.
# Safe to re-run — Homebrew skips already-installed apps.

casks=$(printf '%s\n' \
  karabiner-elements \
  jetbrains-toolbox \
  raycast \
  1password \
  brave-browser \
  google-chrome \
  spotify \
  discord \
  whatsapp \
  slack \
  zoom \
  protonvpn \
  | fzf --multi \
        --prompt="Select apps to install: " \
        --header="Tab to select/deselect, Enter to confirm, Esc to cancel" \
        --bind "space:toggle")

if [ -n "$casks" ]; then
  # shellcheck disable=SC2086
  brew install --cask $casks
else
  echo "Nothing to install."
fi
