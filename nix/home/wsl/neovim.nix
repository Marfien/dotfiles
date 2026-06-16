{ lib, ... }:
{
  programs.neovim.initLua =
    lib.mkAfter
      # lua
      ''
        vim.uv.new_timer():start(0, 2000, function()
          vim.system({
            "/mnt/c/Windows/System32/reg.exe",
            "Query",
            "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
            "/v",
            "AppsUseLightTheme",
          }, { text = true }, function(res)
            if res.code ~= 0 then
              vim.notify_once("Could not detect system theme", vim.log.levels.WARN)
              return
            end

            -- AppsUseLightTheme REG_DWORD 0x0 : dark
            -- AppsUseLightTheme REG_DWORD 0x1 : light
            vim.schedule(function()
              vim.api.nvim_set_option_value("background", res.stdout:match("0x1") and "light" or "dark", {})
            end)
          end)
        end)
      '';
}
