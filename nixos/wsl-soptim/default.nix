{ username, pkgs, ... }:
{
  imports = [ ./shell.nix ];

  networking = {
    hostName = "wsl-soptim";
    search = [ "soptim.net" ];
  };

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
