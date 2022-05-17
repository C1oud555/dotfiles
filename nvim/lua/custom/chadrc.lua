local M = {}

M.options = {
   mouse = "",
}

M.ui = {
   theme = "onedark",
}

local userPlugins = require "custom.plugins"
local pluginConfs = require "custom.plugins.configs"

M.plugins = {
   status = {
      colorizer = true,
      alpha = true,
   },
   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.lspconfig",
      },
   },
   default_plugin_config_replace = {
      nvim_treesitter = pluginConfs.treesitter,
      nvim_tree = pluginConfs.nvimtree,
   },
   default_plugin_remove = {},
   install = userPlugins,
}

M.mappings = {
   custom = {},

   insert_nav = {
      backward = "<C-b>",
      end_of_line = "<C-e>",
      forward = "<C-f>",
      next_line = "<C-n>",
      prev_line = "<C-p>",
      beginning_of_line = "<C-a>",
   },
}

return M
