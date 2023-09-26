local utils = require "core.utils"

local on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad_ui.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- for c/c++
lspconfig["clangd"].setup {
  on_attach    = on_attach,
  capabilities = capabilities,
  cmd          = {
    "clangd",
    "-j=4",
    "--clang-tidy",
    -- "--completion-style=detailed",
    "--cross-file-rename",
    "--header-insertion=iwyu",
  },
}

-- for rust
lspconfig["rust_analyzer"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        command = "clippy"
      }
    }
  }
}

-- for python
lspconfig["pylsp"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- for verilog
lspconfig["verible"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "verible-verilog-ls",
    "--rules_config_search",
  },
}

-- for lua
lspconfig["lua_ls"].setup {
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
