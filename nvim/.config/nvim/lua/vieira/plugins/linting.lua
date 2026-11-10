local lint = require("lint")

lint.linters_by_ft = {
    python = { "pylint" },
    php = { "phpcs" },
}
for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
    lint.linters_by_ft[ft] = { "eslint_d" }
end

-- coisascomgosto has no pylint config; silence the stock noise.
local pylint = lint.linters.pylint
pylint.args = vim.list_extend(vim.deepcopy(pylint.args), {
    "--disable=missing-module-docstring,missing-function-docstring," ..
    "missing-class-docstring,invalid-name",
})

-- No --standard: hitcare ships its own phpcs.xml.dist (tabs).
-- 512M because phpcs OOMs on includes/resources.php (19k lines).
local phpcs = lint.linters.phpcs
phpcs.args = vim.list_extend(vim.deepcopy(phpcs.args), { "-d", "memory_limit=512M" })

-- Run from the nearest eslint config so monorepo apps use their own eslint.
local function try_lint()
    lint.try_lint(nil, {
        cwd = vim.fs.root(0, {
            "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts",
        }),
    })
end

-- On write and InsertLeave, not every keystroke.
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("VieiraLint", { clear = true }),
    callback = function() try_lint() end,
})

vim.keymap.set("n", "<leader>ll", try_lint, { desc = "[L]int this buffer" })
