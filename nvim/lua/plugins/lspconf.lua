local A = vim.api

local on_attach = function(client, bufnr)
  local capabilities = client.server_capabilities

  A.nvim_create_autocmd("CursorHold,CursorHoldI,InsertLeave", {
    callback = function() A.nvim_command "silent! vim.lsp.codelens.refresh()" end,
    buffer = bufnr,
  })

  if capabilities.documentHighlightProvider then
    A.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
    })
    A.nvim_create_autocmd("CursorHold,CursorHoldI", {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
    })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

return {
  'neovim/nvim-lspconfig',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lspconfig = require('lspconfig')
    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,

      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
              [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
              [vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types"] = true,
              [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    }
  end,
}
