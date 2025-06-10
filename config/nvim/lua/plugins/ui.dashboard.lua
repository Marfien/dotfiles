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
        sections = {
          -- Column 1
          {
            section = "terminal",
            cmd = "catimg ~/.config/nvim/assets/dashboard.png",
            height = 30,
            padding = 1,
            pane = 1,
          },
          {
            section = "startup",
            pane = 1,
          },
          -- Column 2
          {
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            padding = 1,
            limit = 14,
            pane = 2,
          },
          {
            pane = 2,
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
