return {
    "tpope/vim-dadbod",
    "kristijanhusak/vim-dadbod-completion",
    "kristijanhusak/vim-dadbod-ui",
    ft = "sql",
    config = function()
        local wk = require("which-key")

        wk.add({
            { "<leader>ud", "<cmd>DBUIToggle", desc = "[D]BUI" }
        })
    end
}
