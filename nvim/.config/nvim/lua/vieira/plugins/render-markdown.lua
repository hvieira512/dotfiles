return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("render-markdown").setup({
            -- No TeX toolchain installed; silences :checkhealth.
            latex = { enabled = false },
        })
    end
}
