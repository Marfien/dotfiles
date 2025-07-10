return {
  {
    "folke/snacks.nvim",
    opts = {
      styles = {
        dashboard = {
          width = 500,
        },
      },
      dashboard = {
        preset = {
          header = [[    *                  *             
        __                *          
     ,db'    *     *                 
    ,d8/       *        *    *       
    888                              
    `db\       *     *               
      `o`_                    **     
 *               *   *    _      *   
       *                 / )         
    *    (\__/) *       ( (  *       
  ,-.,-.,)    (.,-.,-.,-.) ).,-.,-.  
 | @|  ={      }= | @|  / / | @|o |  
_j__j__j_)     `-------/ /__j__j__j_ 
________(               /___________ 
 |  | @| \              || o|O | @|  
 |o |  |,'\       ,   ,'"|  |  |  |  
vV\|/vV|`-'\  ,---\   | \Vv\hjwVv\//v
           _) )    `. \ /            
          (__/       ) )             
                    (_/              ]],
        },
        sections = {
          {
            section = "header",
          },
          {
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            padding = 1,
            limit = 14,
          },
          {
            icon = " ",
            title = "Git History",
            section = "terminal",
            indent = 2,
            height = 15,
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = 'git log --pretty=format:"%C(auto,yellow)%h %C(auto,brightblue)%>(12,trunc)%ad %C(auto,reset)%>|(-1,trunc)%s" --date=relative -n 14; sleep 0.1',
            ttl = 5 * 60,
          },
          {
            section = "startup",
          },
          -- hidden section
          {
            hidden = true,
            action = ":q",
            key = "q",
          },
          {
            hidden = true,
            action = ":ene | startinsert",
            key = "n",
          },
        },
      },
    },
  },
}
