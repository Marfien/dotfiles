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

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-homebrew,
      nix-darwin,
      nixos-wsl,
      ...
    }:
    let
      mkHMSystemModule =
        { imports, stateVersion }: import ./modules/hm-system.nix { inherit imports stateVersion; };
      mkDarwin =
        {
          system,
          modules,
          username,
          imports,
          stateVersion,
          dwnStateVersion,
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            ./darwin
            (mkHMSystemModule {
              inherit stateVersion;
              imports = imports ++ [ ./home/default ];
            })
            { system.stateVersion = dwnStateVersion; }
          ]
          ++ modules;
          specialArgs = {
            inherit inputs username;
          };
        };
      mkNix =
        {
          system,
          modules,
          username,
          imports,
          stateVersion,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModules.home-manager
            (mkHMSystemModule {
              inherit stateVersion;
              imports = imports ++ [ ./home/default ];
            })
            { system = { inherit stateVersion; }; }
          ]
          ++ modules;
          specialArgs = {
            inherit inputs username;
          };
        };
      mkWSL =
        {
          system,
          modules,
          username,
          imports,
          stateVersion,
        }:
        mkNix {
          inherit
            system
            username
            stateVersion
            ;
          imports = imports ++ [ ./modules/windows ];
          modules = [
            nixos-wsl.nixosModules.default
            {
              wsl.enable = true;
              wsl.defaultUser = username;
            }
          ]
          ++ modules;
        };
    in
    {
      darwinConfigurations = {
        mac = mkDarwin {
          system = "aarch64-darwin";
          username = "marvin";
          modules = [ ./darwin/mac ];
          imports = [ ./home/mac ];
          stateVersion = "25.11";
          dwnStateVersion = 6;
        };
      };
      nixosConfigurations = {
        wsl-soptim = mkWSL {
          system = "x86_64-linux";
          username = "maha";
          modules = [ ./nixos/wsl-soptim ];
          imports = [ ./home/wsl-soptim ];
          stateVersion = "25.11";
        };
      };
    };
}
