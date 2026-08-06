{
  description = "Home Manager + nix-darwin configuration";

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
      mkHome = system: hostModule: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [ ./modules/common.nix hostModule ];
      };

      mkDarwin = system: username: hostDir: nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          (hostDir + "/system.nix")
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Rename pre-existing dotfiles instead of aborting activation when
            # a newly-managed file is already in the way.
            home-manager.backupFileExtension = "before-hm";
            home-manager.users.${username}.imports = [
              ./modules/common.nix
              (hostDir + "/home.nix")
            ];
          }
        ];
      };
    in {
      homeConfigurations = {
        "cnewman@cnewman-5690-ubuntu" =
          mkHome "x86_64-linux" ./hosts/cnewman-5690-ubuntu/home.nix;

        # TODO: rename to the work desktop's real `hostname -s` and confirm the
        # username, then rename hosts/TODO-work-desktop/ to match.
        "cnewman@TODO-work-desktop" =
          mkHome "x86_64-linux" ./hosts/TODO-work-desktop/home.nix;
      };

      darwinConfigurations."Colins-MacBook-Pro" =
        mkDarwin "aarch64-darwin" "ccnewman" ./hosts/Colins-MacBook-Pro;
    };
}
