return {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    config = function()
        require("rose-pine").setup({
            variant = "main",
            extend_background_behind_borders = true,

            enable = {
                terminal = true,
                legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                migrations = true, -- Handle deprecated options automatically
            },

            styles = {
                bold = true,
                italic = false,
                transparency = true,
            },
        })
        vim.cmd.colorscheme('rose-pine')
    end
}
