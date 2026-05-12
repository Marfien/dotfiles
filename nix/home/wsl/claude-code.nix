{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bubblewrap
    socat
  ];
  programs.claude-code = {
    enable = true;
    # TODO: settings
  };
}
