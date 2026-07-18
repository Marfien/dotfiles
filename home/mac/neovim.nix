{ lib, ... }:
{
  programs.neovim.initLua =
    lib.mkAfter
      # lua
      ''
        vim.uv.new_timer():start(0, 2000, function()
          vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }, function(res)
            -- With light mode the command fails as the entry is not present.
            -- It's not nice but that's how it works...
            vim.schedule(function()
              vim.api.nvim_set_option_value("background", res.stdout:match("Dark") and "dark" or "light", {})
            end)
          end)
        end)
      '';
}
