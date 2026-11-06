{ ... }:
{
  homebrew = {
    enable = true;
    enableZshIntegration = true;

    casks = [
      "curseforge"
      "linearmouse"
      "discord"
      "spotify"
    ];

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    global.brewfile = true;
  };
}
