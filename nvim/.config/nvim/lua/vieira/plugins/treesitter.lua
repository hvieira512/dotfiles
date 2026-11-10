-- main branch: master doesn't support Neovim 0.12. No auto_install, so
-- parsers are listed explicitly; highlight/indent come from the autocmd.
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    -- Not lazy: the FileType autocmd must exist before the first buffer.
    lazy = false,
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        require("nvim-treesitter").setup({})

        require("nvim-treesitter").install({
            "bash",
            "c",
            "css",
            "dockerfile",
            "gitignore",
            "go",
            "html",
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
                -- pcall: no parser installed falls back to regex syntax.
                if not pcall(vim.treesitter.start, ev.buf) then
                    return
                end
                vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
