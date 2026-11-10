require("blink.cmp").setup({
    keymap = {
        preset = 'enter',
        ["<C-k>"] = { 'select_prev', 'fallback' },
        ["<C-j>"] = { 'select_next', 'fallback' },
    },

    -- Do not complete when in command mode
    completion = {
        menu = { auto_show = function(ctx) return ctx.mode ~= 'cmdline' end }
    },

    appearance = {
        nerd_font_variant = 'mono'
    },

    signature = { enabled = true }
})
