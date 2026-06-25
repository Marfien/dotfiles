{ username, ... }:
{
  imports = [ ./shell.nix ];

  wsl.interop = {
    register = true;
    includePath = false;
  };

  wsl.wslConf.interop.appendWindowsPath = false;

  networking = {
    hostName = "wsl-soptim";
    search = [ "soptim.net" ];
  };

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
