return {
    "ChmaraX/herdr-nvim",
    lazy = false,
    -- keymaps = false: o daemon da sidebar volta a chamar setup() e avisava em cada mapa
    opts = { keymaps = false },
    config = function(_, opts)
        require("herdr-nvim").setup(opts)
        -- O nvim da sidebar é um daemon headless que herda o HERDR_PANE_ID de quem o lançou,
        -- e o Ctrl+h do vim-herdr-navigation falhava na borda; usa o painel em foco ao ligar.
        if #vim.api.nvim_list_uis() > 0 or not vim.env.HERDR_TAB_ID then return end
        vim.api.nvim_create_autocmd({ "UIEnter", "FocusGained" }, {
            callback = function()
                local herdr, tab = vim.env.HERDR_BIN_PATH or "herdr", vim.env.HERDR_TAB_ID
                vim.system({ herdr, "pane", "current" }, { env = { HERDR_PANE_ID = "" } }, function(r)
                    local ok, out = pcall(vim.json.decode, r.stdout or "")
                    local pane = ok and vim.tbl_get(out, "result", "pane") or nil
                    if pane and pane.tab_id == tab then
                        vim.schedule(function() vim.env.HERDR_PANE_ID = pane.pane_id end)
                    end
                end)
            end,
        })
    end,
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
