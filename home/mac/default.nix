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
    ./neovim.nix
  ];
  home = {
    packages = with pkgs; [
      (withPriority orbstack 1)
      sioyek
      prismlauncher
      # issures with autoupdate
      #raycast
      #discord
      #spotify
      anki-bin
    ];
  };
}
