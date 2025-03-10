local opt = vim.opt
local g = vim.g

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- nerd font
g.have_nerd_font = true

-- line numbers
opt.relativenumber = true
opt.number = true

-- tab size
local tab_size = 4
opt.tabstop = tab_size
opt.shiftwidth = tab_size
opt.expandtab = true
opt.autoindent = true

-- line wrap
opt.wrap = false

-- columns
opt.colorcolumn = "80,120"

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true  -- override ignorecase if search pattern contains uppercase letters
vim.opt.incsearch = true  -- show matches as you type
vim.opt.hlsearch = false  -- do not highlight search matches

-- show current line
opt.cursorline = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode position

opt.clipboard = "unnamedplus"

opt.splitright = true
opt.splitbelow = true

-- lines when scrolling
opt.scrolloff = 10
opt.sidescrolloff = 10

opt.updatetime = 300          -- Faster completion (default is 4000ms)
opt.timeoutlen = 300          -- Time to wait for a mapped sequence to complete

opt.mouse = "a"               -- Enable mouse for all modes

opt.fillchars = { eob = ' ' } -- disable tilda on empty line

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

local keymap = vim.keymap
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.api.nvim_create_autocmd({ 'FileType' }, {
    desc = 'Force commentstring to include spaces',
    -- group = ...,
    callback = function(event)
        local cs = vim.bo[event.buf].commentstring
        vim.bo[event.buf].commentstring = cs:gsub('(%S)%%s', '%1 %%s'):gsub('%%s(%S)', '%%s %1')
    end,
})

-- Set all HTML files as htmldjango buftype, for flask projects
local function is_flask_project()
    local reqs_file = vim.fn.findfile("requirements.txt", ".;")
    if reqs_file ~= "" then
        for line in io.lines(reqs_file) do
            if line:match("Flask") then
                return true
            end
        end
    end
    return false
end

if is_flask_project() then
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.html",
        callback = function()
            vim.bo.filetype = "htmldjango"
        end,
    })
end
