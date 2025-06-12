return {
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "RaafatTurki/hex.nvim",
    config = function()
      require("hex").setup()
    end,
  },
  {
    "m4xshen/hardtime.nvim",
    opts = {},
  },
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          position = "float",
        },
      },
    },
    keys = {
      {
        "<leader>.",
        LazyVim.pick("files", { root = false }),
        desc = "Find Files (cwd)",
      },
    },
  },
  {
    "Mythos-404/xmake.nvim",
    version = "^3",
    lazy = true,
    event = "BufReadPost",
    config = true,
  },
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin", "user.cpp_build" },
    },
  },
}
