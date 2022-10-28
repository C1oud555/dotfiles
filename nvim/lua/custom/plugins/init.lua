return {
  ["~/.config/nvim/lua/custom/plugins/chIME"] = {
    config = function()
      require("chIME").setup()
    end,
  },
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },
  ["L3MON4D3/LuaSnip"] = {
    config = function()
      require "custom.plugins.confs.luasnip"
    end,
  },
  ["windwp/nvim-autopairs"] = {
    config = function()
      require "custom.plugins.confs.autopairs"
    end,
  },
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.confs.null-ls"
    end,
  },
  ["kylechui/nvim-surround"] = {
    config = function()
      require("nvim-surround").setup {}
    end,
  },
}



