{ imports, stateVersion }:
{
  inputs,
  pkgs,
  username,
  ...
}:
{
  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      home = { inherit stateVersion; };
      inherit imports;
    };
  };
}
