local M = {}
local pluginConfs = require "custom.plugins.configs"

M.plugins = {
  user = require "custom.plugins",
  override = {
    ["nvim-treesitter/nvim-treesitter"] = pluginConfs.treesitter,
  }
}

M.mappings = require "custom.mappings"

return M
