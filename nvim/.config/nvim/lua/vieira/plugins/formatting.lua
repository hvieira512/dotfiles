local formatters_by_ft = {
    lua = { "stylua" },
    -- conform runs these in order
    python = { "isort", "black" },
    -- No php: hitcare is legacy tab-indented PHP+HTML deployed by FTP; a
    -- whole-file reformat turns small changes into huge uploads.
}
for _, ft in ipairs({
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "css", "html", "json", "yaml", "markdown",
}) do
    formatters_by_ft[ft] = { "prettierd", "prettier", stop_after_first = true }
end

require("conform").setup({
    formatters_by_ft = formatters_by_ft,
    -- A function so php also skips lsp_fallback (intelephense's formatter).
    format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "php" then
            return
        end

        return { lsp_fallback = true, async = false, timeout_ms = 1000 }
    end,
})
