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
                },
                -- v2 default, spelled out because it is the whole reason the
                -- handler table in lspconfig.lua could be deleted: every server
                -- mason installs gets vim.lsp.enable()d automatically, picking
                -- up the vim.lsp.config() overrides declared there.
                automatic_enable = true,
            })

            require("mason-tool-installer").setup({
                ensure_installed = {
                    "prettier", -- prettier formatter
                    "stylua",   -- lua formatter
                    "isort",    -- python formatter
                    "black",    -- python formatter
                    "pylint",
                    "eslint_d",
                },
            })
        end
    }
}
