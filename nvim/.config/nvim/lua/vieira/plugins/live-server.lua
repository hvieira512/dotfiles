-- v0.2.0 rewrote this plugin and the old spec had gone stale three ways:
-- it is pure Lua now, so the `pnpm add -g live-server` build step installed a
-- package nothing uses (and pnpm is not installed anyway); `args` was removed
-- in favour of typed keys; and `config = true` called a setup() that was
-- removed too. Both of those raise an error rather than being ignored — the
-- cmd gating just meant it only surfaced on :LiveServerStart.
return {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    -- init, not config: vim.g.live_server has to be set before the plugin loads.
    init = function()
        vim.g.live_server = {
            port = 3000,
            -- `browser` is a boolean now, not a name — true opens whatever the
            -- system default is, which is Brave here.
            browser = true,
        }
    end,
}
