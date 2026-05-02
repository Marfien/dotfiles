{
  description = "My dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      makePkgs = system: import nixpkgs { inherit system; };
      mkHome =
        inputs@{ system, modules }:
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
