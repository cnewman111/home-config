#!/usr/bin/env sh
# Installs Linux GUI apps outside of Nix via snap (auto-updating).
# Safe to re-run.

snaps=$(printf '%s\n' \
  jetbrains-toolbox \
  1password \
  brave \
  google-chrome \
  spotify \
  slack \
  zoom-client \
  | fzf --multi \
        --prompt="Select apps to install: " \
        --header="Tab to select/deselect, Enter to confirm, Esc to cancel" \
        --bind "space:toggle")

if [ -n "$snaps" ]; then
  for snap in $snaps; do
    sudo snap install "$snap"
  done
else
  echo "Nothing to install."
fi
