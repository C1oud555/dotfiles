return {
  {
    "blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          org = { "orgmode" },
        },
        providers = {
          orgmode = {
            name = "Orgmode",
            module = "orgmode.org.autocompletion.blink",
            fallbacks = { "buffer" },
          },
        },
      },
    },
  },
  {
    "nvim-orgmode/org-bullets.nvim",
    event = "VeryLazy",
    ft = { "org" },
    opts = {},
  },
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      "nvim-orgmode/org-bullets.nvim",
      "danilshvalov/org-modern.nvim",
    },
    event = "VeryLazy",
    ft = { "org" },
    opts = {
      ui = {
        input = {
          use_vim_ui = true,
        },
        menu = {
          handler = function(data)
            require("org-modern.menu")
              :new({
                window = {
                  margin = { 1, 0, 1, 0 },
                  padding = { 0, 1, 0, 1 },
                  title_pos = "center",
                  border = "single",
                  zindex = 1000,
                },
                icons = {
                  separator = "➜",
                },
              })
              :open(data)
          end,
        },
      },
      org_agenda_files = "~/org/**/*",
      org_default_notes_file = "~/org/refile.org",
      org_startup_folded = "showeverything",
    },
  },
}
