return {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.*',
    opts = {
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
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
        },

        signature = { enabled = true }
    },
}
