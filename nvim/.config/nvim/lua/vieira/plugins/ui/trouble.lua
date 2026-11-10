require("trouble").setup({ focus = true })

vim.keymap.set("n", "<leader>dw", "<cmd>Trouble diagnostics toggle<CR>", { desc = "[W]orkspace [D]iagnostics (open buffers)" })
vim.keymap.set("n", "<leader>dp", "<cmd>DiagnosticsProject<CR><cmd>Trouble diagnostics toggle<CR>", { desc = "[P]roject [D]iagnostics (loads all files)" })
vim.keymap.set("n", "<leader>dd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "[B]uffer [D]iagnostics" })
vim.keymap.set("n", "<leader>dq", "<cmd>Trouble quickfix toggle<CR>", { desc = "[Q]uickfix list [D]iagnostics" })
vim.keymap.set("n", "<leader>dl", "<cmd>Trouble loclist toggle<CR>", { desc = "[L]ocation list [D]iagnostics" })
vim.keymap.set("n", "<leader>dt", "<cmd>Trouble todo toggle<CR>", { desc = "[T]odos" })
