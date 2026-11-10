return {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    -- init, not config: vim.g.live_server has to be set before the plugin loads.
    init = function()
        vim.g.live_server = {
            port = 3000,
            -- boolean since v0.2: opens the system default browser
            browser = true,
        }
    end,
}
