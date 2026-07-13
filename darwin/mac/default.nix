{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./dock.nix
    ./brew.nix
    ./omlx.nix
  ];

  environment.shells = [ pkgs.zsh ];
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  users.users.${username} = {
    shell = pkgs.zsh;
  };
}
