require("conform").setup({
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
        lua = { "stylua" },
        -- conform runs these in order
        python = { "isort", "black" },
        -- No php: hitcare is legacy tab-indented PHP+HTML deployed by FTP; a
        -- whole-file reformat turns small changes into huge uploads.
        dart = { "prettier" },
    },
    -- A function so php also skips lsp_fallback (intelephense's formatter).
    format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "php" then
            return
        end

        return { lsp_fallback = true, async = false, timeout_ms = 1000 }
    end,
})
