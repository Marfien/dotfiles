{ inputs, username, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = ../../home/mac;
    extraSpecialArgs = {
      inherit inputs;
    };
  };

}
