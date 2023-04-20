local overrides = require "custom.configs.overrides"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  { "williamboman/mason.nvim", enabled = false },
  {
    "keaising/im-select.nvim",
    config = function()
      require("im_select").setup()
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  -- { "windwp/nvim-autopairs" },
  { "kylechui/nvim-surround" },
  {
    "ggandor/leap.nvim",
    config = function()
      require "custom.configs.leap"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require "custom.configs.null-ls"
      end,
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
}
