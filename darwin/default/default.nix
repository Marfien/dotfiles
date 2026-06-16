{ inputs, username, ... }:
{
  imports = [
    ./homebrew.nix
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      imports = [
        ../../home/default
      ];
    };
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
