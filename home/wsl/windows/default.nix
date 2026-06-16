{ ... }:
let
  mountHome = "/mnt/c/Users/maha";
in
{
  windows = {
    enable = true;
    chocoPackages = [
      "nerd-fonts-Meslo"
      "spotify"
      "powertoys"
      "discord"
      "anki"
      "autohotkey"
      "sioyek"
      "android-sdk"
    ];
    symlinks = {
      "${mountHome}/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/mac-umlauts.ahk" =
        ./mac-umlauts.ahk;
      "${mountHome}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" =
        ./windows-term-settings.json;
      "${mountHome}/.wslconfig" = ./.wslconfig;
    };
  };

}
