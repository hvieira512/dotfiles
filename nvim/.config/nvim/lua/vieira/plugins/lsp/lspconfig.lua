-- nvim-lspconfig only ships the server definitions; mason-lspconfig enables them.
-- Snacks is a runtime global, so load its types whenever a file mentions it.
require("lazydev").setup({
    library = { { path = "snacks.nvim", words = { "Snacks" } } },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end

        -- Only maps that differ from Neovim's defaults (K, grn, gra, grr,
        -- gri, gO); these route through the picker instead of quickfix.
        map("n", "gR", function() Snacks.picker.lsp_references() end, "[R]eferences")
        map("n", "gD", vim.lsp.buf.declaration, "[D]eclarations")
        map("n", "gd", function() Snacks.picker.lsp_definitions() end, "[D]efiniton")
        map("n", "gi", function() Snacks.picker.lsp_implementations() end, "[I]mplementation")
        map("n", "gt", function() Snacks.picker.lsp_type_definitions() end, "[T]ype [D]efinition")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ctions")
        map("n", "<leader>cr", vim.lsp.buf.rename, "[C]ode Smart [R]ename")
        map("n", "<leader>D", function() Snacks.picker.diagnostics_buffer() end, "Show buffer diagnostics")
        map("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")

        -- goto_prev/goto_next are deprecated; jump() replaces both.
        map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Go to previous diagnostic")
        map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Go to next diagnostic")

        -- Neovim 0.12's :lsp replaces lspconfig's :LspRestart.
        map("n", "<leader>lr", "<cmd>lsp restart<CR>", "Restart LSP")
        map("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", "Info LSP")
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
