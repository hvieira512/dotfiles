return {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    config = function()
        -- import nvim-autopairs
        local autopairs = require("nvim-autopairs")

        -- configure autopairs
        autopairs.setup({
            check_ts = true,                        -- enable treesitter
            ts_config = {
                lua = { "string" },                 -- don't add pairs in lua string treesitter nodes
                javascript = { "template_string" }, -- dont add pairs in javascript template_string nodes
                java = { false },                   -- don't check treesitter on java
            },
        })
    end,
}
