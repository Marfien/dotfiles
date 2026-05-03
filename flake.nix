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
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      makePkgs = system: import nixpkgs { inherit system; };
      mkHome =
        { system, modules }:
        home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs; };
          pkgs = makePkgs system;
          modules = [ ./nix/home/default ] ++ modules;
        };
    in
    {
      homeConfigurations = {
        mac = mkHome {
          system = "aarch64-darwin";
          modules = [ ./nix/home/mac ];
        };
        wsl = mkHome {
          pkgs = makePkgs "x86_64-linux";
          modules = [ ./nix/home/wsl ];
        };
      };
    };
}
