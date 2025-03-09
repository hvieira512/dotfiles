return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        indent = { enabled = true },
        bigfile = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        lazygit = { enabled = true },
        dashboard = {
            preset = {
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },

                },
            },
        },
        zen = { enabled = true },
        -- words = { enabled = true },
    },
    keys = {
        { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>z",  function() Snacks.zen() end,     desc = "Zen" },
    }
}
