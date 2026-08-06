{ ... }:

{
  imports = [
    ../../modules/gui.nix
    ../../modules/darwin.nix
    ../../modules/claude.nix
  ];

  # home.username / home.homeDirectory are set by nix-darwin's home-manager
  # module via home-manager.users.<name> in flake.nix.
}
