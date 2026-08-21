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

                -- Only the maps that differ from Neovim's own. 0.11 ships
                -- K (hover), grn (rename), gra (code action), grr (references),
                -- gri (implementation) and gO (document symbol) by default, so
                -- K is no longer redefined here. The rest are kept because they
                -- route through Telescope rather than the quickfix list.
                opts.desc = "[R]eferences"
                vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "[D]eclarations"
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                opts.desc = "[D]efiniton"
                vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

                opts.desc = "[I]mplementation"
                vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

                opts.desc = "[T]ype [D]efinition"
                vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

                opts.desc = "[C]ode [A]ctions"
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                opts.desc = "[C]ode Smart [R]ename"
                vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

                opts.desc = "Show buffer diagnostics"
                vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
                opts.desc = "Show line diagnostics"
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                -- goto_prev/goto_next are deprecated; jump() replaces both.
                opts.desc = "Go to previous diagnostic"
                vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
                opts.desc = "Go to next diagnostic"
                vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)

                opts.desc = "Restart LSP"
                vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<CR>", opts)

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

        vim.lsp.config("emmet_ls", {
            filetypes = {
                "html",
                "htmldjango",
                "typescriptreact",
                "javascriptreact",
                "css",
                "sass",
                "scss",
                "less",
                "php",
            },
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    -- lazydev handles the vim global and the runtime library,
                    -- so only the completion preference is left here.
                    completion = {
                        callSnippet = "Replace",
                    },
                },
            },
        })

        -- pyright is one of the few servers with a real workspace mode; it
        -- ships "openFilesOnly". Servers without one need :DiagnosticsProject
        -- below.
        vim.lsp.config("pyright", {
            settings = {
                python = {
                    analysis = {
                        diagnosticMode = "workspace",
                    },
                },
            },
        })

        -- Project-wide diagnostics, on demand.
        --
        -- LSP reports per document: a server only knows about files the editor
        -- has sent didOpen for, so nothing exists for a file until it has a
        -- buffer. Some servers offer a workspace mode (pyright above) or answer
        -- workspace/diagnostic pulls, but lua_ls advertises no diagnosticProvider
        -- at all, so for Lua there is no protocol route to ask.
        --
        -- What is left is to give the server the buffers. Loading them is enough
        -- — they stay unlisted, so this does not clutter the buffer list.
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
