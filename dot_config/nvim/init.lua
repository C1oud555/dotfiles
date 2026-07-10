-- ============================================================================
-- Neovim 0.12 config
-- C++ / Python / Rust / Org-mode
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ----------------------------------------------------------------------------
-- Options
-- ----------------------------------------------------------------------------

local opt = vim.opt

opt.autowrite = true
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = { foldopen = "", foldclose = "", fold = " ", foldsep = " ", diff = "╱", eob = " " }
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevelstart = 99
opt.foldenable = true
opt.ignorecase = true
opt.inccommand = "split"
opt.jumpoptions = "view"
opt.laststatus = 3
opt.list = true
opt.listchars = { trail = "·", tab = "▸ " }
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.pumblend = 15
opt.pumheight = 10
opt.scrolloff = 8
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "folds" }
opt.shiftround = true
opt.shiftwidth = 4
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smoothscroll = true
opt.softtabstop = 4
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 250
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false

vim.o.winborder = "rounded"

-- .h → C++
vim.filetype.add({
    extension = {
        h = "cpp",
        hh = "cpp",
        hpp = "cpp",
        hxx = "cpp",
        cc = "cpp",
        cxx = "cpp",
    },
})

-- ----------------------------------------------------------------------------
-- Plugins
-- ----------------------------------------------------------------------------

