return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        hidden = true,
      },
      picker = {
        sources = {
          explorer = {
            hidden = true,
          },
          files = {
            hidden = true,
            ignored = true,
            exclude = { ".git", "node_modules", ".next", ".cache" },
          },
          grep = {
            hidden = true,
            ignored = true,
            exclude = { ".git", "node_modules", ".next", ".cache" },
          },
        },
      },
      dashboard = {
        preset = {
          header = [[
   ██╗     ███████╗███████╗███████╗    ██╗███████╗    ███╗   ███╗ ██████╗ ██████╗ ███████╗
   ██║     ██╔════╝██╔════╝██╔════╝    ██║██╔════╝    ████╗ ████║██╔═══██╗██╔══██╗██╔════╝
   ██║     █████╗  ███████╗███████╗    ██║███████╗    ██╔████╔██║██║   ██║██████╔╝█████╗  
   ██║     ██╔══╝  ╚════██║╚════██║    ██║╚════██║    ██║╚██╔╝██║██║   ██║██╔══██╗██╔══╝  
   ███████╗███████╗███████║███████║    ██║███████║    ██║ ╚═╝ ██║╚██████╔╝██║  ██║███████╗
   ╚══════╝╚══════╝╚══════╝╚══════╝    ╚═╝╚══════╝    ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
  ]],
        },
      },
    },
  },
}
