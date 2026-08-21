return {
    -- catgoose fork. norcalli's is unmaintained and calls vim.tbl_flatten,
    -- which Neovim removes in 0.13 — it is the startup deprecation warning.
    "catgoose/nvim-colorizer.lua",
    config = function()
        local colorizer = require("colorizer")

        colorizer.setup()
    end
}
