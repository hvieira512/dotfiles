-- nvim-treesitter, `main` branch.
--
-- Master is not an option any more: its README caps support at "Neovim 0.10 or
-- 0.11 (Neovim 0.12 is not supported)", and its last commit was the one that
-- wrote that cap down. On 0.12 `match[capture_id]` became a list of nodes
-- rather than a single node, which makes master's own query directives call
-- `node:range()` on a table -- the "attempt to call method 'range'" error that
-- fired on every markdown buffer via render-markdown's injection parse.
-- Master will not be fixed, so this migrates rather than pins.
--
-- What the rewrite drops, and where it went:
--   * configs.setup{} -- gone entirely; the module no longer exists
--   * highlight       -- vim.treesitter.start(), in the FileType autocmd below
--   * indent          -- indentexpr, likewise
--   * autotag         -- nvim-ts-autotag's own setup(), which master silently
--                        ignored anyway when passed through configs.setup
--   * auto_install    -- no replacement, hence the explicit parser list
--   * incremental_selection (<C-space>) -- no replacement upstream
--
-- Queries and markdown injections now come from Neovim's own runtime; the
-- plugin's copies of both are deleted on this branch.
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    -- Not lazy-loaded. The FileType autocmd has to be registered before the
    -- first buffer's FileType fires, or that buffer opens unhighlighted.
    lazy = false,
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        require("nvim-treesitter").setup({})

        -- auto_install is gone, so every language has to be named. php pulls
        -- php_only in itself via the parser's `requires`.
        require("nvim-treesitter").install({
            "bash",
            "c",
            "css",
            "dockerfile",
            "gitignore",
            "go",
            "html",
            "java",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "php",
            "phpdoc",
            "query",
            "sql",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        })

        require("nvim-ts-autotag").setup({})

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("VieiraTreesitter", { clear = true }),
            callback = function(ev)
                -- pcall: filetypes with no installed parser are the normal
                -- case now that auto_install is gone (oil buffers, help before
                -- vimdoc compiles, anything not listed above). They fall back
                -- to regex syntax instead of erroring.
                if not pcall(vim.treesitter.start, ev.buf) then
                    return
                end
                vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
