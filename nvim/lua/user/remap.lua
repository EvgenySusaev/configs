vim.g.mapleader = ' '

-- Disable netrw
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.defer_fn(function()
            local arg = vim.fn.argv(0)
            if vim.fn.isdirectory(arg) == 1 then
                require("neo-tree.command").execute({ action = "show", dir = arg })
            elseif vim.fn.argc() == 0 then
                require("neo-tree.command").execute({ action = "show", dir = vim.loop.cwd() })
            end
            vim.cmd("redraw")  -- Force UI refresh after Neo-tree opens
        end, 100)  -- Delay by 100ms
    end
})

-- Map 'jk' to <Esc> in all modes
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })


-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window ", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
