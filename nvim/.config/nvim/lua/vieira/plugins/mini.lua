return {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
        require("mini.ai").setup()
        require("mini.notify").setup()
        require("mini.icons").setup()
    end
}
