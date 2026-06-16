{
  pkgs,
  username,
  ...
}:
{
  system.stateVersion = 6;
  imports = [
    ./home-manager.nix
    ./dock.nix
    ./brew.nix
  ];

  # nix config
  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    enable = false;
  };

  environment.shells = [ pkgs.zsh ];
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    shell = pkgs.zsh;
  };
}
