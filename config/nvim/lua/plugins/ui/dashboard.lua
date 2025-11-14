local augroup = vim.api.nvim_create_augroup("dashboard", {})

vim.api.nvim_create_autocmd("BufNew", {
  group = augroup,
  callback = vim.schedule_wrap(function(event)
    if
      vim.api.nvim_buf_is_valid(event.buf)
      and vim.api.nvim_buf_get_name(event.buf) == ""
      and vim.bo.filetype == ""
      and vim.bo.modifiable
    then
      require("btw").open(event.buf)
    end
  end),
})

vim.api.nvim_create_autocmd("User", {
  group = augroup,
  pattern = "BtwOpened",
  callback = function(event)
    vim.bo.modifiable = false
    vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "<cmd>qa<cr>", { desc = "Quit" })
  end,
})

vim.schedule(function()
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = augroup,
    callback = function()
      if vim.bo.filetype == "starter" then
        vim.api.nvim_win_set_cursor(0, { 1, 1 })
      end
    end,
  })
end)

return {
  {
    "letieu/btw.nvim",
    lazy = false,
    opts = {
      text = [[
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
]],
    },
  },
}
