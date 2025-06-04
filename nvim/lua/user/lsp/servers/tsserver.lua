return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
  end,
  single_file_support = true,
  settings = {},
}

