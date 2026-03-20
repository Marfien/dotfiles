local M = {}

local text = [[
                                           .          .                        
  *+        .              o .                                                 
   |                                                               .    .    . 
 - o -          '    '                +  .:'* .               o                
   |                     |  ''       _.::'        o         |          +       
                       - o -        (_.'             '    --o--     *          
               .         |                .                 |                  
              +                                                                
                         o '        |                   '        .           o 
          +    .-.       .        --o--      / )   .     .          .          
     o        (   )         (\__/)  |   *   ( (      +              .         .
               `-'     +    )    (     .    ) ).                           .   
           +              ={      }=       / /      +                    *.    
                            )     `--,____/ /     ' .        +                o
      +                ___.(               /_.._._/~\           .              
                  _.--'     \             @|         `--./\.                   
           /~~\/~\         ,'\       ,    ,'               `-/~\_         o    
        .-'                `-'\  ,---\   | \                     `-/\_     '   
  _/\.-'                      _) )    `. \ /                      __/~\/\-.__  
.'                           (__/       ) )                                  ` 
 
I use Neovim (BTW)
]]

local buf_prefix = "dashboard://"
local win_buf_map = {}

local function is_empty_buffer(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].buflisted
    and vim.bo[buf].filetype == ""
    and vim.bo[buf].modifiable
    and vim.api.nvim_buf_get_name(buf) == ""
end

local function is_dashboard_buffer(buf)
  return vim.api.nvim_buf_get_name(buf):sub(0, #buf_prefix) == buf_prefix
end

local function shows_dashboard(win_id)
  local buf = vim.api.nvim_win_get_buf(win_id)
  return is_dashboard_buffer(buf)
end

local function format_lines(win_id)
  local win_width = vim.api.nvim_win_get_width(win_id)
  local win_height = vim.api.nvim_win_get_height(win_id)

  ---@type string[]
  local text_lines = {}
  for line in text:gmatch("[^\r\n]+") do
    table.insert(text_lines, line)
  end

  -- Calculate the vertical padding
  local ver_padding = math.floor(win_height / 2) - math.floor(#text_lines / 2)

  -- Create the lines with the centered text
  local lines = {}
  for _ = 1, ver_padding do
    table.insert(lines, "")
  end
  for _, line in ipairs(text_lines) do
    if line ~= string.rep(" ", #line) then
      local hor_padding = math.floor((win_width - string.len(line)) / 2)
      table.insert(lines, string.rep(" ", hor_padding) .. line:gsub(" *$", ""))
    else
      table.insert(lines, "")
    end
  end
  for _ = 1, win_height - ver_padding - #text_lines do
    table.insert(lines, "")
  end

  return lines
end

local function create_win_buf(win_id)
  local buf_id = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf_id, buf_prefix .. win_id)

  vim.bo[buf_id].filetype = "dashboard"
  vim.bo[buf_id].bufhidden = "wipe"
  vim.bo[buf_id].swapfile = false
  vim.bo[buf_id].buftype = "nofile"

  vim.api.nvim_buf_set_keymap(buf_id, "n", "q", "<cmd>q<cr>", {})

  return buf_id
end

local function draw_in_window(win_id)
  vim.api.nvim_feedkeys("\28\14", "nx", false)

  local buf = win_buf_map[win_id]
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = create_win_buf(win_id)
  end

  win_buf_map[win_id] = buf

  local lines = format_lines(win_id)
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.api.nvim_win_set_buf(win_id, buf)
end

local function setup_autocmd()
  vim.api.nvim_create_autocmd("BufNew", {
    callback = vim.schedule_wrap(function(event)
      if is_empty_buffer(event.buf) then
        -- Check if buffer is actually empty
        local first_lines = vim.api.nvim_buf_get_lines(event.buf, 0, 2, false)
        if #first_lines == 1 and first_lines[1] == "" then
          vim.bo[event.buf].bufhidden = "wipe"
          draw_in_window(vim.api.nvim_get_current_win())
        end
      end
    end),
  })

  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        if shows_dashboard(win_id) then
          draw_in_window(win_id)
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd("WinResized", {
    callback = function()
      local win_id = vim.api.nvim_get_current_win()
      if shows_dashboard(win_id) then
        draw_in_window(win_id)
      end
    end,
  })
end

function M.setup()
  if vim.fn.argc() == 0 then
    vim.bo.bufhidden = "wipe"
    draw_in_window(vim.api.nvim_get_current_win())
  end
  vim.schedule(setup_autocmd)
end

return M
