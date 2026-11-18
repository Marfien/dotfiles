{ ... }:
let
  mountHome = "/mnt/c/Users/maha";
in
{
  windows = {
    enable = true;
    wingetPackages = [
      "DEVCOM.JetBrainsMonoNerdFont"
      "Spotify.Spotify"
      "Microsoft.PowerToys"
      "Discord.Discord"
      "Anki.Anki"
      "AutoHotkey.AutoHotkey"
      "ahrm.sioyek"
      "wez.wezterm"
    ];
    symlinks = {
      "${mountHome}/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/mac-umlauts.ahk" =
        ./mac-umlauts.ahk;
      "${mountHome}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" =
        ./windows-term-settings.json;
    };
    copy = {
      "${mountHome}/.wslconfig" = ./.wslconfig;
    };
  };

}
