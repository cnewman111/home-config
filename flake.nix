{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      makeConfig = system: profile: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [ profile ];
      };
    in {
      homeConfigurations = {
        "darwin"   = makeConfig "aarch64-darwin"       ./profiles/darwin.nix;
        "linux"    = makeConfig "x86_64-linux"  ./profiles/linux.nix;
        "headless" = makeConfig "x86_64-linux"  ./profiles/headless.nix;
      };
    };
}
