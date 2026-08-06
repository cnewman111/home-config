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
      [ -f ~/.zshrc.local ] && source ~/.zshrc.local
    '';
    profileExtra = ''
      [ -f ~/.zprofile.local ] && source ~/.zprofile.local
    '';
  };
}
