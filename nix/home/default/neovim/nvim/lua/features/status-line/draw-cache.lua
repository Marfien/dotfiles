local M = {}

local layout = nil

local components = {}
local drawing = false

local sep = " │ "

local function section(hl, keys)
  local rendered = {}
  for i, key in ipairs(keys) do
    rendered[i] = components[key]
  end

  rendered = vim.tbl_filter(function(value)
    return value and (type(value) == "number" or #value > 0)
  end, rendered)

  return hl .. " " .. vim.fn.join(rendered, hl .. sep) .. " "
end

local function build()
  local hl = components.highlights

  if layout == nil or #layout ~= 6 then
    error("Layout needs to be set in format {a} {b} {c}  {x} {y} {z}")
  end

  local left = section(hl[1], layout[1])
      .. section(hl[2], layout[2])
      .. section(hl[3], layout[3])
  local right = section(hl[3], layout[4])
      .. section(hl[2], layout[5])
      .. section(hl[1], layout[6])

  return left .. "%=" .. right
end

function M.draw(sections_layout)
  if sections_layout ~= nil then
    layout = sections_layout
  end

  drawing = true
  vim.o.statusline = build()
end

function M.update(key, value)
  if components[key] == value then
    return
  end

  components[key] = value
  if drawing then
    M.draw()
  end
end

return M
