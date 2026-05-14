{ lib, pkgs, ... }:
let
  mkJDK =
    version:
    let
      home = ".jdk/java${version}";
    in
    {
      file."${home}".source = pkgs."jdk${version}";
      shellAliases."mvn${version}" = ''JAVA_HOME="${home}" mvn'';
    };
in
{
  home = lib.mkMerge [
    (mkJDK "8")
    (mkJDK "17")
    (mkJDK "21")
    (mkJDK "") # latest
    {
      packages = with pkgs; [
        jdk
        dotnet-sdk_10
        dotnet-runtime_10
        maven
        gradle
      ];

      sessionVariables = {
        DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet";
      };
    }
  ];
  programs.go.enable = true;
}
