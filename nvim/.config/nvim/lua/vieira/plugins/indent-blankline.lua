return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
        indent = { char = "┊" },
    },
    config = function()
        local ibl = require("ibl")

        ibl.setup({
            scope = {
                show_start = false,
                show_end = false,
                show_exact_scope = false,
            }
        })
    end
}

