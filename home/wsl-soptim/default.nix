{ pkgs, ... }:
let
  mountPath = "/mnt/c";
in
{
  imports = [
    ./shell.nix
    ./claude-code.nix
    ./go.nix
    ./neovim.nix
    ./windows
  ];
  home = {
    sessionPath = [
      "${mountPath}/WINDOWS"
      "${mountPath}/WINDOWS/system32"
      "${mountPath}/WINDOWS/System32/WindowsPowerShell/v1.0/"
    ];

    packages = with pkgs; [
      awscli2
      xclip
    ];
  };
}
