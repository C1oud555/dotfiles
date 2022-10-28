local options = {
  fast_wrap = {},
  disable_filetype = { "TelescopePrompt", "vim" },
}
require("nvim-autopairs").setup { options }

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

local npairs = require "nvim-autopairs"
local Rule = require "nvim-autopairs.rule"
local cond = require "nvim-autopairs.conds"
npairs.remove_rule "'"
npairs.remove_rule "`"
npairs.add_rule(Rule("'", "'"):with_pair(cond.not_filetypes { "verilog", "systemverilog" }))
npairs.add_rule(Rule("`", "`"):with_pair(cond.not_filetypes { "verilog", "systemverilog" }))
