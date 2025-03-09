return {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    args = { "--port=3000", "--browser=brave" },
    config = true,
}
