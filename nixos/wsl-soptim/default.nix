{ username, pkgs, ... }:
{
  networking = {
    hostName = "nixos";
    search = [ "soptim.net" ];
  };

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
