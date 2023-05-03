-- return {
--   'simrat39/rust-tools.nvim',
--   event = "VeryLazy",
--   config = function()
--     local rt = require("rust-tools")
--     local lspc = require("plugins.lspconf")
--     rt.setup {
--       runnables = {
--         use_telescope = true,
--       },
--       debuggables = {
--         use_telescope = true,
--       },
--       server = {
--         on_attach = function(client, bufnr)
--           lspc.on_attach(client, bufnr)
--           vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
--         end,
--         capabilities = lspc.capabilities,
--         settings = {
--           ["rust-analyzer"] = {
--             check = { command = "clippy" },
--             cargo = { features = "all" },
--             imports = { prefix = "self", granularity = { group = "module", enforce = true } },
--             assist = { emitMustUse = true },
--             lens = { location = "above_whole_item" },
--             semanticHighlighting = {
--               operator = { specialization = { enable = true } },
--               puncutation = {
--                 enable = true,
--                 specialization = { enable = true },
--                 separate = { macro = { bang = true } }
--               }
--             },
--           }
--         }
--       },
--     }
--     rt.inlay_hints.enable()
--   end
-- }
return {
  'simrat39/rust-tools.nvim',
  config = function()
    local rt = require("rust-tools")
    local lspc = require("plugins.lspconf")
    rt.setup {
      server = {
        on_attach = function(client, bufnr)
          lspc.on_attach(client, bufnr)
          vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
        end,
      },
    }
  end
}
