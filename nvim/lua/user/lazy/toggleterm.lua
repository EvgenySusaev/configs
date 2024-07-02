return {
    "akinsho/toggleterm.nvim",

    config = function()
        require("toggleterm").setup {
          size = 20,
          open_mapping = [[<leader>t]],
          hide_numbers = true,
          shade_filetypes = {},
          shade_terminals = true,
          shading_factor = 1,
          start_in_insert = true,
          persist_size = true,
          direction = 'float',
        }
        vim.api.nvim_set_keymap('n', '<F7>', ':ToggleTerm<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('t', '<F7>', '<C-\\><C-n>:ToggleTerm<CR>', {noremap = true, silent = true})

    end
}