vim.pack.add({
    -- Core
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/Kaiser-Yang/blink-cmp-dictionary" },
    {
        src = "https://github.com/Saghen/blink.cmp",
        version = vim.version.range("^1")
    },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/folke/flash.nvim" },

    -- Icons
    { src = "https://github.com/nvim-mini/mini.icons" },

    -- Editing
    { src = "https://github.com/nvim-mini/mini.ai" },
    { src = "https://github.com/nvim-mini/mini.pairs" },
    { src = "https://github.com/nvim-mini/mini.comment" },

    -- UI enhancements
    { src = "https://github.com/folke/todo-comments.nvim" },
    { src = "https://github.com/folke/trouble.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },

    -- Treesitter
    { src = "https://github.com/romus204/tree-sitter-manager.nvim" },

    -- LSP / language tooling
    {
        src = "https://github.com/mrcjkb/rustaceanvim",
        version = vim.version.range('^9')
    },

    { src = "https://github.com/p00f/clangd_extensions.nvim" },
    { src = "https://github.com/Saecki/crates.nvim" },

    -- Python
    { src = "https://github.com/linux-cultist/venv-selector.nvim" },

    -- Org-mode
    { src = "https://github.com/nvim-orgmode/orgmode" },
    {
        src = "https://github.com/chipsenkbeil/org-roam.nvim",
        tag = "0.2.0"
    },


    -- Theme
    { src = "https://github.com/NTBBloodbath/doom-one.nvim" },

    -- vim.pack ui
    { src = "https://github.com/jtprogru/pack-ui.nvim" },
}, { confirm = false })

require("pack_ui").setup({})

-- ----------------------------------------------------------------------------
-- Theme
-- ----------------------------------------------------------------------------

vim.cmd.colorscheme("doom-one")

-- ----------------------------------------------------------------------------
-- Autocmds
-- ----------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- reload files when they change externally
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime", { clear = true }),
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- highlight on yank
autocmd("TextYankPost", {
    group = augroup("highlight_yank", { clear = true }),
    callback = function()
        (vim.hl or vim.highlight).on_yank()
    end,
})

-- go to last location when opening buffer
autocmd("BufReadPost", {
    group = augroup("last_loc", { clear = true }),
    callback = function(ev)
        local exclude = { "gitcommit" }
        local buf = ev.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- close some filetypes with q
autocmd("FileType", {
    group = augroup("close_with_q", { clear = true }),
    pattern = {
        "checkhealth", "help", "lspinfo", "notify", "qf",
        "startuptime", "tsplayground", "gitsigns-blame",
    },
    callback = function(ev)
        vim.bo[ev.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set("n", "q", function()
                vim.cmd("close")
                pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
            end, { buffer = ev.buf, silent = true, desc = "quit buffer" })
        end)
    end,
})

-- wrap + spell for text files
autocmd("FileType", {
    group = augroup("wrap_spell", { clear = true }),
    pattern = { "text", "plaintex", "gitcommit", "markdown", "org" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- auto create parent directories when saving
autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir", { clear = true }),
    callback = function(ev)
        if ev.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(ev.match) or ev.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- disable conceal for json files
autocmd({ "FileType" }, {
    group = augroup("json_conceal", { clear = true }),
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- ----------------------------------------------------------------------------
-- Icons (mini.icons mock nvim-web-devicons)
-- ----------------------------------------------------------------------------

require("mini.icons").setup({})

package.preload["nvim-web-devicons"] = function()
    require("mini.icons").mock_nvim_web_devicons()
    return package.loaded["nvim-web-devicons"]
end

-- ----------------------------------------------------------------------------
-- lualine
-- ----------------------------------------------------------------------------

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "",
        section_separators = "",
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})

-- ----------------------------------------------------------------------------
-- snacks.nvim
-- ----------------------------------------------------------------------------

local Snacks = require("snacks")

Snacks.setup({
    bigfile = { enabled = true },
    quickfile = { enabled = true },

    input = { enabled = true },
    notifier = {
        enabled = true,
        timeout = 3000,
    },

    picker = {
        enabled = true,
        ui_select = true,
        layout = {
            cycle = true,
            preset = function()
                return vim.o.columns >= 120 and "default" or "vertical"
            end,
        },
        matcher = {
            fuzzy = true,
            smartcase = true,
            ignorecase = true,
            filename_bonus = true,
        },
        sources = {
            files = {
                hidden = true,
                ignored = false,
                follow = false,
                exclude = { ".git", "target", "build", "__pycache__", ".venv", "dist" },
            },
            grep = {
                hidden = true,
                ignored = false,
                follow = false,
                exclude = { ".git", "target", "build", "__pycache__", ".venv", "dist" },
                args = { "--smart-case" },
            },
            explorer = {
                hidden = true,
                ignored = false,
                follow_file = true,
                git_status = true,
                diagnostics = true,
                layout = { preset = "sidebar", preview = false },
            },
        },
    },

    explorer = {
        enabled = true,
        replace_netrw = true,
    },

    indent = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },

    terminal = {
        enabled = true,
        win = {
            keys = {
                nav_h = {
                    "<C-h>",
                    function(self)
                        return self:is_floating() and "<C-h>" or
                            vim.schedule(function() vim.cmd.wincmd("h") end)
                    end,
                    desc = "go to left window",
                    expr = true,
                    mode = "t"
                },
                nav_j = {
                    "<C-j>",
                    function(self)
                        return self:is_floating() and "<C-j>" or
                            vim.schedule(function() vim.cmd.wincmd("j") end)
                    end,
                    desc = "go to lower window",
                    expr = true,
                    mode = "t"
                },
                nav_k = {
                    "<C-k>",
                    function(self)
                        return self:is_floating() and "<C-k>" or
                            vim.schedule(function() vim.cmd.wincmd("k") end)
                    end,
                    desc = "go to upper window",
                    expr = true,
                    mode = "t"
                },
                nav_l = {
                    "<C-l>",
                    function(self)
                        return self:is_floating() and "<C-l>" or
                            vim.schedule(function() vim.cmd.wincmd("l") end)
                    end,
                    desc = "go to right window",
                    expr = true,
                    mode = "t"
                },
            },
        },
    },

    lazygit = { enabled = true },
    gitbrowse = { enabled = true },
    toggle = { enabled = true },
    zen = { enabled = true },

    styles = {
        notification = { border = "rounded" },
        input = { border = "rounded" },
        terminal = { border = "rounded" },
        lazygit = { border = "rounded" },
    },
})

vim.notify = Snacks.notifier.notify

-- ----------------------------------------------------------------------------
-- which-key groups
-- ----------------------------------------------------------------------------

local wk = require("which-key")

wk.setup({
    preset = "helix",
    win = { border = "rounded" },
})

-- org file paths
local org_files = {
    todo = "~/org/todo.org",
    work = "~/org/work.org",
    notes = "~/org/notes.org",
    refile = "~/org/refile.org",
    roam = "~/org/roam",
}

wk.add({
    { "<leader>b",  group = "buffer" },
    { "<leader>c",  group = "code" },
    { "<leader>d",  group = "debug" },
    { "<leader>e",  group = "explorer" },
    { "<leader>f",  group = "file/find" },
    { "<leader>g",  group = "git" },
    { "<leader>gh", group = "hunks" },
    { "<leader>n",  group = "org" },
    { "<leader>q",  group = "quit/session" },
    { "<leader>s",  group = "search" },
    { "<leader>u",  group = "ui" },
    { "<leader>w",  group = "window" },
    { "<leader>x",  group = "diagnostics/quickfix" },
    { "[",          group = "prev" },
    { "]",          group = "next" },
    { "g",          group = "goto" },
    { "z",          group = "fold" },
})

-- ----------------------------------------------------------------------------
-- Global keymaps
-- ----------------------------------------------------------------------------

local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "up" })

-- window navigation
map("n", "<C-h>", "<C-w>h", { desc = "window left" })
map("n", "<C-j>", "<C-w>j", { desc = "window down" })
map("n", "<C-k>", "<C-w>k", { desc = "window up" })
map("n", "<C-l>", "<C-w>l", { desc = "window right" })

-- window resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "increase height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "increase width" })

-- move lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "move down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "move up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "move down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "move up" })

-- buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "next buffer" })

-- clear hlsearch on esc
map({ "i", "n", "s" }, "<esc>", function()
    vim.cmd("noh")
    return "<esc>"
end, { expr = true, desc = "escape and clear hlsearch" })

-- search result navigation with center
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })

