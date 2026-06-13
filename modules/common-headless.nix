{ pkgs, ... }:

let
  commonAliases = {
    ga = "git add";
    gcm  = "git commit -m";
    gc  = "git checkout";
    gs  = "git status";
    gp   = "git push";
    gpl   = "git pull";
    gdt   = "git difftool";
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
      diff.tool = "nvimdiff";
      difftool.nvimdiff.cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
      difftool.prompt = false;
    };
  };

  programs.gh = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = commonAliases;
    initExtra = ''
      # Add any extra zsh config here
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = commonAliases;
  };
}
