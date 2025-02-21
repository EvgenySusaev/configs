return {
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        lazy = false,
        config = function()
            require("rose-pine").setup({
                variant = "auto",
                dark_variant = "moon",
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
            vim.cmd.colorscheme('rose-pine-moon')
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { "rose-pine/neovim", "nvim-tree/nvim-web-devicons" },
        config = function()
            require('lualine').setup {
                options = {
                    theme = "rose-pine",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    icons_enabled = false, -- Enable Nerd Font icons
                    globalstatus = true,  -- Use a single status line across all windows (Neovim 0.7+)
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { { 'filename', path = 1 } }, -- Shows relative path
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                extensions = { 'quickfix', 'nvim-tree' } -- Add support for additional plugins
            }
        end
    }
}
