return {
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },
  ["windwp/nvim-autopairs"] = {
    config = function()
      require "nvim-autopairs".setup{}
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.remove_rule("\'")
      npairs.remove_rule("`")
      npairs.add_rule(
        Rule("'", "'")
          :with_pair(cond.not_filetypes({"verilog", "systemverilog"}))
      )
      npairs.add_rule(
        Rule("`", "`")
          :with_pair(cond.not_filetypes({"verilog", "systemverilog"}))
      )
    end
  },
   ["jose-elias-alvarez/null-ls.nvim"] = {
      after = "nvim-lspconfig",
      config = function()
         require "custom.plugins.confs.null-ls"
      end,
 }
}

