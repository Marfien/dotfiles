vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "copilot-*",
  callback = function()
    vim.wo.conceallevel = 0
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})

local function select_model()
  ---@diagnostic disable-next-line: missing-parameter
  require("plenary.async").run(function()
    local perfered_models = { "claude-opus-4.6", "gpt-5.2-codex", "auto" }

    local models = require("CopilotChat.client"):models()
    for _, perfered_model in ipairs(perfered_models) do
      local model = models[perfered_model]
      if model ~= nil then
        require("CopilotChat").config.model = perfered_model
        vim.notify("Selected Model: " .. model.name)
        return
      end
    end

    vim.notify("Could not find prefered model. Please select one manually!", vim.log.levels.WARN)
  end)
end

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      select_model()
    end,
    opts = {
      window = {
        layout = "vertical",
        width = 0.3,
        height = 1,
        border = vim.g.borderstyle.name,
      },
      headers = {
        user = " 👤 Dummy: ",
        assistant = " 🤖 Clanker: ",
        tool = " 🔧 Thingy: ",
      },
      show_folds = true,
      insert_at_end = false,
      resources = "buffer:visible",
      chat_autocomplete = false,
    },
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "pxwg/blink-cmp-copilot-chat",
    },
    opts = {
      sources = {
        per_filetype = {
          ["copilot-chat"] = { "copilot_c", "path", "buffer" },
        },
        providers = {
          copilot_c = {
            name = "CopilotChat",
            module = "blink-cmp-copilot-chat",
          },
        },
      },
    },
  },
}
