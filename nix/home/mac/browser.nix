{ specialArgs, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = specialArgs.inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
    languagePacks = [
      "de"
      "en-US"
    ];
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "password-manager-firefox-extension@apple.com" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/icloud-passwords/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };
  };
}
