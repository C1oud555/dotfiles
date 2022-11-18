local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "clangd", "pyright", "metals", "rust_analyzer" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig["svlangserver"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = function(client)
    -- local path = client.workspace_folders[1].name

    client.config.settings.systemverilog = {
      includeIndexing = { "**/*.{sv,svh}" },
      excludeIndexing = { "test/**/*.sv*" },
      defines = {},
      launchConfiguration = "verilator -sv -Wall --timing --lint-only",
      formatCommand = "verible-verilog-format",
    }

    client.notify "workspace/didChangeConfiguration"
    return true
  end,
}
