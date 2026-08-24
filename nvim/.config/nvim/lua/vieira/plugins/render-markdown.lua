return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("render-markdown").setup({
            -- Drawing LaTeX maths as images needs the `latex` treesitter parser
            -- plus utftex or latex2text on PATH, none of which are installed —
            -- which is all three of this plugin's :checkhealth warnings. Nothing
            -- here writes equations, so turn the feature off rather than install
            -- a TeX toolchain to satisfy a check.
            latex = { enabled = false },
        })
    end
}
