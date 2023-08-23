local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "c",
    "cpp",
    "comment",
    "scala",
    "verilog",
    "python",
    "rust",
  },
  indent = {
    enable = true,
  },
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
  extensions_list = {
    "project", "fzf", "ui-select", "file_browser"
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
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
