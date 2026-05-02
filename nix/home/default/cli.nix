{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      jq
      tree
      curl
      bat
      fd
      ripgrep
    ];
  };
}
