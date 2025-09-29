vim.api.nvim_create_autocmd("User", {
  pattern = "BtwOpened",
  callback = function()
    vim.bo.modifiable = false
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
 
I use Neovim (BTW)]],
    },
  },
}
