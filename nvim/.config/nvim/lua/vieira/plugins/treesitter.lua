return {
    "nvim-treesitter/nvim-treesitter",
    -- Pinned to master on purpose. The main branch is a rewrite that drops
    -- this whole configs.setup() API — no ensure_installed, no auto_install,
    -- highlighting started per-buffer with vim.treesitter.start() instead.
    -- Without this, a :Lazy update would silently move to it and break the
    -- config below. Master is in maintenance mode, so this buys time rather
    -- than settling it; migrating is a job of its own.
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        local treesitter = require("nvim-treesitter.configs")

        treesitter.setup({
            -- enable syntax highlighting
            highlight = {
                enable = true,
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
            -- enable indentation
            indent = { enable = true },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = {
                enable = true,
            },
            -- Only the parsers auto_install cannot be relied on to fetch.
            --
            -- auto_install hangs off a FileType autocmd, so it only ever fires
            -- for a language some buffer actually has as its filetype. That
            -- covers ordinary languages — php, go, yaml — which is why they are
            -- no longer listed here. It does not cover markdown_inline, which is
            -- injected inside markdown buffers and is never a filetype of its
            -- own, so opening a .md file would leave its highlighting partial.
            --
            -- The rest are what Neovim itself leans on: lua and vim for this
            -- config, vimdoc for :help, query for .scm files, markdown for help
            -- and render-markdown. Worth having ready rather than compiling on
            -- first sight.
            ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
            },
            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = true,
            -- Install a parser the first time a file of that language is opened,
            -- so a language missing from `ensure_installed` above still gets
            -- highlighting without a manual :TSInstall. Needs the tree-sitter
            -- CLI and a C compiler, both of which the Brewfile installs.
            auto_install = true,
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
