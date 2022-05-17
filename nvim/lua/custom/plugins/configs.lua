local M = {}

M.treesitter = {
   ensure_installed = {
      "lua",
      "python",
      "scala",
      "latex",
      "comment",
      "verilog",
      "markdown",
   },
}

M.nvimtree = {
   git = {
      enable = true,
   },
}

return M
