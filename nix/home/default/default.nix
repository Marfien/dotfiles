{ ... }:
{
  imports = [
    ./shell.nix
    ./cli.nix
    ./git
    ./tmux.nix
    ./neovim
    ./sdk.nix
    ./devops.nix
  ];
  programs.home-manager.enable = true;
  home = {
    preferXdgDirectories = true;
  };
}
