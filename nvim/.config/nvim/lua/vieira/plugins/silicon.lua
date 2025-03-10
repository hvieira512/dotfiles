return {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    main = "nvim-silicon",
    config = function()
        require("nvim-silicon").setup({
            font = "Liga SFMono Nerd Font=32;Noto Color Emoji=32",
            to_clipboard = true,
            theme = "Dracula"
        })
    end
}
