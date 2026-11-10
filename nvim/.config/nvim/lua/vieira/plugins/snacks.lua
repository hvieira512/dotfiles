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
        picker = {
            enabled = true,
            sources = {
                files = { hidden = true, exclude = { "venv", "env", "__pycache__", "*.py[cod]" } },
                grep = { hidden = true, exclude = { "venv", "env", "__pycache__" } },
            },
        },
        -- words = { enabled = true },
    },
    keys = {
        { "<leader><leader>", function() Snacks.picker.files() end,                     desc = "[F]ind [F]iles" },
        { "<leader>ff", function() Snacks.picker.files() end,                           desc = "[F]ind [F]iles" },
        { "<leader>fr", function() Snacks.picker.recent() end,                          desc = "[F]ind [R]ecent Files" },
        { "<leader>fk", function() Snacks.picker.keymaps() end,                         desc = "[F]ind [K]eymaps" },
        { "<leader>/",  function() Snacks.picker.grep() end,                            desc = "[F]ind [G]rep" },
        { "<leader>fs", function() Snacks.picker.lsp_workspace_symbols() end,           desc = "[F]ind [S]ymbols" },
        { "<leader>fw", function() Snacks.picker.grep_word() end,                       desc = "[F]ind Current [W]ord" },
        { "<leader>ft", function() Snacks.picker.todo_comments() end,                   desc = "[F]ind [T]odos" },
        { "<leader>fh", function() Snacks.picker.help() end,                            desc = "[F]ind [H]elp" },
        { "<leader>uc", function() Snacks.picker.colorschemes() end,                    desc = "[U]I [C]olorscheme" },
        { "<leader>fn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "[F]ind [N]eovim files" },
        { "<leader>lg", function() Snacks.lazygit() end,                desc = "Lazygit" },
        { "<leader>z",  function() Snacks.zen() end,                    desc = "Zen" },
        -- Replacing the two noice message keys worth keeping. noice had five
        -- (last/all/history/dismiss/pick); snacks.notifier only distinguishes
        -- history from dismiss, and history covers what last and all showed.
        { "<leader>nh", function() Snacks.notifier.show_history() end,  desc = "[N]otification [H]istory" },
        { "<leader>nd", function() Snacks.notifier.hide() end,          desc = "[N]otification [D]ismiss" },
    }
}
