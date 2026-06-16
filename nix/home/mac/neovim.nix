{ lib, ... }:
{
  programs.neovim.initLua =
    lib.mkAfter
      # lua
      ''
        vim.uv.new_timer():start(0, 2000, function()
          vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }, function(res)
            if res.code ~= 0 then
              vim.notify_once("Could not detect system theme", vim.log.levels.WARN)
              return
            end

            vim.schedule(function()
              vim.api.nvim_set_option_value("background", res.stdout:match("Dark") and "dark" or "light", {})
            end)
          end)
        end)
      '';
}
