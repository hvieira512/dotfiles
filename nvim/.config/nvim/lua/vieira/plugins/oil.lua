require("oil").setup({
    view_options = {
        is_always_hidden = function(name) return name == "__pycache__" end,
    },
})
