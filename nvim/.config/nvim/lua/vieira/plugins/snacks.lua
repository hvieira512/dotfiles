require("snacks").setup({
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
                { icon = "󰒲 ", key = "l", desc = "Update plugins", action = ":lua vim.pack.update()" },
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
})

vim.keymap.set("n", "<leader><leader>", function() Snacks.picker.files() end, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "[F]ind [R]ecent Files" })
vim.keymap.set("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "[F]ind [K]eymaps" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "[F]ind [G]rep" })
vim.keymap.set("n", "<leader>fs", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "[F]ind [S]ymbols" })
vim.keymap.set("n", "<leader>fw", function() Snacks.picker.grep_word() end, { desc = "[F]ind Current [W]ord" })
vim.keymap.set("n", "<leader>ft", function() Snacks.picker.todo_comments() end, { desc = "[F]ind [T]odos" })
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>uc", function() Snacks.picker.colorschemes() end, { desc = "[U]I [C]olorscheme" })
vim.keymap.set("n", "<leader>fn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "[F]ind [N]eovim files" })
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>z", function() Snacks.zen() end, { desc = "Zen" })
vim.keymap.set("n", "<leader>nh", function() Snacks.notifier.show_history() end, { desc = "[N]otification [H]istory" })
vim.keymap.set("n", "<leader>nd", function() Snacks.notifier.hide() end, { desc = "[N]otification [D]ismiss" })
