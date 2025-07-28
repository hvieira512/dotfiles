return {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            view_options = {
                is_always_hidden = function(name, _)
                    if name == "__pycache__" then
                        return true
                    end
                    return false
                end,
            }
        })
    end
}
