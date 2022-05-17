return {

   {
      "~/.config/nvim/lua/custom/plugins/chIME",
      config = function()
         require("chIME").setup()
      end,
   },

   {
      "jose-elias-alvarez/null-ls.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.confs.null-ls").setup()
      end,
   },

   { "nathom/filetype.nvim" },

   {
      "luukvbaal/stabilize.nvim",
      config = function()
         require("stabilize").setup()
      end,
   },

   {
      "karb94/neoscroll.nvim",
      config = function()
         require("neoscroll").setup()
      end,

      -- lazy loading
      setup = function()
         require("core.utils").packer_lazy_load "neoscroll.nvim"
      end,
   },
}
