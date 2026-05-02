{ pkgs, ... }:
let
  username = "marvin";
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
      orbstack
      meslo-lg
      raycast
      # zen
      sioyek
      discord
      anki
      spotify
    ];
  };
}
