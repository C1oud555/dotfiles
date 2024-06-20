local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "c",
    "cpp",
    "comment",
    "verilog",
    "python",
  },
  indent = {
    enable = true,
  },
}

M.mason = {
  ensure_installed = {
    "lua-language-server",
    "python-lsp-server"
  }
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },
  -- view = {
  --   side = "right",
  -- },

  sync_root_with_cwd = true,

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.telescope = {
  defaults = {
    layout_strategy = "horizontal",
  },
  extensions_list = {
    "project", "ui-select", "file_browser"
  },
  extensions = {
    project = {
      base_dirs = {},
      theme = "dropdown",
      order_by = "asc",
      search_by = "title",
      sync_with_nvim_tree = true,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }
    }
  },
}

return M
