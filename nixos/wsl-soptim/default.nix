{ username, ... }:
{
  imports = [ ./shell.nix ];

  wsl.interop = {
    register = true;
  };

  networking = {
    hostName = "wsl-soptim";
    search = [ "soptim.net" ];
  };

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
