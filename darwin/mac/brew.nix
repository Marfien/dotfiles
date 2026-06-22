{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mas
  ];
  homebrew = {
    enable = true;
    enableZshIntegration = true;

    casks = [
      "curseforge"
      "linearmouse"
      "discord"
      "raycast"
      "spotify"
    ];

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    global.brewfile = true;
  };
}
