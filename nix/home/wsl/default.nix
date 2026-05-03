{ pkgs, ... }:
let
  username = "maha";
in
{
  imports = [
    ./shell.nix
    ./claude-code.nix
  ];
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "25.11";

    packages = with pkgs; [
      awscli2
      xclip 
    ];
  }
}
