{ pkgs, ... }:
let
  withPriority =
    pkg: priority:
    pkg.overrideAttrs (oldAttrs: {
      meta = oldAttrs.meta // {
        inherit priority;
      };
    });
in
{
  imports = [
    ./shell.nix
    ./wezterm
    ./browser.nix
  ];
  home = {
    stateVersion = "25.11";

    packages = with pkgs; [
      (withPriority orbstack 1)
      sioyek
      # issures with autoupdate
      #raycast
      #discord
      #spotify
      anki-bin
    ];
  };
}
