require("mini.ai").setup()
require("mini.icons").setup()

MiniIcons.mock_nvim_web_devicons()

-- No treesitter awareness, unlike nvim-autopairs.
require("mini.pairs").setup()

-- vim-surround keys (ys/ds/cs) instead of mini's sa/sd/sr.
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

-- Visual add on S so it doesn't shadow s; yss surrounds the line.
vim.keymap.del('x', 'ys')
vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]],
    { silent = true, desc = "Surround selection" })
vim.keymap.set('n', 'yss', 'ys_', { remap = true, desc = "Surround line" })
