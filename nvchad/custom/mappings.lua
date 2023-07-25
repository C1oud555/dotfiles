local M = {}

M.disabled = {
  -- i = {
  --   [ "<C-b>" ] = "",
  --   [ "<C-e>" ] = "",
  --   [ "<C-h>" ] = "",
  --   [ "<C-l>" ] = "",
  --   [ "<C-j>" ] = "",
  --   [ "<C-k>" ] = "",
  -- },
  n = {
    ["<leader>n"] = "",
    ["<leader>pt"] = "",
    ["<leader>rn"] = "",
  }
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>,"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    ["<leader>:"] = { "<cmd> Telescope command_history <CR>", "Search Commands" },
    ["<leader>`"] = { "<cmd> bprevious <CR>", "Last buffer" },
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

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>fr"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
    ["<leader>F"] = { "<cmd> Telescope file_browser <CR>", "File browser" },

    -- project
    ["<leader>p"] = { "<cmd> Telescope project <CR>", "Project switcher" },

    -- git

    -- pick a hidden term

    -- theme switcher
  },
}

M.lspconfig = {
  plugin = true,
  n = {
    ["gr"] = {
      function()
        require("telescope.builtin").lsp_references()
      end,
      "LSP references",
    },
    ["<leader>cs"] = {
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      "Document Symbols",
    },
    ["<leader>cd"] = {
      function()
        require("telescope.builtin").diagnostics()
      end,
      "Document Symbols",
    },
    ["<leader>cS"] = {
      function()
        require("telescope.builtin").lsp_workspace_symbols()
      end,
      "Workspace Symbols",
    },
    ["<leader>cf"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "LSP formatting",
    },
    ["<leader>cr"] = {
      function()
        require("nvchad_ui.renamer").open()
      end,
      "LSP formatting",
    },
  }
}

return M
