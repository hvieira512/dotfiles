local gh = function(repo) return "https://github.com/" .. repo end

-- Must exist before vim.pack.add installs or updates treesitter.
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
            if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
            vim.cmd("TSUpdate")
        end
    end,
})

-- Read when the plugin loads, so it has to be set first.
vim.g.live_server = { port = 3000, browser = true }

vim.pack.add({
    -- UI
    { src = gh("rose-pine/neovim"), name = "rose-pine" },
    { src = gh("nvim-mini/mini.nvim"), version = vim.version.range("*") },
    gh("folke/snacks.nvim"),
    gh("nvim-lualine/lualine.nvim"),
    gh("folke/trouble.nvim"),
    gh("folke/which-key.nvim"),
    -- Editor
    gh("nvim-lua/plenary.nvim"),
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
    gh("windwp/nvim-ts-autotag"),
    { src = gh("saghen/blink.cmp"), version = vim.version.range("^1") },
    gh("rafamadriz/friendly-snippets"),
    gh("stevearc/conform.nvim"),
    gh("mfussenegger/nvim-lint"),
    gh("lewis6991/gitsigns.nvim"),
    gh("folke/todo-comments.nvim"),
    gh("catgoose/nvim-colorizer.lua"),
    gh("MeanderingProgrammer/render-markdown.nvim"),
    -- LSP
    gh("neovim/nvim-lspconfig"),
    { src = gh("mason-org/mason.nvim"), version = vim.version.range("^2") },
    { src = gh("mason-org/mason-lspconfig.nvim"), version = vim.version.range("^2") },
    gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
    gh("folke/lazydev.nvim"),
    -- Util
    gh("stevearc/oil.nvim"),
    { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
    gh("ChmaraX/herdr-nvim"),
    gh("barrett-ruth/live-server.nvim"),
    gh("andweeb/presence.nvim"),
})

-- Ctrl+h/j/k/l entre splits e panes do herdr; clonado pelo bootstrap.sh
local herdr_nav = vim.fn.expand("~/.local/share/vim-herdr-navigation")
if vim.uv.fs_stat(herdr_nav) then
    vim.opt.rtp:append(herdr_nav)
    dofile(herdr_nav .. "/editor/nvim.lua")
end

-- Order matters: colorscheme and icons first, blink before the LSP config.
for _, mod in ipairs({
    "ui.colorscheme", "mini", "snacks", "ui.lualine", "ui.trouble", "ui.which-key",
    "treesitter", "lsp.blink", "lsp.lspconfig", "lsp.mason",
    "formatting", "linting", "gitsigns", "todo-comments", "colorizer", "render-markdown",
    "oil", "harpoon", "herdr", "presence",
}) do
    require("vieira.plugins." .. mod)
end
