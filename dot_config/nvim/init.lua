-- ============================================================================
-- Doom-flavored Neovim 0.12 config
-- C++ / Python / Rust
--
-- vim.pack
-- snacks.nvim
-- tree-sitter-manager.nvim
-- blink.cmp
-- native LSP
-- manual LSP formatting
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- ----------------------------------------------------------------------------
-- Basic options
-- ----------------------------------------------------------------------------

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.updatetime = 250
opt.timeoutlen = 400
opt.undofile = true
opt.showmode = false
opt.laststatus = 3
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumblend = 8
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Neovim 0.12 全局 floating window border。
vim.o.winborder = "rounded"

-- Treesitter fold defaults.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- 偏 C++ 工作流：把 .h 当作 C++。
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
-- Plugins: Neovim 0.12 built-in vim.pack
-- ----------------------------------------------------------------------------

vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/Saghen/blink.cmp",                 version = "v1" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/romus204/tree-sitter-manager.nvim" },
}, {
    confirm = false,
})

-- ----------------------------------------------------------------------------
-- Theme
-- ----------------------------------------------------------------------------

vim.cmd.colorscheme("catppuccin")

-- ----------------------------------------------------------------------------
-- Icons
-- ----------------------------------------------------------------------------

require("nvim-web-devicons").setup({
    default = true,
    color_icons = true,
})

-- ----------------------------------------------------------------------------
-- snacks.nvim
-- ----------------------------------------------------------------------------

local Snacks = require("snacks")

Snacks.setup({
    bigfile = { enabled = true },
    quickfile = { enabled = true },

    dashboard = { enabled = true },
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
                exclude = {
                    ".git",
                    "target",
                    "build",
                    "__pycache__",
                    ".venv",
                    "dist",
                },
            },

            grep = {
                hidden = true,
                ignored = false,
                follow = false,
                exclude = {
                    ".git",
                    "target",
                    "build",
                    "__pycache__",
                    ".venv",
                    "dist",
                },
                args = {
                    "--smart-case",
                },
            },

            explorer = {
                hidden = true,
                ignored = false,
                follow_file = true,
                git_status = true,
                diagnostics = true,
                layout = {
                    preset = "sidebar",
                    preview = false,
                },
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

    terminal = { enabled = true },
    lazygit = { enabled = true },
    gitbrowse = { enabled = true },

    toggle = { enabled = true },
    zen = { enabled = true },
    scratch = { enabled = true },

    styles = {
        notification = {
            border = "rounded",
        },
        input = {
            border = "rounded",
        },
        terminal = {
            border = "rounded",
        },
        lazygit = {
            border = "rounded",
        },
        scratch = {
            border = "rounded",
        },
    },
})

vim.notify = Snacks.notifier.notify

-- ----------------------------------------------------------------------------
-- which-key
-- ----------------------------------------------------------------------------

local wk = require("which-key")

wk.setup({
    preset = "modern",
    win = {
        border = "rounded",
    },
})

wk.add({
    { "<leader>!",     group = "checkers" },
    { "<leader>b",     group = "buffer" },
    { "<leader>c",     group = "code" },
    { "<leader>f",     group = "file" },
    { "<leader>g",     group = "git" },
    { "<leader>h",     group = "help" },
    { "<leader>m",     group = "localleader" },
    { "<leader>o",     group = "open" },
    { "<leader>p",     group = "project" },
    { "<leader>q",     group = "quit/session" },
    { "<leader>s",     group = "search" },
    { "<leader>t",     group = "toggle" },
    { "<leader>w",     group = "window" },
    { "<localleader>", group = "localleader" },
})

-- ----------------------------------------------------------------------------
-- Completion: blink.cmp
-- ----------------------------------------------------------------------------

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
        default = { "lsp", "path", "snippets", "buffer" },
    },

    cmdline = {
        enabled = true,
    },
})

-- ----------------------------------------------------------------------------
-- Treesitter: tree-sitter-manager.nvim + native Neovim TS
-- ----------------------------------------------------------------------------

