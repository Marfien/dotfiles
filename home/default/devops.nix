{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      fluxcd
      opentofu
      kubectl
      docker-client
    ];
  };
}