-- undo breakpoints
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "save file" })
map({ "n", "t" }, "<c-/>", function() Snacks.terminal() end, { desc = "terminal toggle" })
map({ "n", "t" }, "<c-_>", function() Snacks.terminal() end, { desc = "which_key_ignore" })

-- better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- diagnostic navigation
local function diagnostic_goto(next, severity)
    return function()
        vim.diagnostic.jump({
            count = (next and 1 or -1) * vim.v.count1,
            severity = severity and vim.diagnostic.severity[severity] or nil,
            float = true,
        })
    end
end

map("n", "]d", diagnostic_goto(true), { desc = "next diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "prev diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "next error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "prev error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "next warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "prev warning" })

-- quickfix navigation
map("n", "]q", vim.cmd.cnext, { desc = "next quickfix" })
map("n", "[q", vim.cmd.cprev, { desc = "prev quickfix" })

-- ----------------------------------------------------------------------------
-- which-key leader keymaps
-- ----------------------------------------------------------------------------

wk.add({
    -- File / Find
    { "<leader>ff", function() Snacks.picker.files() end,                                   desc = "find files",   mode = "n" },
    { "<leader>fn", "<cmd>enew<cr>",                                                        desc = "new file",     mode = "n" },
    { "<leader>fp", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "config files", mode = "n" },
    { "<leader>fr", function() Snacks.picker.recent() end,                                  desc = "recent files", mode = "n" },
    { "<leader>fs", "<cmd>write<cr>",                                                       desc = "save file",    mode = "n" },
    {
        "<leader>fy",
        function()
            vim.fn.setreg("+", vim.fn.expand("%:p")); vim.notify("path yanked")
        end,
        desc = "yank file path",
        mode = "n"
    },
    { "<leader>ft",       function() Snacks.terminal() end,                                                                  desc = "terminal (cwd)",        mode = "n" },

    -- Search
    { "<leader>sf",       function() Snacks.picker.files() end,                                                              desc = "find files",            mode = "n" },
    { "<leader>sg",       function() Snacks.picker.grep() end,                                                               desc = "live grep",             mode = "n" },
    { "<leader>sb",       function() Snacks.picker.lines() end,                                                              desc = "buffer lines",          mode = "n" },
    { "<leader>sB",       function() Snacks.picker.grep_buffers() end,                                                       desc = "grep buffers",          mode = "n" },
    { "<leader>sd",       function() Snacks.picker.diagnostics() end,                                                        desc = "workspace diagnostics", mode = "n" },
    { "<leader>sD",       function() Snacks.picker.diagnostics_buffer() end,                                                 desc = "buffer diagnostics",    mode = "n" },
    { "<leader>sh",       function() Snacks.picker.help() end,                                                               desc = "help pages",            mode = "n" },
    { "<leader>sk",       function() Snacks.picker.keymaps() end,                                                            desc = "keymaps",               mode = "n" },
    { "<leader>sr",       function() Snacks.picker.resume() end,                                                             desc = "resume picker",         mode = "n" },
    { "<leader>ss",       function() Snacks.picker.lsp_symbols() end,                                                        desc = "document symbols",      mode = "n" },
    { "<leader>sS",       function() Snacks.picker.lsp_workspace_symbols() end,                                              desc = "workspace symbols",     mode = "n" },

    -- Git
    { "<leader>gg",       function() Snacks.lazygit() end,                                                                   desc = "lazygit",               mode = "n" },
    { "<leader>gl",       function() Snacks.picker.git_log() end,                                                            desc = "git log",               mode = "n" },
    { "<leader>gb",       function() Snacks.picker.git_log_line() end,                                                       desc = "git blame line",        mode = "n" },
    { "<leader>gf",       function() Snacks.picker.git_log_file() end,                                                       desc = "file history",          mode = "n" },
    { "<leader>gB",       function() Snacks.gitbrowse() end,                                                                 desc = "browse remote",         mode = { "n", "x" } },
    { "<leader>gY",       function() Snacks.gitbrowse({ open = function(u) vim.fn.setreg("+", u) end, notify = false }) end, desc = "copy remote url",       mode = { "n", "x" } },

    -- Window
    { "<leader>-",        "<C-W>s",                                                                                          desc = "split below",           mode = "n" },
    { "<leader>|",        "<C-W>v",                                                                                          desc = "split right",           mode = "n" },
    { "<leader>wd",       "<C-W>c",                                                                                          desc = "delete window",         mode = "n" },
    { "<leader>w=",       "<C-w>=",                                                                                          desc = "balance windows",       mode = "n" },

    -- Buffer
    { "<leader>bb",       "<cmd>e #<cr>",                                                                                    desc = "switch buffer",         mode = "n" },
    { "<leader>bd",       function() Snacks.bufdelete() end,                                                                 desc = "delete buffer",         mode = "n" },
    { "<leader>bo",       function() Snacks.bufdelete.other() end,                                                           desc = "delete others",         mode = "n" },
    { "<leader>bi",       function() Snacks.bufdelete.invisible() end,                                                       desc = "delete invisible",      mode = "n" },
    { "<leader>bD",       "<cmd>bd<cr>",                                                                                     desc = "force delete buffer",   mode = "n" },

    -- Explorer
    { "<leader>ee",       function() Snacks.explorer() end,                                                                  desc = "toggle explorer",       mode = "n" },
    { "<leader>ef",       function() Snacks.explorer.reveal() end,                                                           desc = "reveal file",           mode = "n" },

    -- Quit
    { "<leader>qq",       "<cmd>qa<cr>",                                                                                     desc = "quit all",              mode = "n" },
    { "<leader>qw",       "<cmd>quit<cr>",                                                                                   desc = "quit",                  mode = "n" },

    -- Misc
    { "<leader>:",        function() Snacks.picker.commands() end,                                                           desc = "commands",              mode = "n" },
    { "<leader><leader>", function() Snacks.picker.smart() end,                                                              desc = "smart find",            mode = "n" },
    { "<leader>?",        function() require("which-key").show({ global = false }) end,                                      desc = "buffer keymaps",        mode = "n" },

    -- Org-mode
    { "<leader>na",       function() require("orgmode.api.agenda").agenda() end,                                             desc = "org agenda",            mode = "n" },
    {
        "<leader>nt",
        function()
            require("orgmode.api.agenda").todos({ org_agenda_files = { org_files.todo }, header = "Personal TODOs" })
        end,
        desc = "personal TODOs",
        mode = "n"
    },
    {
        "<leader>nw",
        function()
            require("orgmode.api.agenda").todos({ org_agenda_files = { org_files.work }, header = "Work TODOs" })
        end,
        desc = "work TODOs",
        mode = "n"
    },
    -- below: descriptions only — actual mappings registered by org-roam
    { "<leader>nc", desc = "capture" },
    { "<leader>nf", desc = "find node" },
    { "<leader>ni", desc = "insert link" },
    { "<leader>nl", desc = "toggle roam buffer" },

    -- Python venv
    { "<leader>cv", "<cmd>VenvSelect<cr>",      desc = "select venv", mode = "n" },
})

-- ----------------------------------------------------------------------------
-- Snacks toggles (<leader>u*)
-- ----------------------------------------------------------------------------

Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.option("conceallevel", { off = 0, on = 2, name = "Conceal Level" }):map("<leader>uc")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")

Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

if vim.lsp.inlay_hint then
    Snacks.toggle.inlay_hints():map("<leader>uh")
end

-- ----------------------------------------------------------------------------
-- flash.nvim
-- ----------------------------------------------------------------------------

require("flash").setup({
    modes = {
        search = { enabled = true },
        char = { enabled = true },
        treesitter = { labels = "abcdefghijklmnopqrstuvwxyz" },
    },
})

map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "flash jump" })
map({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "flash treesitter" })
map("o", "r", function() require("flash").remote() end, { desc = "flash remote" })

