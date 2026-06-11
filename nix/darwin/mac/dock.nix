{ username, ... }:
let
  mkHomeManagerApp = name: "/Users/${username}/Applications/Home Manager Apps/${name}.app";
  mkSystemApp = name: "/System/Applications/${name}.app";
  mkUserApp = name: "/Users/${username}/Applications/${name}.app";
  mkRootApp = name: "/Applications/${name}.app";
in
{
  system.defaults.dock = {
    persistent-apps = [
      (mkHomeManagerApp "Zen Browser (Beta)")
      (mkHomeManagerApp "WezTerm")
      (mkSystemApp "Mail")
      (mkUserApp "Crunchyroll")
      (mkRootApp "Discord")
      (mkRootApp "Spotify")
    ];
    persistent-others = [
      {
        folder = {
          path = "/Users/${username}/Downloads";
          displayas = "stack";
          showas = "fan";
          arrangement = "date-added";
        };
      }
    ];
  };
}
