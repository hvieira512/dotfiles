-- nvim-lspconfig is still here for the server *definitions* it ships in lsp/,
-- which vim.lsp.config reads. Its own lspconfig.setup() framework is not used:
-- Neovim 0.11 made vim.lsp.config()/vim.lsp.enable() native, and mason-lspconfig
-- v2 enables each installed server itself, so the old setup_handlers block is
-- gone along with the v1 API it depended on.
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "saghen/blink.cmp" },
        { "antosha417/nvim-lsp-file-operations", config = true },
        -- lazydev replaces neodev, which is archived upstream. ft-gated because
        -- it only has anything to say about Lua buffers.
        { "folke/lazydev.nvim",                  ft = "lua", opts = {} },
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

                -- `:lsp restart`, not `:LspRestart`. Neovim 0.12 ships a
                -- native `:lsp` command, and nvim-lspconfig's plugin file now
                -- opens with `if vim.fn.exists(':lsp') == 2 then return end` —
                -- so on 0.12 it defines none of LspStart/LspStop/LspRestart/
                -- LspInfo/LspLog, and this keymap was calling a command that
                -- no longer exists. Subcommands: disable, enable, restart, stop.
                opts.desc = "Restart LSP"
                vim.keymap.set("n", "<leader>lr", "<cmd>lsp restart<CR>", opts)

                opts.desc = "Info LSP"
                vim.keymap.set("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", opts)
            end,
        })

        -- One call replaces the sign_define loop. virtual_lines is what
        -- tiny-inline-diagnostic was installed for; it is native since 0.11,
        -- so the plugin is gone. current_line keeps it to the cursor's line
        -- instead of every diagnostic in the buffer at once.
        vim.diagnostic.config({
            virtual_lines = { current_line = true },
            virtual_text = false,
            severity_sort = true,
            -- Written as \u{...} escapes rather than the glyphs themselves.
            -- These are Nerd Font private-use codepoints, and pasting them as
            -- literal characters is how three of the four got silently eaten
            -- once already — only the hint survived, because it sits outside
            -- the BMP and is encoded differently. The escapes are plain ASCII
            -- on disk, so nothing in between can mangle them.
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "\u{f057} ", -- circled ×
                    [vim.diagnostic.severity.WARN]  = "\u{f071} ", -- warning triangle
                    [vim.diagnostic.severity.HINT]  = "\u{f0820} ", -- lightbulb-ish
                    [vim.diagnostic.severity.INFO]  = "\u{f05a} ", -- circled i
                },
            },
        })

        -- Defaults every server inherits. '*' is the wildcard config.
        vim.lsp.config("*", {
            capabilities = require("blink.cmp").get_lsp_capabilities(),
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
