return {
    "nvim-lua/plenary.nvim", -- lua functions that many plugins use
    {
        -- Ctrl+h/j/k/l entre splits e panes do herdr; clonado pelo bootstrap.sh
        dir = "~/.local/share/vim-herdr-navigation",
        cond = vim.uv.fs_stat(vim.fn.expand("~/.local/share/vim-herdr-navigation")) ~= nil,
        config = function()
            dofile(vim.fn.expand("~/.local/share/vim-herdr-navigation/editor/nvim.lua"))
        end,
    },
}
