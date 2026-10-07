return {
    "ChmaraX/herdr-nvim",
    lazy = false,
    -- keymaps = false: o daemon da sidebar volta a chamar setup() e avisava em cada mapa
    opts = { keymaps = false },
    keys = {
        { "<leader>ac", "<CMD>Herdr comment<CR>", desc = "herdr: comment line" },
        { "<leader>ac", ":Herdr comment<CR>", mode = "x", desc = "herdr: comment selection" },
        { "<leader>al", "<CMD>Herdr list<CR>", desc = "herdr: list comments" },
        { "<leader>as", "<CMD>Herdr send<CR>", desc = "herdr: paste comments to agent" },
        { "<leader>aS", "<CMD>Herdr submit<CR>", desc = "herdr: send comments to agent" },
        { "<leader>ai", "<CMD>Herdr ref<CR>", desc = "herdr: reference line" },
        { "<leader>ai", ":Herdr ref<CR>", mode = "x", desc = "herdr: reference selection" },
    },
}
