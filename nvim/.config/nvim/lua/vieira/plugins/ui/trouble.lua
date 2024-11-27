return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
    opts = {
        focus = true,
    },
    cmd = "Trouble",
    keys = {
        { "<leader>dw", "<cmd>Trouble diagnostics toggle<CR>",              desc = "[W]orkspace [D]iagnostics" },
        { "<leader>dd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "[B]uffer [D]iagnostics" },
        { "<leader>dq", "<cmd>Trouble quickfix toggle<CR>",                 desc = "[Q]uickfix list [D]iagnostics" },
        { "<leader>dl", "<cmd>Trouble loclist toggle<CR>",                  desc = "[L]ocation list [D]iagnostics" },
        { "<leader>dt", "<cmd>Trouble todo toggle<CR>",                     desc = "[T]odos" },
    },
}
