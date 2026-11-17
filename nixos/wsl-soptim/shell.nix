{ pkgs, username, ... }:
{
  programs.zsh = {
    enable = true;
    # home-manager already runs compinit; don't run it twice
    enableGlobalCompInit = false;
  };
  environment.shells = [ pkgs.zsh ];
  users.users."${username}" = {
    shell = pkgs.zsh;
  };
}
