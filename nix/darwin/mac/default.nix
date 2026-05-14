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

  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    shell = pkgs.zsh;
  };
}
