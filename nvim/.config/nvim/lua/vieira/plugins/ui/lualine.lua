return {
    'nvim-lualine/lualine.nvim',
    config = function()
        local lualine = require("lualine")

        lualine.setup({
            sections = {
                -- ● N comentários do herdr-nvim por enviar; o resto é o default
                lualine_x = {
                    function() return require("herdr-nvim").statusline() end,
                    'encoding', 'fileformat', 'filetype',
                },
            },
        })
    end
}
