local M = {}

M.defaultIME = "com.apple.keylayout.ABC"
M.currentIME = ""
-- My IME Change Func
M.getCurrentIME = function()
   if vim.fn.has "macunix" == 1 then
      local handle = io.popen "im-select"
      M.currentIME = handle:read "*a"
      handle:close()
   end
end

M.recoverIME = function()
   if vim.fn.has "macunix" == 1 then
      local handle = io.popen("im-select " .. M.currentIME)
      handle:close()
   end
end

M.setDefaultIME = function()
   if vim.fn.has "macunix" == 1 then
      local handle = io.popen("im-select " .. M.defaultIME)
      handle:close()
   end
end

M.leave = function()
   if vim.fn.has "macunix" == 1 then
      M.getCurrentIME()
      M.setDefaultIME()
   end
end

M.setup = function()
   vim.api.nvim_exec(
      [[
    augroup chIME
    autocmd!
    autocmd InsertEnter * lua require("chIME").recoverIME()
    autocmd VimEnter    * lua require("chIME").setDefaultIME()
    autocmd InsertLeave * lua require("chIME").leave()
    augroup end
        ]],
      false
   )
end
return M
