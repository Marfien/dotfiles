local augroup = vim.api.nvim_create_augroup("dashboard", {})

vim.api.nvim_create_autocmd("User", {
  group = augroup,
  pattern = "BtwOpened",
  callback = function()
    vim.bo.modifiable = false
  end,
})

vim.api.nvim_create_autocmd("BufNew", {
  group = augroup,
  callback = function(event)
    vim.schedule(function()
      if vim.api.nvim_buf_get_name(event.buf) == "" and vim.bo.filetype == "" then
        require("btw").open(event.buf)
      end
    end)
  end,
})

return {
  {
    "letieu/btw.nvim",
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
