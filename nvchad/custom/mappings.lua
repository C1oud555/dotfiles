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
    -- ["<leader>n"] = "",
    ["<leader>b"] = "",
    ["<leader>rn"] = "",
  }
}

M.general = {
  n = {
    -- [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>,"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    [";"] = { "<cmd> Telescope command_history <CR>", "Search Commands" },
    ["<leader>;"] = { "<cmd> Telescope commands <CR>", "Search Commands" },
    ["<leader>`"] = { "<cmd> bprevious <CR>", "Last buffer" },
    ["<leader>."] = { function() require("telescope.builtin").find_files { cwd = vim.fn.expand("%:p:h") } end,
      "Last buffer" },
    ["<leader> "] = { "<cmd> Telescope find_files <CR>", "Git files" },

    ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>", "Debug breakpoint" },
    ["<leader>dc"] = { "<cmd> DapContinue <CR>", "Debug continue" },
    ["<leader>di"] = { "<cmd> DapStepInto <CR>", "Debug continue" },
    ["<leader>do"] = { "<cmd> DapStepOver <CR>", "Debug continue" },
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
    ["<leader>fg"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    ["<leader>F"] = { "<cmd> Telescope file_browser <CR>", "File browser" },
    ["<leader>ss"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },

    -- project
    ["<leader>pp"] = { "<cmd> Telescope project <CR>", "Project switcher" },
    ["<leader>pg"] = {
      function()
        local ft = vim.bo.filetype
        if ft == "cpp" or ft == "c" then
          require("cmake-tools").generate{}
        else
          print("not set for this file type")
        end
      end,
      "Project generate" },
    ["<leader>pc"] = {
      function()
        local ft = vim.bo.filetype
        if ft == "cpp" or ft == "c" then
          require("cmake-tools").build{}
        else
          print("not set for this file type")
        end
      end,
      "Project compile" },
    ["<leader>pr"] = {
      function()
        local ft = vim.bo.filetype
        if ft == "cpp" or ft == "c" then
          require("cmake-tools").run{}
        else
          print("not set for this file type")
        end
      end,
      "Project run"
    },

    -- buffers
    ["<leader>bb"] = { "<cmd> Telescope buffers <CR>", "Find oldfiles" },
    ["<leader>bn"] = { "<cmd> enew <CR>", "New buffer" },
    ["<leader>bk"] = { "<cmd> bw! <CR>", "Find oldfiles" },

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
    ["gd"] = {
      function()
        require("telescope.builtin").lsp_definitions()
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
      "Document Diagnostics",
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
        require("nvchad.renamer").open()
      end,
      "LSP formatting",
    },
  }
}

return M
