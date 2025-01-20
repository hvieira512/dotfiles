return {
    -- Rosé Pine
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        lazy = false,
        priority = 1000,
        config = function()
            local rosepine = require("rose-pine")

            rosepine.setup({
                variant = "moon",      -- auto, main, moon, or dawn
                dark_variant = "moon", -- main, moon, or dawn

                styles = {
                    italic = false,
                    bold = false,
                    transparency = true,
                },
            })

            vim.cmd('colorscheme rose-pine') -- set as default theme
        end
    },
    -- Catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            local catppuccin = require("catppuccin")

            catppuccin.setup({
                -- transparent_background = true,
                flavour = "mocha"
            })

            -- vim.cmd('colorscheme catppuccin')
        end
    }
}
