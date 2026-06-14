{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-darwin, ... }:
    let
      # Under sudo, $USER is "root" — fall through to $SUDO_USER which sudo sets to the caller.
      user = let u = builtins.getEnv "SUDO_USER"; in if u != "" then u else builtins.getEnv "USER";
      makeConfig = system: profile: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [ profile ];
      };
    in {
      darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./profiles/darwin-system.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./profiles/darwin.nix;
          }
        ];
      };

      homeConfigurations = {
        "linux"    = makeConfig "x86_64-linux" ./profiles/linux.nix;
        "headless" = makeConfig "x86_64-linux" ./profiles/headless.nix;
      };
    };
}
