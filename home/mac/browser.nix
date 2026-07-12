{ lib, specialArgs, ... }:
{
  imports = [
    specialArgs.inputs.zen-browser.homeModules.beta
    ./zen-signing-fix.nix
  ];
  programs.zen-browser =
    let
      mkSpace =
        id:
        {
          name,
          icon,
          position,
          pins,
        }:
        {
          spaces.${name} = {
            inherit id;
            icon = "chrome://browser/skin/zen-icons/selectable/${icon}.svg";
            position = position;
          };
          pins = lib.mapAttrs (
            key: pin:
            lib.mkMerge [
              pin
              { workspace = id; }
            ]
          ) pins;
        };
    in
    {
      enable = true;
      setAsDefaultBrowser = true;
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
      profiles.default = lib.mkMerge [
        {
          spacesForce = true;
          pinsForce = true;
          settings = {
            "browser.warnOnQuitShortcut" = false;
            "zen.workspaces.continue-where-left-off" = true;
            "zen.view.show-newtab-button-top" = true;
            "zen.urlbar.behavior" = "normal";
            "zen.tabs.show-newtab-vertical" = false;
            "services.sync.username" = "marvin.sempa.haase@gmail.com";
            "zen.view.use-single-toolbar" = false;
          };
          pins = {
            "GitHub" = {
              id = "5fde353b-1325-427d-90f5-2429ed661950";
              url = "https://github.com";
              position = 101;
              isEssential = true;
            };
          };
        }
        (mkSpace "56c8e738-c9ab-42a9-a4e0-4272327c3bd8" {
          name = "Default";
          icon = "bookmark";
          position = 1000;
          pins = { };
        })
        (mkSpace "b3248414-7d7d-4e19-9743-dc5ddb20ad2d" {
          name = "Dev";
          icon = "terminal";
          position = 4002;
          pins = {
            "Exaclidraw" = {
              id = "1c71ba19-fde2-40a4-99c1-5661ec5606b0";
              url = "https://excalidraw.com/";
              position = 2001;
            };
          };
        })
        (mkSpace "022cd71d-740b-4206-8553-c1faefa6e5e2" {
          name = "Cooking";
          icon = "pizza";
          position = 3000;
          pins = { };
        })
        (mkSpace "a4c9dee3-5819-4090-8d62-a2a11def1570" {
          name = "Uni";
          icon = "book";
          position = 4000;
          pins = {
            "MATSE-Dienste" = {
              id = "fbccc001-74dd-4610-b5c7-39f0006c7e7a";
              url = "https://www.matse.itc.rwth-aachen.de/dienste/protected/index.php?m=azubicheck&p=azubicheck&role=student";
              position = 4001;
            };
            "ILIAS" = {
              id = "2b626868-87e5-49bc-b383-ae1441059317";
              url = "https://www.ili.fh-aachen.de/ilias.php";
              position = 4002;
            };
          };
        })
      ];
    };
}
