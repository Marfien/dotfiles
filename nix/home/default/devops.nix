{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      fluxcd
      opentofu
      kubectl
    ];
  };
  programs.docker-cli.enable = true;
}
