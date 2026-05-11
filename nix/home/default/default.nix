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
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home = {
    preferXdgDirectories = true;
  };
}
