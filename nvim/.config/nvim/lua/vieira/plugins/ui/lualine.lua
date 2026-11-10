local lualine = require("lualine")

lualine.setup({
    sections = {
        -- ● N comentários do herdr-nvim por enviar; o resto é o default
        lualine_x = {
            -- cmdheight = 0 hides "recording @q", so show it here
            function()
                local reg = vim.fn.reg_recording()
                return reg ~= "" and "recording @" .. reg or ""
            end,
            function() return require("herdr-nvim").statusline() end,
            'encoding', 'fileformat', 'filetype',
        },
    },
})
