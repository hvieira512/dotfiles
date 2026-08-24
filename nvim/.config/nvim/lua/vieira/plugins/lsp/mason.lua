-- mason moved org: williamboman/* is archived, mason-org/* is where v2 lives.
-- v2 is what makes lspconfig.lua's vim.lsp.config migration possible — it
-- enables each installed server itself, so setup_handlers (removed in v2) is
-- no longer called anywhere.
return {
    {
        "mason-org/mason.nvim",
        version = "^2",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end
    },
    {
        "mason-org/mason-lspconfig.nvim",
        version = "^2",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "html",
                    "cssls",
                    "lua_ls",
                    "emmet_ls",
                    "pyright",
                    "gopls",
                    -- Was installed by hand and never declared here, so a fresh
                    -- machine would have had PHP files opening with only the
                    -- emmet abbreviations attached and no diagnostics at all.
                    "intelephense",
                    -- phpactor alongside intelephense, not instead of it:
                    -- intelephense's rename, code actions, find-implementations
                    -- and go-to-type-definition are premium-only, so it reports
                    -- renameProvider=false and those keymaps do nothing.
                    -- phpactor provides exactly those four for free. It is
                    -- stripped down to them in lspconfig.lua so nothing it does
                    -- overlaps with intelephense. Needs a PHP runtime on PATH
                    -- (php 8.5 via brew here) — the phar runs on it.
                    "phpactor",
                },
                -- v2 default, spelled out because it is the whole reason the
                -- handler table in lspconfig.lua could be deleted: every server
                -- mason installs gets vim.lsp.enable()d automatically, picking
                -- up the vim.lsp.config() overrides declared there.
                automatic_enable = true,
            })

            require("mason-tool-installer").setup({
                ensure_installed = {
                    "prettier",     -- js/ts/css/html/json/yaml/markdown formatter
                    "stylua",       -- lua formatter
                    "isort",        -- python import sorter
                    "black",        -- python formatter
                    "pylint",       -- python linter, run by nvim-lint
                    "eslint_d",     -- js/ts linter, run by nvim-lint
                    "php-cs-fixer", -- php formatter
                    -- php linter. phpcs rather than phpstan: hitcare has no
                    -- composer.json, and phpstan effectively wants one plus an
                    -- installed dependency tree to analyse against. phpcs runs
                    -- standalone against a coding standard.
                    "phpcs",
                },
            })
        end
    }
}