require("tree-sitter-manager").setup({
    ensure_installed = {
        "cpp",
        "python",
        "rust",
        "toml",
        "cmake",
        "lua",
        "luadoc",
    },

    auto_install = false,

    -- true 表示默认为已安装 parser 启用 TS highlight。
    highlight = true,

    -- nil 也可以，因为它会使用 vim.o.winborder。
    border = "rounded",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "c",
        "cpp",
        "python",
        "rust",
        "toml",
        "cmake",
        "lua",
    },
    callback = function()
        pcall(vim.treesitter.start)

        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldlevel = 99
    end,
})

-- ----------------------------------------------------------------------------
-- Git
-- ----------------------------------------------------------------------------

require("gitsigns").setup({
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function bmap(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, {
                buffer = bufnr,
                silent = true,
                desc = desc,
            })
        end

        bmap("]g", function()
            gs.nav_hunk("next")
        end, "next git hunk")

        bmap("[g", function()
            gs.nav_hunk("prev")
        end, "previous git hunk")

        bmap("<leader>g p", gs.preview_hunk, "preview hunk")
        bmap("<leader>g r", gs.reset_hunk, "reset hunk")
        bmap("<leader>g R", gs.reset_buffer, "reset buffer")
        bmap("<leader>g b", function()
            gs.blame_line({ full = true })
        end, "blame line")
    end,
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
        ".luarc.json",
        ".luarc.jsonc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".git",
    },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    vim.fn.stdpath("config"),
                },
            },
            completion = {
                callSnippet = "Replace",
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=never",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = {
        ".clangd",
        "compile_commands.json",
        "compile_flags.txt",
        ".git",
    },
})

vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = {
        "Cargo.toml",
        "rust-project.json",
        ".git",
    },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            check = {
                command = "clippy",
            },
        },
    },
})

vim.lsp.config("ty", {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = {
        "ty.toml",
        "pyproject.toml",
        "uv.lock",
        "requirements.txt",
        ".git",
    },
    settings = {
        ty = {
            diagnosticMode = "openFilesOnly",
        },
    },
})

vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "ruff.toml",
        ".ruff.toml",
        ".git",
    },
    init_options = {
        settings = {},
    },
    on_attach = function(client)
        -- ty 负责 Python hover；ruff 专注 lint/fix/import/format。
        client.server_capabilities.hoverProvider = false
    end,
})

vim.lsp.enable({
    "clangd",
    "rust_analyzer",
    "ty",
    "ruff",
    "lua_ls",
})

vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = true,
    underline = true,
})

