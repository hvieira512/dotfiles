local keymap = vim.keymap
local opts = { noremap = true, silent = true}

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "Q", "<nop>")

-- toggle file explorer
keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "[E]xplorer" })

-- delete character without copying it into the register
keymap.set("n", "x", '"_x', opts) 

-- center screen after scrolling
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- center screen when searching
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- move code in visual mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- indent code without leaving visual mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- keep last yanked when pasting
keymap.set("v", "p", '"_dP', opts)

-- resize splits
keymap.set("n", "<Up>", "<cmd>resize -2<CR>", opts)
keymap.set("n", "<Down>", "<cmd>resize +2<CR>", opts)
keymap.set("n", "<Left>", "<cmd>vertical resize +2<CR>", opts)
keymap.set("n", "<Right>", "<cmd>vertical resize -2<CR>", opts)

-- create splits
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[S]plit [H]orizontally", noremap = true, silent = true })
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[S]plit [V]ertically", noremap = true, silent = true })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "[S]plit [E]qual", noremap = true, silent = true })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "[S]plit Close", noremap = true, silent = true })
keymap.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "[S]plit [M]aximize", noremap = true, silent = true })
