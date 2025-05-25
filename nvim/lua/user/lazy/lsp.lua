return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require('lspconfig')

    -- Setup for OmniSharp (C# LSP)
    lspconfig.csharp_ls.setup {
        cmd = { "csharp-ls" },
        filetypes = { "cs" },  -- Add more if needed
        root_dir = lspconfig.util.root_pattern(".git", "*.sln", "*.csproj"),
        settings = {
            enableEditorConfigSupport = true,  -- Enable EditorConfig support
            enableRoslynAnalyzers = true,      -- Enable Roslyn analyzers
        },
        on_attach = function(client, bufnr)
            -- Keymaps for LSP features
            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local opts = { noremap=true, silent=true }

            -- Example LSP keybindings
            buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
            buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
            buf_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
            buf_set_keymap('n', '<leader>f', '<Cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
        end
    }

    -- Setup for tsserver (TypeScript/JavaScript LSP)
    lspconfig.ts_ls.setup {
      on_attach = function(client, bufnr)
        -- Keybindings and other settings for TypeScript/JavaScript LSP
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      end,
 --     capabilities = require('cmp_nvim_lsp').default_capabilities(),
      root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
    }
    -- Setup for rust-analyzer (Rust LSP)
    lspconfig.rust_analyzer.setup {
      cmd = { "rust-analyzer" },
      filetypes = { "rust" },
      root_dir = lspconfig.util.root_pattern("Cargo.toml", "rust-project.json", ".git"),
      settings = {
          ["rust-analyzer"] = {
              cargo = {
                  allFeatures = true,
              },
              checkOnSave = {
                  command = "clippy",  -- Use clippy for linting
              },
          },
      },
      on_attach = function(client, bufnr)
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<leader>f', '<Cmd>lua vim.lsp.buf.format({ async = true })<CR>', bufopts)
      end,
    }
  end
}


