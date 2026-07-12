{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  targets.darwin.defaults = lib.mkIf pkgs.stdenv.isDarwin {
    "app.zen-browser.zen" = {
      EnterprisePoliciesEnabled = true;
    }
    // config.programs.zen-browser.policies;
  };

  programs.zen-browser.package = lib.mkIf pkgs.stdenv.isDarwin (
    pkgs.lib.makeOverridable (
      _:
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta-unwrapped.overrideAttrs (old: {
        installPhase = builtins.replaceStrings [ "/usr/bin/codesign" ] [ ": " ] old.installPhase;
        dontFixup = true;
      })
    ) { }
  );
}
