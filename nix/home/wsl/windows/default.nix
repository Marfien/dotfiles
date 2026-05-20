{ ... }:
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
      "/mnt/c/Users/maha/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/mac-umlauts.ahk" =
        ./mac-umlauts.ahk;
      #"/mnt/c/Users/maha/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" =
      #  ./windows-term-settings.json;
    };
  };

}
