---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  hl_override = highlights.override,
  hl_add = highlights.add,

  theme = "onedark",
  theme_toggle = { "onedark", "one_light" },
  transparency = true,
  lsp_semantic_tokens = true,

  cheatsheet = { theme = "simple" },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
