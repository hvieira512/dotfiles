return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
        { 'nvim-telescope/telescope-ui-select.nvim' },
        -- "nvim-telescope/telescope-media-files.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")
        local keymap = vim.keymap -- for conciseness

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next,     -- move to next result
                    },
                },
            },
            pickers = {
                colorscheme = {
                    enable_preview = true
                }
            }
        })

        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
        -- telescope.load_extension("media-files")

        keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
        keymap.set("n", "<leader><leader>", builtin.find_files, { noremap = true, silent = true })
        keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent Files" })
        keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
        keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
        keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind Current [W]ord" })
        keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "[F]ind [T]odos" })
        keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
        keymap.set("n", "<leader>uc", builtin.colorscheme, { desc = "[U]I [C]olorscheme" })

        -- Shortcut for searching your Neovim configuration files
        keymap.set('n', '<leader>fn', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[F]ind [N]eovim files' })
    end,
}
