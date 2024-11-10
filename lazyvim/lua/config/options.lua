-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here


local g = vim.g


vim.o.shell = "fish"

if g.neovide then
  g.neovide_transparency = 1.0
  -- g.neovide_window_blurred = true
  -- g.neovide_floating_blur_amount_x = 2.0
  -- g.neovide_floating_blur_amount_y = 2.0
end
