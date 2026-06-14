#!/usr/bin/env sh
# Installs Linux GUI apps outside of Nix via snap (auto-updating).
# Safe to re-run.

prompt() {
  printf "Install %s? [y/N] " "$1"
  read -r answer
  case "$answer" in
    [yY]) return 0 ;;
    *) return 1 ;;
  esac
}

snaps=""

prompt jetbrains-toolbox && snaps="$snaps jetbrains-toolbox"
prompt 1password         && snaps="$snaps 1password"
prompt brave             && snaps="$snaps brave"
prompt google-chrome     && snaps="$snaps google-chrome"
prompt spotify           && snaps="$snaps spotify"
prompt slack             && snaps="$snaps slack"
prompt zoom-client       && snaps="$snaps zoom-client"

if [ -n "$snaps" ]; then
  for snap in $snaps; do
    sudo snap install "$snap"
  done
else
  echo "Nothing to install."
fi
