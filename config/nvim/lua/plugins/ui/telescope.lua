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

vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
  callback = function(event)
    if vim.bo[event.buf].filetype ~= "TelescopePrompt" then
      return
    end

    if resume_timeout ~= nil then
      resume_timeout:stop()
      resume_timeout:close()
    end

    resume_timeout = vim.uv.new_timer()

    if resume_timeout == nil then
      vim.notify("Could not retrieve new timer")
      return
    end

    resume_timeout:start(1000 * timeout_seconds, 0, function()
      resume_timeout = nil
    end)
  end,
})

local function resume_or_find()
  if resume_timeout then
    require("telescope.builtin").resume()
  else
    require("telescope.builtin").find_files()
  end
end

local no_preview = {
  previewer = false,
  theme = "dropdown",
  borderchars = {
    vim.g.borderstyle.chars,
    prompt = vim.tbl_extend("force", vim.deepcopy(vim.g.borderstyle.chars), { [3] = " " }),
    results = vim.tbl_extend("force", vim.deepcopy(vim.g.borderstyle.chars), { [5] = "├", [6] = "┤" }),
    preview = vim.g.borderstyle.chars,
  },
}

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
      "folke/noice.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "jmacadie/telescope-hierarchy.nvim",
    },
    init = function()
      -- Workaround to lazy load telescope ui select
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("telescope").load_extension("ui-select")
        vim.ui.select(...)
      end
    end,
    opts = {
      defaults = {
        wrap_results = true,
        results_title = false,
        path_display = {
          "filename_first",
        },
        --border = {},
        borderchars = {
          vim.g.borderstyle.chars,
          prompt = vim.g.borderstyle.chars,
          results = vim.g.borderstyle.chars,
          preview = vim.g.borderstyle.chars,
        },
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",

          horizontal = {
            mirror = false,
          },
          vertical = {
            mirror = false,
          },
        },
        mappings = {
          n = {
            ["q"] = "close",
            -- delay require
            ["<c-q>"] = function(bufnr, opts)
              require("trouble.sources.telescope").open(bufnr, opts)
            end,
          },
          i = {
            ["<c-j>"] = "move_selection_next",
            ["<c-k>"] = "move_selection_previous",
            -- delay require
            ["<c-q>"] = function(bufnr, opts)
              require("trouble.sources.telescope").open(bufnr, opts)
            end,
          },
        },
      },
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
          preview_title = "",
          file_ignore_patterns = file_ignore_patterns,
          path_display = {
            shorten = { len = 1, exclude = { 1, -1 } },
          },
          additional_args = function(_)
            return { "--trim", "--hidden" }
          end,
        },
        find_files = vim.tbl_extend("keep", {
          hidden = true,
          layout_config = {
            height = 0.8,
          },
          file_ignore_patterns = file_ignore_patterns,
          additional_args = { "--strip-cwd-prefix" },
        }, no_preview),
        buffers = vim.tbl_extend("keep", {
          layout_config = {
            height = 0.5,
          },
          sort_mru = true,
          ignore_current_buffer = true,
        }, no_preview),
        git_branches = vim.tbl_extend("keep", {}, no_preview),
        grep_string = {
          preview_title = "",
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(vim.tbl_deep_extend("force", opts, {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_cursor(no_preview),
          },
        },
      }))

      telescope.load_extension("fzf")
      telescope.load_extension("noice")
      telescope.load_extension("hierarchy")
    end,
    -- stylua: ignore
    keys = {
      { "<leader><space>", resume_or_find, desc = "Resume or find files" },

      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
      { "<leader>fn", "<cmd>Telescope noice<cr>", desc = "Notifications" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },

      { "<leader>cs", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>ci", "<cmd>Telescope lsp_implementations<cr>", desc = "Find Implementation" },
      { "<leader>cr", "<cmd>Telescope lsp_references<cr>", desc = "Find References" },
      { "<leader>cd", "<cmd>Telescope lsp_definitions<cr>",  desc = "Goto Definition" },
      { "<leader>cS", "<cmd>Telescope hierarchy incoming_calls<cr>", desc = "Call Stack" },

      { "<leader>gb", "<cmd>Telescope git_branches<cr>",  desc = "Branches" },
      { "<leader>gs", "<cmd>Telescope git_stash<cr>",  desc = "Stashed Files" },
    },
  },
}
