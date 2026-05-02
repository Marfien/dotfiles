{ ... }:
{
  imports = [
    ./shell.nix
    ./cli.nix
    ./git
    ./tmux.nix
    ./neovim.nix
    ./sdk.nix
    ./devops.nix
  ];
  programs.home-manager.enable = true;
}
