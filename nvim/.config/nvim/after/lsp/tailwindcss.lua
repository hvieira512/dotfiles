-- Upstream falls back to .git and starts in every repo; require a Tailwind project.
return {
    root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, function(name, path)
            if name:match("^tailwind%.config%.") then return true end
            if name ~= "package.json" then return false end
            local f = io.open(vim.fs.joinpath(path, name))
            local s = f and f:read("*a") or ""
            if f then f:close() end
            return s:find('"tailwindcss"') ~= nil
        end)
        if root then on_dir(root) end
    end,
}