local function lsp_format(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local ft = vim.bo[bufnr].filetype

    local preferred = {
        python = { ruff = true },
        c = { clangd = true },
        cpp = { clangd = true },
        rust = { rust_analyzer = true },
        lua = { lua_ls = true },
    }

    vim.lsp.buf.format({
        bufnr = bufnr,
        async = true,
        timeout_ms = 3000,
        filter = function(client)
            local allow = preferred[ft]
            if allow then
                return allow[client.name] == true
            end

            if client.supports_method then
                return client:supports_method("textDocument/formatting")
            end

            return true
        end,
    })
end

local function source_action(kind)
    vim.lsp.buf.code_action({
        apply = true,
        context = {
            only = { kind },
            diagnostics = vim.diagnostic.get(0),
        },
    })
end

-- ----------------------------------------------------------------------------
-- Global Doom-like keymaps via which-key.add
-- ----------------------------------------------------------------------------

wk.add({
    -- Top-level
    {
        "<leader>:",
        function()
            Snacks.picker.commands()
        end,
        desc = "M-x commands",
        mode = "n",
    },
    {
        "<leader><leader>",
        function()
            Snacks.picker.smart()
        end,
        desc = "smart find",
        mode = "n",
    },
    {
        "<leader>.",
        function()
            Snacks.picker.files()
        end,
        desc = "find file",
        mode = "n",
    },
    {
        "<leader>/",
        function()
            Snacks.picker.grep()
        end,
        desc = "search project",
        mode = "n",
    },

    -- File: SPC f
    {
        "<leader>ff",
        function()
            Snacks.picker.files()
        end,
        desc = "find file",
        mode = "n",
    },
    {
        "<leader>fp",
        function()
            Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "find config file",
        mode = "n",
    },
    {
        "<leader>fr",
        function()
            Snacks.picker.recent()
        end,
        desc = "recent files",
        mode = "n",
    },
    {
        "<leader>fs",
        "<cmd>write<cr>",
        desc = "save file",
        mode = "n",
    },
    {
        "<leader>fy",
        function()
            local path = vim.fn.expand("%:p")
            vim.fn.setreg("+", path)
            vim.notify("Copied: " .. path)
        end,
        desc = "yank file path",
        mode = "n",
    },

    -- Project: SPC p
    {
        "<leader>pf",
        function()
            Snacks.picker.git_files()
        end,
        desc = "project files",
        mode = "n",
    },
    {
        "<leader>pp",
        function()
            Snacks.picker.projects()
        end,
        desc = "switch project",
        mode = "n",
    },
    {
        "<leader>ps",
        function()
            Snacks.picker.grep()
        end,
        desc = "search project",
        mode = "n",
    },
    {
        "<leader>pe",
        function()
            Snacks.explorer()
        end,
        desc = "project explorer",
        mode = "n",
    },

    -- Buffer: SPC b
    {
        "<leader>bb",
        function()
            Snacks.picker.buffers()
        end,
        desc = "switch buffer",
        mode = "n",
    },
    {
        "<leader>bd",
        function()
            Snacks.bufdelete()
        end,
        desc = "delete buffer",
        mode = "n",
    },
    {
        "<leader>bn",
        "<cmd>bnext<cr>",
        desc = "next buffer",
        mode = "n",
    },
    {
        "<leader>bp",
        "<cmd>bprevious<cr>",
        desc = "previous buffer",
        mode = "n",
    },

    -- Search: SPC s
    {
        "<leader>sp",
        function()
            Snacks.picker.grep()
        end,
        desc = "search project",
        mode = "n",
    },
    {
        "<leader>sb",
        function()
            Snacks.picker.lines()
        end,
        desc = "search buffer",
        mode = "n",
    },
    {
        "<leader>sB",
        function()
            Snacks.picker.grep_buffers()
        end,
        desc = "search open buffers",
        mode = "n",
    },
    {
        "<leader>sd",
        function()
            Snacks.picker.diagnostics()
        end,
        desc = "workspace diagnostics",
        mode = "n",
    },
    {
        "<leader>sD",
        function()
            Snacks.picker.diagnostics_buffer()
        end,
        desc = "buffer diagnostics",
        mode = "n",
    },
    {
        "<leader>sh",
        function()
            Snacks.picker.help()
        end,
        desc = "help pages",
        mode = "n",
    },
    {
        "<leader>sk",
        function()
            Snacks.picker.keymaps()
        end,
        desc = "keymaps",
        mode = "n",
    },
    {
        "<leader>sr",
        function()
            Snacks.picker.resume()
        end,
        desc = "resume picker",
        mode = "n",
    },
    {
        "<leader>ss",
        function()
            Snacks.picker.lsp_symbols()
        end,
        desc = "document symbols",
        mode = "n",
    },
    {
        "<leader>sS",
        function()
            Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "workspace symbols",
        mode = "n",
    },

    -- Open: SPC o
    {
        "<leader>op",
        function()
            Snacks.explorer()
        end,
        desc = "project explorer",
        mode = "n",
    },
    {
        "<leader>oP",
        function()
            Snacks.explorer.reveal()
        end,
        desc = "reveal current file",
        mode = "n",
    },
    {
        "<leader>ot",
        function()
            Snacks.terminal()
        end,
        desc = "terminal",
        mode = "n",
    },
    {
        "<leader>os",
        function()
            Snacks.scratch()
        end,
        desc = "scratch buffer",
        mode = "n",
    },
    {
        "<leader>oS",
        function()
            Snacks.scratch.select()
        end,
        desc = "select scratch buffer",
        mode = "n",
    },

    -- Git: SPC g
    {
        "<leader>gg",
        function()
            Snacks.lazygit()
        end,
        desc = "lazygit",
        mode = "n",
    },
    {
        "<leader>gs",
        function()
            Snacks.picker.git_status()
        end,
        desc = "git status",
        mode = "n",
    },
    {
        "<leader>gl",
        function()
            Snacks.picker.git_log()
        end,
        desc = "git log",
        mode = "n",
    },
    {
        "<leader>gL",
        function()
            Snacks.picker.git_log_line()
        end,
        desc = "git log current line",
        mode = "n",
    },
    {
        "<leader>gf",
        function()
            Snacks.picker.git_log_file()
        end,
        desc = "git log current file",
        mode = "n",
    },
    {
        "<leader>gB",
        function()
            Snacks.picker.git_branches()
        end,
        desc = "git branches",
        mode = "n",
    },
    {
        "<leader>gy",
        function()
            Snacks.gitbrowse()
        end,
        desc = "browse remote",
        mode = { "n", "x" },
    },

    -- Help: SPC h
    {
        "<leader>hh",
        function()
            Snacks.picker.help()
        end,
        desc = "help",
        mode = "n",
    },
    {
        "<leader>hk",
        function()
            Snacks.picker.keymaps()
        end,
        desc = "keymaps",
        mode = "n",
    },
    {
        "<leader>hm",
        function()
            Snacks.picker.man()
        end,
        desc = "man pages",
        mode = "n",
    },
    {
        "<leader>hc",
        function()
            Snacks.picker.colorschemes()
        end,
        desc = "colorschemes",
        mode = "n",
    },

    -- Window: SPC w
    { "<leader>wv", "<cmd>vsplit<cr>",  desc = "vertical split",   mode = "n" },
    { "<leader>ws", "<cmd>split<cr>",   desc = "horizontal split", mode = "n" },
    { "<leader>wd", "<cmd>close<cr>",   desc = "delete window",    mode = "n" },
    { "<leader>wh", "<C-w>h",           desc = "window left",      mode = "n" },
    { "<leader>wj", "<C-w>j",           desc = "window down",      mode = "n" },
    { "<leader>wk", "<C-w>k",           desc = "window up",        mode = "n" },
    { "<leader>wl", "<C-w>l",           desc = "window right",     mode = "n" },
    { "<leader>w=", "<C-w>=",           desc = "balance windows",  mode = "n" },

    -- Quit/session: SPC q
    { "<leader>qq", "<cmd>quit<cr>",    desc = "quit",             mode = "n" },
    { "<leader>qQ", "<cmd>qa<cr>",      desc = "quit all",         mode = "n" },
    { "<leader>qr", "<cmd>restart<cr>", desc = "restart Neovim",   mode = "n" },

    -- Treesitter manager
    {
        "<leader>tT",
        "<cmd>TSManager<cr>",
        desc = "treesitter manager",
        mode = "n",
    },

    -- Toggle: SPC t
    {
        "<leader>tn",
        function()
            vim.opt.relativenumber = not vim.opt.relativenumber:get()
        end,
        desc = "toggle relative number",
        mode = "n",
    },
    {
        "<leader>tw",
        function()
            vim.opt.wrap = not vim.opt.wrap:get()
        end,
        desc = "toggle wrap",
        mode = "n",
    },
    {
        "<leader>ti",
        function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
        end,
        desc = "toggle inlay hints",
        mode = "n",
    },
    {
        "<leader>tz",
        function()
            Snacks.zen()
        end,
        desc = "toggle zen",
        mode = "n",
    },
    {
        "<leader>tf",
        function()
            if vim.wo.foldcolumn == "0" then
                vim.wo.foldcolumn = "1"
            else
                vim.wo.foldcolumn = "0"
            end
        end,
        desc = "toggle foldcolumn",
        mode = "n",
    },
})

local diagnostics_enabled = true

wk.add({
    {
        "<leader>td",
        function()
            diagnostics_enabled = not diagnostics_enabled
            vim.diagnostic.enable(diagnostics_enabled)
        end,
        desc = "toggle diagnostics",
        mode = "n",
    },
})

-- ----------------------------------------------------------------------------
-- LSP / code keymaps
-- ----------------------------------------------------------------------------

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local bufnr = ev.buf

        local function bmap(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
                buffer = bufnr,
                silent = true,
                desc = desc,
            })
        end

        local function n(lhs, rhs, desc)
            bmap("n", lhs, rhs, desc)
        end

        local function x(lhs, rhs, desc)
            bmap("x", lhs, rhs, desc)
        end

        local function local_n(lhs, rhs, desc)
            n("<localleader>" .. lhs, rhs, desc)
            n("<leader>m" .. lhs, rhs, desc)
        end

        -- Doom-like SPC c
        n("<leader>ca", vim.lsp.buf.code_action, "code action")
        x("<leader>ca", vim.lsp.buf.code_action, "code action")

        n("<leader>cd", function()
            Snacks.picker.lsp_definitions()
        end, "definition")

        n("<leader>cD", function()
            Snacks.picker.lsp_declarations()
        end, "declaration")

        n("<leader>cr", vim.lsp.buf.rename, "rename")

        n("<leader>cR", function()
            Snacks.picker.lsp_references()
        end, "references")

        n("<leader>ci", function()
            Snacks.picker.lsp_implementations()
        end, "implementation")

        n("<leader>ct", function()
            Snacks.picker.lsp_type_definitions()
        end, "type definition")

        n("<leader>ck", vim.lsp.buf.hover, "documentation")

        n("<leader>cf", function()
            lsp_format(bufnr)
        end, "format buffer")

        n("<leader>co", function()
            source_action("source.organizeImports.ruff")
        end, "organize imports")

        n("<leader>cF", function()
            source_action("source.fixAll.ruff")
        end, "fix all")

        n("<leader>cx", function()
            Snacks.picker.diagnostics_buffer()
        end, "buffer diagnostics")

        n("<leader>cX", function()
            Snacks.picker.diagnostics()
        end, "workspace diagnostics")

        n("<leader>cs", function()
            Snacks.picker.lsp_symbols()
        end, "document symbols")

        n("<leader>cS", function()
            Snacks.picker.lsp_workspace_symbols()
        end, "workspace symbols")

        -- Localleader aliases: "," and "SPC m"
        local_n("a", vim.lsp.buf.code_action, "code action")
        local_n("d", function()
            Snacks.picker.lsp_definitions()
        end, "definition")
        local_n("D", function()
            Snacks.picker.lsp_references()
        end, "references")
        local_n("f", function()
            lsp_format(bufnr)
        end, "format")
        local_n("i", function()
            Snacks.picker.lsp_implementations()
        end, "implementation")
        local_n("k", vim.lsp.buf.hover, "documentation")
        local_n("r", vim.lsp.buf.rename, "rename")
        local_n("t", function()
            Snacks.picker.lsp_type_definitions()
        end, "type definition")
        local_n("x", function()
            Snacks.picker.diagnostics_buffer()
        end, "diagnostics")

        -- Keep common Vim/Neovim muscle memory.
        n("gd", function()
            Snacks.picker.lsp_definitions()
        end, "definition")

        n("gD", function()
            Snacks.picker.lsp_declarations()
        end, "declaration")

        n("gr", function()
            Snacks.picker.lsp_references()
        end, "references")

        n("gi", function()
            Snacks.picker.lsp_implementations()
        end, "implementation")

        n("gy", function()
            Snacks.picker.lsp_type_definitions()
        end, "type definition")

        n("K", vim.lsp.buf.hover, "hover")

        n("[d", vim.diagnostic.goto_prev, "previous diagnostic")
        n("]d", vim.diagnostic.goto_next, "next diagnostic")
    end,
})
