{
  description = "My dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      mkHome =
        {
          system,
          modules,
          username,
        }:
        home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
            inherit username;
          };
          pkgs = import nixpkgs { inherit system; };
          modules = [
            ./nix/home/default
            {
              nixpkgs.config.allowUnfree = true;
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
            }
          ]
          ++ modules;
        };
      mkDarwin =
        {
          system,
          modules,
          username,
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            home-manager.darwinModules.home-manager
            ./nix/darwin/default
            {
              system.primaryUser = username;
              users.users.${username} = {
                home = "/Users/${username}";
              };
            }
          ]
          ++ modules;
          specialArgs = {
            inherit inputs;
            inherit username;
          };
        };
    in
    {
      homeConfigurations = {
        wsl = mkHome {
          system = "x86_64-linux";
          username = "maha";
          modules = [ ./nix/home/wsl ];
        };
      };
      darwinConfigurations = {
        mac = mkDarwin {
          system = "aarch64-darwin";
          username = "marvin";
          modules = [ ./nix/darwin/mac ];
        };
      };
    };
}
