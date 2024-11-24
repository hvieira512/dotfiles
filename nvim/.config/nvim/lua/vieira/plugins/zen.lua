return {
    "folke/zen-mode.nvim",
    config = function()
        local zen = require("zen-mode")
        local wk = require("which-key")

        wk.add({
            { "<leader>z", zen.toggle, desc = "[Z]en Mode" }
        })
    end
}
