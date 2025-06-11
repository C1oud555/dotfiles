-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local g = vim.g
local o = vim.o
if g.neovide then
  o.guifont = "Maple Mono NF CN:h14"
  g.neovide_opacity = 0.80
  g.neovide_normal_opacity = 0.80
  g.neovide_theme = "auto"

  g.neovide_floating_blur_amount_x = 2.0
  g.neovide_floating_blur_amount_y = 2.0
end

g.clipboard = {
  name = "win32yank-wsl",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enabled = true,
}
