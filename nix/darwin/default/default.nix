{ inputs, username, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
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
