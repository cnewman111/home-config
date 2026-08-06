# Minimal bash config — a fallback, not the shell you use day to day.
#
# The login shell in /etc/passwd is still /bin/bash (nix zsh isn't in
# /etc/shells, so chsh would refuse it), and ghostty + the JetBrains terminals
# are pointed at zsh explicitly. So bash is only what you land in via SSH,
# GNOME's Ctrl+Alt+T, su, or cron.
#
# Without this module Home Manager generates no ~/.bashrc at all, and those
# paths lose ~/.bashrc.local — meaning no cargo, nvm, PATH additions, work
# aliases, or ~/.secrets. This restores that sourcing and nothing else: the
# aliases, vi-mode, and plugins live in zsh.nix.
{ ... }:

{
  programs.bash = {
    enable = true;
    initExtra = ''
      [ -f ~/.bashrc.local ] && source ~/.bashrc.local
    '';
    profileExtra = ''
      [ -f ~/.profile.local ] && source ~/.profile.local
    '';
  };
}
