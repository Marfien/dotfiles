local timeout_seconds = 30
local resume_timeout = nil

local function telescope_left()
  if resume_timeout then
    resume_timeout:stop()
    resume_timeout:close()
  end

  resume_timeout = vim.loop.new_timer()

  if resume_timeout == nil then
    vim.notify("Could not retrieve new timer")
    return
  end

  resume_timeout:start(1000 * timeout_seconds, 0, function()
    resume_timeout = nil
  end)
end

function _G.telescope_resume_or_files()
  if resume_timeout then
    require("telescope.builtin").resume()
  else
    require("telescope.builtin").find_files()
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-tree/nvim-web-devicons", opts = {} },
      "folke/noice.nvim",
    },
    opts = {
      pickers = {
        find_files = {
          hidden = true,
          file_ignore_patterns = {
            ".git/",
            ".cache",
            "%.o",
            "%.a",
            "%.out",
            "%.class",
            "%.pdf",
            "%.mkv",
            "%.mp4",
            "%.zip",
          },
        },
      },
      defaults = {
        mappings = {
          n = {
            ["q"] = "close",
          },
          i = {
            ["<c-j>"] = "move_selection_next",
            ["<c-k>"] = "move_selection_previous",
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      telescope.load_extension("fzf")
      telescope.load_extension("noice")

      vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
        callback = function(event)
          if vim.bo[event.buf].filetype ~= "TelescopePrompt" then
            return
          end

          telescope_left()
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      { "<leader><space>", "<cmd>lua telescope_resume_or_files()<cr>", desc = "Resume or find files" },
      { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find files" },
      { "<leader>fl", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "Live grep" },
      { "<leader>fs", "<cmd>lua require('telescope.builtin').grep_string()<cr>", desc = "Grep string" },
      { "<leader>fn", "<cmd>Telescope noice<cr>", desc = "Telescope notifications" },
    },
  },
}
