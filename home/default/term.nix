{ lib, ... }:
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      font =
        lib.generators.mkLuaInline
          # lua
          ''wezterm.font("MesloLGL Nerd Font Mono")'';
      color_scheme =
        lib.generators.mkLuaInline
          # lua
          ''wezterm.gui.get_appearance():find("Dark") and "Tokyo Night" or "Tokyo Night Day"'';
      hide_tab_bar_if_only_one_tab = true;
      max_fps = 60;
      quote_dropped_files = "Posix";
      window_padding = {
        left = "0px";
        right = "0px";
        top = "0px";
        bottom = "0px";
      };
      use_resize_increments = true;
      send_composed_key_when_left_alt_is_pressed = true;
    };
  };
}
