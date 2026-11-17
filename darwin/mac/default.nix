{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./dock.nix
    ./brew.nix
    ./shell.nix
  ];

  # home-manager already runs compinit; don't run it twice
  programs.zsh.enableGlobalCompInit = false;
  environment.shells = [ pkgs.zsh ];
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  users.users.${username} = {
    shell = pkgs.zsh;
  };
}
