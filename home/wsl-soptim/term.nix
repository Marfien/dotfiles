{ config, pkgs, ... }:
let
  switchThemeScript =
    pkgs.writeShellScript "sync-wezterm"
      # bash
      ''
        target="/mnt/c/Users/maha/.config/wezterm/wezterm.lua"
        mkdir -p "$(dirname "$target")"

        install -m 644 "${config.xdg.configFile."wezterm/wezterm.lua".source}" "$target"
      '';
in
{
  programs.wezterm = {
    settings.default_prog = [
      "wsl.exe"
      "--cd"
      "~"
    ];
  };

  systemd.user.services.sync-wezterm = {
    Unit = {
      Description = "Syncs wezterm config to windows file system";
      X-SwitchMethod = "stop-start";
      X-Reload-Triggers = [
        config.xdg.configFile."wezterm/wezterm.lua".source
      ];
    };
    Service.ExecStart = switchThemeScript;
    Install.WantedBy = [ "default.target" ];
  };
}
