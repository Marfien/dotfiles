{ username, ... }:
let
  mkHomeManagerApp = name: "/Users/${username}/Applications/Home Manager Apps/${name}.app";
  mkSystemApp = name: "/System/Applications/${name}.app";
  mkUserApp = name: "/Users/${username}/Applications/${name}.app";
in
{
  system.defaults.dock = {
    persistent-apps = [
      (mkHomeManagerApp "Zen Browser (Twilight)")
      (mkHomeManagerApp "WezTerm")
      (mkSystemApp "Mail")
      (mkHomeManagerApp "Discord")
      (mkHomeManagerApp "Spotify")
      (mkUserApp "Crunchyroll")
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
