require("lspconfig").texlab.setup {
   on_attach = function(client)
      client.resolved_capabilities.document_formatting = false
   end,
   settings = {
      texlab = {
         build = {
            executable = "latexmk",
            args = {
               "-shell-escape",
               "-synctex=1",
               "-interaction=nonstopmode",
               "-file-line-error",
               "-xelatex",
               "%f",
            },
            onSave = true,
            forwardSearchAfter = true,
         },
         forwardSearch = {
            executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
            args = { "-g", "%l", "%p", "%f" },
         },
      },
   },
}
