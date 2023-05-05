local M = {}

M.disabled = {
  i = {
    [ "<C-b>" ] = "",
    [ "<C-e>" ] = "",
    [ "<C-h>" ] = "",
    [ "<C-l>" ] = "",
    [ "<C-j>" ] = "",
    [ "<C-k>" ] = "",
  },
  n = {
    ["<leader>n"] = "",
    ["<leader>rn"] = "",
  }

}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
  i = {
    -- go to  beginning and end
    ["<C-a>"] = { "<ESC>^i", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },

    -- navigate within insert mode
    ["<C-b>"] = { "<Left>", "move left" },
    ["<C-f>"] = { "<Right>", "move right" },
    ["<C-n>"] = { "<Down>", "move down" },
    ["<C-p>"] = { "<Up>", "move up" },
  },
}


return M
