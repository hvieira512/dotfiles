-- Catppuccin used to sit alongside this one, installed and eagerly loaded with a
-- full setup() call every startup — while its `colorscheme catppuccin` line was
-- commented out. A whole theme costing ~2.9ms to configure something nothing
-- ever selected. Removed; add it back as a spec if you want to switch.
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
