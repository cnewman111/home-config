{ ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./dev.nix
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.sessionVariables.EDITOR = "nvim";
}
