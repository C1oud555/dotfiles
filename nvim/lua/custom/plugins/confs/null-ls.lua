local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
   -- Lua
   b.formatting.stylua,
   b.formatting.autopep8,
   b.formatting.clang_format,
   b.formatting.scalafmt,
   b.formatting.latexindent,
}

local M = {}

M.setup = function()
   null_ls.setup {
      debug = true,
      sources = sources,

      -- format on save
      on_attach = function(client)
         if client.resolved_capabilities.document_formatting then
            vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
         end
      end,
   }
end

return M
