local M = {}
local pluginConfs = require "custom.plugins.configs"
M.ui = {
  transparency = true,
}

M.plugins = {
  user = require "custom.plugins",
  override = {
    ["nvim-treesitter/nvim-treesitter"] = pluginConfs.treesitter,
    ["kyazdani42/nvim-tree.lua"] = pluginConfs.nvimtree,
    ["NvChad/ui"] = pluginConfs.nvchadui,
  },
  remove = {
    "williamboman/mason.nvim",
  },
}

M.mappings = require "custom.mappings"

return M
