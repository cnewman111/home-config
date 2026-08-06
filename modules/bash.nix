# Login shell on the Linux hosts. Imported by modules/linux.nix.
{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = import ./aliases.nix;
    initExtra = ''
      [ -f ~/.bashrc.local ] && source ~/.bashrc.local
    '';
    profileExtra = ''
      [ -f ~/.profile.local ] && source ~/.profile.local
    '';
  };
}
