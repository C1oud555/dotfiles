local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "verilog",
    "rust",
    "scala",
    "comment",
    "c",
    "cpp",
    "python",
  },
  indent = {
    enable = true,
    disable = {
      "python",
    },
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
