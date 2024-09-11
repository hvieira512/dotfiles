return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
        { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                    },
                },
            },
        })

        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")

        -- set keymaps
        local keymap = vim.keymap -- for conciseness
        local opts = { noremap = true, silent = true }

        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "[F]ind [F]iles" })
        keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", opts) -- my preference
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "[F]ind [R]ecent Files" })
        keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "[F]ind [K]eymaps" })
        keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "[F]ind [G]rep" })
        keymap.set("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "[F]ind Current [W]ord" })
        keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "[F]ind [T]odos" })
        keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "[F]ind [H]elp" })
    end,
}