-- ----------------------------------------------------------------------------
-- mini.nvim (ai, pairs, comment)
-- ----------------------------------------------------------------------------

require("mini.ai").setup({ n_lines = 500 })
require("mini.pairs").setup()
require("mini.comment").setup()

-- ----------------------------------------------------------------------------
-- todo-comments.nvim
-- ----------------------------------------------------------------------------

require("todo-comments").setup({})

map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "next todo" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "prev todo" })

-- ----------------------------------------------------------------------------
-- trouble.nvim
-- ----------------------------------------------------------------------------

require("trouble").setup({
    modes = {
        lsp = { win = { position = "right" } },
    },
})

wk.add({
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "diagnostics",        mode = "n" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "buffer diagnostics", mode = "n" },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                               desc = "todo",               mode = "n" },
    { "<leader>xT", "<cmd>Trouble todo toggle filter={tag={TODO,FIX,FIXME}}<cr>", desc = "todo/fix/fixme",     mode = "n" },
    {
        "<leader>xl",
        function()
            local ok, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
            if not ok and err then vim.notify(err, vim.log.levels.ERROR) end
        end,
        desc = "location list",
        mode = "n"
    },
    {
        "<leader>xq",
        function()
            local ok, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
            if not ok and err then vim.notify(err, vim.log.levels.ERROR) end
        end,
        desc = "quickfix list",
        mode = "n"
    },
})

