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
for _, key in ipairs({ "<C-d>", "<C-u>" }) do
    keymap.set("n", key, key .. "zz", opts)
end

-- center screen hen searching
for _, key in ipairs({ "n", "N" }) do
    keymap.set("n", key, key .. "zzzv", opts)
end

-- move code in visual mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- indent code without leaving visual mode
for _, key in ipairs({ "<", ">" }) do
    keymap.set("v", key, key .. "gv", opts)
end

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
for key, args in pairs({
    k = { "resize -2", "up", "k", "j" },
    j = { "resize +2", "down", "k", "j" },
    h = { "vertical resize +2", "left", "h", "l" },
    l = { "vertical resize -2", "right", "h", "l" },
}) do
    keymap.set("n", "<A-" .. key .. ">", function() resize(unpack(args)) end, opts)
end

-- create splits
keymap.set("n", "<leader>sh", "<cmd>leftabove vsplit<CR>", { desc = "[S]plit Left" })
keymap.set("n", "<leader>sj", "<cmd>rightbelow split<CR>", { desc = "[S]plit Down" })
keymap.set("n", "<leader>sk", "<cmd>leftabove split<CR>", { desc = "[S]plit Up" })
keymap.set("n", "<leader>sl", "<cmd>rightbelow vsplit<CR>", { desc = "[S]plit Right" })
keymap.set("n", "<leader>s=", "<C-w>=", { desc = "[S]plit [E]qual" })
keymap.set("n", "<leader>sq", "<cmd>close<CR>", { desc = "[S]plit [Q]uit" })

-- move splits
for key, name in pairs({ h = "Left", j = "Down", k = "Up", l = "Right" }) do
    keymap.set("n", "<C-A-" .. key .. ">", "<cmd>wincmd " .. key:upper() .. "<CR>", { desc = "Move Split " .. name })
end

-- select all code
keymap.set("n", "<C-a>", "ggVG", opts)

-- update plugins
keymap.set("n", "<leader>L", vim.pack.update, { desc = "Update plugins" })
