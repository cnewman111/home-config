# zsh: login shell on macOS (the platform default since 10.15), and on Linux
# via modules/linux.nix — imported by both platform modules.
#
# Completion is enabled explicitly because macOS doesn't ship the
# bash-completion scripts Ubuntu provides, along with the two plugins that make
# zsh worth using over bash: autosuggestion and syntax highlighting.
{ ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = import ./aliases.nix;
    initContent = ''
      # zsh's bare completion defaults feel broken coming from bash: an
      # ambiguous prefix inserts nothing and just beeps. These make Tab behave
      # the way bash-completion users expect.
      zstyle ':completion:*' menu select                    # arrow-key menu
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' matcher-list 'm:{a-z-}={A-Z_}' # case/dash insensitive
      zstyle ':completion:*' completer _complete _correct _approximate
      zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
      setopt AUTO_LIST          # list choices on an ambiguous completion
      setopt AUTO_MENU          # then cycle through them on a second Tab
      setopt COMPLETE_IN_WORD   # complete from the cursor, not just line end
      setopt ALWAYS_TO_END      # move cursor to end after completing

      [ -f ~/.zshrc.local ] && source ~/.zshrc.local
    '';
    profileExtra = ''
      [ -f ~/.zprofile.local ] && source ~/.zprofile.local
    '';
  };
}
