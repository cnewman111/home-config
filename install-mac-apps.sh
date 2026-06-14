#!/usr/bin/env sh
# Installs Mac GUI apps that can't be managed by Nix.
# Safe to re-run — Homebrew skips already-installed apps.

prompt() {
  printf "Install %s? [y/N] " "$1"
  read -r answer
  case "$answer" in
    [yY]) return 0 ;;
    *) return 1 ;;
  esac
}

casks=""

prompt karabiner-elements && casks="$casks karabiner-elements"
prompt jetbrains-toolbox  && casks="$casks jetbrains-toolbox"
prompt raycast            && casks="$casks raycast"
prompt 1password          && casks="$casks 1password"
prompt brave-browser      && casks="$casks brave-browser"
prompt google-chrome      && casks="$casks google-chrome"
prompt spotify            && casks="$casks spotify"
prompt discord            && casks="$casks discord"
prompt slack              && casks="$casks slack"
prompt zoom               && casks="$casks zoom"
prompt protonvpn          && casks="$casks protonvpn"

if [ -n "$casks" ]; then
  # shellcheck disable=SC2086
  brew install --cask $casks
else
  echo "Nothing to install."
fi