-- ----------------------------------------------------------------------------
-- conform.nvim
-- ----------------------------------------------------------------------------

require("conform").setup({
    formatters_by_ft = {
        python = { "ruff_format" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
    default_format_opts = {
        timeout_ms = 3000,
        async = false,
        lsp_format = "fallback",
    },
})

-- ----------------------------------------------------------------------------
-- blink.cmp
-- ----------------------------------------------------------------------------

local function dictionary_files()
    local candidates
    if vim.uv.os_uname().sysname == "Darwin" then
        candidates = { "/usr/share/dict/words", "/usr/share/dict/web2" }
    else
        candidates = { "/usr/share/dict/words" }
    end
    return vim.tbl_filter(function(path)
        return vim.uv.fs_stat(path) ~= nil
    end, candidates)
end

local function inside_comment_block()
    if vim.api.nvim_get_mode().mode ~= "i" then
        return false
    end
    local node = vim.treesitter.get_node()
    local parser = vim.treesitter.get_parser(nil, nil, { error = false })
    local query = vim.treesitter.query.get(vim.bo.filetype, "highlights")
    if not node or not parser or not query then
        return false
    end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    for id, capture_node in query:iter_captures(node, 0, row, row + 1) do
        if query.captures[id]:find("comment") then
            local start_row, start_col, end_row, end_col = capture_node:range()
            if start_row <= row and row <= end_row then
                if start_row == row and end_row == row then
                    return start_col <= col and col <= end_col
                elseif start_row == row then
                    return start_col <= col
                elseif end_row == row then
                    return col <= end_col
                end
                return true
            end
        end
    end
    return false
end

require("blink.cmp").setup({
    keymap = {
        preset = "super-tab",
        ["<C-y>"] = { "select_and_accept" },
        ["<C-e>"] = { "cancel" },
    },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
        },
    },
    sources = {
        default = function()
            local result = { "lsp", "path", "snippets", "buffer" }
            if vim.tbl_contains({ "markdown", "text", "gitcommit" }, vim.bo.filetype) or inside_comment_block() then
                table.insert(result, "dictionary")
            end
            return result
        end,
        providers = {
            dictionary = {
                module = "blink-cmp-dictionary",
                name = "Dict",
                min_keyword_length = 2,
                max_items = 8,
                opts = {
                    force_fallback = true,
                    dictionary_files = dictionary_files,
                },
            },
        },
    },
    cmdline = { enabled = true },
})

