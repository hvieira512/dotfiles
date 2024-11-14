return {
    "Pocco81/auto-save.nvim",
    enabled = false,
    config = function()
        local autosave = require("auto-save")

        autosave.setup()
    end
}
