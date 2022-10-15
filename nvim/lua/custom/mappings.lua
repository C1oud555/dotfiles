local M = {}

M.general = {
  i = {

    -- go to  beginning and end
    ["<C-a>"] = { "<ESC>^i", "論 beginning of line" },
    ["<C-e>"] = { "<End>", "壟 end of line" },

    -- navigate within insert mode
    ["<C-b>"] = { "<Left>", "  move left" },
    ["<C-f>"] = { "<Right>", " move right" },
    ["<C-n>"] = { "<Down>", "  move down" },
    ["<C-p>"] = { "<Up>", "  move up" },
  },
}

return M
