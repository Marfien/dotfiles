{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jdk25
    dotnet-sdk_10
    dotnet-runtime_10
    maven
    gradle
    gcc
  ];
  programs.go.enable = true;
}
