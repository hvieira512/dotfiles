-- Only for the server definitions in its lsp/; mason-lspconfig enables them.
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "saghen/blink.cmp" },
        { "folke/lazydev.nvim", ft = "lua", opts = {} },
    },
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }

                -- Only maps that differ from Neovim's defaults (K, grn, gra, grr,
                -- gri, gO); these route through the picker instead of quickfix.
                opts.desc = "[R]eferences"
                vim.keymap.set("n", "gR", function() Snacks.picker.lsp_references() end, opts)

                opts.desc = "[D]eclarations"
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                opts.desc = "[D]efiniton"
                vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts)

                opts.desc = "[I]mplementation"
                vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, opts)

                opts.desc = "[T]ype [D]efinition"
                vim.keymap.set("n", "gt", function() Snacks.picker.lsp_type_definitions() end, opts)

                opts.desc = "[C]ode [A]ctions"
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                opts.desc = "[C]ode Smart [R]ename"
                vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

                opts.desc = "Show buffer diagnostics"
                vim.keymap.set("n", "<leader>D", function() Snacks.picker.diagnostics_buffer() end, opts)
                opts.desc = "Show line diagnostics"
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                -- goto_prev/goto_next are deprecated; jump() replaces both.
                opts.desc = "Go to previous diagnostic"
                vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
                opts.desc = "Go to next diagnostic"
                vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)

                -- Neovim 0.12's :lsp replaces lspconfig's :LspRestart.
                opts.desc = "Restart LSP"
                vim.keymap.set("n", "<leader>lr", "<cmd>lsp restart<CR>", opts)

                opts.desc = "Info LSP"
                vim.keymap.set("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", opts)
            end,
        })

        -- virtual_lines on the cursor line only.
        vim.diagnostic.config({
            virtual_lines = { current_line = true },
            virtual_text = false,
            severity_sort = true,
            -- \u{} escapes, not glyphs: pasted Nerd Font codepoints got eaten once.
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "\u{f057} ", -- circled ×
                    [vim.diagnostic.severity.WARN]  = "\u{f071} ", -- warning triangle
                    [vim.diagnostic.severity.HINT]  = "\u{f0820} ", -- lightbulb-ish
                    [vim.diagnostic.severity.INFO]  = "\u{f05a} ", -- circled i
                },
            },
        })

        -- fileOperations lets servers update imports when oil renames a file.
        vim.lsp.config("*", {
            capabilities = require("blink.cmp").get_lsp_capabilities({
                workspace = { fileOperations = { didRename = true, willRename = true } },
            }),
        })

        -- Project-wide diagnostics on demand: load matching files as unlisted
        -- buffers so servers without a workspace mode (lua_ls) report on them.
        vim.api.nvim_create_user_command("DiagnosticsProject", function(opts)
            local glob = opts.args ~= "" and opts.args
                or ("**/*." .. (vim.fn.expand("%:e") ~= "" and vim.fn.expand("%:e") or "*"))
            local files = vim.fn.glob(glob, false, true)
            if #files == 0 then
                vim.notify("No files match " .. glob, vim.log.levels.WARN)
                return
            end
            for _, f in ipairs(files) do
                if vim.fn.isdirectory(f) == 0 then
                    vim.fn.bufload(vim.fn.bufadd(f))
                end
            end
            vim.notify(("Loaded %d file(s) — diagnostics will arrive as each server replies")
                :format(#files), vim.log.levels.INFO)
        end, {
            nargs = "?",
            complete = "file",
            desc = "Load project files so diagnostics cover the whole project",
        })
    end,
}
