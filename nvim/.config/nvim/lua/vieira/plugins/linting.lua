-- Linting, which nothing was doing before this file existed.
--
-- pylint and eslint_d were already being installed by mason-tool-installer and
-- then never run: conform only formats, and the language servers report type
-- and symbol errors rather than lint rules. This is the piece that actually
-- invokes them and feeds the results into vim.diagnostic, so they land in the
-- same sign column and Trouble list as everything else.
return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            python = { "pylint" },
            php = { "phpcs" },
            javascript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescript = { "eslint_d" },
            typescriptreact = { "eslint_d" },
        }

        -- coisascomgosto has no pyproject.toml or .pylintrc, so pylint would
        -- otherwise run with its stock rules and bury real problems under
        -- missing-docstring and invalid-name on every line. These four are the
        -- usual suspects; drop the list once the project carries its own config.
        local pylint = lint.linters.pylint
        pylint.args = vim.list_extend(vim.deepcopy(pylint.args), {
            "--disable=missing-module-docstring,missing-function-docstring," ..
            "missing-class-docstring,invalid-name",
        })

        -- No --standard here on purpose. It used to force PSR12, which the
        -- explicit flag applies even when the project ships its own ruleset,
        -- and hitcare indents with tabs in 954 of its 1057 PHP files: PSR12
        -- reported 159 tab errors in a 244-line file that had nothing wrong
        -- with it. hitcare now carries a phpcs.xml.dist that phpcs discovers
        -- by itself; any project without one still gets phpcs's own default.
        --
        -- memory_limit, because phpcs tokenises the whole buffer and dies at
        -- the stock 128M on hitcare's includes/resources.php (19k lines) — an
        -- out-of-memory crash instead of diagnostics.
        local phpcs = lint.linters.phpcs
        phpcs.args = vim.list_extend(vim.deepcopy(phpcs.args), { "-d", "memory_limit=512M" })

        -- Lint after writing and on leaving insert, rather than on every
        -- keystroke — these shell out to real processes.
        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("VieiraLint", { clear = true }),
            callback = function()
                -- try_lint is a no-op for filetypes with no linter listed, and
                -- silently does nothing if the executable is missing.
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>ll", function()
            lint.try_lint()
        end, { desc = "[L]int this buffer" })
    end,
}
