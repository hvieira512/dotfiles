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
        local builtin = require("telescope.builtin")
        local keymap = vim.keymap

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                file_ignore_patterns = {
                    "venv/",
                    "__pycache__/",
                    "%.pyc$",
                    "%.pyo$",
                    "%.pyd$",
                    "%.git/",
                    "node_modules/",
                    "env/",
                    "venv/",
                },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next,     -- move to next result
                    },
                },
                -- layout_config = {
                --     prompt_position = "top",
                -- },
                -- sorting_strategy = "ascending",
            },
            pickers = {
                colorscheme = {
                    enable_preview = true
                },
                find_files = {
                    hidden = true,
                }
            }
        })

        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
        telescope.load_extension("flutter")

        keymap.set("n", "<leader><leader>", function()
            builtin.find_files({ find_command = { 'rg', '--files', '--hidden', '--no-ignore', '-g', '!.git' } })
        end, { desc = "[F]ind [F]iles" })
        keymap.set("n", "<leader>ff", function()
            builtin.find_files({ find_command = { 'rg', '--files', '--hidden', '--no-ignore', '-g', '!.git' } })
        end, { desc = "[F]ind [F]iles" })
        keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent Files" })
        keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
        keymap.set("n", "<leader>/", builtin.live_grep, { desc = "[F]ind [G]rep" })
        keymap.set("n", "<leader>fs", builtin.lsp_dynamic_workspace_symbols, { desc = "[F]ind [S]ymbols" })
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
