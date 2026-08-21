return {
    "folke/trouble.nvim",
    dependencies = { "folke/todo-comments.nvim" },
    opts = {
        focus = true,
    },
    cmd = "Trouble",
    keys = {
        -- "Workspace" here only ever meant "buffers you have opened", since
        -- that is all the servers have been told about.
        { "<leader>dw", "<cmd>Trouble diagnostics toggle<CR>",              desc = "[W]orkspace [D]iagnostics (open buffers)" },
        -- The real project-wide one: load every file of this type first, then
        -- show the list. Results fill in as each server replies.
        { "<leader>dp", "<cmd>DiagnosticsProject<CR><cmd>Trouble diagnostics toggle<CR>", desc = "[P]roject [D]iagnostics (loads all files)" },
        { "<leader>dd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "[B]uffer [D]iagnostics" },
        { "<leader>dq", "<cmd>Trouble quickfix toggle<CR>",                 desc = "[Q]uickfix list [D]iagnostics" },
        { "<leader>dl", "<cmd>Trouble loclist toggle<CR>",                  desc = "[L]ocation list [D]iagnostics" },
        { "<leader>dt", "<cmd>Trouble todo toggle<CR>",                     desc = "[T]odos" },
    },
}
