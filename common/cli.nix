{ pkgs, lib, ... }:

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
  imports = [ ../nvim ];

  home.packages = with pkgs; [
    tmux
    ripgrep
    bat
    fzf
    fd
    btop
    curl
    lazygit
    tree-sitter
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Colin Newman";
      user.email = "54.central-view@icloud.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.gh.enable = true;

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    shellAliases = commonAliases;
    initContent = builtins.readFile ../zshrc;
    profileExtra = builtins.readFile ../zprofile;
    initContent = lib.mkAfter ''
      [ -f ~/.zshrc.local ] && source ~/.zshrc.local
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = commonAliases;
    initExtra = ''
      [ -f ~/.bashrc.local ] && source ~/.bashrc.local
    '';
  };
}
