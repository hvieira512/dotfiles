return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    config = function()
        local wk = require("which-key")
        wk.add({
            -- Keymaps groups
            { "<leader>s",        group = "[S]plit" },
            { "<leader>e",        group = "[E]xplorer Toggle" },
            { "<leader>f",        group = "[F]ind" },
            { "<leader>c",        group = "[C]ode" },
            { "<leader>g",        group = "[G]o To" },
            { "<leader>u",        group = "[U]I" },
            { "<leader>w",        group = "Session" },
            { "<leader>l",        group = "[L]SP" },
            { "<leader>L",        group = "[L]azy" },
            { "<leader>H",        group = "[H]arpoon" },
            { "<leader>d",        group = "[D]iagnostic" },
            { "<leader>D",        group = "[D]ebug" },

            -- Hide keymaps
            { "<leader><leader>", hidden = true },
            { "<leader>D",        hidden = true },
            { "<leader>-",        hidden = true },
            { "<leader>+",        hidden = true },
            { "<leader>F",        hidden = true }
        })
    end
}
