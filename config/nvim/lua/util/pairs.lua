local M = {}

-- Default configuration
M.config = {
  pairs = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ['"'] = '"',
    ["'"] = "'",
    ["`"] = "`",
  },
}

-- Allow user configuration
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  M._setup_autocmds()
end

-- Helpers
local function get_char_after_cursor()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  return line:sub(col, col)
end

local function get_char_before_cursor()
  local col = vim.fn.col(".") - 1
  local line = vim.fn.getline(".")
  return line:sub(col, col)
end

local function in_string_node()
  return vim.list_contains(vim.treesitter.get_captures_at_cursor(), "string")
end

-- Insert or skip pairs
function M.handle_open(open)
  local close = M.config.pairs[open]
  if not close then
    return open
  end

  -- Skip inside string or if next char same as close
  if in_string_node() or get_char_after_cursor() == open then
    return open
  end

  return open .. close .. "<Left>"
end

-- When typing a closing character
function M.handle_close(close)
  local next_char = get_char_after_cursor()
  if next_char ~= close or in_string_node() then
    return close
  else
    -- Just jump over it instead of inserting another
    return "<Right>"
  end
end

-- Handle backspace (delete both sides if empty pair)
function M.handle_backspace()
  local before = get_char_before_cursor()
  local after = get_char_after_cursor()
  if M.config.pairs[before] == after then
    return "<Del><BS>"
  end
  return "<BS>"
end

-- Handle Enter inside empty pair
function M.handle_cr()
  local before = get_char_before_cursor()
  local after = get_char_after_cursor()
  if M.config.pairs[before] == after then
    return "<CR><Esc>O"
  end
  return "<CR>"
end

-- Setup all keymaps
function M._setup_mappings()
  -- opening pairs
  for open, close in pairs(M.config.pairs) do
    if close then
      vim.keymap.set("i", open, function()
        return M.handle_open(open)
      end, { expr = true, noremap = true })

      -- closing pairs
      vim.keymap.set("i", close, function()
        return M.handle_close(close)
      end, { expr = true, noremap = true })
    end
  end

  vim.keymap.set("i", "<BS>", M.handle_backspace, { expr = true, noremap = true })
  vim.keymap.set("i", "<CR>", M.handle_cr, { expr = true, noremap = true })
end

return M
