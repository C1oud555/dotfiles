local M = {}

M.treesitter = {
  ensure_installed = {
    "lua",
    "verilog",
    "rust",
    "scala",
    "comment",
    "c",
    "cpp",
    "python"
  }
}

M.nvimtree = {
   git = {
      enable = true,
      ignore = true,
      show_on_dirs = true,
      timeout = 400,
   },
   renderer = {
     icons = {
       show = {
         git = true,
       }
     }
   }
}
M.nvchadui = {
  statusline = {
    separator_style = "round",
  },
  tabufline = {
    enabled = false,
  }
}

return M
