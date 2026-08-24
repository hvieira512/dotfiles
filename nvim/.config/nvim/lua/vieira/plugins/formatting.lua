return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("conform").setup({
            -- formatters_by_ft, not _by_tf. Conform reads `opts.formatters_by_ft
            -- or {}` and does not validate unknown keys, so the typo silently
            -- threw this entire table away — prettier and black had never run.
            -- format_on_save's lsp_fallback masked it by formatting via the LSP
            -- instead, which is why files still looked formatted.
            formatters_by_ft = {
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                -- was isort, which is a Python import sorter. stylua is the Lua
                -- one, and mason-tool-installer was already installing it.
                lua = { "stylua" },
                -- isort first so imports are ordered, then black over the whole
                -- file; conform runs a list in order.
                python = { "isort", "black" },
                -- No php entry, and format_on_save below skips php buffers
                -- outright. hitcare is 1057 legacy PHP files that mix HTML and
                -- PHP, indent with tabs, and are deployed by hand-picked FTP
                -- uploads; a formatter rewriting a whole file on save turns a
                -- three-line change into a 300-line diff to upload, and any
                -- reindent of a file with inline HTML is a chance to break
                -- output. php-cs-fixer also cannot run here at all: it wants a
                -- composer.json for the target version and this project has
                -- none.
                dart = { "prettier" },
            },
            -- A function rather than a table so php can opt out: with a
            -- table, lsp_fallback would hand php buffers to intelephense's
            -- formatter, which is the same whole-file rewrite by another route.
            format_on_save = function(bufnr)
                if vim.bo[bufnr].filetype == "php" then
                    return
                end

                return { lsp_fallback = true, async = false, timeout_ms = 1000 }
            end,
        })
    end
}