-- ----------------------------------------------------------------------------
-- tree-sitter-manager
-- ----------------------------------------------------------------------------

require("tree-sitter-manager").setup({
    ensure_installed = {
        "c", "cpp", "python", "rust", "toml", "cmake", "lua", "luadoc",
    },
    auto_install = false,
    highlight = true,
    border = "rounded",
})

-- ----------------------------------------------------------------------------
-- gitsigns
-- ----------------------------------------------------------------------------

require("gitsigns").setup({
    signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
    },
    signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function m(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        m("n", "]h", function()
            if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
        end, "next hunk")
        m("n", "[h", function()
            if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
        end, "prev hunk")
        m("n", "]H", function() gs.nav_hunk("last") end, "last hunk")
        m("n", "[H", function() gs.nav_hunk("first") end, "first hunk")
        m({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "stage hunk")
        m({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "reset hunk")
        m("n", "<leader>ghS", gs.stage_buffer, "stage buffer")
        m("n", "<leader>ghu", gs.undo_stage_hunk, "undo stage hunk")
        m("n", "<leader>ghR", gs.reset_buffer, "reset buffer")
        m("n", "<leader>ghp", gs.preview_hunk_inline, "preview hunk")
        m("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "blame line")
        m("n", "<leader>ghB", function() gs.blame() end, "blame buffer")
        m("n", "<leader>ghd", gs.diffthis, "diff this")
        m("n", "<leader>ghD", function() gs.diffthis("~") end, "diff this ~")
        m({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "select hunk")
    end,
})

Snacks.toggle({
    name = "Git Signs",
    get = function() return require("gitsigns.config").config.signcolumn end,
    set = function(state) require("gitsigns").toggle_signs(state) end,
}):map("<leader>uG")

-- ----------------------------------------------------------------------------
-- crates.nvim
-- ----------------------------------------------------------------------------

require("crates").setup({
    completion = {
        crates = { enabled = true },
    },
    lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
    },
})

-- ----------------------------------------------------------------------------
-- venv-selector.nvim
-- ----------------------------------------------------------------------------

require("venv-selector").setup({
    options = {
        notify_user_on_venv_activation = true,
    },
})

-- ----------------------------------------------------------------------------
-- clangd_extensions.nvim
-- ----------------------------------------------------------------------------

require("clangd_extensions").setup({
    inlay_hints = { inline = false },
})

-- ----------------------------------------------------------------------------
-- rustaceanvim
-- ----------------------------------------------------------------------------

vim.g.rustaceanvim = {
    server = {
        default_settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    buildScripts = {
                        enable = true,
                    },
                },
                check = { command = "clippy" },
                procMacro = { enable = true },
                files = {
                    exclude = {
                        ".direnv", ".git", ".jj", ".github", ".gitlab",
                        "bin", "node_modules", "target", "venv", ".venv",
                    },
                    watcher = "client",
                },
            },
        },
    },
}

-- ----------------------------------------------------------------------------
-- nvim-orgmode
-- ----------------------------------------------------------------------------

