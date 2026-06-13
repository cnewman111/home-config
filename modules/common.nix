{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
    bat
    fzf
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

  programs.gh = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      gcm = "git commit -m";
      gco = "git checkout";
      gst = "git status";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      glog = "git log --oneline --graph --decorate";
    };
    initExtra = ''
      # Add any extra zsh config here
    '';
  };
}
