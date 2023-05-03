local map = vim.keymap.set

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- exit term
map("t", "<esc>", "<c-\\><c-n>", { desc = "Enter nornal mode" })
-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- function map to leader
local function leaderMap(lhs, rhs, opts, mode)
  vim.keymap.set(mode or "n", "<leader>" .. lhs, rhs, opts)
end

-- lsp related
map("n", "gd", vim.lsp.buf.definition, { desc = "lsp definition"})
map("n", "gD", vim.lsp.buf.declaration, { desc = "lsp declaration"})
map("n", "gi", vim.lsp.buf.implementation, { desc = "lsp implementation"})
map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "lsp references"})
map("n", "gs", vim.lsp.buf.document_symbol)
map("n", "gS", vim.lsp.buf.workspace_symbol)
map("n", "[d", vim.diagnostic.goto_prev, { desc = "last error"})
map("n", "]d", vim.diagnostic.goto_next, { desc = "next error"})
map("n", "K", vim.lsp.buf.hover, { desc = "Hover"})


-- common
leaderMap(";", "<cmd>Telescope command_history<cr>", { desc = "Exec Comands" })
leaderMap(":", "<cmd>Telescope commands<cr>", { desc = "Exec Comands" })
leaderMap(",", "<cmd>Telescope buffers show_all_buffers=true<cr>", { desc = "All buffer" })
leaderMap("<space>", "<cmd>Telescope find_files<cr>", { desc = "Buffers under projects" })

-- code
leaderMap("ca", vim.lsp.buf.format, { desc = "Code action" })
leaderMap("cf", vim.lsp.buf.format, { desc = "Format buffer" })
leaderMap("cl", vim.lsp.codelens.run, { desc = "Code lens" })
leaderMap("cs", vim.lsp.buf.signature_help, { desc = "Signature Help" })
leaderMap("cr", vim.lsp.buf.rename, { desc = "rename" })
leaderMap("cx", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Format buffer" })

-- dap
leaderMap("dr", "<cmd>lua require('dap').repl.toggle()<cr>", { desc = "Format buffer" })

leaderMap("e", vim.diagnostic.open_float, { desc = "Format buffer" })

-- file
leaderMap("ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
leaderMap("fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

-- search
leaderMap("ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search line" })

-- windows
leaderMap("ww", "<C-W>p", { desc = "Other window" })
leaderMap("wd", "<C-W>c", { desc = "Delete window" })
leaderMap("ws", "<C-W>s", { desc = "Split window below" })
leaderMap("wv", "<C-W>v", { desc = "Split window right" })

-- open
leaderMap("op", "<cmd>NvimTreeToggle<cr>", { desc = "Open Nvim Tree" })
leaderMap("ot", "<cmd>ToggleTerm direction=float<cr>", { desc = "Open Nvim Tree" })

-- project
leaderMap("pp", "<cmd>lua require('telescope').extensions.projects.projects{}<cr>", { desc = "Open Nvim Tree" })

