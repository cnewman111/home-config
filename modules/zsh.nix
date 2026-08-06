# Login shell on macOS (the platform default since 10.15). Imported by
# modules/darwin.nix.
#
# macOS does not ship the bash-completion scripts the Linux hosts get from
# Ubuntu, so completion is enabled explicitly here along with the two plugins
# that make zsh worth using over bash.
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
