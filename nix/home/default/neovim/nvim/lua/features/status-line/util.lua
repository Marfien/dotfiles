local M = {}

function M.project_root()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients > 0 and clients[1].config.root_dir then
    return clients[1].config.root_dir
  end
  local git_dir = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel 2>/dev/null")
  if vim.v.shell_error == 0 then
    return vim.trim(git_dir)
  end

  return vim.fn.getcwd()
end

return M
