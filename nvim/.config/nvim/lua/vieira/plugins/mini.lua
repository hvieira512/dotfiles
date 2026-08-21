return {
    'echasnovski/mini.nvim',
    version = '*',
    -- Eager and early: mock_nvim_web_devicons() below registers the module
    -- under that name, and it has to be in place before anything that requires
    -- it loads, now that nvim-web-devicons itself is gone.
    lazy = false,
    priority = 1000,
    config = function()
        require("mini.ai").setup()
        require("mini.icons").setup()

        -- Several plugins still `require("nvim-web-devicons")`. This serves
        -- them mini.icons under that name, so there is one icon set instead of
        -- two providers disagreeing with each other.
        MiniIcons.mock_nvim_web_devicons()

        -- Replaces nvim-autopairs. Worth knowing what was given up: mini.pairs
        -- has no treesitter awareness, so the old check_ts rules (no pairs
        -- inside lua strings or JS template strings) are gone.
        require("mini.pairs").setup()

        -- Replaces nvim-surround. mini.surround's own defaults are sa/sd/sr,
        -- which would break the muscle memory; this is its documented
        -- vim-surround recipe, keeping ys/ds/cs exactly as before.
        require("mini.surround").setup({
            mappings = {
                add = 'ys',
                delete = 'ds',
                replace = 'cs',
                find = '',
                find_left = '',
                highlight = '',
                update_n_lines = '',
                suffix_last = '',
                suffix_next = '',
            },
            search_method = 'cover_or_next',
        })

        -- The recipe's other half: `ys` in visual mode would shadow vim's `s`,
        -- so visual add moves to `S`, and `yss` surrounds the whole line.
        vim.keymap.del('x', 'ys')
        vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]],
            { silent = true, desc = "Surround selection" })
        vim.keymap.set('n', 'yss', 'ys_', { remap = true, desc = "Surround line" })
    end
}
