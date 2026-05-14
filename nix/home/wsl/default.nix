{ pkgs, ... }:
{
  imports = [
    ./shell.nix
    ./claude-code.nix
  ];
  home = {
    stateVersion = "25.11";

    packages = with pkgs; [
      awscli2
      xclip
    ];
  };
}
