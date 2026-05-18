{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pkgs.mas
  ];
  homebrew = {
    enable = true;
    enableZshIntegration = true;

    casks = [
      "curseforge"
      "linearmouse"
    ];

    #masApps = {
    #  "Command X" = 6448461551;
    #  "Keynote" = 409183694;
    #  "Numbers" = 409203825;
    #  "Pages" = 409201541;
    #  "Plash" = 1494023538;
    #  "Shareful" = 1522267256;
    #};

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    global.brewfile = true;
  };
}
