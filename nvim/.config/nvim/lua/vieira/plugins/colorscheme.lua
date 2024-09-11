return {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
        local rosepine = require("rose-pine")

        rosepine.setup({
            variant = 'auto',
            dark_variant = 'main',
            disable_background = true,
            disable_float_background = true,
        })

        vim.cmd('colorscheme rose-pine')
    end
}

