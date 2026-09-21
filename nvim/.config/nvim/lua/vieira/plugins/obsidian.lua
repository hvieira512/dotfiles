return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("obsidian").setup({
            workspaces = {
                { name = "notas", path = "~/notas" },
                { name = "hub", path = "~/dev/hub/docs" },
            },

            -- Os docs do hub são versionados e lidos no GitHub, onde wikilinks
            -- não resolvem.
            preferred_link_style = "markdown",

            -- Por omissão o plugin escreve frontmatter YAML em cada nota que se
            -- grava. Num repositório isso aparece no diff de cada capítulo que
            -- se abre, mesmo sem o alterar.
            disable_frontmatter = function(filename)
                return filename:match("/dev/hub/docs/") ~= nil
            end,

            completion = { blink = true },
            legacy_commands = false,
        })

        local keymap = vim.keymap
        keymap.set("n", "<leader>oo", "<cmd>Obsidian search<cr>", { desc = "Search Notes" })
        keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Show Backlinks" })
        keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New Note" })
        keymap.set("n", "<leader>od", "<cmd>Obsidian today<cr>", { desc = "Daily Note" })
    end
}
