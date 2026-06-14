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
  home.packages = with pkgs; [
    neovim
    tmux
    ripgrep
    bat
    fzf
    fd
    btop
    curl
    lazygit
    tree-sitter
    _1password-cli
    nerd-fonts.jetbrains-mono
  ];

  home.activation.lazyVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d ~/.config/nvim ]; then
      ${pkgs.git}/bin/git clone https://github.com/LazyVim/starter ~/.config/nvim
      rm -rf ~/.config/nvim/.git
    fi
    mkdir -p ~/.config/nvim/lua
    cp -r ${./configs/nvim/lua}/. ~/.config/nvim/lua/
  '';

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
    initContent = ''
      [ -f ~/.zshrc.local ] && source ~/.zshrc.local
    '';
    profileExtra = builtins.readFile ./zprofile + ''
      [ -f ~/.zprofile.local ] && source ~/.zprofile.local
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
