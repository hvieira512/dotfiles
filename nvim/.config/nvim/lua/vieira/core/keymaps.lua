local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- just dont use it
keymap.set("n", "Q", "<nop>")
keymap.set("n", "<cmd>w\\<CR>", "<nop>")

-- increment and decrement number
keymap.set("n", "+", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- toggle file explorer
keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "[E]xplorer" })

-- delete character ithout copying it into the register
-- so huge btw
keymap.set("n", "x", '"_x', opts)

-- center screen after scrolling
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- center screen hen searching
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- move code in visual mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- indent code without leaving visual mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- keep last yanked after pasting
keymap.set("v", "p", '"_dP', opts)

-- resize splits with alt+hjkl
keymap.set("n", "<A-k>", "<cmd>resize -2<CR>", opts)
keymap.set("n", "<A-j>", "<cmd>resize +2<CR>", opts)
keymap.set("n", "<A-h>", "<cmd>vertical resize +2<CR>", opts)
keymap.set("n", "<A-l>", "<cmd>vertical resize -2<CR>", opts)

-- create splits
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[S]plit [H]orizontally" })
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[S]plit [V]ertically" })
keymap.set("n", "<leader>s=", "<C-w>=", { desc = "[S]plit [E]qual" })
keymap.set("n", "<leader>sq", "<cmd>close<CR>", { desc = "[S]plit [Q]uit" })
keymap.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "[S]plit [M]aximize" })

-- move splits
keymap.set("n", "<C-A-h>", "<cmd>wincmd H<CR>", { desc = "Move Split Left" })
keymap.set("n", "<C-A-j>", "<cmd>wincmd J<CR>", { desc = "Move Split Down" })
keymap.set("n", "<C-A-k>", "<cmd>wincmd K<CR>", { desc = "Move Split Up" })
keymap.set("n", "<C-A-l>", "<cmd>wincmd L<CR>", { desc = "Move Split Right" })

-- select all code
keymap.set("n", "<C-a>", "ggVG", opts)

-- enter lazy
keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "[L]azy" })
