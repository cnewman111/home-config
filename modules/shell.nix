{ ... }:

let
  commonAliases = {
    ga  = "git add";
    gcm = "git commit -m";
    gc  = "git checkout";
    gs  = "git status";
    gp  = "git push";
    gpl = "git pull";
    gdt = "git difftool";
    nd  = "nix develop";
    ndc = "nix develop --command";
  };
in {
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    shellAliases = commonAliases;
    initContent = ''
      [ -f ~/.zshrc.local ] && source ~/.zshrc.local
    '';
    profileExtra = ''
      [ -f ~/.zprofile.local ] && source ~/.zprofile.local
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = commonAliases;
    initExtra = ''
      [ -f ~/.bashrc.local ] && source ~/.bashrc.local
    '';
    profileExtra = ''
      [ -f ~/.profile.local ] && source ~/.profile.local
    '';
  };
}
