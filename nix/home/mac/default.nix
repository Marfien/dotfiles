{ pkgs, ... }:
let
  username = "marvin";
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
    inherit username;
    homeDirectory = "/Users/${username}";

    stateVersion = "25.11";

    packages = with pkgs; [
      (withPriority orbstack 1)
      nerd-fonts.meslo-lg
      raycast
      # zen
      sioyek
      discord
      anki-bin
      spotify
    ];
  };
}
