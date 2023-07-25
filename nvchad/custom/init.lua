-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h16"
  vim.g.neovide_transparency = 0.95
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_macos_alt_is_meta = true
end

local g = vim.g
local opt = vim.opt

g.maplocalleader = ","

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
