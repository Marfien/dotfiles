local timeout_seconds = 60
local file_ignore_patterns = {
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
}

local resume_timeout = nil

local function on_close()
  if resume_timeout ~= nil then
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
      { "nvim-tree/nvim-web-devicons" },
      "folke/noice.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    opts = {
      pickers = {
        lsp_definitions = {
          theme = "dropdown",
        },
        lsp_references = {
          theme = "dropdown",
        },
        lsp_implementations = {
          theme = "dropdown",
        },
        live_grep = {
          file_ignore_patterns = file_ignore_patterns,
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
        find_files = {
          hidden = true,
          file_ignore_patterns = file_ignore_patterns,
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

      telescope.setup(vim.tbl_deep_extend("force", opts, {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      }))

      telescope.load_extension("fzf")
      telescope.load_extension("noice")
      telescope.load_extension("ui-select")

      vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
        callback = function(event)
          if vim.bo[event.buf].filetype == "TelescopePrompt" then
            on_close()
          end
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      { "<leader><space>", "<cmd>lua telescope_resume_or_files()<cr>", desc = "Resume or find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
      { "<leader>fn", "<cmd>Telescope noice<cr>", desc = "Telescope notifications" },
    },
  },
}
