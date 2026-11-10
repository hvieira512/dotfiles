return {
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
}