require("orgmode").setup({
    org_agenda_files = { org_files.todo },
    org_default_notes_file = org_files.refile,
    org_capture_templates = {
        t = {
            description = "Personal todo",
            template = "* TODO %?\n%%a",
            target = org_files.todo,
        },
        n = {
            description = "Personal notes",
            template = "* %%u %?\n%%a",
            target = org_files.notes,
        },
        w = {
            description = "Work todo",
            template = "* TODO %?\n%%a",
            target = org_files.work,
        },
    },
    org_todo_keywords = {
        "TODO(t)", "PROJ(p)", "LOOP(r)", "STRT(s)", "WAIT(w)", "HOLD(h)", "IDEA(i)",
        "|", "DONE(d)", "KILL(k)",
    },
    org_log_done = "time",
    org_tags_exclude_from_inheritance = { "crypt" },
})

vim.lsp.enable("org")

-- ----------------------------------------------------------------------------
-- org-roam.nvim
-- ----------------------------------------------------------------------------

require("org-roam").setup({
    directory = org_files.roam,
    bindings = {
        prefix = "<Leader>n",
    },
})

-- ----------------------------------------------------------------------------
-- LSP: native vim.lsp.config / vim.lsp.enable
-- ----------------------------------------------------------------------------

local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".luarc.json", ".luarc.jsonc", ".stylua.toml",
        "stylua.toml", "selene.toml", "selene.yml", ".git",
    },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    vim.fn.stdpath("config"),
                },
            },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = {
        ".clangd", "compile_commands.json", "compile_flags.txt",
        "Makefile", "meson.build", "build.ninja", ".git",
    },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
})

vim.lsp.config("ty", {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = {
        "ty.toml", "pyproject.toml", "uv.lock", "requirements.txt", ".git",
    },
    settings = {
        ty = { diagnosticMode = "openFilesOnly" },
    },
})

vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml", "ruff.toml", ".ruff.toml", ".git",
    },
    init_options = {
        settings = {},
    },
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
})

vim.lsp.enable({
    "clangd",
    "ty",
    "ruff",
    "lua_ls",
})

-- ----------------------------------------------------------------------------
-- Diagnostics
-- ----------------------------------------------------------------------------

vim.diagnostic.config({
    virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
    },
    severity_sort = true,
    float = { border = "rounded", source = true },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
    },
    underline = true,
})

-- ----------------------------------------------------------------------------
-- LspAttach — LSP keymaps
-- ----------------------------------------------------------------------------

autocmd("LspAttach", {
    callback = function(ev)
        local bufnr = ev.buf

        local function n(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        local function x(lhs, rhs, desc)
            vim.keymap.set("x", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        -- g prefix: goto
        n("gd", vim.lsp.buf.definition, "definition")
        n("gD", vim.lsp.buf.declaration, "declaration")
        n("gr", vim.lsp.buf.references, "references")
        n("gI", vim.lsp.buf.implementation, "implementation")
        n("gy", vim.lsp.buf.type_definition, "type definition")
        n("K", vim.lsp.buf.hover, "hover")
        n("gK", vim.lsp.buf.signature_help, "signature help")
        vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help,
            { buffer = bufnr, silent = true, desc = "signature help" })

        -- <leader>c: code
        n("<leader>ca", vim.lsp.buf.code_action, "code action")
        x("<leader>ca", vim.lsp.buf.code_action, "code action")
        n("<leader>cr", vim.lsp.buf.rename, "rename")
        n("<leader>cf", function()
            require("conform").format({ bufnr = bufnr, lsp_format = "fallback" })
        end, "format buffer")
        n("<leader>cd", vim.diagnostic.open_float, "line diagnostics")
        n("<leader>co", function()
            vim.lsp.buf.code_action({
                apply = true,
                context = { only = { "source.organizeImports" }, diagnostics = {} },
            })
        end, "organize imports")

        -- Language-specific extras
        if ev.data and ev.data.client_id then
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client then
                if client.name == "clangd" then
                    n("<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", "switch source/header")
                end
                if client.name == "ruff" then
                    n("<leader>cF", function()
                        vim.lsp.buf.code_action({
                            apply = true,
                            context = { only = { "source.fixAll" }, diagnostics = {} },
                        })
                    end, "fix all")
                end
            end
        end
    end,
})
