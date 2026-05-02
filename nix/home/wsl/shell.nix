{ lib, ... }:
let
  mountPath = "/mnt/c";
in {
  programs.zsh.sessionPath = [
    "${mountPath}/WINDOWS"
    "${mountPath}/WINDOWS/system32"
    "${mountPath}/WINDOWS/System32/WindowsPowerShell/v1.0/"
  ];
}
