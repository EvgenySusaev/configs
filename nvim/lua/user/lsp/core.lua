-- lsp/core.lua

local M = {}

-- Common on_attach for all LSPs
local function on_attach(client, bufnr)
  local buf_map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end

  -- Go to definition, declaration, implementation
  buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  buf_map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  buf_map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")

  -- Hover documentation, signature help
  buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  buf_map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")

  -- Rename, code actions, format
  buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  buf_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  buf_map("v", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  buf_map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")

  -- Diagnostics
  buf_map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
  buf_map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  buf_map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
end

-- Capabilities (e.g., for nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Register individual LSP servers
local function setup_servers()
  local servers = {
        "lua_ls",
        "csharp_ls"
  }

  for _, server in ipairs(servers) do

    local ok, config = pcall(require, "user.lsp.servers." .. server)
--[[      
    if not ok then
      vim.notify("Failed to load LSP config for " .. server .. ": " .. config, vim.log.levels.ERROR)
    else
      print("Loaded config for", server, vim.inspect(config))
      config.on_attach = config.on_attach or on_attach
      config.capabilities = config.capabilities or capabilities
      require("lspconfig")[server].setup(config)
    end
]] 
    
    if ok and config then
      config.on_attach = config.on_attach or on_attach
      config.capabilities = config.capabilities or capabilities
      require("lspconfig")[server].setup(config)
    else
      vim.notify("Failed to load LSP config for " .. server, vim.log.levels.WARN)
    end
  end
end

function M.setup()
  require("lspconfig") -- ensure lspconfig is loaded
  setup_servers()
end

return M

