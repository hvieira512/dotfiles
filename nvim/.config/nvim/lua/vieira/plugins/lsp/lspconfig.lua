return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim",                   opts = {} },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local keymap = vim.keymap

        local function setup_flutter_keymaps(buf)
            local opts = { buffer = buf, silent = true }

            -- Flutter-specific keymaps
            keymap.set("n", "<leader>cR", "<cmd>FlutterRun<CR>",
                vim.tbl_extend("force", opts, { desc = "[C]ode [R]un Flutter App" }))
            keymap.set("n", "<leader>cq", "<cmd>FlutterQuit<CR>",
                vim.tbl_extend("force", opts, { desc = "[C]ode [Q]uit Flutter App" }))
            keymap.set("n", "<leader>ch", "<cmd>FlutterHotReload<CR>",
                vim.tbl_extend("force", opts, { desc = "[C]ode [H]ot Reload" }))
            keymap.set("n", "<leader>cH", "<cmd>FlutterHotRestart<CR>",
                vim.tbl_extend("force", opts, { desc = "[C]ode [H]ot Restart" }))
            keymap.set("n", "<leader>cd", "<cmd>FlutterDevices<CR>",
                vim.tbl_extend("force", opts, { desc = "[C]ode Select [D]evice" }))
            keymap.set("n", "<leader>co", "<cmd>FlutterOutlineToggle<CR>",
                vim.tbl_extend("force", opts, { desc = "[C]ode [O]utline Toggle" }))
            keymap.set("n", "<leader>cl", "<cmd>FlutterLogClear<CR>",
                vim.tbl_extend("force", opts, { desc = "[C]ode Clear [L]ogs" }))
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }

                -- keybinds
                opts.desc = "[R]eferences"
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "[D]eclarations"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                opts.desc = "[D]efiniton"
                keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

                opts.desc = "[I]mplementation"
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

                opts.desc = "[T]ype [D]efinition"
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

                opts.desc = "[C]ode [A]ctions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                opts.desc = "[C]ode Smart [R]ename"
                keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

                if vim.fn.filereadable(vim.fn.getcwd() .. "/pubspec.yaml" == 1) then
                    setup_flutter_keymaps(ev.buf)
                end

                opts.desc = "Show buffer diagnostics"
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
                opts.desc = "Show line diagnostics"
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                opts.desc = "Go to previous diagnostic"
                keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                opts.desc = "Go to next diagnostic"
                keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

                opts.desc = "Show documentation for what is under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>lr", "<cmd>LspRestart<CR>", opts)

                opts.desc = "Info LSP"
                keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", opts)
            end,
        })

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        -- (not in youtube nvim video)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        mason_lspconfig.setup_handlers({
            -- default handler for installed servers
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
            ["emmet_ls"] = function()
                -- configure emmet language server
                lspconfig["emmet_ls"].setup({
                    capabilities = capabilities,
                    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "php" },
                })
            end,
            ["lua_ls"] = function()
                -- configure lua server (with special settings)
                lspconfig["lua_ls"].setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            -- make the language server recognize "vim" global
                            diagnostics = {
                                globals = { "vim" },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                })
            end,
        })

        lspconfig["dartls"].setup({
            cmd = { "dart", 'language-server', '--protocol=lsp' },
        })
    end,
}
