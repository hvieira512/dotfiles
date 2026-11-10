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
                    "clangd",
                    "ts_ls",
                    "intelephense",
                    -- phpactor covers intelephense's premium-only rename/code actions/
                    -- implementations/type definition; stripped down in after/lsp. Needs php.
                    "phpactor",
                },
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
                    -- phpcs, not phpstan: hitcare has no composer.json.
                    "phpcs",
                },
            })
        end
    }
}
