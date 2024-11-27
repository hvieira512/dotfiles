return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    config = function()
        local flutter_tools = require("flutter-tools")

        flutter_tools.setup({})
    end
}
