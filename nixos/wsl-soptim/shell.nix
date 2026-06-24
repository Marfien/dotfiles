{ pkgs, username, ... }:
{
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
  users.users."${username}" = {
    shell = pkgs.zsh;
  };
}
