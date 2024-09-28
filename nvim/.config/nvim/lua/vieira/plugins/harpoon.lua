return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon.setup()

        vim.keymap.set("n", "<leader>h", function() harpoon:list():add() end, { desc = "Add File to Harpoon" })
        vim.keymap.set("n", "<leader>H", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Toggle Harpoon Menu" })

        vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "1st Harpoon File" })
        vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "2nd Harpoon File" })
        vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "3rd Harpoon File" })
        vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "4th Harpoon File" })

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
    end
}
