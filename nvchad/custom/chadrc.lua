---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "onedark",
  theme_toggle = { "onedark", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,
  lsp_semantic_tokens = true,
  nvdash = {
    load_on_startup = true,
    buttons = {
      { "  Find Project",  "Spc p",   "Telescope project" },
      { "  Find File",     "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word",    "Spc f w", "Telescope live_grep" },
      { "  Bookmarks",     "Spc m a", "Telescope marks" },
      { "  Themes",        "Spc t h", "Telescope themes" },
      { "  Mappings",      "Spc c h", "NvCheatsheet" },
    },
  },
  cheatsheet = { theme = "simple" },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
