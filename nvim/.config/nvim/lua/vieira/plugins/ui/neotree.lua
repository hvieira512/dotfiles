return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",                   -- Make sure to use the latest stable branch
        dependencies = {
            "nvim-lua/plenary.nvim",       -- A dependency of neo-tree
            "nvim-tree/nvim-web-devicons", -- For file icons (optional)
            "MunifTanjim/nui.nvim",        -- UI component library for Neovim
        },
        config = function()
            -- Set up neo-tree with default options or your custom options
            require("neo-tree").setup({
                close_if_last_window = true, -- Closes Neo-tree if it is the last window
                enable_git_status = true,    -- Shows git status in the file tree
                enable_diagnostics = true,   -- Shows diagnostics in the file tree
                follow_current_file = { enabled = true },
                window = {
                    position = "right", -- Position of the tree (left, right, float)
                    width = 30,
                    mappings = {
                        ["l"] = "toggle_node",
                        ["h"] = "close_node",
                    },
                },
                filesystem = {
                    hide_dotfiles = false,
                    hide_by_name = {
                        ".git",
                        ".DS_Store",
                    },
                    hide_hidden = true,
                    always_show = {
                        ".env",
                    },
                },
                nesting_rules = {
                    ["package.json"] = {
                        pattern = "^package%.json$",                                                                     -- <-- Lua pattern
                        files = { "package-lock.json", "yarn*", "eslint*", "prettier*", "tsconfig*", "vite*", "pnpm-*" } -- <-- glob pattern
                    },
                    ["go"] = {
                        pattern = "(.*)%.go$",    -- <-- Lua pattern with capture
                        files = { "%1_test.go" }, -- <-- glob pattern with capture
                    },
                    ["js-extended"] = {
                        pattern = "(.+)%.js$",
                        files = { "%1.js.map", "%1.min.js", "%1.d.ts" },
                    },
                    ["docker"] = {
                        pattern = "^dockerfile$",
                        ignore_case = true,
                        files = { ".dockerignore", "docker-compose.*", "dockerfile*" },
                    },
                    ["tailwind"] = {
                        files = { "tailwind.config*", "postcss.config*" }
                    }
                }
            })
        end,
    },
}
