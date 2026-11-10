vim.o.timeoutlen = 500

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
    { "<leader>H",        group = "[H]arpoon" },
    { "<leader>d",        group = "[D]iagnostic" },
    { "<leader>n",        group = "[N]otifications" },

    -- Hide keymaps
    { "<leader><leader>", hidden = true },
    { "<leader>-",        hidden = true },
    { "<leader>+",        hidden = true },
    { "<leader>F",        hidden = true }
})
