local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local fmt = require("luasnip.extras.fmt").fmt
local extras = require "luasnip.extras"
local m = extras.m
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

local filename = function()
  local fname = vim.fn.fnamemodify(vim.fn.expand "%", ":t")
  local w = string.gmatch(fname, "([^" .. "." .. "]+)")
  return w() .. ".vcd"
end

return {
  s("box", {
    t "/*----------",
    l(l._1:gsub(".", "-"), 1),
    t { "--------*", "" },

    t " *---     ",
    i(1, "header title"),
    t { "       ---*", "" },

    t " *----------",
    l(l._1:gsub(".", "-"), 1),
    t { "--------*/", "" },
  }),
  s("vcddump", {
    t { "initial begin", "" },
    t { '    $dumpfile("' },
    f(filename, {}),
    t { '");', "" },
    t { "    $dumpvars;", "" },
    t { "end" },
  }),
}
