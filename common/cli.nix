{ pkgs, ... }:

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
  home.packages = with pkgs; [
    neovim
    tmux
    ripgrep
    bat
    fzf
    btop
    curl
  ];

  programs.git = {
    enable = true;
    userName = "Colin Newman";
    userEmail = "54.central-view@icloud.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.gh.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = commonAliases;
  };

  programs.bash = {
    enable = true;
    shellAliases = commonAliases;
  };
}
