return {
    "nvim-lua/plenary.nvim", -- lua functions that many plugins use
    {
        "christoomey/vim-tmux-navigator", -- tmux & split window navigation
        lazy = false,
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
        end,
        config = function()
            -- Ctrl+h/j/k/l entre splits, panes do herdr e panes do tmux
            local herdr_nav = vim.fn.expand("~/.local/share/vim-herdr-navigation/editor/nvim.lua")
            if vim.uv.fs_stat(herdr_nav) then
                dofile(herdr_nav)
            end
        end,
    },
}
