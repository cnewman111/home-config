#!/usr/bin/env sh
# Installs Mac GUI apps that can't be managed by Nix.
# Safe to re-run — Homebrew skips already-installed apps.

brew install --cask \
  karabiner-elements \
  jetbrains-toolbox \
  raycast \
  1password \
  brave-browser \
  google-chrome
