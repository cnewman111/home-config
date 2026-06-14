#!/usr/bin/env sh
# Installs Linux GUI apps outside of Nix via snap (auto-updating).
# Safe to re-run.

snaps=$(printf '%s\n' \
  jetbrains-toolbox \
  ghostty \
  1password \
  brave \
  spotify \
  slack \
  zoom-client \
  | fzf --multi \
        --prompt="Select apps to install: " \
        --header="Tab to select/deselect, Enter to confirm, Esc to cancel" \
        --bind "space:toggle")

if [ -n "$snaps" ]; then
  for snap in $snaps; do
    case "$snap" in
      ghostty) sudo snap install "$snap" --classic ;;
      *)       sudo snap install "$snap" ;;
    esac
  done
else
  echo "Nothing to install."
fi
