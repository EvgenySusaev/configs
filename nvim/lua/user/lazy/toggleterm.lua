return {
    "akinsho/toggleterm.nvim",

    config = function()
        require("toggleterm").setup {
          size = 20,
          open_mapping = [[<F7>]],
          hide_numbers = true,
          shade_filetypes = {},
          shade_terminals = true,
          shading_factor = 1,
          start_in_insert = true,
          persist_size = true,
          direction = 'float',
        }
    end
}
