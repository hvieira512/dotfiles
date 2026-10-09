local keymap = vim.keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap.set("n", "Q", "<nop>")
keymap.set("n", "<cmd>w\\<CR>", "<nop>")

-- increment and decrement number
keymap.set("n", "+", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- toggle file explorer
keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "[E]xplorer" })

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

-- resize splits with alt+hjkl; with no split on that axis, resize the herdr pane
local function resize(cmd, dir, a, b)
    if (vim.fn.winnr(a) == vim.fn.winnr() and vim.fn.winnr(b) == vim.fn.winnr()) and vim.env.HERDR_PANE_ID then
        vim.system({ vim.env.HERDR_BIN_PATH or "herdr", "pane", "resize", "--direction", dir, "--pane", vim.env.HERDR_PANE_ID })
    else
        vim.cmd(cmd)
    end
end
keymap.set("n", "<A-k>", function() resize("resize -2", "up", "k", "j") end, opts)
keymap.set("n", "<A-j>", function() resize("resize +2", "down", "k", "j") end, opts)
keymap.set("n", "<A-h>", function() resize("vertical resize +2", "left", "h", "l") end, opts)
keymap.set("n", "<A-l>", function() resize("vertical resize -2", "right", "h", "l") end, opts)

-- create splits
keymap.set("n", "<leader>sh", "<cmd>leftabove vsplit<CR>", { desc = "[S]plit Left" })
keymap.set("n", "<leader>sj", "<cmd>rightbelow split<CR>", { desc = "[S]plit Down" })
keymap.set("n", "<leader>sk", "<cmd>leftabove split<CR>", { desc = "[S]plit Up" })
keymap.set("n", "<leader>sl", "<cmd>rightbelow vsplit<CR>", { desc = "[S]plit Right" })
keymap.set("n", "<leader>s=", "<C-w>=", { desc = "[S]plit [E]qual" })
keymap.set("n", "<leader>sq", "<cmd>close<CR>", { desc = "[S]plit [Q]uit" })

-- move splits
keymap.set("n", "<C-A-h>", "<cmd>wincmd H<CR>", { desc = "Move Split Left" })
keymap.set("n", "<C-A-j>", "<cmd>wincmd J<CR>", { desc = "Move Split Down" })
keymap.set("n", "<C-A-k>", "<cmd>wincmd K<CR>", { desc = "Move Split Up" })
keymap.set("n", "<C-A-l>", "<cmd>wincmd L<CR>", { desc = "Move Split Right" })

-- select all code
keymap.set("n", "<C-a>", "ggVG", opts)

-- enter lazy
keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "[L]azy" })
